//
//  WifiList.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiList.h"

@implementation WifiList

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_WIFI_LIST *model = (HI_P2P_S_WIFI_LIST *)data;

//        HI_P2P_S_WIFI_LIST *model = (HI_P2P_S_WIFI_LIST *)malloc(sizeof(HI_P2P_S_WIFI_LIST));
//        memset(model, 0, sizeof(HI_P2P_S_WIFI_LIST));
//        memcpy(model, data, size);
        
        _u32Num     = model->u32Num;
        _wifis      = [[NSMutableArray alloc] initWithCapacity:0];
        
        SWifiAp wifi_list[HI_P2P_MAX_LIST_WIFI_NUM];
        memcpy(wifi_list, model->sWifiInfo, size - sizeof(model->u32Num));

        for (int i = 0; i < _u32Num; i++) {
            WifiAp *wifiap = [[WifiAp alloc] initWithSWifiAp:wifi_list[i]];
            [_wifis addObject:wifiap];
        }

        
//        free(model);
    }
    return self;
}





@end
