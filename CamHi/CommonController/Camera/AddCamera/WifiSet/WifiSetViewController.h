//
//  WifiSetViewController.h
//  CamHi
//
//  Created by HXjiang on 16/8/19.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ViewController.h"

#define SMART_WIFI_TIME (60)

@interface WifiSetViewController : ViewController


@property (nonatomic, copy) void(^setwifiBlock)(BOOL success, NSInteger type);

@end
