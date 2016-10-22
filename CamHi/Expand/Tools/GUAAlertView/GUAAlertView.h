//
//  GUAAlertView.h
//  GUAAlertView
//
//  Created by gua on 11/11/14.
//  Copyright (c) 2014 GUA. All rights reserved.
//

@import UIKit;



@protocol GUAAlertViewDelegate <NSObject>
@optional

- (void)clickedButtonAtIndex:(int)index;

@end



typedef void (^GUAAlertViewBlock)(void);


@interface GUAAlertView : UIView 

+ (instancetype)alertViewWithTitle:(NSString *)title
//                           message:(NSString *)message
                          view:(UIProgressView*)view
                       buttonTitle:(NSString *)buttonTitle
               buttonTouchedAction:(GUAAlertViewBlock)buttonBlock
                     dismissAction:(GUAAlertViewBlock)dismissBlock;






@property (nonatomic, assign) id<GUAAlertViewDelegate> clickeddelegate;
- (void)show;
- (void)dismiss;

@end
