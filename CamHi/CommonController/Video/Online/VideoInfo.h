//
//  VideoInfo.h
//  CamHi
//
//  Created by zhao qi on 15/5/4.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hi_p2p_ipc_protocol.h"

@interface VideoInfo : NSObject 

@property (nonatomic, retain) NSString *UUID;
@property int eventType;
@property long startTime;
@property long endTime;
@property int eventStatus;

+ (NSString *)getEventTypeName:(int)eventType;
+ (STimeDay)getTimeDay:(long)time;
- (id)initWithEventType:(int)type StertTime:(long)sTime EndTime:(long)eTime EventStatus:(int)status;

@end
