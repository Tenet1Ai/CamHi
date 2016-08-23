//
//  WifiAp.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiAp.h"

@implementation WifiAp

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        SWifiAp *model = (SWifiAp *)malloc(sizeof(SWifiAp));
        memset(model, 0, sizeof(SWifiAp));
        memcpy(model, data, size);
        
        _Mode           = [NSNumber numberWithChar:model->Mode];
        _EncType        = [NSNumber numberWithChar:model->EncType];
        _Signal         = [NSNumber numberWithChar:model->Signal];
        _Status         = [NSNumber numberWithChar:model->Status];
        _strSSID        = [NSString stringWithUTF8String:model->strSSID];
        
        
//        switch (_EncType.intValue) {
//                
//            case HI_P2P_WIFIAPENC_INVALID:
//                _strEncType = @"INVALID";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WEP:
//                _strEncType = @"WEP";
//                //WEP, for no password
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA_TKIP:
//                _strEncType = @"WPA_TKIP";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA_AES:
//                _strEncType = @"WPA_AES";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA2_TKIP:
//                _strEncType = @"WPA2_TKIP";
//                break;
//                
//            case HI_P2P_WIFIAPENC_WPA2_AES:
//                _strEncType = @"WPA2_AES";
//                break;
//                
//            default:
//                _strEncType = @"Unknown";
//                break;
//                
//        }//@switch
//
        
        free(model);
    }
    return self;
}

- (id)initWithSWifiAp:(SWifiAp)swifiap {
    if (self = [super init]) {
        
        _Mode           = [NSNumber numberWithChar:swifiap.Mode];
        _EncType        = [NSNumber numberWithChar:swifiap.EncType];
        _Signal         = [NSNumber numberWithChar:swifiap.Signal];
        _Status         = [NSNumber numberWithChar:swifiap.Status];
        _strSSID        = [NSString stringWithUTF8String:swifiap.strSSID];
        
    }
    return self;
}

- (NSString *)strEncType {
    
    NSString *_strEncType = @"Unknown";
    switch (_EncType.charValue) {
            
        case HI_P2P_WIFIAPENC_INVALID:
            _strEncType = @"INVALID";
            break;
            
        case HI_P2P_WIFIAPENC_WEP:
            _strEncType = @"WEP";
            //WEP, for no password
            break;
            
        case HI_P2P_WIFIAPENC_WPA_TKIP:
            _strEncType = @"WPA_TKIP";
            break;
            
        case HI_P2P_WIFIAPENC_WPA_AES:
            _strEncType = @"WPA_AES";
            break;
            
        case HI_P2P_WIFIAPENC_WPA2_TKIP:
            _strEncType = @"WPA2_TKIP";
            break;
            
        case HI_P2P_WIFIAPENC_WPA2_AES:
            _strEncType = @"WPA2_AES";
            break;
            
        default:
            break;
            
    }//@switch

    return _strEncType;
}

@end
