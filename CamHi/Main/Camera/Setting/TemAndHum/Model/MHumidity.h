//
//  MHumidity.h
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

///********************HI_P2P_HUMIDITY_ALARM_GET*********************/
//typedef struct
//{
//    HI_U32 u32Enable;
//    HI_FLOAT fMaxHumidity;
//    HI_FLOAT fMinHumidity;
//}HI_P2P_HUM_ALARM;
///********************HI_P2P_HUMIDITY_ALARM_GET*********************/

@interface MHumidity : NSObject

@property (nonatomic, assign) NSInteger u32Enable;
@property (nonatomic, assign) CGFloat fMaxHumidity;
@property (nonatomic, assign) CGFloat fMinHumidity;

- (instancetype)initWithData:(char *)data size:(int)size;
- (HI_P2P_HUM_ALARM *)model;

@end
