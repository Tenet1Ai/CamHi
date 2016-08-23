//
//  AudioAttr.m
//  CamHi
//
//  Created by HXjiang on 16/8/5.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "AudioAttr.h"

@implementation AudioAttr

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_AUDIO_ATTR *model = (HI_P2P_S_AUDIO_ATTR *)malloc(sizeof(HI_P2P_S_AUDIO_ATTR));
        memset(model, 0, sizeof(HI_P2P_S_AUDIO_ATTR));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _u32Stream      = model->u32Stream;
        _u32AudioType   = model->u32AudioType;
        _u32InMode      = model->u32InMode;
        _u32InVol       = model->u32InVol;
        _u32OutVol      = model->u32OutVol;
        
        free(model);
    }
    return self;
}

- (id)initWithMode:(HI_P2P_S_AUDIO_ATTR *)model {
    if (self = [super init]) {
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _u32Stream      = model->u32Stream;
        _u32AudioType   = model->u32AudioType;
        _u32InMode      = model->u32InMode;
        _u32InVol       = model->u32InVol;
        _u32OutVol      = model->u32OutVol;
        
    }
    return self;
}

- (HI_P2P_S_AUDIO_ATTR *)model {
    
    HI_P2P_S_AUDIO_ATTR *t_model = (HI_P2P_S_AUDIO_ATTR *)malloc(sizeof(HI_P2P_S_AUDIO_ATTR));
    memset(t_model, 0, sizeof(HI_P2P_S_AUDIO_ATTR));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Enable      = _u32Enable;
    t_model->u32Stream      = _u32Stream;
    t_model->u32AudioType   = _u32AudioType;
    t_model->u32InMode      = _u32InMode;
    t_model->u32InVol       = _u32InVol;
    t_model->u32OutVol      = _u32OutVol;
    
    return t_model;
}

@end
