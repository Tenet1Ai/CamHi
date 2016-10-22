//
//  MTemperature.m
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "MTemperature.h"

@implementation MTemperature

- (instancetype)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size < 0 || size != sizeof(HI_P2P_TMP_ALARM)) {
            return nil;
        }
        
        HI_P2P_TMP_ALARM *tmp_alarm = (HI_P2P_TMP_ALARM *)malloc(sizeof(HI_P2P_TMP_ALARM));
        memset(tmp_alarm, 0, sizeof(HI_P2P_TMP_ALARM));
        memcpy(tmp_alarm, data, size);
        
        self.u32Enable = tmp_alarm->u32Enable;
        self.fMaxTemperature = tmp_alarm->fMaxTemperature;
        self.fMinTemperature = tmp_alarm->fMinTemperature;
        
        free(tmp_alarm);
    }
    return self;
}

- (HI_P2P_TMP_ALARM *)model {
    
    HI_P2P_TMP_ALARM *tmp_alarm = (HI_P2P_TMP_ALARM *)malloc(sizeof(HI_P2P_TMP_ALARM));
    memset(tmp_alarm, 0, sizeof(HI_P2P_TMP_ALARM));
    
    tmp_alarm->u32Enable = (HI_U32)self.u32Enable;
    tmp_alarm->fMaxTemperature = (HI_FLOAT)self.fMaxTemperature;
    tmp_alarm->fMinTemperature = (HI_FLOAT)self.fMinTemperature;

    return tmp_alarm;
}

@end
