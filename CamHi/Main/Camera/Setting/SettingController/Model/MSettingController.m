//
//  MSettingController.m
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "MSettingController.h"

@implementation MSettingController

+ (instancetype)initWithName:(NSString *)name title:(NSString *)title {
    
    MSettingController *controller = [[MSettingController alloc] init];
    controller.className = name;
    controller.classTitle = title;
    
    return controller;
}

@end
