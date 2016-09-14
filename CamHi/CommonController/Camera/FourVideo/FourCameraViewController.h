//
//  FourCameraViewController.h
//  CamHi
//
//  Created by HXjiang on 16/9/7.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ViewController.h"

@interface FourCameraViewController : ViewController

@property (nonatomic, assign) NSInteger viewTag;
@property (nonatomic, copy) void(^selectCameraBlock)(Camera *mycam, NSInteger tag);

@end
