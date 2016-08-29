//
//  SinProgressView.m
//  CamHi
//
//  Created by HXjiang on 16/8/26.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SinProgressView.h"

@interface SinProgressView ()
{
    CGFloat w;
    CGFloat h;
}

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UILabel *labMessage;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SinProgressView


+ (SinProgressView *)sharedProgress {
    
    static SinProgressView *sinProgress = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        sinProgress = [[SinProgressView alloc] init];
    });
    
    return sinProgress;
}


- (instancetype)init {
    if (self = [super init]) {
        
        w = [UIScreen mainScreen].bounds.size.width*0.8;
        h = w/2;

        self.backgroundColor = [UIColor lightGrayColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0.8;
        
        [self addSubview:self.viewBackground];
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (UIView *)viewBackground {
    if (!_viewBackground) {
        
        _viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _viewBackground.backgroundColor = [UIColor whiteColor];
        _viewBackground.layer.cornerRadius = 8.0f;
        _viewBackground.center = self.center;
        _viewBackground.alpha = 1;
        
        
        [_viewBackground addSubview:self.labMessage];
        [_viewBackground addSubview:self.proSin];
        [_viewBackground addSubview:self.btnCancel];

    }
    return _viewBackground;
}

- (UILabel *)labMessage {
    if (!_labMessage) {
        _labMessage = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, w-40, h/3)];
        _labMessage.adjustsFontSizeToFitWidth = YES;
        _labMessage.text = INTERSTR(@"Wait for connecting");
        _labMessage.textAlignment = NSTextAlignmentCenter;
    }
    return _labMessage;
}

- (UIProgressView *)proSin {
    if (!_proSin) {
        
        _proSin = [[UIProgressView alloc] initWithFrame:CGRectMake(20, h/3, w-40, h/3)];
        
    }
    return _proSin;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(20, h/3*2, w-40, h/3)];
        [_btnCancel setTitle:INTERSTR(@"Cancel") forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
//        _btnCancel.backgroundColor = [UIColor redColor];
    }
    return _btnCancel;
}


- (void)btnCancelAction:(id)sender {
    if (_cancelBlock) {
        _cancelBlock(YES, 0);
    }
    [SinProgressView sharedProgress].proSin.progress = 0;
    [[SinProgressView sharedProgress] removeFromSuperview];
}



+ (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    SinProgressView *s = [SinProgressView sharedProgress];
    //s.center = window.center;
    [window addSubview:s];
}

+ (void)dismiss {
    
    SinProgressView *s = [SinProgressView sharedProgress];
    [s removeFromSuperview];
}

@end
