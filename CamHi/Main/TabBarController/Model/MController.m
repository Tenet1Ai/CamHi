//
//  MController.m
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "MController.h"

@implementation MController

+ (instancetype)initWithName:(NSString *)name title:(NSString *)title navigationTitle:(NSString *)ntitle tabbarImage:(NSString *)image tabbarImageSelect:(NSString *)simage {
    
    MController *controller = [[MController alloc] init];
    controller.className = name;
    controller.classTitle = title;
    controller.navigationTitle = ntitle;
    controller.tabbarImage = image;
    controller.tabbarImageSelect = simage;
    
    return controller;
}

@end
