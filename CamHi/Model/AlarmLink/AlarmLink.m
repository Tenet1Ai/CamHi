//
//  AlarmLink.m
//  CamHi
//
//  Created by HXjiang on 16/7/29.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "AlarmLink.h"

@implementation AlarmLink

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_ALARM_PARAM *model = (HI_P2P_S_ALARM_PARAM *)malloc(sizeof(HI_P2P_S_ALARM_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_ALARM_PARAM));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32EmailSnap   = model->u32EmailSnap;
        _u32SDSnap      = model->u32SDSnap;
        _u32SDRec       = model->u32SDRec;
        _u32FtpRec      = model->u32FtpRec;
        _u32FtpSnap     = model->u32FtpSnap;
        _u32Relay       = model->u32Relay;
        _u32RelayTime   = model->u32RelayTime;
        _u32PTZ         = model->u32PTZ;
        _u32Svr         = model->u32Svr;
        
        free(model);
    }
    return self;

}

- (id)initWithMode:(HI_P2P_S_ALARM_PARAM *)model {
    if (self = [super init]) {
        
        _u32Channel     = model->u32Channel;
        _u32EmailSnap   = model->u32EmailSnap;
        _u32SDSnap      = model->u32SDSnap;
        _u32SDRec       = model->u32SDRec;
        _u32FtpRec      = model->u32FtpRec;
        _u32FtpSnap     = model->u32FtpSnap;
        _u32Relay       = model->u32Relay;
        _u32RelayTime   = model->u32RelayTime;
        _u32PTZ         = model->u32PTZ;
        _u32Svr         = model->u32Svr;

    }
    return self;
}

- (HI_P2P_S_ALARM_PARAM *)model {
    
    HI_P2P_S_ALARM_PARAM *alarm_param = (HI_P2P_S_ALARM_PARAM *)malloc(sizeof(HI_P2P_S_ALARM_PARAM));
    memset(alarm_param, 0, sizeof(HI_P2P_S_ALARM_PARAM));
    
    alarm_param->u32Channel     = _u32Channel;
    alarm_param->u32EmailSnap   = _u32EmailSnap;
    alarm_param->u32SDSnap      = _u32SDSnap;
    alarm_param->u32SDRec       = _u32SDRec;
    alarm_param->u32FtpRec      = _u32FtpRec;
    alarm_param->u32FtpSnap     = _u32FtpSnap;
    alarm_param->u32Relay       = _u32Relay;
    alarm_param->u32RelayTime   = _u32RelayTime;
    alarm_param->u32PTZ         = _u32PTZ;
    alarm_param->u32Svr         = _u32Svr;
    
    return alarm_param;
}

@end
