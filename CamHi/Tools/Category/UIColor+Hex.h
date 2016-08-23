//
//  UIColor+Hex.h
//  LastMissor
//
//  Created by HXjiang on 16/7/1.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA_COLOR(R, G, B, A)  ([UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A])
#define RGB_COLOR(R, G, B)      ([UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f])

@interface UIColor (Hex)

//十六进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色
//color:支持@"#123456"    @"0x123456"     @"123456"   三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
