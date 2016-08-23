//
//  WifiList.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WifiAp.h"

@interface WifiList : NSObject

//typedef struct
//{
//    HI_U32 u32Num;
//    SWifiAp sWifiInfo[0];
//} HI_P2P_S_WIFI_LIST;



@property (nonatomic, assign) unsigned int u32Num;
@property (nonatomic, strong) NSMutableArray *wifis;

- (id)initWithData:(char *)data size:(int)size;

@end
