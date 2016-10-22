//
//  SecureViewController.h
//  CamHi
//
//  Created by HXjiang on 16/8/12.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ViewController.h"

@interface SecureViewController : ViewController


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void(^connectionTypeBlock)(BOOL success, NSInteger cmd, int type);

@end
