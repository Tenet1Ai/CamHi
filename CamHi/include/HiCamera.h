//
//  HiCamera.h
//  HiP2PSDK
//
//  Created by zhao qi on 16/6/16.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hi_p2p_ipc_protocol.h"
#import "HiGLMonitor.h"

#define CHIP_VERSION_GOKE 1
#define CHIP_VERSION_HISI 0


#define CAMERA_CONNECTION_STATE_DISCONNECTED  0
#define CAMERA_CONNECTION_STATE_CONNECTING  1
//#define CAMERA_CONNECTION_STATE_CONNECTED  2
#define CAMERA_CONNECTION_STATE_WRONG_PASSWORD  3
#define CAMERA_CONNECTION_STATE_LOGIN  4




@interface HiCamera : NSObject
{
    NSString *uid;
    NSString *username;
    NSString *password;
    
    
    HiGLMonitor* monitor;
}

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, retain) HiGLMonitor *monitor;


- (BOOL)getP2PAlarm;
- (void)setP2PAlarm:(BOOL)b;


- (id)initWithUid:(NSString*)uid_ Username:(NSString *)username_ Password:(NSString *)password_;


- (void)connect;
- (void)disconnect;


- (void) startLiveShow:(int)quality Monitor:(HiGLMonitor*)monitor;
- (void) stopLiveShow;
- (void) setLiveShowMonitor:(HiGLMonitor*)monitor;
- (UIImage*) getSnapshot;


- (void) startListening;
- (void) stopListening;


- (void) startTalk;
- (void) stopTalk;


- (BOOL) getCommandFunction:(int)cmd;
- (int) getChipVersion;
- (HI_P2P_S_DEV_INFO_EXT*)getDeviceInfo;

- (void) startPlayback:(STimeDay*)startTiem Monitor:(HiGLMonitor*)monitor;
- (void) stopPlayback;
- (void) setPlaybackMonitor:(HiGLMonitor*)monitor;


- (void)startRecording:(NSString*)path;
- (void)stopRecording;


- (void)sendIOCtrl:(int)type Data:(char*)data Size:(int)size;


-(void) registerIOSessionDelegate:(id)delegate;
-(void) unregisterIOSessionDelegate:(id)delegate;


-(int) getConnectState;

@end
