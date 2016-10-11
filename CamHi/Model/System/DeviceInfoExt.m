//
//  DeviceInfoExt.m
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "DeviceInfoExt.h"

@implementation DeviceInfoExt

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size != sizeof(HI_P2P_S_DEV_INFO_EXT)) {
            return self;
        }
        
        HI_P2P_S_DEV_INFO_EXT *model = (HI_P2P_S_DEV_INFO_EXT *)malloc(sizeof(HI_P2P_S_DEV_INFO_EXT));
        memset(model, 0, sizeof(HI_P2P_S_DEV_INFO_EXT));
        memcpy(model, data, size);
        
        
        _u32Channel         = model->u32Channel;
        _u32NetType         = model->u32NetType;
        _sUserNum           = model->sUserNum;
        _s32SDStatus        = model->s32SDStatus;
        _s32SDFreeSpace     = model->s32SDFreeSpace;
        _s32SDTotalSpace    = model->s32SDTotalSpace;

        _strCableMAC    = [NSString stringWithUTF8String:model->strCableMAC];
        _strWifiMAC     = [NSString stringWithUTF8String:model->strWifiMAC];
        _strHardVer     = [NSString stringWithUTF8String:model->strHardVer];
        _aszSystemName  = [NSString stringWithUTF8String:model->aszSystemName];
        _aszSystemModel = [NSString stringWithUTF8String:model->aszSystemModel];
        _aszStartDate   = [NSString stringWithUTF8String:model->aszStartDate];
        _aszWebVersion  = [NSString stringWithUTF8String:model->aszWebVersion];
        _sReserved      = [NSString stringWithUTF8String:model->sReserved];
        _aszSystemSoftVersion   = [NSString stringWithUTF8String:model->aszSystemSoftVersion];
        
        free(model);
    }
    return self;
}

@end
