//
//  RecAutoParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecAutoParam : NSObject

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Enable;
@property (nonatomic, assign) unsigned int u32FileLen;
@property (nonatomic, assign) unsigned int u32Stream;

- (id)initWihtData:(char *)data size:(int)size;
- (id)initWithMode:(HI_P2P_S_REC_AUTO_PARAM *)model;
- (HI_P2P_S_REC_AUTO_PARAM *)model;

@end
