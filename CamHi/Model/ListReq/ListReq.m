//
//  ListReq.m
//  CamHi
//
//  Created by HXjiang on 16/8/19.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ListReq.h"

@interface ListReq ()

@property (nonatomic, strong) NSDateFormatter *tFormatter;

@end

@implementation ListReq

- (instancetype)init {
    if (self = [super init]) {
        
        self.startTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        self.stopTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        self.isSerach = NO;
    }
    return self;
}



- (HI_P2P_S_PB_LIST_REQ *)model {
    
    STimeDay start = [self getTimeDay:self.startTime];
    STimeDay stop = [self getTimeDay:self.stopTime];

    if (!self.isSerach) {
        
        start.second = 0;
        start.hour = 0;
        start.minute = 0;
    }
    

    
    LOG(@"start.day:%d", start.day)
    LOG(@"start.hour:%d", start.hour)
    LOG(@"start.minute:%d", start.minute)
    LOG(@"start.second:%d", start.second)
    LOG(@"start.wday:%d", start.wday)

    return [self modelForStartTimeDay:start stopTimeDay:stop];
}

- (HI_P2P_S_PB_LIST_REQ *)modelForStartTimeDay:(STimeDay)start stopTimeDay:(STimeDay)stop {
    
    HI_P2P_S_PB_LIST_REQ* list_req = (HI_P2P_S_PB_LIST_REQ *)malloc(sizeof(HI_P2P_S_PB_LIST_REQ));
    memset(list_req, 0, sizeof(HI_P2P_S_PB_LIST_REQ));
    
    list_req->u32Chn = 0;
    list_req->sStartTime = start;
    list_req->sEndtime = stop;
    list_req->EventType = EVENT_ALL;
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //和格林尼治时间差
    NSInteger timeOff = [zone secondsFromGMT];
    
    int mode = ((int)(timeOff / 36))%100;
    
    char timeZone = 0;
    
    if (timeOff > 0 && mode == 0) {
        timeZone = (char)(timeOff / 3600);
    }
    else if(timeOff <=0 && mode == 0) {
        timeZone = (char)(-timeOff/3600 + 24);
    }
    else if(timeOff >0 && mode == 50) {
        timeZone = (char)(timeOff/3600 + 72);
    }
    else if(timeOff <=0 && mode == -50) {
        timeZone = (char)(-timeOff/3600 + 48);
    }
    
    NSLog(@"timezone:%ld",(long)timeOff);
    NSLog(@">>>start:%d-%d-%d-%d-%d-%d-%d", start.year, start.month, start.day, start.hour, start.minute, start.second, start.wday);
    NSLog(@">>>stop:%d-%d-%d-%d-%d-%d-%d", stop.year, stop.month, stop.day, stop.hour, stop.minute, stop.second, stop.wday);

    list_req->sReserved[0] = timeZone;
    
    return list_req;
}



- (STimeDay)getTimeDay:(long)time {
    
    STimeDay result;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    
    
    self.tFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    
    [self.tFormatter setDateFormat:@"yyyy"];
    result.year = [[self.tFormatter stringFromDate:date] intValue];
    
    [self.tFormatter setDateFormat:@"MM"];
    result.month = [[self.tFormatter stringFromDate:date] intValue];
    
    [self.tFormatter setDateFormat:@"dd"];
    result.day = [[self.tFormatter stringFromDate:date] intValue];
    
    [self.tFormatter setDateFormat:@"e"];
    result.wday = [[self.tFormatter stringFromDate:date] intValue];
    
    [self.tFormatter setDateFormat:@"HH"];
    result.hour = [[self.tFormatter stringFromDate:date] intValue];
    
    [self.tFormatter setDateFormat:@"mm"];
    result.minute = [[self.tFormatter stringFromDate:date] intValue];
    
    [self.tFormatter setDateFormat:@"ss"];
    result.second = [[self.tFormatter stringFromDate:date] intValue];
    
    return result;
}

- (NSDateFormatter *)tFormatter {
    if (!_tFormatter) {
        _tFormatter = [[NSDateFormatter alloc] init];
    }
    return _tFormatter;
}



@end
