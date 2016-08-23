//
//  MdParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MdParam : NSObject


/****************HI_P2P_GET_MD_PARAM  HI_P2P_SET_MD_PARAM******************
 移动侦测参数的设置************************************************/
//#define HI_P2P_MOTION_AREA_MAX	4
//#define HI_P2P_MOTION_AREA_1    1
//#define HI_P2P_MOTION_AREA_2    2
//#define HI_P2P_MOTION_AREA_3    3
//#define HI_P2P_MOTION_AREA_4    4
//typedef struct
//{
//    HI_U32 u32Area;/*获取和设置那个区域就赋值那个区域*/
//    HI_U32 u32Enable;
//    HI_U32 u32X;
//    HI_U32 u32Y;
//    HI_U32 u32Width;
//    HI_U32 u32Height;
//    HI_U32 u32Sensi;	/* 报警灵敏度，取值范围1~99 */
//} HI_P2P_S_MD_AREA;
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_P2P_S_MD_AREA struArea;
//} HI_P2P_S_MD_PARAM;
/****************HI_P2P_GET_MD_PARAM  HI_P2P_SET_MD_PARAM*******************/



@property (nonatomic, assign) unsigned int u32Area;
@property (nonatomic, assign) unsigned int u32Enable;
@property (nonatomic, assign) unsigned int u32X;
@property (nonatomic, assign) unsigned int u32Y;
@property (nonatomic, assign) unsigned int u32Width;
@property (nonatomic, assign) unsigned int u32Height;
@property (nonatomic, assign) unsigned int u32Sensi;
@property (nonatomic, assign) unsigned int u32Channel;

- (id)initWithData:(char *)data size:(int)size;

- (HI_P2P_S_MD_PARAM *)requestModel;
- (HI_P2P_S_MD_PARAM *)model;
- (NSInteger)sensi;

@end
