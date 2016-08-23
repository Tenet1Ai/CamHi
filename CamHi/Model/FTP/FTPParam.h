//
//  FTPParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/12.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTPParam : NSObject

/**********HI_P2P_GET_FTP_PARAM  HI_P2P_SET_FTP_PARAM  HI_P2P_GET_FTP_PARAM_EXT*********/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_CHAR strSvr[64];
//    HI_U32  u32Port;
//    HI_CHAR strUsernm[64];
//    HI_CHAR strPasswd[64];
//    HI_CHAR strFilePath[256];
//} HI_P2P_S_FTP_PARAM;
//
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_CHAR strSvr[64];
//    HI_U32  u32Port;
//    HI_U32  u32Mode;
//    HI_CHAR strUsernm[64];
//    HI_CHAR strPasswd[64];
//    HI_CHAR strFilePath[256];
//    HI_U32 u32CreatePath;			/*自动创建目录, 1:创建, 0:不创建*/
//    HI_U32 u32Check;				/*1:check, 0:no check*/
//    HI_CHAR strReserved[8];		/*预留*/
//} HI_P2P_S_FTP_PARAM_EXT;
/**********HI_P2P_GET_FTP_PARAM  HI_P2P_SET_FTP_PARAM  HI_P2P_GET_FTP_PARAM_EXT*********/

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Port;
@property (nonatomic, assign) unsigned int u32Mode;
@property (nonatomic, assign) unsigned int u32CreatePath;
@property (nonatomic, assign) unsigned int u32Check;

@property (nonatomic, copy) NSString *strSvr;
@property (nonatomic, copy) NSString *strUsernm;
@property (nonatomic, copy) NSString *strPasswd;
@property (nonatomic, copy) NSString *strFilePath;
@property (nonatomic, copy) NSString *strReserved;

- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_FTP_PARAM_EXT *)model;


@end
