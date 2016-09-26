//
//  GBase.m
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "GBase.h"

#define MAX_CAMERA_LIMIT 32
#define SQLCMD_CREATE_TABLE_DEVICE @"CREATE TABLE IF NOT EXISTS device(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, dev_nickname TEXT, dev_name TEXT, dev_pwd TEXT, view_acc TEXT, view_pwd TEXT, ask_format_sdcard INTEGER, channel INTEGER, video_quality INTEGER)"

#define SQLCMD_CREATE_TABLE_SNAPSHOT @"CREATE TABLE IF NOT EXISTS snapshot(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, file_path TEXT, time REAL)"

#define SQLCMD_CREATE_TABLE_ALARM @"CREATE TABLE IF NOT EXISTS alarm(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, type INTEGER, time INTEGER)"


#define SQLCMD_CREATE_TABLE_VIDEO @"CREATE TABLE IF NOT EXISTS video(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_uid TEXT, file_path TEXT, time REAL)"





@interface GBase ()

@property FMDatabase *db;

@property (nonatomic, strong) NSFileManager *gFileManager;

@end

@implementation GBase


+ (GBase *)sharedBase {
    static GBase *base = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        base = [[GBase alloc] init];
    });
    return base;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
//        self.cameras = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"databasehx.sqlite"];
        
        //
        self.db = [[FMDatabase alloc] initWithPath:databaseFilePath];
        
        //open database
        if (![self.db open]) {
            LOG(@">>> open sqlite db failed.")
            return nil;
        }
        
        //create table
        if (self.db != NULL) {
            if (![self.db executeUpdate:SQLCMD_CREATE_TABLE_DEVICE]) LOG(@"Can not create table device");
            if (![self.db executeUpdate:SQLCMD_CREATE_TABLE_SNAPSHOT]) LOG(@"Can not create table snapshot");
            if (![self.db executeUpdate:SQLCMD_CREATE_TABLE_VIDEO]) LOG(@"Can not create table video");
        }
        
        
        
        // 判断要添加的字段是否存在
        
        // 新增录像类型字段，用于区分手动录像与下载录像
        if (![self.db columnExists:@"recording_type" inTableWithName:@"video"]) {
            
            // 添加不存在的字段
            NSString *addColumn = @"alter table video add recording_type int default 0";
            if (![self.db executeUpdate:addColumn]) {
                NSLog(@"cann't add recording_type to table video");
            }
        }
        
        // 新增是否添加四画面字段
        if (![self.db columnExists:@"add_four" inTableWithName:@"device"]) {
            
            NSString *addColum = @"alter table device add add_four int default 0";
            if (![self.db executeUpdate:addColum]) {
                LOG(@"cann't add add_four to table device");
            }
        }
        
        // 判断要添加的字段是否存在 20160901
        
    }
    return self;
}

- (NSMutableArray *)cameras {
    if (!_cameras) {
        _cameras = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cameras;
}

+ (void)initCameras {
    
    GBase *base = [GBase sharedBase];

//    if (base.cameras.count != 0) {
        [base.cameras removeAllObjects];
//    }
    
    if (base.db != NULL) {
        
        FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM device"];
        int cnt = 0;
        
        while([rs next] && cnt++ < MAX_CAMERA_LIMIT) {
            
            NSString *tuid  = [rs stringForColumn:@"dev_uid"];
            NSString *tname = [rs stringForColumn:@"dev_nickname"];
            NSString *tuser = [rs stringForColumn:@"view_acc"];
            NSString *tpwd  = [rs stringForColumn:@"view_pwd"];
            //NSInteger tchannel = [rs intForColumn:@"channel"];
            //NSInteger tvideo_quality = [rs intForColumn:@"video_quality"];
            NSInteger add_four = [rs intForColumn:@"add_four"];
            
            
            Camera *mycam = [[Camera alloc] initWithUid:tuid Name:tname Username:tuser Password:tpwd];
            mycam.select = add_four == 1 ? YES : NO;
            
            [base.cameras addObject:mycam];
            
            LOG(@">>>Load Camera (%@)", mycam);

        }
        
        [rs close];
    }
}

+ (void)connectCameras {
    
    GBase *base = [GBase sharedBase];
    
    for (Camera *mycam in base.cameras) {
        [mycam connect];
    }
}

+ (void)disconnectCameras {
    GBase *base = [GBase sharedBase];
    
    for (Camera *mycam in base.cameras) {
        [mycam disconnect];
    }
}

+ (void)addCamera:(Camera *)mycam {
    GBase *base = [GBase sharedBase];
    
    [base.cameras addObject:mycam];
    
    if (base.db != NULL) {
        [base.db executeUpdate:@"INSERT INTO device(dev_uid, dev_nickname, dev_name, dev_pwd, view_acc, view_pwd, channel, video_quality) VALUES(?,?,?,?,?,?,?,?)",
         mycam.uid, mycam.name, mycam.name, mycam.password, mycam.username, mycam.password, [NSNumber numberWithInt:0], [NSNumber numberWithInt:1]];
    }
}

+ (void)deleteCamera:(Camera *)mycam {
    GBase *base = [GBase sharedBase];
    
    //删除摄像机时一定要先关掉信鸽报警推送
    [mycam.pushSDK unbind];
    
    [mycam disconnect];
    [base.cameras removeObject:mycam];
    
    if (base.db != NULL) {
        
        if (![base.db executeUpdate:@"DELETE FROM device where dev_uid=?", mycam.uid]) {
            LOG(@"Fail to remove device from database.")
        }
    }
}


+ (void)editCamera:(Camera *)mycam {
    GBase *base = [GBase sharedBase];

    if (base.db != NULL) {
        if (![base.db executeUpdate:@"UPDATE device SET dev_nickname=?, view_pwd=? ,view_acc=? WHERE dev_uid=?", mycam.name, mycam.password, mycam.username , mycam.uid]) {
            LOG(@"Fail to update device to database.")
        }
    }
}

+ (void)editCameraSelect:(Camera *)mycam {
    GBase *base = [GBase sharedBase];
    
    NSNumber *selectNum = [NSNumber numberWithInteger:mycam.select ? 1 : 0];
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"UPDATE device SET add_four=? WHERE dev_uid=?", selectNum, mycam.uid]) {
            LOG(@"Fail to update device to database.")
        }
    }

}


+ (BOOL)savePictureForCamera:(Camera *)mycam {
    
    GBase *base = [GBase sharedBase];
    
    NSString *imgName = [NSString stringWithFormat:@"%f.jpg", [[NSDate date] timeIntervalSince1970]];
    //NSString *imgPath = [base imgFilePathWithImgName:imgName];
    UIImage *image = [mycam getSnapshot];

    //NSLog(@"imgPath:%@", imgName);
    
    if (image == nil) {
        return NO;
    }
    
    [base saveImageToFile:image imageName:imgName];
    
    //NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
//    if (![imgData writeToFile:imgPath atomically:NO]) {
//        return NO;
//    }
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO snapshot(dev_uid, file_path, time) VALUES(?,?,?)", mycam.uid, imgName, [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
            LOG(@"Fail to add snapshot to database.");
            return NO;
        }
    }
    
    return YES;

}



//- (NSString *) pathForDocumentsResource:(NSString *) relativePath {
//    
//    static NSString* documentsPath = nil;
//    
//    if (nil == documentsPath) {
//        
//        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        documentsPath = [dirs objectAtIndex:0];
//    }
//    
//    return [documentsPath stringByAppendingPathComponent:relativePath];
//}

- (void)saveImageToFile:(UIImage *)image imageName:(NSString *)fileName {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    
    //NSString *imgFullName = [self pathForDocumentsResource:fileName];
    NSString *imgFullName = [self documentsWithFileName:fileName];

    //NSLog(@"imgFullName:%@", imgFullName);
    
    [imgData writeToFile:imgFullName atomically:YES];
}


//保存录像
+ (BOOL)saveRecordingForCamera:(Camera *)mycam {
  
//    GBase *base = [GBase sharedBase];
//
//    
//    NSString *recordFileName = [base recordingFileName:mycam];
//    
//    NSString *recordFilePath = [base recordingFilePath:mycam fileName:recordFileName];
//    
//    [mycam startRecording:recordFilePath];
//    
//    if (base.db != NULL) {
//        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path, time) VALUES(?,?,?)", mycam.uid, recordFileName, [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
//            LOG(@"Fail to add snapshot to database.");
//            return NO;
//        }
//    }
//    
//    return YES;
    
    
    GBase *base = [GBase sharedBase];
    
    
    NSString *recordFileName = [base recordingNameWithCamera:mycam];
    
    NSString *recordFilePath = [base recordingPathWithCamera:mycam recordingName:recordFileName];
    
    [mycam startRecording:recordFilePath];
    
//    if (base.db != NULL) {
//        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path, time) VALUES(?,?,?)", mycam.uid, recordFileName, [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
//            LOG(@"Fail to add snapshot to database.");
//            return NO;
//        }
//    }
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path, recording_type, time) VALUES(?,?,?,?)", mycam.uid, recordFileName, [NSNumber numberWithInteger:0], [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]) {
            LOG(@"Fail to save recording to database.");
            return NO;
        }
    }

    return YES;

}


// 下载录像
+ (void)downloadRecordingForCamera:(Camera *)mycam fileName:(NSString *)fileName time:(NSNumber *)time {
    
    
    GBase *base = [GBase sharedBase];
    
    
    
    
//    if (base.db != NULL) {
//        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path, time) VALUES(?,?,?)", mycam.uid, fileName, time]) {
//            LOG(@"Fail to add snapshot to database.");
//        }
//    }
    

    if (base.db != NULL) {
        if (![base.db executeUpdate:@"INSERT INTO video(dev_uid, file_path, recording_type, time) VALUES(?,?,?,?)", mycam.uid, fileName, [NSNumber numberWithInteger:1], time]) {
            LOG(@"Fail to download recording to database.");
        }
    }

}


//删除录像
+ (void)deleteRecording:(NSString *)recordingPath camera:(Camera *)mycam {
    
    GBase *base = [GBase sharedBase];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:mycam.uid];
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath: strPath];
    //删除
    [fileManager removeItemAtPath:[ NSString stringWithFormat:@"%@.mp4", recordingPath] error:nil];
    
    
    
    if (base.db != NULL) {
        if (![base.db executeUpdate:@"DELETE FROM video where file_path=?", recordingPath]){
            NSLog(@"Fail to remove device from database.");
        }
    }

}



- (NSString *)recordingFileName:(Camera *)mycam {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.mp4", mycam.uid, strDateTime];
    
    NSLog(@"strFileName:%@",strFileName);
    return strFileName;
}

- (NSString *)recordingFilePath:(Camera *)mycam fileName:(NSString *)fileName {
    
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:mycam.uid];
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    strPath = [strPath stringByAppendingPathComponent:fileName];

    NSLog(@"strPath:%@",strPath);

    
    return strPath;
}


- (NSString *)recordingNameWithCamera:(Camera *)mycam {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.mp4", mycam.uid, strDateTime];
    
    NSLog(@"strFileName:%@",strFileName);
    return strFileName;
}

// 本地录像存储路径 Documents/uid/recordingName.mp4
- (NSString *)recordingPathWithCamera:(Camera *)mycam recordingName:(NSString *)recordingName {
    
    NSString *document_uid = [self.Documents stringByAppendingPathComponent:mycam.uid];
    [[NSFileManager defaultManager] createDirectoryAtPath:document_uid withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [document_uid stringByAppendingPathComponent:recordingName];
}

// 下载录像存储路径 Documents/uid/Download/recordingName
- (NSString *)downloadPathWithCamera:(Camera *)mycam recordingName:(NSString *)recordingName {
    
    return [[self downloadPathWithCamera:mycam] stringByAppendingPathComponent:recordingName];
}

// 下载录像存储文件夹 Documents/uid/Download/
- (NSString *)downloadPathWithCamera:(Camera *)mycam {
    
    NSString *document_uid = [self.Documents stringByAppendingPathComponent: mycam.uid];
    [self.gFileManager createDirectoryAtPath:document_uid withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *document_uid_download = [document_uid stringByAppendingString:@"Download"];
    [self.gFileManager createDirectoryAtPath:document_uid_download withIntermediateDirectories:YES attributes:nil error:nil];
    
    return document_uid_download;
}


+ (NSMutableArray *)picturesForCamera:(Camera *)mycam {
    
    GBase *base = [GBase sharedBase];

    NSMutableArray *pictures = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM snapshot WHERE dev_uid=?", mycam.uid];
    
    while([rs next]) {
        
        NSString *imageName = [rs stringForColumn:@"file_path"];
        
        [pictures addObject:imageName];
        
         //NSLog(@"imagePath :%@", imageName);
    }
    [rs close];
    
    return pictures;
}


+ (NSMutableArray *)recordingsForCamera:(Camera *)mycam {
    
    GBase *base = [GBase sharedBase];
    
    NSMutableArray *recordings = [[NSMutableArray alloc] initWithCapacity:0];
    
    FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM video WHERE dev_uid=?", mycam.uid];
    
    while([rs next]) {
        
        NSString *filePath = [rs stringForColumn:@"file_path"];
        NSInteger time = [rs doubleForColumn:@"time"];
        NSInteger type = [rs intForColumn:@"recording_type"];
        
        NSLog(@">>>filePath:%@ type:%d", filePath, (int)type);

        LocalVideoInfo* vi = [[LocalVideoInfo alloc] initWithRecordingName:filePath time:time type:type];
        
        [recordings addObject:vi];
    }
    
    [rs close];

    return recordings;
}

//删除照片
+ (void)deletePicture:(NSString *)pictureName {
    
    GBase *base = [GBase sharedBase];

    if (base.db != NULL) {
        
        FMResultSet *rs = [base.db executeQuery:@"SELECT * FROM snapshot WHERE file_path=?", pictureName];
        
        
        while([rs next]) {
            
            NSString *filePath = [rs stringForColumn:@"file_path"];
            
            
            [base.gFileManager removeItemAtPath:[base documentsWithFileName:filePath] error:NULL];
            
            NSLog(@"delete -> pictureName:%@", pictureName);
            //NSLog(@"delete -> picturePath:%@", [base documentsWithFileName:filePath]);

        }
        
        [rs close];
        
        [base.db executeUpdate:@"DELETE FROM snapshot WHERE file_path=?", pictureName];
    }

}





#pragma mark - NSFileManager
- (NSFileManager *)gFileManager {
    return [NSFileManager defaultManager];
}

- (NSString *)Documents {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


- (NSString *)documentsWithFileName:(NSString *)fileName {
    return [self.Documents stringByAppendingPathComponent:fileName];
}



@end
