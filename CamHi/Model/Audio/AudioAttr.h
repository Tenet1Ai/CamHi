//
//  AudioAttr.h
//  CamHi
//
//  Created by HXjiang on 16/8/5.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioAttr : NSObject

/****************HI_P2P_GET_AUDIO_ATTR  HI_P2P_SET_AUDIO_ATTR*******************/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_U32 u32Enable;
//    HI_U32 u32Stream;           /*HI_P2P_STREAM_1 ...*/
//    HI_U32 u32AudioType;
//    HI_U32 u32InMode;		/*0：线性输入1：麦克输入*/
//    HI_U32 u32InVol;	/* 输入音量*/
//    HI_U32 u32OutVol;  /*输出音量*/
//} HI_P2P_S_AUDIO_ATTR;
/****************HI_P2P_GET_AUDIO_ATTR  HI_P2P_SET_AUDIO_ATTR*******************/

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Enable;
@property (nonatomic, assign) unsigned int u32Stream;
@property (nonatomic, assign) unsigned int u32AudioType;
@property (nonatomic, assign) unsigned int u32InMode;
@property (nonatomic, assign) unsigned int u32InVol;
@property (nonatomic, assign) unsigned int u32OutVol;

- (id)initWithData:(char *)data size:(int)size;
- (id)initWithMode:(HI_P2P_S_AUDIO_ATTR *)model;
- (HI_P2P_S_AUDIO_ATTR *)model;

@end
