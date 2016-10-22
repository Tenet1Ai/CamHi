//
//  PhotoModel.m
//  CamHi
//
//  Created by HXjiang on 16/8/17.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel


- (id)initWithImageName:(NSString *)imgName {
    if (self = [super init]) {
        
        _ismark = NO;
        _imgName = imgName;
        _imgPath = [self imgFilePathWithImgName:_imgName];
        //_image = [UIImage imageWithContentsOfFile:_imgPath];
        
        //LOG(@"_image:%@", _image)
    }
    return self;
}


//本地图片文件位置
- (NSString *)imgFilePathWithImgName:(NSString *)imgName {
    NSArray *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[directory objectAtIndex:0] stringByAppendingPathComponent:imgName];
}


@end
