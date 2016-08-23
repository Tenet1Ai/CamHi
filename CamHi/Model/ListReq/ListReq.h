//
//  ListReq.h
//  CamHi
//
//  Created by HXjiang on 16/8/19.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListReq : NSObject

//获取录像列表

- (HI_P2P_S_PB_LIST_REQ *)model;

@property BOOL isSerach;
@property NSTimeInterval startTime;
@property NSTimeInterval stopTime;


@end
