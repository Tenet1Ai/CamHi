//
//  TimeZone.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "TimeZone.h"

@implementation TimeZone

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_TIME_ZONE *model = (HI_P2P_S_TIME_ZONE *)malloc(sizeof(HI_P2P_S_TIME_ZONE));
        memset(model, 0, sizeof(HI_P2P_S_TIME_ZONE));
        memcpy(model, data, size);
        
        LOG(@">>>> model->u32DstMode:%d", model->u32DstMode)
        
        _u32Channel     = model->u32Channel;
        _u32DstMode     = model->u32DstMode;
        _s32TimeZone    = model->s32TimeZone;
        
        free(model);
    }
    return self;
}


- (HI_P2P_S_TIME_ZONE *)model {
    
    HI_P2P_S_TIME_ZONE *t_model = (HI_P2P_S_TIME_ZONE *)malloc(sizeof(HI_P2P_S_TIME_ZONE));
    memset(t_model, 0, sizeof(HI_P2P_S_TIME_ZONE));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32DstMode     = _u32DstMode;
    t_model->s32TimeZone    = _s32TimeZone;
    
    LOG(@">>>> t_model->u32DstMode:%d", t_model->u32DstMode)

    return t_model;
}

@end
