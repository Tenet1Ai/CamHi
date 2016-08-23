//
//  MdParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "MdParam.h"

@implementation MdParam


- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_MD_PARAM *model = (HI_P2P_S_MD_PARAM*)malloc(sizeof(HI_P2P_S_MD_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_MD_PARAM));
        memcpy(model, data, size);

        _u32Channel = model->u32Channel;
        _u32Area    = model->struArea.u32Area;
        _u32Enable  = model->struArea.u32Enable;
        _u32X       = model->struArea.u32X;
        _u32Y       = model->struArea.u32Y;
        _u32Width   = model->struArea.u32Width;
        _u32Height  = model->struArea.u32Height;
        _u32Sensi   = model->struArea.u32Sensi;
        
        LOG(@"_u32Enable:%d", _u32Enable)
        LOG(@"_u32Sensi:%d", _u32Sensi)

        free(model);
        
    }
    return self;
}

- (HI_P2P_S_MD_PARAM *)requestModel {
    
    HI_P2P_S_MD_PARAM *md_param = (HI_P2P_S_MD_PARAM*)malloc(sizeof(HI_P2P_S_MD_PARAM));
    memset(md_param, 0, sizeof(HI_P2P_S_MD_PARAM));
    
    md_param->struArea.u32Area = HI_P2P_MOTION_AREA_1;
    md_param->u32Channel = 0;
    
    return md_param;
}

- (HI_P2P_S_MD_PARAM *)model {
    
    HI_P2P_S_MD_PARAM *t_model = (HI_P2P_S_MD_PARAM*)malloc(sizeof(HI_P2P_S_MD_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_S_MD_PARAM));
    

    t_model->u32Channel = _u32Channel;
    t_model->struArea.u32Area   = _u32Area;
    t_model->struArea.u32Enable = _u32Enable;
    t_model->struArea.u32X      = _u32X;
    t_model->struArea.u32Y      = _u32Y;
    t_model->struArea.u32Width  = _u32Width;
    t_model->struArea.u32Height = _u32Height;
    t_model->struArea.u32Sensi  = _u32Sensi;
    
    
    return t_model;
}


- (NSInteger)sensi {
    
    NSInteger index = 0;
    int sen = _u32Sensi;
    
    if (sen >= 0 && sen <= 25) {
        index = 0;
    }
    
    if(sen > 25 && sen <=50) {
        index = 1;
        
    }
    if(sen > 50) {
        index = 2;
    }

    return index;
}


@end
