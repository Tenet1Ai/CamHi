//
//  SetDownload.h
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetDownload : NSObject

/**************************HI_P2P_SET_DOWNLOAD**************************/
//#define HI_DOWN_PATH_LEN 128
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_CHAR sFileName[HI_DOWN_PATH_LEN]; /*APP 从服务器获取的最新升级文件地址（名）*/
//}HI_P2P_S_SET_DOWNLOAD;
/**************************HI_P2P_SET_DOWNLOAD**************************/


@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, copy) NSString *sFileName;


- (HI_P2P_S_SET_DOWNLOAD *)model;

@end
