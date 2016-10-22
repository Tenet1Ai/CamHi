//
//  PlayView.h
//  CamHi
//
//  Created by HXjiang on 16/8/18.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIView

// 工具栏
@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) UISlider *sliderProgress;
@property (nonatomic, strong) UILabel *labCurSeconds;
@property (nonatomic, strong) UILabel *labTotalSeconds;
@property (nonatomic, strong) UIButton *btnExit;
@property BOOL isShow;

- (void)show;
- (void)dismiss;
@property (nonatomic, copy) void(^playBlock)(NSInteger type, CGFloat value);

@end
