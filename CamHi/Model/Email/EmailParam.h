//
//  EmailParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/11.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailParam : NSObject


/*******HI_P2P_GET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM_EXT*******/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_CHAR strSvr[64];
//    HI_U32  u32Port;
//    HI_U32  u32Auth;
//    HI_U32  u32LoginType;	/*1：开启验证   3：关闭验证*/
//    HI_CHAR strUsernm[64];
//    HI_CHAR strPasswd[64];
//    HI_CHAR strFrom[64];
//    HI_CHAR strTo[3][64];
//    HI_CHAR strSubject[128];
//    HI_CHAR strText[256];
//} HI_P2P_S_EMAIL_PARAM;
//
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_CHAR strSvr[64];
//    HI_U32  u32Port;
//    HI_U32  u32Auth;
//    HI_U32  u32LoginType;	/*1：开启验证   3：关闭验证*/
//    HI_CHAR strUsernm[64];
//    HI_CHAR strPasswd[64];
//    HI_CHAR strFrom[64];
//    HI_CHAR strTo[3][64];
//    HI_CHAR strSubject[128];
//    HI_CHAR strText[256];
//    HI_U32  u32Check;				/*1:check,  0:no check*/
//    HI_CHAR strReserved[8];		/*预留*/
//} HI_P2P_S_EMAIL_PARAM_EXT;

/*******HI_P2P_GET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM_EXT*******/



@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Port;
@property (nonatomic, assign) unsigned int u32Auth;
@property (nonatomic, assign) unsigned int u32LoginType;
@property (nonatomic, assign) unsigned int u32Check;

@property (nonatomic, copy) NSString *strSvr;
@property (nonatomic, copy) NSString *strUsernm;
@property (nonatomic, copy) NSString *strPasswd;
@property (nonatomic, copy) NSString *strFrom;
@property (nonatomic, copy) NSString *strTo;
@property (nonatomic, copy) NSString *strSubject;
@property (nonatomic, copy) NSString *strText;
@property (nonatomic, copy) NSString *strReserved;


- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_EMAIL_PARAM_EXT *)checkModel;
- (HI_P2P_S_EMAIL_PARAM *)model;
- (NSString *)connectionType;

@end
