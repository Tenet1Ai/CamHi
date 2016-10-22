//
//  MHumidity.m
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "MHumidity.h"

@implementation MHumidity

- (instancetype)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size < 0 || size != sizeof(HI_P2P_HUM_ALARM)) {
            return nil;
        }
        
        HI_P2P_HUM_ALARM *hum_alarm = (HI_P2P_HUM_ALARM *)malloc(sizeof(HI_P2P_HUM_ALARM));
        memset(hum_alarm, 0, sizeof(HI_P2P_HUM_ALARM));
        memcpy(hum_alarm, data, size);
        
        self.u32Enable = hum_alarm->u32Enable;
        self.fMaxHumidity = hum_alarm->fMaxHumidity;
        self.fMinHumidity = hum_alarm->fMinHumidity;
        
        free(hum_alarm);
    }
    return self;
}


- (HI_P2P_HUM_ALARM *)model {
    
    HI_P2P_HUM_ALARM *hum_alarm = (HI_P2P_HUM_ALARM *)malloc(sizeof(HI_P2P_HUM_ALARM));
    memset(hum_alarm, 0, sizeof(HI_P2P_HUM_ALARM));
    
    hum_alarm->u32Enable = (HI_U32)self.u32Enable;
    hum_alarm->fMaxHumidity = (HI_FLOAT)self.fMaxHumidity;
    hum_alarm->fMinHumidity = (HI_FLOAT)self.fMinHumidity;

    return hum_alarm;
}


@end
