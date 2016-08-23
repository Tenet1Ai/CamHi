//
//  RecAutoParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "RecAutoParam.h"

@implementation RecAutoParam

- (id)initWihtData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_REC_AUTO_PARAM *model = (HI_P2P_S_REC_AUTO_PARAM *)malloc(sizeof(HI_P2P_S_REC_AUTO_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_REC_AUTO_PARAM));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _u32FileLen     = model->u32FileLen;
        _u32Stream      = model->u32Stream;
        
        free(model);
    }
    return self;
}

- (id)initWithMode:(HI_P2P_S_REC_AUTO_PARAM *)model {
    if (self = [super init]) {
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _u32FileLen     = model->u32FileLen;
        _u32Stream      = model->u32Stream;
        
    }
    return self;
}

- (HI_P2P_S_REC_AUTO_PARAM *)model {
    
    HI_P2P_S_REC_AUTO_PARAM *t_model = (HI_P2P_S_REC_AUTO_PARAM *)malloc(sizeof(HI_P2P_S_REC_AUTO_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_S_REC_AUTO_PARAM));
    
    t_model->u32Channel  = _u32Channel;
    t_model->u32Enable   = _u32Enable;
    t_model->u32FileLen  = _u32FileLen;
    t_model->u32Stream   = _u32Stream;
    
    return t_model;
}

@end
