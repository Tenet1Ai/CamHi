//
//  ZoomFocusDialog.h
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZoomW   (230)
#define ZoomH   (90)
#define ZOOMFOCUS_BTN_DOWN  (100)
#define ZOOMFOCUS_BTN_UP    (101)


@interface ZoomFocusDialog : UIView


@property (nonatomic, copy) void(^zoomBlock)(NSInteger tag, NSInteger type);
@property BOOL isShow;

- (void)show;
- (void)dismiss;

@end
