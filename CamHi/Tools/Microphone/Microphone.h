//
//  Microphone.h
//  CamHi
//
//  Created by HXjiang on 16/8/16.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MicrophoneH (134)

typedef NS_ENUM(NSInteger, PressType) {
    PressTypeNone,
    PressTypeDown,
    PressTypeUpInside,
};


@interface Microphone : UIView

@property BOOL isShow;
@property (nonatomic, copy) void(^microphoneBlock)(PressType type);
- (void)show;
- (void)dismiss;

@end
