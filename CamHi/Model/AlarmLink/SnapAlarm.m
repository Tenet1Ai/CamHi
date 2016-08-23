//
//  SnapAlarm.m
//  CamHi
//
//  Created by HXjiang on 16/8/1.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SnapAlarm.h"

@implementation SnapAlarm

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_SNAP_ALARM *model = (HI_P2P_SNAP_ALARM *)malloc(sizeof(HI_P2P_SNAP_ALARM));
        memset(model, 0, sizeof(HI_P2P_SNAP_ALARM));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _u32Chn         = model->u32Chn;
        _u32Number      = model->u32Number;
        _u32Interval    = model->u32Interval;
        _sReserved      = [NSString stringWithUTF8String:model->sReserved];
        
        free(model);
    }
    return self;

}

- (id)initWithMode:(HI_P2P_SNAP_ALARM *)model {
    if (self = [super init]) {
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _u32Chn         = model->u32Chn;
        _u32Number      = model->u32Number;
        _u32Interval    = model->u32Interval;
        _sReserved      = [NSString stringWithUTF8String:model->sReserved];
        
    }
    return self;
}

- (HI_P2P_SNAP_ALARM *)model {
    
    HI_P2P_SNAP_ALARM *snap_alarm = (HI_P2P_SNAP_ALARM *)malloc(sizeof(HI_P2P_SNAP_ALARM));
    memset(snap_alarm, 0, sizeof(HI_P2P_SNAP_ALARM));
    
    snap_alarm->u32Channel  = _u32Channel;
    snap_alarm->u32Enable   = _u32Enable;
    snap_alarm->u32Chn      = _u32Chn;
    snap_alarm->u32Number   = _u32Number;
    snap_alarm->u32Interval = _u32Interval;
    
    const char *s = _sReserved.UTF8String;
    memcpy(snap_alarm->sReserved, s, 8);

    return snap_alarm;
}


@end
