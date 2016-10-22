//
//  MTemperature.h
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTemperature : NSObject

///******************HI_P2P_TEMPERATURE_ALARM_GET*******************/
//typedef struct
//{
//    HI_U32 u32Enable;
//    HI_FLOAT fMaxTemperature;
//    HI_FLOAT fMinTemperature;
//}HI_P2P_TMP_ALARM;
///******************HI_P2P_TEMPERATURE_ALARM_GET*******************/

@property (nonatomic, assign) NSInteger u32Enable;
@property (nonatomic, assign) CGFloat fMaxTemperature;
@property (nonatomic, assign) CGFloat fMinTemperature;

- (instancetype)initWithData:(char *)data size:(int)size;
- (HI_P2P_TMP_ALARM *)model;

@end
