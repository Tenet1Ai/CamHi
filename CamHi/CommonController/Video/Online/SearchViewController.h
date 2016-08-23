//
//  SearchViewController.h
//  CamHi
//
//  Created by HXjiang on 16/8/19.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ViewController.h"

@interface SearchViewController : ViewController

@property (nonatomic, copy) void(^searchBlock)(NSTimeInterval startTime, NSTimeInterval stopTime);

@end
