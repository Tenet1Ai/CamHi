//
//  TimeZoneInfo.h
//  CamHi
//
//  Created by zhao qi on 15/5/9.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface TimeZoneInfo : NSObject


@property (nonatomic, copy) NSString *abbreviation;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) int timeZone;
@property (nonatomic, assign) int dstMode;


- (id)initWithTimeZone:(int)timezone DstMode:(long)dstmode Abbreviation:(NSString*)abb Detail:(NSString*)dec;




@end
