//
//  PhotoModel.h
//  CamHi
//
//  Created by HXjiang on 16/8/17.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

//@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *imgPath;

@property BOOL ismark;
- (id)initWithImageName:(NSString *)imgName;

@end
