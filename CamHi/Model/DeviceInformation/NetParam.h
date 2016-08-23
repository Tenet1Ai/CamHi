//
//  NetParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetParam : NSObject


/****************HI_P2P_GET_NET_PARAM  HI_P2P_SET_NET_PARAM*******************/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_CHAR strIPAddr[HI_P2P_NET_LEN];
//    HI_CHAR strNetMask[HI_P2P_NET_LEN];
//    HI_CHAR strGateWay[HI_P2P_NET_LEN];
//    HI_CHAR strFDNSIP[HI_P2P_NET_LEN];
//    HI_CHAR strSDNSIP[HI_P2P_NET_LEN];
//    HI_U32	u32Port;
//    HI_U32 u32DhcpFlag;
//    HI_U32 u32DnsDynFlag;
//} HI_P2P_S_NET_PARAM;
/****************HI_P2P_GET_NET_PARAM  HI_P2P_SET_NET_PARAM*******************/


@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Port;
@property (nonatomic, assign) unsigned int u32DhcpFlag;
@property (nonatomic, assign) unsigned int u32DnsDynFlag;

@property (nonatomic, copy) NSString *strIPAddr;
@property (nonatomic, copy) NSString *strNetMask;
@property (nonatomic, copy) NSString *strGateWay;
@property (nonatomic, copy) NSString *strFDNSIP;
@property (nonatomic, copy) NSString *strSDNSIP;


- (id)initWithData:(char *)data size:(int)size;

@end
