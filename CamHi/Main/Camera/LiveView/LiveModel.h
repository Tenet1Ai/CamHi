//
//  LiveModel.h
//  CamHi
//
//  Created by HXjiang on 16/9/22.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveModel : NSObject

@property (nonatomic, copy) NSString *normalImgName;
@property (nonatomic, copy) NSString *selectImgName;
@property (nonatomic, assign) SEL normalSelector;
@property (nonatomic, assign) SEL selectSelector;

+ (instancetype)modelWithNormalImage:(NSString *)normalImg selectImage:(NSString *)selectImg normalSel:(SEL)normalSelector selectSel:(SEL)selectSelector;

@end
