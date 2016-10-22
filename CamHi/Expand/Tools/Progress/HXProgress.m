//
//  HXProgress.m
//  LastMissor
//
//  Created by HXjiang on 16/6/29.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "HXProgress.h"

@interface HXProgress ()

@end


@implementation HXProgress

+ (instancetype)sharedProgress {
    
    static HXProgress *progress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        progress = [[HXProgress alloc] init];
    });
    
    return progress;
}

- (id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}


+ (void)showProgressSize:(CGSize)size Color:(UIColor *)color dissmissTime:(NSTimeInterval)seconds {
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    UIWindow *window  = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    HXProgress *p = [HXProgress sharedProgress];
    
    while (p.subviews.lastObject != nil) {
        [(UIView *)p.subviews.lastObject removeFromSuperview];
    }
    
    p.frame = CGRectMake(0, 0, w, h);
    p.center = window.center;
    p.backgroundColor = color;
    p.clipsToBounds = YES;
    p.layer.cornerRadius = 5.0f;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.center = CGPointMake(w/2, h/2);
    [activity startAnimating];
    
    [p addSubview:activity];
    
    [window addSubview:p];
    
    if (seconds > 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [activity stopAnimating];
            
            UIButton *btnDismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
            btnDismiss.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnDismiss setTitle:@"Time out!" forState:UIControlStateNormal];
            [btnDismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnDismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            [p addSubview:btnDismiss];
            
        });
    }

}

+ (void)showProgressWithSize:(CGSize)size withColor:(UIColor *)color {
    
    [self showProgressSize:size Color:color dissmissTime:0];
}

+ (void)showProgressWithSize:(CGSize)size {
   
    [self showProgressSize:size Color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] dissmissTime:0];
}

+ (void)showProgressWithSize:(CGSize)size timeOut:(NSTimeInterval)time {
    
    [self showProgressSize:size Color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] dissmissTime:time];
}

+ (void)showProgress {
    [self showProgressWithSize:CGSizeMake(50, 50)];
}


+ (void)showText:(NSString *)text transform:(CGFloat)rotate {
    [self showText:text Size:CGSizeMake(100, 50) Color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] dissmissTime:1 transform:rotate];
}

+ (void)showText:(NSString *)text Size:(CGSize)size Color:(UIColor *)color dissmissTime:(NSTimeInterval)seconds transform:(CGFloat)rotate {
    
    UIWindow *window  = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    HXProgress *p = [HXProgress sharedProgress];
    
    CGRect r = [p rectOfText:text WithFont:[UIFont systemFontOfSize:18]];
    CGFloat w = size.width > r.size.width ? size.width : r.size.width;
    CGFloat h = size.height > r.size.height ? size.height : r.size.height;
    
    while (p.subviews.lastObject != nil) {
        [(UIView *)p.subviews.lastObject removeFromSuperview];
    }
    
    //p.frame = CGRectMake(0, 0, w, h);
    p.frame = CGRectMake(0, 0, h, w);

    p.center = window.center;
    p.backgroundColor = color;
    p.clipsToBounds = YES;
    p.layer.cornerRadius = 5.0f;
    //p.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate);
    
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
    l.text = text;
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.center = CGPointMake(w/2, h/2);
    l.adjustsFontSizeToFitWidth = YES;
    //l.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate);
    //    l.backgroundColor = [UIColor greenColor];
    
    [p addSubview:l];
    
    [window addSubview:p];
    p.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate);

    //    NSLog(@"r{%.2f, %.2f, %.2f, %.2f}", r.origin.x, r.origin.y, r.size.width, r.size.height);
    
    if (seconds > 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismiss];
        });
    }
    
}



+ (void)showText:(NSString *)text Size:(CGSize)size Color:(UIColor *)color dissmissTime:(NSTimeInterval)seconds {
    
    UIWindow *window  = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    HXProgress *p = [HXProgress sharedProgress];
    
    CGRect r = [p rectOfText:text WithFont:[UIFont systemFontOfSize:18]];
    CGFloat w = size.width > r.size.width ? size.width : r.size.width;
    CGFloat h = size.height > r.size.height ? size.height : r.size.height;
    
    while (p.subviews.lastObject != nil) {
        [(UIView *)p.subviews.lastObject removeFromSuperview];
    }
    
    p.frame = CGRectMake(0, 0, w, h);
    p.center = window.center;
    p.backgroundColor = color;
    p.clipsToBounds = YES;
    p.layer.cornerRadius = 5.0f;
    
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
    l.text = text;
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.center = CGPointMake(w/2, h/2);
    l.adjustsFontSizeToFitWidth = YES;
    //    l.backgroundColor = [UIColor greenColor];
    
    [p addSubview:l];
    
    [window addSubview:p];
    
    //    NSLog(@"r{%.2f, %.2f, %.2f, %.2f}", r.origin.x, r.origin.y, r.size.width, r.size.height);
    
    if (seconds > 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismiss];
        });
    }
    
}

+ (void)showText:(NSString *)text withSize:(CGSize)size durationTime:(NSTimeInterval)time {
    
    [self showText:text Size:size Color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] dissmissTime:time];
}

+ (void)showText:(NSString *)text withSize:(CGSize)size withColor:(UIColor *)color withDismissTime:(NSTimeInterval)seconds {
    
    [self showText:text Size:size Color:color dissmissTime:seconds];
}

+ (void)showText:(NSString *)text {
    [self showText:text withSize:CGSizeMake(100, 50) durationTime:1];
}

+ (void)dismiss {
    
    for (UIView *view in [[UIApplication sharedApplication].windows objectAtIndex:0].subviews) {
        
//        NSLog(@"class:%@", [NSString stringWithUTF8String:object_getClassName(view)]);
        
        if ([view isKindOfClass:[HXProgress class]]) {
            
            [view removeFromSuperview];
            break;
        }
    }

//    HXProgress *p = [HXProgress sharedProgress];
//    [p removeFromSuperview];
    
}


#pragma mark -
//label的默认font.pointSize = 17.0
- (CGRect)rectOfText:(NSString *)text WithFont:(UIFont *)font {
    
    UIFont *attributesFont = nil;
    if (font == nil) {
        attributesFont = [UIFont systemFontOfSize:17];
    }
    else {
        attributesFont = font;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributesDic = @{NSFontAttributeName:attributesFont,
                                    NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake(w-20, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributesDic
                                     context:nil];
    
    return rect;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
