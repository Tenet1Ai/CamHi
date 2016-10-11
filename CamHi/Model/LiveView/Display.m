//
//  Display.m
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "Display.h"

@implementation Display


- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size != sizeof(HI_P2P_S_DISPLAY)) {
            return self;
        }
        
        HI_P2P_S_DISPLAY *model = (HI_P2P_S_DISPLAY*)malloc(sizeof(HI_P2P_S_DISPLAY));
        memset(model, 0, sizeof(HI_P2P_S_DISPLAY));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Brightness  = model->u32Brightness;
        _u32Contrast    = model->u32Contrast;
        _u32Saturation  = model->u32Saturation;
        _u32Sharpness   = model->u32Sharpness;
        _u32Flip        = model->u32Flip;
        _u32Mirror      = model->u32Mirror;
        _u32Mode        = model->u32Mode;
        _u32Wdr         = model->u32Wdr;
        _u32Shutter     = model->u32Shutter;
        _u32Night       = model->u32Night;
        
        free(model);
    }
    return self;
}


- (HI_P2P_S_DISPLAY *)model {
    
    HI_P2P_S_DISPLAY *t_model = (HI_P2P_S_DISPLAY*)malloc(sizeof(HI_P2P_S_DISPLAY));
    memset(t_model, 0, sizeof(HI_P2P_S_DISPLAY));
    
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Brightness  = _u32Brightness;
    t_model->u32Contrast    = _u32Contrast;
    t_model->u32Saturation  = _u32Saturation;
    t_model->u32Sharpness   = _u32Sharpness;
    t_model->u32Flip        = _u32Flip;
    t_model->u32Mirror      = _u32Mirror;
    t_model->u32Mode        = _u32Mode;
    t_model->u32Wdr         = _u32Wdr;
    t_model->u32Shutter     = _u32Shutter;
    t_model->u32Night       = _u32Night;
    
    return t_model;
}


@end
