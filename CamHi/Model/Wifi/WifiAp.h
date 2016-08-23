//
//  WifiAp.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiAp : NSObject

//typedef struct
//{
//    HI_CHAR strSSID[32];			// WiFi ssid
//    HI_CHAR Mode;	   				// refer to ENUM_AP_MODE
//    HI_CHAR EncType; 				// refer to ENUM_AP_ENCTYPE
//    HI_CHAR Signal;   				// signal intensity 0--100%
//    HI_CHAR Status;   				// 0 : invalid ssid
//    // 1 : connected
//}SWifiAp;
//#define HI_P2P_MAX_LIST_WIFI_NUM 26


@property (nonatomic, strong) NSNumber *Mode;
@property (nonatomic, strong) NSNumber *EncType;
@property (nonatomic, strong) NSNumber *Signal;
@property (nonatomic, strong) NSNumber *Status;
@property (nonatomic, copy) NSString *strSSID;


- (id)initWithData:(char *)data size:(int)size;
- (id)initWithSWifiAp:(SWifiAp)swifiap;
- (NSString *)strEncType;

@end
