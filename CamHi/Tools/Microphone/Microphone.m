//
//  Microphone.m
//  CamHi
//
//  Created by HXjiang on 16/8/16.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "Microphone.h"

@interface Microphone ()

@property (nonatomic, strong) UIButton *btnMic;

@end

@implementation Microphone


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _isShow = NO;
        [self addSubview:self.btnMic];
        
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIButton *)btnMic {
    
    if (!_btnMic) {
        
        _btnMic = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MicrophoneH, MicrophoneH)];
        
        [_btnMic setBackgroundImage:[UIImage imageNamed:@"mic_gray"] forState:UIControlStateNormal];
        [_btnMic setBackgroundImage:[UIImage imageNamed:@"mic_blue"] forState:UIControlStateHighlighted];
        
        [_btnMic addTarget:self action:@selector(btnMicDownAction:) forControlEvents:UIControlEventTouchDown];
        [_btnMic addTarget:self action:@selector(btnMicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnMic;
}

- (void)btnMicDownAction:(id)sender {
    if (_microphoneBlock) {
        _microphoneBlock(PressTypeDown);
    }
}

- (void)btnMicAction:(id)sender {
    if (_microphoneBlock) {
        _microphoneBlock(PressTypeUpInside);
    }
}


- (void)show {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.x -= 2*currentframe.size.width;
        weakSelf.frame = currentframe;
    }];
    
}

- (void)dismiss {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.x += 2*currentframe.size.width;
        weakSelf.frame = currentframe;
    }];
    
}



@end
