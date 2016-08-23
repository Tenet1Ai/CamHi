//
//  SDCard.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SDCard.h"

@implementation SDCard

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_SD_INFO *model = (HI_P2P_S_SD_INFO *)malloc(sizeof(HI_P2P_S_SD_INFO));
        memset(model, 0, sizeof(HI_P2P_S_SD_INFO));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Status      = model->u32Status;
        _u32Space       = model->u32Space;
        _u32LeftSpace   = model->u32LeftSpace;
        
        free(model);
    }
    return self;
}

- (HI_P2P_S_SD_INFO *)model {
    
    HI_P2P_S_SD_INFO *t_model = (HI_P2P_S_SD_INFO *)malloc(sizeof(HI_P2P_S_SD_INFO));
    memset(t_model, 0, sizeof(HI_P2P_S_SD_INFO));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Status      = _u32Status;
    t_model->u32Space       = _u32Space;
    t_model->u32LeftSpace   = _u32LeftSpace;

    return t_model;
}

- (NSString *)total {
    return [NSString stringWithFormat:@"%dMB", _u32Space/1024];
}

- (NSString *)available {
    return [NSString stringWithFormat:@"%dMB", _u32LeftSpace/1024];
}

@end
