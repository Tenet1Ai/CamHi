//
//  DeviceInfo.m
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo


- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size < 0) {
            return self;
        }
        
//        NSLog(@"size : %d, HI_P2P_S_DEV_INFO : %d", size, (int)sizeof(HI_P2P_S_DEV_INFO));
        
        HI_P2P_S_DEV_INFO *model = (HI_P2P_S_DEV_INFO *)malloc(sizeof(HI_P2P_S_DEV_INFO));
        memset(model, 0, sizeof(HI_P2P_S_DEV_INFO));
        memcpy(model, data, size);
        
        
        _u32NetType         = model->u32NetType;
        _sUserNum           = model->sUserNum;
        
        _strCableMAC    = [NSString stringWithUTF8String:model->strCableMAC];
        _strWifiMAC     = [NSString stringWithUTF8String:model->strWifiMAC];
        _strSoftVer     = [NSString stringWithUTF8String:model->strSoftVer];
        _strHardVer     = [NSString stringWithUTF8String:model->strHardVer];
        _strDeviceName  = [NSString stringWithUTF8String:model->strDeviceName];

        //NSLog(@"model_sUserNum : %d", model->sUserNum);
        
        free(model);
    }
    return self;
}



- (NSString *)netType {
    return _u32NetType == 1 ? @"WLAN" : @"LAN";
}

@end
