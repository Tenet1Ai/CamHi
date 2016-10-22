//
//  TimeZoneViewController.h
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ViewController.h"

@interface TimeZoneViewController : ViewController

@property (nonatomic, strong) TimeZone *timeZone;
@property (nonatomic, copy)  void(^timezoneBlock)(BOOL success, NSInteger cmd, TimeZone *tzone);

@end
