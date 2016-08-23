//
//  TimeParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "TimeParam.h"

@implementation TimeParam

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_TIME_PARAM *model = (HI_P2P_S_TIME_PARAM *)malloc(sizeof(HI_P2P_S_TIME_PARAM));
        memset(model, 0, sizeof(HI_P2P_S_TIME_PARAM));
        memcpy(model, data, size);
        
        _u32Year    = model->u32Year;
        _u32Month   = model->u32Month;
        _u32Day     = model->u32Day;
        _u32Hour    = model->u32Hour;
        _u32Minute  = model->u32Minute;
        _u32Second  = model->u32Second;
        
        free(model);
    }
    return self;
}


- (HI_P2P_S_TIME_PARAM *)model {
    
    HI_P2P_S_TIME_PARAM *t_model = (HI_P2P_S_TIME_PARAM *)malloc(sizeof(HI_P2P_S_TIME_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_S_TIME_PARAM));
    
    t_model->u32Year    = _u32Year;
    t_model->u32Month   = _u32Month;
    t_model->u32Day     = _u32Day;
    t_model->u32Hour    = _u32Hour;
    t_model->u32Minute  = _u32Minute;
    t_model->u32Second  = _u32Second;
    
    return t_model;
}



- (NSString *)time {
    return  [NSString stringWithFormat:@"%04d-%02d-%02d  %02d:%02d:%02d", _u32Year, _u32Month, _u32Day, _u32Hour, _u32Minute, _u32Second];
}

- (void)syncCurrentTime {
    
    _u32Year    = [GDate cyear].intValue;
    _u32Month   = [GDate cmonth].intValue;
    _u32Day     = [GDate cday].intValue;
    _u32Hour    = [GDate chour].intValue;
    _u32Minute  = [GDate cminute].intValue;
    _u32Second  = [GDate csecond].intValue;

}

@end
