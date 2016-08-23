//
//  TimeZoneInfo.m
//  CamHi
//
//  Created by zhao qi on 15/5/9.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import "TimeZoneInfo.h"

@implementation TimeZoneInfo


- (id)initWithTimeZone:(int)timezone DstMode:(long)dstmode Abbreviation:(NSString*)abb Detail:(NSString*)dec {
    
    if (self = [super init]) {
        
        _timeZone       = timezone;
        _dstMode        = (int)dstmode;
        _abbreviation   = abb;
        _detail         = dec;
    }
    
    return self;
}

@end
