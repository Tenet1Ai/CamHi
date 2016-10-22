//
//  MSettingController.h
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSettingController : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *classTitle;

+ (instancetype)initWithName:(NSString *)name title:(NSString *)title;

@end
