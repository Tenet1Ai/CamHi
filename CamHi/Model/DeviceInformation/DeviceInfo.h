//
//  DeviceInfo.h
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

/****************HI_P2P_GET_DEV_INFO*************/
//#define HI_P2P_NET_TYPE_CABLE 0
//#define HI_P2P_NET_TYPE_WIFI  1
//typedef struct
//{
//    HI_CHAR strCableMAC[32];
//    HI_CHAR strWifiMAC[32];
//    HI_U32  u32NetType;
//    HI_CHAR strSoftVer[32];
//    HI_CHAR strHardVer[32];
//    
//    HI_CHAR strDeviceName[32];		/*设备名称*/
//    HI_S32  sUserNum;				/*用户连接数*/
//} HI_P2P_S_DEV_INFO;
/****************HI_P2P_GET_DEV_INFO*************/


@property (nonatomic, assign) unsigned int u32NetType;
@property (nonatomic, assign) unsigned int sUserNum;
@property (nonatomic, copy) NSString *strCableMAC;
@property (nonatomic, copy) NSString *strWifiMAC;
@property (nonatomic, copy) NSString *strSoftVer;
@property (nonatomic, copy) NSString *strHardVer;
@property (nonatomic, copy) NSString *strDeviceName;


- (id)initWithData:(char *)data size:(int)size;
- (NSString *)netType;

@end
