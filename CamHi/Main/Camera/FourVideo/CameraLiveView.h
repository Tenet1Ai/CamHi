//
//  CameraLiveView.h
//  CamHi
//
//  Created by HXjiang on 16/9/7.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"

@interface CameraLiveView : UIView

@property (nonatomic, assign) BOOL isAddCamera;
@property (nonatomic, strong) HiGLMonitor *monitor;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) Camera *camera;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) Recording *recordView;

- (void)setBorderColor:(UIColor *)color;


@end
