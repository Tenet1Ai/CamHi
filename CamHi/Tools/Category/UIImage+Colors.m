//
//  UIImage+Colors.m
//  LastMissor
//
//  Created by HXjiang on 16/7/1.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "UIImage+Colors.h"

@implementation UIImage (Colors)

+ (UIImage *)imageWithColor:(UIColor *)color wihtSize:(CGSize)size {
    
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
