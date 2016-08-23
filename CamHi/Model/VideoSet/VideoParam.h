//
//  VideoParam.h
//  CamHi
//
//  Created by HXjiang on 16/8/5.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoParam : NSObject

/****************HI_P2P_GET_VIDEO_PARAM  HI_P2P_SET_VIDEO_PARAM*******************/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_U32 u32Stream;           /*HI_P2P_STREAM_1 ...*/
//    HI_U32 u32Cbr;
//    HI_U32 u32Frame;
//    HI_U32 u32BitRate;
//    HI_U32 u32Quality;
//    HI_U32 u32IFrmInter;
//} HI_P2P_S_VIDEO_PARAM;
/****************HI_P2P_GET_VIDEO_PARAM  HI_P2P_SET_VIDEO_PARAM*******************/


@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Stream;
@property (nonatomic, assign) unsigned int u32Cbr;
@property (nonatomic, assign) unsigned int u32Frame;
@property (nonatomic, assign) unsigned int u32BitRate;
@property (nonatomic, assign) unsigned int u32Quality;
@property (nonatomic, assign) unsigned int u32IFrmInter;


- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_VIDEO_PARAM *)model;

@end
