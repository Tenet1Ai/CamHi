//
//  GDate.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "GDate.h"

@implementation GDate

+ (GDate *)sharedFormatter {
    
    static GDate *gdateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gdateFormatter = [[GDate alloc] init];
    });
    return gdateFormatter;
}



+ (NSString *)formatter:(NSString *)dateFormatter {
    GDate *gd = [GDate sharedFormatter];
    gd.dateFormat = dateFormatter;
    return [gd stringFromDate:[NSDate date]];
}

+ (NSString *)cyear {
    return [self formatter:@"yyyy"];
}

+ (NSString *)cmonth {
    return [self formatter:@"MM"];
}

+ (NSString *)cday {
    return [self formatter:@"dd"];
}

+ (NSString *)cwday {
    return [self formatter:@"e"];
}

+ (NSString *)chour {
    return [self formatter:@"HH"];
}

+ (NSString *)cminute {
    return [self formatter:@"mm"];
}

+ (NSString *)csecond {
    return [self formatter:@"ss"];
}


@end
