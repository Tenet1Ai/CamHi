//
//  CameraIOSessionProtocol.h
//  CamHi
//
//  Created by zhao qi on 16/6/18.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#ifndef CameraIOSessionProtocol_h
#define CameraIOSessionProtocol_h

#import <Foundation/Foundation.h>
#import "HiCamera.h"

#define PLAY_STATE_START  0
#define PLAY_STATE_EDN 1
#define PLAY_STATE_POS  2
#define PLAY_STATE_RECORDING_START  3
#define PLAY_STATE_RECORDING_END  4

//@interface HiCamera;

@protocol CameraIOSessionProtocol <NSObject>
@optional

- (void)receiveIOCtrl:(HiCamera *)camera Type:(int)type Data:(char*)data Size:(int)size Status:(int)status;
- (void)receiveSessionState:(HiCamera *)camera Status:(int)status;
- (void)receivePlayState:(HiCamera *)camera State:(int)state Width:(int)width Height:(int)height;
- (void)receivePlayUTC:(HiCamera *)camera Time:(int)time;

@end

#endif /* CameraIOSessionProtocol_h */
