//
//  VideoCode.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "VideoCode.h"

@implementation VideoCode

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_CODING_PARAM *model = (HI_P2P_CODING_PARAM *)malloc(sizeof(HI_P2P_CODING_PARAM));
        memset(model, 0, sizeof(HI_P2P_CODING_PARAM));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Frequency   = model->u32Frequency;
        _u32Profile     = model->u32Profile;
        _sReserved      = [NSString stringWithUTF8String:model->sReserved];

        free(model);
    }
    return self;
}

- (HI_P2P_CODING_PARAM *)model {
    
    HI_P2P_CODING_PARAM *t_model = (HI_P2P_CODING_PARAM *)malloc(sizeof(HI_P2P_CODING_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_CODING_PARAM));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Frequency   = _u32Frequency;
    t_model->u32Profile     = _u32Profile;
    memcpy(t_model->sReserved, [_sReserved cStringUsingEncoding:NSUTF8StringEncoding], 2*_sReserved.length);
    
    return t_model;
    
}


@end
