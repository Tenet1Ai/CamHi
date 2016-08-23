//
//  VideoCode.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCode : NSObject

/**************************HI_P2P_GET_CODING*******************************/
//typedef struct
//{
//    HI_U32 u32Channel;
//    HI_U32 u32Frequency; 	/*50Hz、60Hz*/
//    HI_U32 u32Profile;		/*0: baseline 1: mainprofile*/
//    HI_CHAR sReserved[8];	/*预留*/
//} HI_P2P_CODING_PARAM;
/**************************HI_P2P_GET_CODING*******************************/

@property (nonatomic, assign) unsigned int u32Channel;
@property (nonatomic, assign) unsigned int u32Frequency;
@property (nonatomic, assign) unsigned int u32Profile;
@property (nonatomic, copy) NSString *sReserved;




- (id)initWithData:(char *)data size:(int)size;
- (HI_P2P_CODING_PARAM *)model;


@end
