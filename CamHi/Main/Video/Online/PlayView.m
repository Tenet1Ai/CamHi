//
//  PlayView.m
//  CamHi
//
//  Created by HXjiang on 16/8/18.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PlayView.h"

@interface PlayView ()
{
    CGFloat w;
    CGFloat h;
}

@end

@implementation PlayView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        w = frame.size.width;
        h = frame.size.height;
        
        [self addSubview:self.btnPlay];
        [self addSubview:self.btnExit];
        [self addSubview:self.labCurSeconds];
        [self addSubview:self.labTotalSeconds];
        [self addSubview:self.sliderProgress];
        
        self.backgroundColor = [UIColor lightGrayColor];
        //self.alpha = 0.7;
        _isShow = YES;
    }
    return self;
}


- (UIButton *)btnPlay {
    if (!_btnPlay) {
        
        CGFloat bw = 40.0f;
        CGFloat bh = 40.0f;
        CGFloat bx = 20.0f;
        CGFloat by = (h-bh)/2;
        _btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(bx, by, bw, bh)];
        _btnPlay.tag = 0;
        [_btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        [_btnPlay addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}


- (UIButton *)btnExit {
    if (!_btnExit) {
        
        CGFloat bw = 40.0f;
        CGFloat bh = 40.0f;
        CGFloat bx = w-20-bw;
        CGFloat by = (h-bh)/2;
        _btnExit = [[UIButton alloc] initWithFrame:CGRectMake(bx, by, bw, bh)];
        _btnExit.tag = 1;
        [_btnExit setImage:[UIImage imageNamed:@"exitbutton"] forState:UIControlStateNormal];
        //[_btnExit setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_btnExit addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnExit;
}

- (void)btnAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0) {
        button.selected = !button.selected;
    }
    
    if (_playBlock) {
        _playBlock(button.tag, 0);
    }
}



- (UILabel *)labCurSeconds {
    if (!_labCurSeconds) {
        
        CGFloat lx = CGRectGetMaxX(self.btnPlay.frame) + 10;
        CGFloat lh = 30.0f;
        CGFloat lw = 50.0f;
        CGFloat ly = (h-lh)/2;
        
        _labCurSeconds = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, lw, lh)];
        _labCurSeconds.textAlignment = NSTextAlignmentCenter;
        _labCurSeconds.adjustsFontSizeToFitWidth = YES;
        _labCurSeconds.font = [UIFont systemFontOfSize:12];
        
        //_labCurSeconds.text = @"00:00:00";
        //_labCurSeconds.backgroundColor = [UIColor greenColor];
        
    }
    return _labCurSeconds;
}

- (UILabel *)labTotalSeconds {
    if (!_labTotalSeconds) {
        
        CGFloat lh = 30.0f;
        CGFloat lw = 50.0f;
        CGFloat lx = CGRectGetMinX(self.btnExit.frame) - lw - 10;
        CGFloat ly = (h-lh)/2;
        
        _labTotalSeconds = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, lw, lh)];
        _labTotalSeconds.textAlignment = NSTextAlignmentCenter;
        _labTotalSeconds.adjustsFontSizeToFitWidth = YES;
        _labTotalSeconds.font = [UIFont systemFontOfSize:12];
        
        //_labTotalSeconds.text = @"00:00:00";
        //_labTotalSeconds.backgroundColor = [UIColor greenColor];

    }
    return _labTotalSeconds;
}


- (UISlider *)sliderProgress {
    if (!_sliderProgress) {
        
        CGFloat sx = CGRectGetMaxX(self.labCurSeconds.frame) + 5;
        CGFloat sw = CGRectGetMinX(self.labTotalSeconds.frame) - 5 - sx;
        CGFloat sh = 30.0f;
        CGFloat sy = (h-sh)/2;
        _sliderProgress = [[UISlider alloc] initWithFrame:CGRectMake(sx, sy, sw, sh)];
        _sliderProgress.minimumValue = 1;
        _sliderProgress.maximumValue = 100;
        
        //_sliderProgress.backgroundColor = [UIColor redColor];
        
        [_sliderProgress addTarget:self action:@selector(sliderEndAction:)forControlEvents:UIControlEventTouchUpInside];
        [_sliderProgress addTarget:self action:@selector(sliderChangedAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _sliderProgress;
}

- (void)sliderEndAction:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    if (_playBlock) {
        _playBlock(2, slider.value);
    }
}


- (void)sliderChangedAction:(id)sender {
  
    UISlider *slider = (UISlider *)sender;

    if (_playBlock) {
        _playBlock(3, slider.value);
    }

}



- (void)show {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y -= currentframe.size.height;
        weakSelf.frame = currentframe;
    }];
    
}

- (void)dismiss {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y += currentframe.size.height;
        weakSelf.frame = currentframe;
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
