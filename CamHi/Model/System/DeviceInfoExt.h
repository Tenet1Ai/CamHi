//
//  DeviceInfoExt.h
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoExt : NSObject


/**************************HI_P2P_GET_DEV_INFO_EXT************************/
//typedef struct
//{
//    HI_U32 u32Channel;
//    HI_CHAR strCableMAC[32];
//    HI_CHAR strWifiMAC[32];
//    HI_U32  u32NetType;
//    HI_CHAR aszSystemSoftVersion[HI_P2P_MAX_VERLENGTH];
//    HI_CHAR strHardVer[32];
//   	HI_CHAR aszSystemName[HI_P2P_MAX_STRINGLENGTH];		/*设备名称*/
//    HI_S32  sUserNum;									/*用户连接数*/
//    
//    HI_CHAR aszSystemModel[HI_P2P_MAX_STRINGLENGTH];
//   	HI_CHAR aszStartDate[HI_P2P_MAX_STRINGLENGTH];
//   	HI_S32  s32SDStatus;
//   	HI_S32  s32SDFreeSpace;
//   	HI_S32  s32SDTotalSpace;
//   	HI_CHAR aszWebVersion[HI_P2P_MAX_VERLENGTH];
//    HI_CHAR sReserved[8];								/*预留*/
//}HI_P2P_S_DEV_INFO_EXT;
/**************************HI_P2P_GET_DEV_INFO_EXT************************/


@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32NetType;
@property (nonatomic, assign) unsigned int sUserNum;
@property (nonatomic, assign) unsigned int s32SDStatus;
@property (nonatomic, assign) unsigned int s32SDFreeSpace;
@property (nonatomic, assign) unsigned int s32SDTotalSpace;

@property (nonatomic, copy) NSString *strCableMAC;
@property (nonatomic, copy) NSString *strWifiMAC;
@property (nonatomic, copy) NSString *strHardVer;
@property (nonatomic, copy) NSString *aszSystemSoftVersion;
@property (nonatomic, copy) NSString *aszSystemName;
@property (nonatomic, copy) NSString *aszSystemModel;
@property (nonatomic, copy) NSString *aszStartDate;
@property (nonatomic, copy) NSString *aszWebVersion;
@property (nonatomic, copy) NSString *sReserved;

- (id)initWithData:(char *)data size:(int)size;


@end
