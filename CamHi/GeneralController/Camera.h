//
//  Camera.h
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "HiCamera.h"
#import "CameraIOSessionProtocol.h"
#import "HiPushSDK.h"


//model
#import "MdParam.h"
#import "AlarmLink.h"
#import "SnapAlarm.h"
#import "RecAutoParam.h"
#import "QuantumTime.h"
#import "AudioAttr.h"
#import "VideoParam.h"
#import "VideoCode.h"
#import "WifiParam.h"
#import "WifiList.h"
#import "SDCard.h"
#import "TimeParam.h"
#import "TimeZone.h"
#import "EmailParam.h"
#import "FTPParam.h"
#import "DeviceInfoExt.h"
#import "SetDownload.h"
#import "DeviceInfo.h"
#import "NetParam.h"
#import "Display.h"
#import "VideoInfo.h"
#import "ListReq.h"


#define HI_P2P_GET_VIDEO_PARAM1     (1001)
#define HI_P2P_GET_VIDEO_PARAM2     (1002)


@interface Camera : HiCamera
<OnPushResult>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) BOOL online;
@property (nonatomic, assign) id<CameraIOSessionProtocol> delegate;
@property (nonatomic, strong) NSMutableArray *onlineRecordings;

- (id)initWithUid:(NSString *)uid_ Name:(NSString *)name_ Username:(NSString *)username_ Password:(NSString *)password_;
- (BOOL)isGoke;
- (UIImage *)image;
- (void)saveImage:(UIImage *)image;


//return block
//@property (nonatomic, copy) void(^retBlock)(NSInteger index);

- (void)request:(int)cmd dson:(NSDictionary *)dic;
- (NSDictionary *)dic:(id)object;
- (id)object:(NSDictionary *)dic;

@property (nonatomic, copy) void(^cmdBlock)(BOOL success, NSInteger cmd, NSDictionary *dic);
@property (nonatomic, copy) void(^connectBlock)(NSInteger state, NSString *connection);
@property (nonatomic, copy) void(^playBackBlock)(NSInteger cmd, int seconds);
@property (nonatomic, copy) void(^alarmBlock)(BOOL isAlarm, NSInteger type);
@property (nonatomic, copy) void(^playStateBlock)(NSInteger state);
@property (nonatomic, copy) void(^downloadBlock)(Camera *mycam, int tsize, int csize, int state, NSString *recordingPath);


//转动摄像机
- (NSInteger)direction:(CGPoint)translation;
- (void)moveDirection:(NSInteger)direction runMode:(NSInteger)mode;
//预置位设置
- (void)presetWithNumber:(NSInteger)number action:(NSInteger)action;
//变焦设置
- (void)zoomWithCtrl:(NSInteger)ctrl;


#pragma mark - XingePush
@property (nonatomic, strong) HiPushSDK *pushSDK;
@property (nonatomic, assign) BOOL isAlarm;
@property (nonatomic, assign) NSInteger isPushOn;
@property (nonatomic, copy) void(^xingePushBlock)(int subID, int type, int result);
- (void)turnOnXingePush;
- (void)turnOffXingePush;

@end
