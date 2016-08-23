//
//  QuantumTime.m
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "QuantumTime.h"

@implementation QuantumTime

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_QUANTUM_TIME *model = (HI_P2P_QUANTUM_TIME *)malloc(sizeof(HI_P2P_QUANTUM_TIME));
        memset(model, 0, sizeof(HI_P2P_QUANTUM_TIME));
        memcpy(model, data, size);
        
        _u32QtType     = model->u32QtType;
        
        _recordTime = 1;
        
        for (int i=0; i<7; i++) {
            for (int j=0; j<48; j++) {
                if(model->sDayData[i][j] == 'N') {
                    _recordTime = 0;
                }
            }
        }
        
        free(model);
    }
    return self;
}

- (id)initWithMode:(HI_P2P_QUANTUM_TIME *)model {
    if (self = [super init]) {
        
        _u32QtType     = model->u32QtType;
        
        _recordTime = 1;
        
        for (int i=0; i<7; i++) {
            for (int j=0; j<48; j++) {
                if(model->sDayData[i][j] == 'N') {
                    _recordTime = 0;
                }
            }
        }
        
        
    }
    return self;
}

- (HI_P2P_QUANTUM_TIME *)model {
    
    HI_P2P_QUANTUM_TIME *t_model = (HI_P2P_QUANTUM_TIME *)malloc(sizeof(HI_P2P_QUANTUM_TIME));
    memset(t_model, 0, sizeof(HI_P2P_QUANTUM_TIME));
    
    t_model->u32QtType  = _u32QtType;

    for (int i=0; i<7; i++) {
        for (int j=0; j<48; j++) {
            if (_recordTime == 0) {
                t_model->sDayData[i][j] = 'N';
            }
            else {
                t_model->sDayData[i][j] = 'P';
            }
        }
    }
    
    return t_model;
}

@end
