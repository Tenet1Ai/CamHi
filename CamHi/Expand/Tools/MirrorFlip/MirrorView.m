//
//  MirrorView.m
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "MirrorView.h"

@interface MirrorView ()
{
    CGFloat offx;
    CGFloat objw;
    CGFloat objh;
}
@property (nonatomic, strong) UILabel *labMirror;
@property (nonatomic, strong) UILabel *labFlip;

@end

@implementation MirrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        offx = 5.0f;
        objw = 60.0f;
        objh = 30.0f;
        
        _w = offx*3+objw*2;//135
        _h = offx*3+objh*2;//75
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, _w, _h);
        
        [self addSubview:self.labMirror];
        [self addSubview:self.labFlip];
        [self addSubview:self.switchMirror];
        [self addSubview:self.switchFlip];
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        
        _isShow = NO;

    }
    return self;
}


- (UILabel *)labMirror {
    if (!_labMirror) {
        
        _labMirror = [[UILabel alloc] initWithFrame:CGRectMake(offx, offx, objw, objh)];
        _labMirror.text = INTERSTR(@"Mirror");
        _labMirror.textColor = [UIColor whiteColor];
        _labMirror.textAlignment = NSTextAlignmentCenter;
        _labMirror.font = [UIFont systemFontOfSize:14];
        _labMirror.adjustsFontSizeToFitWidth = YES;
    }
    return _labMirror;
}

- (UILabel *)labFlip {
    if (!_labFlip) {
        
        _labFlip = [[UILabel alloc] initWithFrame:CGRectMake(offx, objh+offx*2, objw, objh)];
        _labFlip.text = INTERSTR(@"Flip");
        _labFlip.textColor = [UIColor whiteColor];
        _labFlip.textAlignment = NSTextAlignmentCenter;
        _labFlip.font = [UIFont systemFontOfSize:14];
        _labFlip.adjustsFontSizeToFitWidth = YES;
    }
    return _labFlip;
}

- (UISwitch *)switchMirror {
    if (!_switchMirror) {
        
        _switchMirror = [[UISwitch alloc] initWithFrame:CGRectMake(objw+offx*2, offx, objw, objh)];
        [_switchMirror addTarget:self action:@selector(switchMirrorAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchMirror;
}


- (void)switchMirrorAction:(id)sender {
    UISwitch *tswitch = (UISwitch *)sender;
    if (_mirrorBlock) {
        _mirrorBlock(SwitchTagMirror, tswitch);
    }
}

- (UISwitch *)switchFlip {
    if (!_switchFlip) {
        
        _switchFlip = [[UISwitch alloc] initWithFrame:CGRectMake(objw+offx*2, objh+offx*2, objw, objh)];
        [_switchFlip addTarget:self action:@selector(switchFlipAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchFlip;
}

- (void)switchFlipAction:(id)sender {
    UISwitch *tswitch = (UISwitch *)sender;
    if (_mirrorBlock) {
        _mirrorBlock(SwitchTagFlip, tswitch);
    }
}



- (void)show {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.x += 2*currentframe.size.width;
        weakSelf.frame = currentframe;
    }];

}

- (void)dismiss {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.x -= 2*currentframe.size.width;
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
