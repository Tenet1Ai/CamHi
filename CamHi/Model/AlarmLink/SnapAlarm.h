//
//  SnapAlarm.h
//  CamHi
//
//  Created by HXjiang on 16/8/1.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnapAlarm : NSObject

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Enable;
@property (nonatomic, assign) unsigned int u32Chn;
@property (nonatomic, assign) unsigned int u32Number;
@property (nonatomic, assign) unsigned int u32Interval;
@property (nonatomic, copy) NSString *sReserved;

- (id)initWithData:(char *)data size:(int)size;
- (id)initWithMode:(HI_P2P_SNAP_ALARM *)model;
- (HI_P2P_SNAP_ALARM *)model;

@end
