//
//  HiChipSDK.h
//  CamHi
//
//  Created by zhao qi on 16/7/16.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define P2P_SY_SERVER "EFGNFJBOKAIEGHJOEKHAFPEDGLNMHMNHHHFKBADPAGJDLLKPDMANCCPKGFLBIBLCAMMLKHDOOKNKBPCIJEMA"


@protocol HiChipInitCallback <NSObject>
@optional

- (void)onInitResult:(int)result;

@end




@interface HiChipSDK : NSObject


+(void) initAsync:(id<HiChipInitCallback>)delegate;

+(int) init;

+(int) uninit;

+(NSString*) getSDKVersion;

@end
