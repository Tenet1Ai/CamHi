//
//  AlarmLink.h
//  CamHi
//
//  Created by HXjiang on 16/7/29.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmLink : NSObject

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32EmailSnap;
@property (nonatomic, assign) unsigned int u32SDSnap;
@property (nonatomic, assign) unsigned int u32SDRec;
@property (nonatomic, assign) unsigned int u32FtpRec;
@property (nonatomic, assign) unsigned int u32FtpSnap;
@property (nonatomic, assign) unsigned int u32Relay;
@property (nonatomic, assign) unsigned int u32RelayTime;
@property (nonatomic, assign) unsigned int u32PTZ;
@property (nonatomic, assign) unsigned int u32Svr;

- (id)initWithData:(char *)data size:(int)size;
- (id)initWithMode:(HI_P2P_S_ALARM_PARAM *)model;
- (HI_P2P_S_ALARM_PARAM *)model;

@end
