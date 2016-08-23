//
//  WifiParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiParam : NSObject

//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_U32 u32Enable;
//    HI_CHAR Mode;/*ENUM_AP_MODE*/
//    HI_CHAR EncType;/*ENUM_AP_ENCTYPE*/
//    HI_CHAR strSSID[32];
//    HI_CHAR strKey[HI_P2P_NET_LEN];
//} HI_P2P_S_WIFI_PARAM;

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Enable;
@property (nonatomic, strong) NSNumber *Mode;
@property (nonatomic, strong) NSNumber *EncType;
@property (nonatomic, copy) NSString *strSSID;
@property (nonatomic, copy) NSString *strKey;


- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_WIFI_PARAM *)model;

@end
