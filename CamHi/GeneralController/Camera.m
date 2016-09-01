//
//  Camera.m
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "Camera.h"

@interface Camera ()
{
    char* snapData;
    int snapPos;
    BOOL isSnapshot;
}

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) NSUserDefaults *camDefaults;
@property (nonatomic, copy) NSString *xingePushKey;

@end

@implementation Camera


- (id)initWithUid:(NSString *)uid_ Name:(NSString *)name_ Username:(NSString *)username_ Password:(NSString *)password_ {
    
    if (self = [super initWithUid:uid_ Username:username_ Password:password_]) {
        self.name = name_;
        self.isAlarm = NO;
        
        [self registerIOSessionDelegate:self];
    }
    
    return self;
}



//获取截图
- (UIImage *)image {
    
    if ([self fileExistsAtPath:self.imagePath]) {
        return [UIImage imageWithContentsOfFile:self.imagePath];
    }
    else {
        return [UIImage imageNamed:@"videoClip"];
    }
}


//保存截图至沙盒
- (void)saveImage:(UIImage *)image {
    //[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    [UIImageJPEGRepresentation(image, 1) writeToFile:self.imagePath atomically:YES];
}

//判断一个文件是否存在
- (BOOL)fileExistsAtPath:(NSString *)filePath {
    NSFileManager *tFileManager = [NSFileManager defaultManager];
    return [tFileManager fileExistsAtPath:filePath];
}


//保存图片沙盒路径
- (NSString *)imagePath {
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", self.uid];
    NSString *filePath = [[self documents] stringByAppendingPathComponent:fileName];
    return filePath;
}

//Documents
- (NSString *)documents {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}











- (void)receiveSessionState:(HiCamera *)camera Status:(int)status {
    LOG(@">>> uid:%@,  receiveSessionState:%x", camera.uid, status);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_connectBlock) {
            _connectBlock((NSInteger)status, [self state]);
        }
    });


    
    if(status == CAMERA_CONNECTION_STATE_LOGIN) {
        
        
        //goke去实时画面取图
        if (![self isGoke]) {
            
            if (!isSnapshot) {
                isSnapshot = YES;
                
                [self sendIOCtrl:HI_P2P_GET_FUNCTION Data:(char *)nil Size:0];
                
                
                HI_P2P_S_SNAP_REQ* snap_req = (HI_P2P_S_SNAP_REQ*)malloc(sizeof(HI_P2P_S_SNAP_REQ));
                snap_req->u32Channel = 0;
                snap_req->u32Stream = HI_P2P_STREAM_2;
                
                [self sendIOCtrl:HI_P2P_GET_SNAP Data:(char *)snap_req Size:sizeof(HI_P2P_S_SNAP_REQ)];
                
            }
        }
        
        
//        ListReq *listReq = [[ListReq alloc] init];
//        [self request:HI_P2P_PB_QUERY_START dson:[self dic:listReq]];
        
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveSessionState:Status:)]) {
        
        [self.delegate receiveSessionState:camera Status:status];
    }
}

- (void)receivePlayUTC:(HiCamera *)camera Time:(int)time {
    
    //NSLog(@"%@ - receivePlayUTC : %d", camera.uid, time);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_playBackBlock) {
            _playBackBlock(0, time);
        }
    });
    
}


- (void)receivePlayState:(HiCamera *)camera State:(int)state Width:(int)width Height:(int)height {

    LOG(@">>> uid:%@,  receivePlayState:%d", camera.uid, state);
    
    if (_playStateBlock) {
        _playStateBlock((NSInteger)state);
    }

}



#pragma mark - download/录像下载
- (void)receiveDownloadState:(HiCamera*)camera Total:(int)total CurSize:(int)curSize State:(int)state Path:(NSString*)path {
    
    LOG(@"download:<%@ %d %d %d> %@", camera.uid, total, curSize, state, path);
    
    if (_downloadBlock) {
        _downloadBlock((Camera *)camera, total, curSize, state, path);
    }
}









#pragma mark - send request
- (void)request:(int)cmd dson:(NSDictionary *)dic {
    
    [HXProgress showProgress];
    
    
    //重启
    if (cmd == HI_P2P_SET_REBOOT) {
        [self sendIOCtrl:cmd Data:(char *)nil Size:0];
    }//@HI_P2P_SET_REBOOT
    
    //恢复出厂设置
    if (cmd == HI_P2P_SET_RESET) {
        [self sendIOCtrl:cmd Data:(char *)nil Size:0];
    }//@HI_P2P_SET_RESET

    
    
    
    //实时画面页面
    if (cmd == HI_P2P_GET_DISPLAY_PARAM || cmd == HI_P2P_SET_DISPLAY_PARAM) {
        
        if (cmd == HI_P2P_GET_DISPLAY_PARAM) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_DISPLAY_PARAM) {
            Display *display = [self object:dic];
            HI_P2P_S_DISPLAY *s_display = [display model];
            [self sendIOCtrl:cmd Data:(char *)s_display Size:sizeof(HI_P2P_S_DISPLAY)];
            free(s_display);
        }
    }
    
    
    
    
    //报警设置页面
    if (cmd == HI_P2P_GET_MD_PARAM || cmd == HI_P2P_SET_MD_PARAM) {
        
        if (cmd == HI_P2P_GET_MD_PARAM) {
            MdParam *tmdparam = [self object:dic];
            LOG(@"tmdparam:%@", tmdparam);
            HI_P2P_S_MD_PARAM *md_param = [tmdparam requestModel];
            [self sendIOCtrl:cmd Data:(char *)md_param Size:sizeof(HI_P2P_S_MD_PARAM)];
            free(md_param);
        }
        
        if (cmd == HI_P2P_SET_MD_PARAM) {
            MdParam *mdparam = [self object:dic];
            LOG(@"mdparam %d", mdparam.u32Enable)
            HI_P2P_S_MD_PARAM *md_param = [mdparam model];
            
            [self sendIOCtrl:cmd Data:(char *)md_param Size:sizeof(HI_P2P_S_MD_PARAM)];
            free(md_param);
        }

    }//@HI_P2P_GET_MD_PARAM || HI_P2P_SET_MD_PARAM
    
    
    //报警联动页面
    if (cmd == HI_P2P_GET_ALARM_PARAM || cmd == HI_P2P_SET_ALARM_PARAM) {
        
        if (cmd == HI_P2P_GET_ALARM_PARAM) {
            [self sendIOCtrl:HI_P2P_GET_ALARM_PARAM Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_ALARM_PARAM) {
            AlarmLink *model = dic[@"model"];
            HI_P2P_S_ALARM_PARAM *alarm_param = [model model];
            [self sendIOCtrl:HI_P2P_SET_ALARM_PARAM Data:(char *)alarm_param Size:sizeof(HI_P2P_S_ALARM_PARAM)];
            free(alarm_param);
        }
    }//@HI_P2P_GET_ALARM_PARAM || HI_P2P_SET_ALARM_PARAM
    

    
    
    if (cmd == HI_P2P_GET_SNAP_ALARM_PARAM || cmd == HI_P2P_SET_SNAP_ALARM_PARAM) {
        
        if (cmd == HI_P2P_GET_SNAP_ALARM_PARAM) {
            [self sendIOCtrl:HI_P2P_GET_SNAP_ALARM_PARAM Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_SNAP_ALARM_PARAM) {
            SnapAlarm *model = dic[@"model"];
            HI_P2P_SNAP_ALARM *snap_alarm = [model model];
            [self sendIOCtrl:HI_P2P_SET_SNAP_ALARM_PARAM Data:(char *)snap_alarm Size:sizeof(HI_P2P_SNAP_ALARM)];
            free(snap_alarm);
        }
    }//@HI_P2P_GET_SNAP_ALARM_PARAM || HI_P2P_SET_SNAP_ALARM_PARAM
    
    
    
    
    //定时录像页面
    if (cmd == HI_P2P_GET_REC_AUTO_PARAM || cmd == HI_P2P_SET_REC_AUTO_PARAM) {
        
        if (cmd == HI_P2P_GET_REC_AUTO_PARAM) {
            [self sendIOCtrl:HI_P2P_GET_REC_AUTO_PARAM Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_REC_AUTO_PARAM) {
            RecAutoParam *model = dic[@"model"];
            HI_P2P_S_REC_AUTO_PARAM *rec_auto_param = [model model];
            [self sendIOCtrl:HI_P2P_SET_REC_AUTO_PARAM Data:(char *)rec_auto_param Size:sizeof(HI_P2P_S_REC_AUTO_PARAM)];
            free(rec_auto_param);
        }
    }//@HI_P2P_GET_REC_AUTO_PARAM || HI_P2P_SET_REC_AUTO_PARAM

    
    
    
    
    if (cmd == HI_P2P_GET_REC_AUTO_SCHEDULE || cmd == HI_P2P_SET_REC_AUTO_SCHEDULE) {
        
        if (cmd == HI_P2P_GET_REC_AUTO_SCHEDULE) {
            [self sendIOCtrl:HI_P2P_GET_REC_AUTO_SCHEDULE Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_REC_AUTO_SCHEDULE) {
            QuantumTime *model = dic[@"model"];
            HI_P2P_QUANTUM_TIME *quantum_time = [model model];
            [self sendIOCtrl:HI_P2P_SET_REC_AUTO_SCHEDULE Data:(char *)quantum_time Size:sizeof(HI_P2P_QUANTUM_TIME)];
            free(quantum_time);
        }
    }//@HI_P2P_GET_REC_AUTO_SCHEDULE || HI_P2P_SET_REC_AUTO_SCHEDULE
    
    
    
    //音频设置页面
    if (cmd == HI_P2P_GET_AUDIO_ATTR || cmd == HI_P2P_SET_AUDIO_ATTR) {
        if (cmd == HI_P2P_GET_AUDIO_ATTR) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_AUDIO_ATTR) {
            AudioAttr *audio = [self object:dic];
            HI_P2P_S_AUDIO_ATTR *audio_attr = [audio model];
            [self sendIOCtrl:cmd Data:(char *)audio_attr Size:sizeof(HI_P2P_S_AUDIO_ATTR)];
            free(audio_attr);
        }
        
    }//@HI_P2P_GET_AUDIO_ATTR || HI_P2P_SET_AUDIO_ATTR
    
    
    
    //视频参数设置页面
    if (cmd == HI_P2P_GET_VIDEO_PARAM1 || cmd == HI_P2P_GET_VIDEO_PARAM2 || cmd == HI_P2P_SET_VIDEO_PARAM) {
     
        if (cmd == HI_P2P_GET_VIDEO_PARAM1 || cmd == HI_P2P_GET_VIDEO_PARAM2) {
            HI_P2P_S_VIDEO_PARAM* video_param = (HI_P2P_S_VIDEO_PARAM*)malloc(sizeof(HI_P2P_S_VIDEO_PARAM));
            memset(video_param, 0, sizeof(HI_P2P_S_VIDEO_PARAM));
            
            if (cmd == HI_P2P_GET_VIDEO_PARAM1) {
                video_param->u32Stream = HI_P2P_STREAM_1;
            }
            if (cmd == HI_P2P_GET_VIDEO_PARAM2) {
                video_param->u32Stream = HI_P2P_STREAM_2;
            }
            
            [self sendIOCtrl:HI_P2P_GET_VIDEO_PARAM Data:(char *)video_param Size:sizeof(HI_P2P_S_VIDEO_PARAM)];
            free(video_param);
        }
        
        if (cmd == HI_P2P_SET_VIDEO_PARAM) {
            VideoParam *videoParam = [self object:dic];
            HI_P2P_S_VIDEO_PARAM *video_param = [videoParam model];
            [self sendIOCtrl:cmd Data:(char *)video_param Size:sizeof(HI_P2P_S_VIDEO_PARAM)];
            free(video_param);
        }

    }//@HI_P2P_GET_VIDEO_PARAM || HI_P2P_SET_VIDEO_PARAM
    
    
    
    if (cmd == HI_P2P_GET_VIDEO_CODE || cmd == HI_P2P_SET_VIDEO_CODE) {
        
        if (cmd == HI_P2P_GET_VIDEO_CODE) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_VIDEO_CODE) {
            VideoCode *videoCode = [self object:dic];
            HI_P2P_CODING_PARAM *coding_param = [videoCode model];
            [self sendIOCtrl:cmd Data:(char *)coding_param Size:sizeof(HI_P2P_CODING_PARAM)];
            free(coding_param);
        }
        
    }//@HI_P2P_GET_VIDEO_CODE || HI_P2P_SET_VIDEO_CODE
    
    
    //wifi设置界面
    if (cmd == HI_P2P_GET_WIFI_PARAM || cmd == HI_P2P_SET_WIFI_PARAM || cmd == HI_P2P_SET_WIFI_CHECK) {
        
        if (cmd == HI_P2P_GET_WIFI_PARAM) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_WIFI_PARAM) {
            
            WifiParam *wifiParam = [self object:dic];
            
            HI_P2P_S_WIFI_PARAM *wifi_param = [wifiParam model];
            
            NSLog(@"wifi_param->strSSID:%s", wifi_param->strSSID);
            NSLog(@"wifi_param->strKey:%s", wifi_param->strKey);

            [self sendIOCtrl:cmd Data:(char *)wifi_param Size:sizeof(HI_P2P_S_WIFI_PARAM)];
            free(wifi_param);
            
        }
        
        if (cmd == HI_P2P_SET_WIFI_CHECK) {
            WifiParam *wifiParam = [self object:dic];
            HI_P2P_S_WIFI_CHECK *wifi_check = [wifiParam modelCheck];
           
            NSLog(@"wifi_check->strSSID:%s", wifi_check->strSSID);
            NSLog(@"wifi_check->strKey:%s", wifi_check->strKey);
            
            [self sendIOCtrl:cmd Data:(char *)wifi_check Size:sizeof(HI_P2P_S_WIFI_CHECK)];
            free(wifi_check);
        }
        
    }//@HI_P2P_GET_WIFI_PARAM || HI_P2P_SET_WIFI_PARAM

    if (cmd == HI_P2P_GET_WIFI_LIST) {
        
        [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        
    }//@HI_P2P_GET_WIFI_LIST
    
    

    //SD卡设置界面
    if (cmd == HI_P2P_GET_SD_INFO || cmd == HI_P2P_SET_FORMAT_SD) {
        
        if (cmd == HI_P2P_GET_SD_INFO) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_FORMAT_SD) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
    }//@HI_P2P_GET_SD_INFO || HI_P2P_SET_FORMAT_SD

    
    
    
    //SD卡设置界面
    if (cmd == HI_P2P_GET_TIME_PARAM || cmd == HI_P2P_SET_TIME_PARAM) {
        
        if (cmd == HI_P2P_GET_TIME_PARAM) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_TIME_PARAM) {
            TimeParam *timeParam = [self object:dic];
            HI_P2P_S_TIME_PARAM *time_param = [timeParam model];
            [self sendIOCtrl:cmd Data:(char *)time_param Size:sizeof(HI_P2P_S_TIME_PARAM)];
            free(time_param);
        }
        
    }//@HI_P2P_GET_TIME_PARAM || HI_P2P_SET_TIME_PARAM

    
    
    if (cmd == HI_P2P_GET_TIME_ZONE || cmd == HI_P2P_SET_TIME_ZONE) {
        
        if (cmd == HI_P2P_GET_TIME_ZONE) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_TIME_ZONE) {
            TimeZone *timeZone = [self object:dic];
            HI_P2P_S_TIME_ZONE *time_zone = [timeZone model];
            [self sendIOCtrl:cmd Data:(char *)time_zone Size:sizeof(HI_P2P_S_TIME_ZONE)];
            free(time_zone);
        }
        
    }//@HI_P2P_GET_TIME_ZONE || HI_P2P_SET_TIME_ZONE

    
    
    
    //Email设置界面
    if (cmd == HI_P2P_GET_EMAIL_PARAM || cmd == HI_P2P_SET_EMAIL_PARAM_EXT || cmd == HI_P2P_SET_EMAIL_PARAM) {
        
        if (cmd == HI_P2P_GET_EMAIL_PARAM) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_EMAIL_PARAM) {
            EmailParam *emailParam = [self object:dic];
            HI_P2P_S_EMAIL_PARAM *email_param = [emailParam model];
            [self sendIOCtrl:cmd Data:(char *)email_param Size:sizeof(HI_P2P_S_EMAIL_PARAM)];
            free(email_param);
        }
        
        if (cmd == HI_P2P_SET_EMAIL_PARAM_EXT) {
            EmailParam *emailParam = [self object:dic];
            HI_P2P_S_EMAIL_PARAM_EXT *email_param = [emailParam checkModel];
            [self sendIOCtrl:cmd Data:(char *)email_param Size:sizeof(HI_P2P_S_EMAIL_PARAM_EXT)];
            free(email_param);
        }
        
    }//@HI_P2P_GET_EMAIL_PARAM || HI_P2P_SET_EMAIL_PARAM_EXT || HI_P2P_SET_EMAIL_PARAM

    
    
    
    //FTP设置界面
    if (cmd == HI_P2P_GET_FTP_PARAM_EXT || cmd == HI_P2P_SET_FTP_PARAM_EXT) {
        
        if (cmd == HI_P2P_GET_FTP_PARAM_EXT) {
            [self sendIOCtrl:cmd Data:(char *)nil Size:0];
        }
        
        if (cmd == HI_P2P_SET_FTP_PARAM_EXT) {
            FTPParam *ftpParam = [self object:dic];
            HI_P2P_S_FTP_PARAM_EXT *ftp_param = [ftpParam model];
            [self sendIOCtrl:cmd Data:(char *)ftp_param Size:sizeof(HI_P2P_S_FTP_PARAM_EXT)];
            free(ftp_param);
        }
        
    }//@HI_P2P_GET_FTP_PARAM_EXT || HI_P2P_SET_FTP_PARAM_EXT
    
    
    
    //system界面
    if (cmd == HI_P2P_GET_DEV_INFO_EXT) {
        [self sendIOCtrl:cmd Data:(char *)nil Size:0];
    }//@HI_P2P_GET_DEV_INFO_EXT
    
    //远程升级
    if (cmd == HI_P2P_SET_DOWNLOAD) {
        
        SetDownload *download = [self object:dic];
        HI_P2P_S_SET_DOWNLOAD *set_download = [download model];
        [self sendIOCtrl:cmd Data:(char *)set_download Size:sizeof(HI_P2P_S_SET_DOWNLOAD)];
        free(set_download);
        
    }//@HI_P2P_SET_DOWNLOAD
    
    
    //设备信息界面
    if (cmd == HI_P2P_GET_DEV_INFO) {
        [self sendIOCtrl:cmd Data:(char *)nil Size:0];
    }//@HI_P2P_GET_DEV_INFO
    
    if (cmd == HI_P2P_GET_NET_PARAM) {
        [self sendIOCtrl:cmd Data:(char *)nil Size:0];
    }//@HI_P2P_GET_NET_PARAM
    
    
    
    //远程录像列表
    if (cmd == HI_P2P_PB_QUERY_START) {
        
        [self.onlineRecordings removeAllObjects];
        LOG(@">>>removeAllObjects onlineRecordings.count:%ld", self.onlineRecordings.count);
        
        ListReq *listReq = [self object:dic];
        NSLog(@"listReq>>>:%@", listReq);
        HI_P2P_S_PB_LIST_REQ *list_req = [listReq model];
        [self sendIOCtrl:cmd Data:(char *)list_req Size:sizeof(HI_P2P_S_PB_LIST_REQ)];
        free(list_req);
    }
    
}

- (NSMutableArray *)onlineRecordings {
    if (!_onlineRecordings) {
        _onlineRecordings = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _onlineRecordings;
}



- (void)receiveIOCtrl:(HiCamera *)camera Type:(int)type Data:(char*)data Size:(int)size Status:(int)status {
    
    LOG(@">>> uid:%@ type:%x size:%d",camera.uid, type, size);
    
    
    //获取截图并保存至沙盒
    if (type == HI_P2P_GET_SNAP) {
        
        
        HI_P2P_S_SNAP_RESP* snap_resp =(HI_P2P_S_SNAP_RESP*)data;
        
        if (!snapData) {
            snapData = (char*)malloc(snap_resp->u32SnapLen);
            snapPos = 0;
            
        }
        
        if (snap_resp->u32SendLen <=0) {
            return;
        }
        if(size<=0) {
            return;
        }
        
        
        memcpy((snapData + snapPos), snap_resp->pSnapBuf, snap_resp->u32SendLen);
        snapPos += snap_resp->u32SendLen;
        if (snapData && snap_resp->u16Flag == 1) {
            
            NSData *nsdata = [NSData dataWithBytes:snapData   length:snapPos];
            UIImage *image=[[UIImage alloc]initWithData:nsdata];
            
            [self saveImage:image];
            
            [self getCMD:type object:nil success:YES];
            
            free(snapData);
            snapData = NULL;
        }
    }
    
    
    

    
    
    //重启
    if (type == HI_P2P_SET_REBOOT) {
        [self setCMD:type size:size];
    }//@HI_P2P_SET_REBOOT
    
    //恢复出厂设置
    if (type == HI_P2P_SET_RESET) {
        [self setCMD:type size:size];
    }//@HI_P2P_SET_RESET

    
    //实时画面页面
    if (type == HI_P2P_GET_DISPLAY_PARAM || type == HI_P2P_SET_DISPLAY_PARAM) {
        
        if (type == HI_P2P_GET_DISPLAY_PARAM) {
            Display *display = [[Display alloc] initWithData:data size:size];
            [self getCMD:type object:display success:YES];
        }
        
        if (type == HI_P2P_SET_DISPLAY_PARAM) {
            [self setCMD:type size:size];
        }
    }

    
    //报警设置页面
    if (type == HI_P2P_GET_MD_PARAM || type == HI_P2P_SET_MD_PARAM) {
        
        if (type == HI_P2P_GET_MD_PARAM) {
            
            MdParam *mdparam = [[MdParam alloc] initWithData:data size:size];
            [self getCMD:type object:mdparam success:YES];
        }
        
        if (type == HI_P2P_SET_MD_PARAM) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_MD_PARAM || HI_P2P_SET_MD_PARAM

    
    //报警联动页设置
    if (type == HI_P2P_GET_ALARM_PARAM || type == HI_P2P_SET_ALARM_PARAM) {
        
        if (type == HI_P2P_GET_ALARM_PARAM) {
            if (size != sizeof(HI_P2P_S_ALARM_PARAM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            AlarmLink *alarmLickModel = [[AlarmLink alloc] initWithData:data size:size];
            [self getCMD:type object:alarmLickModel success:YES];
        }
        
        if (type == HI_P2P_SET_ALARM_PARAM) {
            [self setCMD:type size:size];
        }
        
     }//@HI_P2P_GET_ALARM_PARAM || HI_P2P_SET_ALARM_PARAM
    
    
    
    
    
    if (type == HI_P2P_GET_SNAP_ALARM_PARAM || type == HI_P2P_SET_SNAP_ALARM_PARAM) {
        
        if (type == HI_P2P_GET_SNAP_ALARM_PARAM) {
            //SnapAlarm
            if (size != sizeof(HI_P2P_SNAP_ALARM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            SnapAlarm *snapAlarm = [[SnapAlarm alloc] initWithData:data size:size];
            [self getCMD:type object:snapAlarm success:YES];
        }

        if (type == HI_P2P_SET_SNAP_ALARM_PARAM) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_SNAP_ALARM_PARAM || HI_P2P_SET_SNAP_ALARM_PARAM
    
    
    
    
    //定时录像页面
    if (type == HI_P2P_GET_REC_AUTO_PARAM || type == HI_P2P_SET_REC_AUTO_PARAM) {
        
        if (type == HI_P2P_GET_REC_AUTO_PARAM) {
            
            if (size != sizeof(HI_P2P_S_REC_AUTO_PARAM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            RecAutoParam *recAutoParam = [[RecAutoParam alloc] initWihtData:data size:size];
            [self getCMD:type object:recAutoParam success:YES];
        }
        
        if (type == HI_P2P_SET_REC_AUTO_PARAM) {
            [self setCMD:type size:size];
        }
    }//@HI_P2P_GET_REC_AUTO_PARAM || HI_P2P_SET_REC_AUTO_PARAM


    
    //录像时间
    if (type == HI_P2P_GET_REC_AUTO_SCHEDULE || type == HI_P2P_SET_REC_AUTO_SCHEDULE) {
        
        if (type == HI_P2P_GET_REC_AUTO_SCHEDULE) {
            
            if (size != sizeof(HI_P2P_QUANTUM_TIME)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            QuantumTime *quantumTime = [[QuantumTime alloc] initWithData:data size:size];
            [self getCMD:type object:quantumTime success:YES];
        }
        
        if (type == HI_P2P_SET_REC_AUTO_SCHEDULE) {
            [self setCMD:type size:size];
        }
    }//@HI_P2P_GET_REC_AUTO_SCHEDULE || HI_P2P_SET_REC_AUTO_SCHEDULE
    
    
    
    //音频设置页面
    if (type == HI_P2P_GET_AUDIO_ATTR || type == HI_P2P_SET_AUDIO_ATTR) {
        if (type == HI_P2P_GET_AUDIO_ATTR) {
            if (size != sizeof(HI_P2P_S_AUDIO_ATTR)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            AudioAttr *audio = [[AudioAttr alloc] initWithData:data size:size];
            [self getCMD:type object:audio success:YES];
        }
        
        if (type == HI_P2P_SET_AUDIO_ATTR) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_AUDIO_ATTR || HI_P2P_SET_AUDIO_ATTR


    
    
    //视频参数设置页面
    if (type == HI_P2P_GET_VIDEO_PARAM || type == HI_P2P_SET_VIDEO_PARAM) {
        if (type == HI_P2P_GET_VIDEO_PARAM) {
            
            if (size != sizeof(HI_P2P_S_VIDEO_PARAM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            VideoParam *videoParam = [[VideoParam alloc] initWithData:data size:size];
            type = videoParam.u32Stream == 1 ? HI_P2P_GET_VIDEO_PARAM1 : HI_P2P_GET_VIDEO_PARAM2;
            
            [self getCMD:type object:videoParam success:YES];
            
         }
        
        if (type == HI_P2P_SET_VIDEO_PARAM) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_VIDEO_PARAM || HI_P2P_SET_VIDEO_PARAM

    if (type == HI_P2P_GET_VIDEO_CODE || type == HI_P2P_SET_VIDEO_CODE) {
        
        if (type == HI_P2P_GET_VIDEO_CODE) {
            
            if (size != sizeof(HI_P2P_CODING_PARAM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            VideoCode *videoCode = [[VideoCode alloc] initWithData:data size:size];
            [self getCMD:type object:videoCode success:YES];
        }
        
        if (type == HI_P2P_SET_VIDEO_CODE) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_VIDEO_CODE || HI_P2P_SET_VIDEO_CODE

    
    
    
    //wifi设置界面
    if (type == HI_P2P_GET_WIFI_PARAM || type == HI_P2P_SET_WIFI_PARAM || type == HI_P2P_SET_WIFI_CHECK) {
        
        if (type == HI_P2P_GET_WIFI_PARAM) {
            
            if (size != sizeof(HI_P2P_S_WIFI_PARAM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            WifiParam *wifiParam = [[WifiParam alloc] initWithData:data size:size];
            [self getCMD:type object:wifiParam success:YES];
        }
        
        if (type == HI_P2P_SET_WIFI_PARAM) {
            [self setCMD:type size:size];
        }
        
        if (type == HI_P2P_SET_WIFI_CHECK) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_WIFI_PARAM || HI_P2P_SET_WIFI_PARAM
    
    if (type == HI_P2P_GET_WIFI_LIST) {
        
        if (size > (sizeof(int))) {
            WifiList *wifiList = [[WifiList alloc] initWithData:data size:size];
            [self getCMD:type object:wifiList success:YES];
        }
        else {
            [self getCMD:type object:nil success:NO];
        }
        
        
    }//@HI_P2P_GET_WIFI_LIST

    
    
    //SD卡设置界面
    if (type == HI_P2P_GET_SD_INFO || type == HI_P2P_SET_FORMAT_SD) {
        
        if (type == HI_P2P_GET_SD_INFO) {
            //[self sendIOCtrl:type Data:(char *)nil Size:0];
            
            if (size != sizeof(HI_P2P_S_SD_INFO)) {
                [self getCMD:type object:nil success:YES];
                return;
            }
            SDCard *sdcard = [[SDCard alloc] initWithData:data size:size];
            [self getCMD:type object:sdcard success:YES];
        }
        
        if (type == HI_P2P_SET_FORMAT_SD) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_SD_INFO || HI_P2P_SET_WIFI_PARAM

    
    
    //SD卡设置界面
    if (type == HI_P2P_GET_TIME_PARAM || type == HI_P2P_SET_TIME_PARAM) {
        
        if (type == HI_P2P_GET_TIME_PARAM) {
            
            if (size != sizeof(HI_P2P_S_TIME_PARAM)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            TimeParam *timeParam = [[TimeParam alloc] initWithData:data size:size];
            [self getCMD:type object:timeParam success:YES];
        }
        
        if (type == HI_P2P_SET_TIME_PARAM) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_TIME_PARAM || HI_P2P_SET_TIME_PARAM

    
    if (type == HI_P2P_GET_TIME_ZONE || type == HI_P2P_SET_TIME_ZONE) {
        
        if (type == HI_P2P_GET_TIME_ZONE) {
            
            if (size != sizeof(HI_P2P_S_TIME_ZONE)) {
                [self getCMD:type object:nil success:NO];
                return;
            }
            TimeZone *timeZone = [[TimeZone alloc] initWithData:data size:size];
            [self getCMD:type object:timeZone success:YES];
        }
        
        if (type == HI_P2P_SET_TIME_ZONE) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_TIME_ZONE || HI_P2P_SET_TIME_ZONE

    

    
    
    //Email设置界面
    if (type == HI_P2P_GET_EMAIL_PARAM || type == HI_P2P_SET_EMAIL_PARAM_EXT || type == HI_P2P_SET_EMAIL_PARAM) {
        
        if (type == HI_P2P_GET_EMAIL_PARAM) {
            
            EmailParam *emailParam = [[EmailParam alloc] initWithData:data size:size];
            LOG(@"emailParam:%@", emailParam)
            [self getCMD:type object:emailParam success:YES];
            
        }
        
        if (type == HI_P2P_SET_EMAIL_PARAM) {
            [self setCMD:type size:size];
        }
        
        if (type == HI_P2P_SET_EMAIL_PARAM_EXT) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_EMAIL_PARAM || HI_P2P_SET_EMAIL_PARAM_EXT || HI_P2P_SET_EMAIL_PARAM
    
    
    
    
    
    //FTP设置界面
    if (type == HI_P2P_GET_FTP_PARAM_EXT || type == HI_P2P_SET_FTP_PARAM_EXT) {
        
        if (type == HI_P2P_GET_FTP_PARAM_EXT) {
            
            FTPParam *ftpParam = [[FTPParam alloc] initWithData:data size:size];
            [self getCMD:type object:ftpParam success:YES];
        }
        
        if (type == HI_P2P_SET_FTP_PARAM_EXT) {
            [self setCMD:type size:size];
        }
        
    }//@HI_P2P_GET_FTP_PARAM_EXT || HI_P2P_SET_FTP_PARAM_EXT


    //system界面
    if (type == HI_P2P_GET_DEV_INFO_EXT) {
        
        DeviceInfoExt *deviceInfo = [[DeviceInfoExt alloc] initWithData:data size:size];
        [self getCMD:type object:deviceInfo success:YES];
    }//@HI_P2P_GET_DEV_INFO_EXT

    //远程升级
    if (type == HI_P2P_SET_DOWNLOAD) {
        [self setCMD:type size:size];
    }//@HI_P2P_SET_DOWNLOAD

    
    //设备信息界面
    if (type == HI_P2P_GET_DEV_INFO) {
        
        DeviceInfo *deviceInfo = [[DeviceInfo alloc] initWithData:data size:size];
        [self getCMD:type object:deviceInfo success:YES];
        
    }//@HI_P2P_GET_DEV_INFO
    
    if (type == HI_P2P_GET_NET_PARAM) {
        
        NetParam *netParam = [[NetParam alloc] initWithData:data size:size];
        [self getCMD:type object:netParam success:YES];
        
    }//@HI_P2P_GET_NET_PARAM
    
    
    

    //远程录像列表
    if (type == HI_P2P_PB_QUERY_START) {
        
        
        HI_P2P_S_PB_LIST_RESP* s = (HI_P2P_S_PB_LIST_RESP*)data;
        
        if (s->total == 0) {
            _onlineRecordings = 0;
            [self getCMD:type object:nil success:YES];
        }
        
        if (s->count > 0) {
            

            for (int i = 0; i < s->count; i++) {
                
                HI_P2P_FILE_INFO saEvt = s->sFileInfo[i];
                
                VideoInfo* v = [[VideoInfo alloc]initWithEventType:saEvt.EventType StertTime:[self getTimeInMillis:saEvt.sStartTime] EndTime:[self getTimeInMillis:saEvt.sEndTime] EventStatus:0];

                [self.onlineRecordings addObject:v];

            }
        }
        
        if (s->endflag == 1) {
            
            LOG(@"end s->total:%d", s->total);
            NSLog(@"endflag-onlineRecordings.cout:%ld", self.onlineRecordings.count);
            [self getCMD:type object:self.onlineRecordings success:YES];
        }
    }//
    
    
    if (type == HI_P2P_DEV_PLAYBACK_END_FLAG) {
        [self setCMD:type size:size];
    }

    // 远程录像回放拖动
    if (type == HI_P2P_PB_POS_SET) {
        [self setCMD:type size:size];
    }

}


- (double)getTimeInMillis:(STimeDay)time {
    
    double result;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:time.year];
    [comps setMonth:time.month];
    [comps setWeekday:time.wday];
    [comps setDay:time.day];
    [comps setHour:time.hour];
    [comps setMinute:time.minute];
    [comps setSecond:time.second];
    
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    //    [cal setLocale:[NSLocale currentLocale]];
    
    NSDate *date = [cal dateFromComponents:comps];
    
    result = [date timeIntervalSince1970];
    
    return result;
}



- (void)getCMD:(int)type object:(id)obj success:(BOOL)success {
    dispatch_async(dispatch_get_main_queue(), ^{
        [HXProgress dismiss];
        NSDictionary *dic = [self dic:obj];
        [self startCMDBlock:success command:type object:dic];
    });
}

- (void)setCMD:(int)type size:(int)size {
    dispatch_async(dispatch_get_main_queue(), ^{
        [HXProgress dismiss];
        size >= 0 ? [self startCMDBlock:YES command:type object:nil] : [self startCMDBlock:NO command:type object:nil];
    });
}

//回调block
- (void)startCMDBlock:(BOOL)success command:(int)cmd object:(NSDictionary *)obj {
    if (_cmdBlock) {
        _cmdBlock(success, cmd, obj);
    }
}

//对象转字典
- (NSDictionary *)dic:(id)object {
    NSDictionary *dic = object == nil ? nil : @{@"model": object};
    return dic;
}
//字典转对象
- (id)object:(NSDictionary *)dic {
    return dic[@"model"];
}











#pragma mark - 懒加载
- (NSString *)state {
    
    if ([self getConnectState] == CAMERA_CONNECTION_STATE_LOGIN) {
        return NSLocalizedString(@"Online", nil);
    }
    
//    if ([self getConnectState] == CAMERA_CONNECTION_STATE_CONNECTED) {
//        return NSLocalizedString(@"Connected", nil);
//    }
    
    if ([self getConnectState] == CAMERA_CONNECTION_STATE_CONNECTING) {
        return NSLocalizedString(@"Connecting...", nil);
    }
    
    if ([self getConnectState] == CAMERA_CONNECTION_STATE_DISCONNECTED) {
        return NSLocalizedString(@"Disconnected", nil);
    }
    
    if ([self getConnectState] == CAMERA_CONNECTION_STATE_WRONG_PASSWORD) {
        return NSLocalizedString(@"Wrong Password", nil);
    }
    return nil;
}

//摄像机是否在线
- (BOOL)online {
    int cstate = [self getConnectState];
    return cstate == CAMERA_CONNECTION_STATE_LOGIN ? YES : NO;
}


#pragma mark - OnPushResult/信鸽推送
- (HiPushSDK *)pushSDK {
    if (!_pushSDK) {
        
        //注册信鸽推送返回的deviceToken
        NSString *token = [self.camDefaults objectForKey:@"xinge_push_deviceToken"];
        _pushSDK = [[HiPushSDK alloc] initWithXGToken:token Uid:self.uid Company:XINGECAMPANY Delegate:self];
    }
    return _pushSDK;
}

- (void)turnOnXingePush {
    [HXProgress showProgress];
    [self.pushSDK bind];
}

- (void)turnOffXingePush {
    [HXProgress showProgress];
    [self.pushSDK unbind];
}

//开启关闭信鸽报警推送代理返回
- (void)pushBindResult:(int)subID Type:(int)type Result:(int)result {
    
    if (type == PUSH_TYPE_BIND) {
        
        if (result == PUSH_RESULT_FAIL) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:0] forKey:self.xingePushKey];
        }
        
        if (result == PUSH_RESULT_SUCCESS) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:1] forKey:self.xingePushKey];
        }
    }
    
    
    if (type == PUSH_TYPE_UNBIND) {
        
        if (result == PUSH_RESULT_FAIL) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:1] forKey:self.xingePushKey];
        }
        
        if (result == PUSH_RESULT_SUCCESS) {
            [self.camDefaults setObject:[NSNumber numberWithInteger:0 ] forKey:self.xingePushKey];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HXProgress dismiss];

        if (_xingePushBlock) {
            _xingePushBlock(subID, type, result);
        }
    });
    
    LOG(@">>>xinge  subID:%d, type:%d, result:%d", subID, type, result);
    
}

- (NSInteger)isPushOn {
    return [[self.camDefaults objectForKey:self.xingePushKey] integerValue];
}

- (NSString *)xingePushKey {
    return [NSString stringWithFormat:@"%@-XingePushOn", self.uid];
}


- (NSUserDefaults *)camDefaults {
    if (!_camDefaults) {
        _camDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _camDefaults;
}

#pragma mark - description
- (NSString *)description {
    return [NSString stringWithFormat:@"uid:%@ user:%@ name:%@ pwd:%@", self.uid, self.username, self.name, self.password];
}

#pragma mark - getChipVersion
- (BOOL)isGoke {
    return [self getChipVersion] == CHIP_VERSION_GOKE ? YES : NO;
}


#pragma mark - 转动摄像机
//转动摄像机
- (void)moveDirection:(NSInteger)direction runMode:(NSInteger)mode {
    
    if (direction < 0 || mode < 0) {
        return;
    }
    
    HI_P2P_S_PTZ_CTRL* ptz_ctrl =(HI_P2P_S_PTZ_CTRL *)malloc(sizeof(HI_P2P_S_PTZ_CTRL));
    ptz_ctrl->u32Channel = 0;
    ptz_ctrl->u32Ctrl = (HI_U32)direction;  //转动方向
    ptz_ctrl->u32Mode = (HI_U32)mode;    //模式，step 单步， run 持续
    ptz_ctrl->u16TurnTime = 50;
    ptz_ctrl->u16Speed = 50;
    
    [self sendIOCtrl:HI_P2P_SET_PTZ_CTRL Data:(char *)ptz_ctrl Size:sizeof(HI_P2P_S_PTZ_CTRL)];
    
    free(ptz_ctrl);
}

//判断划动手势，返回摄像机转动方向
- (NSInteger)direction:(CGPoint)translation {
    
    if (fabs(translation.x) > fabs(translation.y)) {
        return translation.x > 0.0 ? HI_P2P_PTZ_CTRL_RIGHT : HI_P2P_PTZ_CTRL_LEFT;
    }
    else {
        return translation.y > 0.0 ? HI_P2P_PTZ_CTRL_DOWN : HI_P2P_PTZ_CTRL_UP;
    }
}

#pragma mark - 预置位设置
- (void)presetWithNumber:(NSInteger)number action:(NSInteger)action {
    
    HI_P2P_S_PTZ_PRESET* ptz = (HI_P2P_S_PTZ_PRESET*)malloc(sizeof(HI_P2P_S_PTZ_PRESET));
    ptz->u32Channel = 0;
    ptz->u32Number = (HI_U32)number;
    ptz->u32Action = (HI_U32)action;

    LOG(@"ptz->u32Number:%d, ptz->u32Action:%d", ptz->u32Number, ptz->u32Action)
    
    [self sendIOCtrl:HI_P2P_SET_PTZ_PRESET Data:(char *)ptz Size:sizeof(HI_P2P_S_PTZ_PRESET)];
    free(ptz);
}

#pragma mark - 变焦设置
- (void)zoomWithCtrl:(NSInteger)ctrl {
    
    HI_P2P_S_PTZ_CTRL* ptz = (HI_P2P_S_PTZ_CTRL*)malloc(sizeof(HI_P2P_S_PTZ_CTRL));
    ptz->u32Channel = 0;
    ptz->u32Mode = HI_P2P_PTZ_MODE_RUN;
    ptz->u32Ctrl = (int)ctrl;
    
    [self sendIOCtrl:HI_P2P_SET_PTZ_CTRL Data:(char *)ptz Size:sizeof(HI_P2P_S_PTZ_CTRL)];
    free(ptz);
}

@end
