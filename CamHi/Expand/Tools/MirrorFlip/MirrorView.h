//
//  MirrorView.h
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MirrorW     (135)
#define MirrorH     (75)

typedef NS_ENUM(NSInteger, SwitchTag) {
    SwitchTagNone,
    SwitchTagMirror,
    SwitchTagFlip,
};

@interface MirrorView : UIView

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, strong) UISwitch *switchMirror;
@property (nonatomic, strong) UISwitch *switchFlip;
@property BOOL isShow;
@property (nonatomic, copy) void(^mirrorBlock)(SwitchTag tag, UISwitch *tswitch);

- (void)show;
- (void)dismiss;


@end
