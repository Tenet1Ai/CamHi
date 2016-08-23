//
//  TimeParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDate.h"

@interface TimeParam : NSObject

/****************HI_P2P_GET_TIME_PARAM  HI_P2P_SET_TIME_PARAM*************/
//typedef struct
//{
//    HI_U32  u32Year;
//    HI_U32  u32Month;
//    HI_U32  u32Day;
//    HI_U32  u32Hour;
//    HI_U32  u32Minute;
//    HI_U32  u32Second;
//} HI_P2P_S_TIME_PARAM;
/****************HI_P2P_GET_TIME_PARAM  HI_P2P_SET_TIME_PARAM*************/


@property (nonatomic, assign) unsigned int u32Year;
@property (nonatomic, assign) unsigned int u32Month;
@property (nonatomic, assign) unsigned int u32Day;
@property (nonatomic, assign) unsigned int u32Hour;
@property (nonatomic, assign) unsigned int u32Minute;
@property (nonatomic, assign) unsigned int u32Second;

- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_TIME_PARAM *)model;
- (NSString *)time;
- (void)syncCurrentTime;

@end
