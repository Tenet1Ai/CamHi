//
//  MController.h
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MController : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *classTitle;
@property (nonatomic, copy) NSString *navigationTitle;
@property (nonatomic, copy) NSString *tabbarImage;
@property (nonatomic, copy) NSString *tabbarImageSelect;

+ (instancetype)initWithName:(NSString *)name title:(NSString *)title navigationTitle:(NSString *)ntitle tabbarImage:(NSString *)image tabbarImageSelect:(NSString *)simage;

@end
