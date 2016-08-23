//
//  Display.h
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Display : NSObject

/****************HI_P2P_GET_DISPLAY_PARAM  HI_P2P_SET_DISPLAY_PARAM*******************/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_U32 u32Brightness;
//    HI_U32 u32Contrast;
//    HI_U32 u32Saturation;
//    HI_U32 u32Sharpness;
//    HI_U32 u32Flip;
//    HI_U32 u32Mirror;
//    HI_U32 u32Mode;
//    HI_U32 u32Wdr;
//    HI_U32 u32Shutter;
//    HI_U32 u32Night;
//} HI_P2P_S_DISPLAY;
/****************HI_P2P_GET_DISPLAY_PARAM  HI_P2P_SET_DISPLAY_PARAM*******************/


@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Brightness;
@property (nonatomic, assign) unsigned int u32Contrast;
@property (nonatomic, assign) unsigned int u32Saturation;
@property (nonatomic, assign) unsigned int u32Sharpness;
@property (nonatomic, assign) unsigned int u32Flip;
@property (nonatomic, assign) unsigned int u32Mirror;
@property (nonatomic, assign) unsigned int u32Mode;
@property (nonatomic, assign) unsigned int u32Wdr;
@property (nonatomic, assign) unsigned int u32Shutter;
@property (nonatomic, assign) unsigned int u32Night;

- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_DISPLAY *)model;

@end
