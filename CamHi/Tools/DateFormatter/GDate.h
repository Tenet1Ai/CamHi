//
//  GDate.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDate : NSDateFormatter



+ (NSString *)cyear;
+ (NSString *)cmonth;
+ (NSString *)cday;
+ (NSString *)cwday;
+ (NSString *)chour;
+ (NSString *)cminute;
+ (NSString *)csecond;


@end
