//
//  NetParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "NetParam.h"

@implementation NetParam

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size < 0) {
            return self;
        }
        
        HI_P2P_S_NET_PARAM *model = (HI_P2P_S_NET_PARAM *)malloc(sizeof(HI_P2P_S_NET_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_NET_PARAM));
        memcpy(model, data, size);
        
        
        
        _u32Channel     = model->u32Channel;
        _u32Port        = model->u32Port;
        _u32DhcpFlag    = model->u32DhcpFlag;
        _u32DnsDynFlag  = model->u32DnsDynFlag;

        _strIPAddr  = [NSString stringWithUTF8String:model->strIPAddr];
        _strNetMask = [NSString stringWithUTF8String:model->strNetMask];
        _strGateWay = [NSString stringWithUTF8String:model->strGateWay];
        _strFDNSIP  = [NSString stringWithUTF8String:model->strFDNSIP];
        _strSDNSIP  = [NSString stringWithUTF8String:model->strSDNSIP];
        
        
        free(model);
    }
    return self;
}

@end
