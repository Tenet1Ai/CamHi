//
//  PicturesLoop.h
//  管理系统
//
//  Created by haixinweishi on 16/1/8.
//  Copyright © 2016年 SanMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicturesLoop : UIView

@property (nonatomic, copy) NSString *deleteName;
@property (nonatomic, copy) void(^tapBlock)(NSInteger currentIndex, NSInteger type);
- (id)initWithFrame:(CGRect)frame WithImages:(NSArray *)imageArray WithTitle:(NSArray *)titleArray WithDetail:(NSArray *)detailArray;


- (id)initWithFrame:(CGRect)frame WithImages:(NSArray *)imageArray;
- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images currentIndex:(NSInteger)index;
- (void)nextIfDeleted:(BOOL)delete;

//setPagecontrol
- (void)setPagecontrolHidden:(BOOL)hide;
- (void)setpagecontrolFrame:(CGRect)frame;
- (void)setPagecontrolIndicatorTintColor:(UIColor *)color;
- (void)setPagecontrolCurrentPageIndicatorTintColor:(UIColor *)color;

@end
