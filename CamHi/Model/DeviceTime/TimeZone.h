//
//  TimeZone.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeZone : NSObject

/****************HI_P2P_SET_TIME_ZONE  HI_P2P_GET_TIME_ZONE*************/
//typedef struct
//{
//    HI_U32 u32Channel;/*ipc: 0*/
//    HI_S32 s32TimeZone;
//    HI_U32 u32DstMode;
//}HI_P2P_S_TIME_ZONE;
/****************HI_P2P_SET_TIME_ZONE  HI_P2P_GET_TIME_ZONE*************/

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32DstMode;
@property (nonatomic, assign) int s32TimeZone;

- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_S_TIME_ZONE *)model;


@end
