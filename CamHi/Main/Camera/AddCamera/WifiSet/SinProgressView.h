//
//  SinProgressView.h
//  CamHi
//
//  Created by HXjiang on 16/8/26.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinProgressView : UIView

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIProgressView *proSin;
@property (nonatomic, copy) void(^cancelBlock)(BOOL success, NSInteger type);

+ (SinProgressView *)sharedProgress;
+ (void)show;
+ (void)dismiss;


@end
