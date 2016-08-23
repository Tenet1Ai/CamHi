//
//  WifiParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiParam.h"

@implementation WifiParam

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_WIFI_PARAM *model = (HI_P2P_S_WIFI_PARAM *)malloc(sizeof(HI_P2P_S_WIFI_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_WIFI_PARAM));
        memcpy(model, data, size);
        
        _u32Channel     = model->u32Channel;
        _u32Enable      = model->u32Enable;
        _Mode           = [NSNumber numberWithChar:model->Mode];
        _EncType        = [NSNumber numberWithChar:model->EncType];
        _strSSID        = [NSString stringWithUTF8String:model->strSSID];
        _strKey         = [NSString stringWithUTF8String:model->strKey];
        
        free(model);
    }
    return self;
}

- (HI_P2P_S_WIFI_PARAM *)model {
    
    HI_P2P_S_WIFI_PARAM *t_model = (HI_P2P_S_WIFI_PARAM *)malloc(sizeof(HI_P2P_S_WIFI_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_S_WIFI_PARAM));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Enable      = _u32Enable;
    t_model->Mode           = _Mode.charValue;
    t_model->EncType        = _EncType.charValue;
    memcpy(t_model->strSSID, [_strSSID cStringUsingEncoding:NSUTF8StringEncoding], 2*_strSSID.length);
    memcpy(t_model->strKey, [_strKey cStringUsingEncoding:NSUTF8StringEncoding], 2*_strKey.length);

    return t_model;
    
}

@end
