//
//  ToolBar.h
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarDelegate <NSObject>

@required

@optional
- (void)didClickTag:(NSInteger)tag atIndex:(NSInteger)index;
- (void)didClickDownTag:(NSInteger)tag atIndex:(NSInteger)index;

@end


@interface ToolBar : UIView

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<ToolBarDelegate> delegate;
@property   BOOL isUp;

- (id)initWithFrame:(CGRect)frame btnNumber:(int)num;
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color atIndex:(NSInteger)index forState:(UIControlState)state;
- (void)setBackgroudImage:(UIImage*)img atIndex:(NSInteger)index forState:(UIControlState)state;
- (void)setImage:(UIImage*)img atIndex:(NSInteger)index forState:(UIControlState)state;
- (void)setWidth:(CGFloat)width atIndex:(NSInteger)index;
- (void)setSelect:(BOOL)flag atIndex:(int)index;
- (void)setEnable:(BOOL)flag atIndex:(int)index;
- (void)setBackgroudColor:(UIColor*)color atIndex:(int)index;
- (void)moveDown;
- (void)moveUp;


@end
