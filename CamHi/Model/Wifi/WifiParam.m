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
        
//        HI_P2P_S_WIFI_PARAM *model = (HI_P2P_S_WIFI_PARAM *)malloc(sizeof(HI_P2P_S_WIFI_PARAM));
//        memset(model, 0, sizeof(HI_P2P_S_WIFI_PARAM));
//        memcpy(model, data, size);
//        
//        _u32Channel     = model->u32Channel;
//        _u32Enable      = model->u32Enable;
//        _Mode           = [NSNumber numberWithChar:model->Mode];
//        _EncType        = [NSNumber numberWithChar:model->EncType];
//        _strSSID        = [NSString stringWithUTF8String:model->strSSID];
//        _strKey         = [NSString stringWithUTF8String:model->strKey];
//        
//        
//        NSLog(@"_strSSID:%@", _strSSID);
//        NSLog(@"_strKey:%@", _strKey);
//        NSLog(@"model->strSSID:%s", model->strSSID);
//        NSLog(@"model->strKey:%s", model->strKey);
//
//        
//        free(model);
        
        //HI_P2P_S_WIFI_CHECK
        HI_P2P_S_WIFI_CHECK *modelCheck = (HI_P2P_S_WIFI_CHECK *)malloc(sizeof(HI_P2P_S_WIFI_CHECK));
        memset(modelCheck, 0, sizeof(HI_P2P_S_WIFI_CHECK));
        memcpy(modelCheck, data, size);
        
        _u32Channel     = modelCheck->u32Channel;
        _u32Enable      = modelCheck->u32Enable;
        _u32Check       = modelCheck->u32Check;
        _Mode           = [NSNumber numberWithChar:modelCheck->Mode];
        _EncType        = [NSNumber numberWithChar:modelCheck->EncType];
        _strSSID        = [NSString stringWithUTF8String:modelCheck->strSSID];
        _strKey         = [NSString stringWithUTF8String:modelCheck->strKey];
        
        
        NSLog(@"_strSSID:%@", _strSSID);
        NSLog(@"_strKey:%@", _strKey);
        NSLog(@"model->strSSID:%s", modelCheck->strSSID);
        NSLog(@"model->strKey:%s", modelCheck->strKey);
        NSLog(@"model->u32Check:%d", modelCheck->u32Check);

        
        free(modelCheck);

    }
    return self;
}

- (HI_P2P_S_WIFI_PARAM *)model {
    
//    HI_P2P_S_WIFI_PARAM *t_model = (HI_P2P_S_WIFI_PARAM *)malloc(sizeof(HI_P2P_S_WIFI_PARAM));
//    memset(t_model, 0, sizeof(HI_P2P_S_WIFI_PARAM));
//    
//    t_model->u32Channel     = _u32Channel;
//    t_model->u32Enable      = _u32Enable;
//    t_model->Mode           = _Mode.charValue;
//    t_model->EncType        = _EncType.charValue;
//    memcpy(t_model->strSSID, [_strSSID cStringUsingEncoding:NSUTF8StringEncoding], 32);
//    memcpy(t_model->strKey, [_strKey cStringUsingEncoding:NSUTF8StringEncoding], HI_P2P_NET_LEN);
//
//    //strncpy(t_model->strSSID, [_strSSID cStringUsingEncoding:NSUTF8StringEncoding], 32);
//    //strncpy(t_model->strKey, [_strKey cStringUsingEncoding:NSUTF8StringEncoding], HI_P2P_NET_LEN);
//    
//    return t_model;
    
    return nil;
}

- (HI_P2P_S_WIFI_CHECK *)modelCheck {
    
    HI_P2P_S_WIFI_CHECK *t_model = (HI_P2P_S_WIFI_CHECK *)malloc(sizeof(HI_P2P_S_WIFI_CHECK));
    memset(t_model, 0, sizeof(HI_P2P_S_WIFI_CHECK));
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Enable      = _u32Enable;
    t_model->u32Check       = _u32Check;
    t_model->Mode           = _Mode.charValue;
    t_model->EncType        = _EncType.charValue;
    
    NSLog(@"before_memcpy_strSSID:%@", _strSSID);
    
    const char *char_ssid = [_strSSID cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger char_ssid_len = _strSSID.length;
    
    char_ssid_len = char_ssid_len > 31 ? 31 : char_ssid_len;
    NSLog(@"before_memcpy_char_ssid:%s", char_ssid);
    memcpy(t_model->strSSID, char_ssid, char_ssid_len);
    
    NSLog(@"after_memcpy_t_model->strSSID:%s", t_model->strSSID);

    
    const char *char_key = [_strKey cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger char_key_len = _strKey.length;
    char_key_len = char_key_len > HI_P2P_NET_LEN-1 ? HI_P2P_NET_LEN-1 : char_key_len;
    
    memcpy(t_model->strKey, char_key, char_key_len);

    return t_model;
}

@end
