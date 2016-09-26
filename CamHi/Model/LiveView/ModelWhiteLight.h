//
//  ModelWhiteLight.h
//  CamHi
//
//  Created by HXjiang on 16/9/23.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>


// 白光
///**************************HI_P2P_WHITE_LIGHT_GET**************************/
//typedef struct
//{
//    HI_U32 u32Chn;			/*ipc :0*/
//    HI_U32 u32State;		/*0: 关,  1: 开*/
//    HI_S8 sReserved[4];
//}HI_P2P_WHITE_LIGHT_INFO;
///**************************HI_P2P_WHITE_LIGHT_GET**************************/

// 夜视
///**************************HI_P2P_WHITE_LIGHT_GET_EXT**************************/
//typedef struct
//{
//    HI_U32 u32Chn;			/*ipc :0*/
//    HI_U32 u32State;		/*0普通,1彩色,2智能*/
//    HI_S8 sReserved[4];
//}HI_P2P_WHITE_LIGHT_INFO_EXT;
///**************************HI_P2P_WHITE_LIGHT_GET_EXT**************************/


@interface ModelWhiteLight : NSObject

@property (nonatomic, assign) HI_U32 u32Chn;
@property (nonatomic, assign) HI_U32 u32State;
@property (nonatomic, copy) NSString *sReserved;

- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_WHITE_LIGHT_INFO *)model;

- (id)initWithData:(char *)data size:(int)size command:(int)cmd;
- (HI_P2P_WHITE_LIGHT_INFO_EXT *)modelExt;

@end
