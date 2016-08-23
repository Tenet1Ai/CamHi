//
//  SDCard.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCard : NSObject

/****************HI_P2P_GET_SD_INFO*************/
//#define HI_P2P_SD_IS_NONE 	0
//#define HI_P2P_SD_IS_OK 	1
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_U32 u32Status;
//    HI_U32 u32Space;
//    HI_U32 u32LeftSpace;
//} HI_P2P_S_SD_INFO;
/****************HI_P2P_GET_SD_INFO*************/

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Status;
@property (nonatomic, assign) unsigned int u32Space;
@property (nonatomic, assign) unsigned int u32LeftSpace;


- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_SD_INFO *)model;
- (NSString *)total;
- (NSString *)available;


@end
