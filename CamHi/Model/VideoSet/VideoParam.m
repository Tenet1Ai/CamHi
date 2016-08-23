//
//  VideoParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/5.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "VideoParam.h"

@implementation VideoParam

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_VIDEO_PARAM *model = (HI_P2P_S_VIDEO_PARAM *)malloc(sizeof(HI_P2P_S_VIDEO_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_VIDEO_PARAM));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Stream      = model->u32Stream;
        _u32Cbr         = model->u32Cbr;
        _u32Frame       = model->u32Frame;
        _u32BitRate     = model->u32BitRate;
        _u32Quality     = model->u32Quality;
        _u32IFrmInter   = model->u32IFrmInter;
        
        free(model);
    }
    return self;
}

- (HI_P2P_S_VIDEO_PARAM *)model {
    
    HI_P2P_S_VIDEO_PARAM *t_model = (HI_P2P_S_VIDEO_PARAM *)malloc(sizeof(HI_P2P_S_VIDEO_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_S_VIDEO_PARAM));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Cbr         = _u32Cbr;
    t_model->u32Stream      = _u32Stream;
    t_model->u32Frame       = _u32Frame;
    t_model->u32BitRate     = _u32BitRate;
    t_model->u32Quality     = _u32Quality;
    t_model->u32IFrmInter   = _u32IFrmInter;
    
    return t_model;

}

@end
