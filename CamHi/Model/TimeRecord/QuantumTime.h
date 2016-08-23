//
//  QuantumTime.h
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuantumTime : NSObject


@property (nonatomic, assign) unsigned int u32QtType;
@property (nonatomic, assign) unsigned int recordTime;

- (id)initWithData:(char *)data size:(int)size;
- (id)initWithMode:(HI_P2P_QUANTUM_TIME *)model;
- (HI_P2P_QUANTUM_TIME *)model;

@end
