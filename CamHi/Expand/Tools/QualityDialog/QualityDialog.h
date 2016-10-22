//
//  QualityDialog.h
//  CamHi
//
//  Created by HXjiang on 16/8/16.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QualityW    (100)
#define QualityH    (90)

typedef NS_ENUM(NSInteger, QualityType) {
    QualityTypeNone,
    QualityTypeHigh,
    QualityTypeLow,
};

@interface QualityDialog : UIView


@property (nonatomic, strong) UIButton *btnHigh;
@property (nonatomic, strong) UIButton *btnLow;
@property BOOL isShow;
@property (nonatomic, copy) void(^qualityBlock)(NSInteger type);
- (void)show;
- (void)dismiss;

@end
