//
//  GBase.h
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalVideoInfo.h"

@interface GBase : NSObject

@property (nonatomic, strong) NSMutableArray *cameras;


+ (GBase *)sharedBase;
+ (void)initCameras;
+ (void)connectCameras;
+ (void)disconnectCameras;
+ (void)addCamera:(Camera *)mycam;
+ (void)editCamera:(Camera *)mycam;
+ (void)deleteCamera:(Camera *)mycam;
+ (BOOL)savePictureForCamera:(Camera *)mycam;
+ (BOOL)saveRecordingForCamera:(Camera *)mycam;
+ (NSMutableArray *)picturesForCamera:(Camera *)mycam;
+ (NSMutableArray *)recordingsForCamera:(Camera *)mycam;
+ (void)deletePicture:(NSString *)pictureName;

@end
