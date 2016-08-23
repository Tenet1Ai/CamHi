//
//  QualityDialog.m
//  CamHi
//
//  Created by HXjiang on 16/8/16.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "QualityDialog.h"

@interface QualityDialog ()

@property (nonatomic, strong) UIImage *imgbg;

@end

@implementation QualityDialog


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, QualityW, QualityH)]) {
        
        
        _imgbg = [UIImage imageWithColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8] wihtSize:CGSizeMake(80, 30)];
        
        [self addSubview:self.btnHigh];
        [self addSubview:self.btnLow];
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];

        _isShow = YES;
    }
    return self;
}


- (UIButton *)btnHigh {
    if (!_btnHigh) {
        
        _btnHigh = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHigh.frame = CGRectMake(10,5,80,30);
        [_btnHigh setTitle:NSLocalizedString(@"high", @"") forState:UIControlStateNormal];
        [_btnHigh setBackgroundImage:nil forState:UIControlStateNormal];
        [_btnHigh setBackgroundImage:_imgbg forState:UIControlStateSelected];
        [_btnHigh addTarget:self action:@selector(onClickHigh:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnHigh;
}

- (UIButton *)btnLow {
    if (!_btnLow) {
        
        _btnLow = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLow.frame = CGRectMake(10,45,80,30);
        [_btnLow setTitle:NSLocalizedString(@"low", @"") forState:UIControlStateNormal];
        [_btnLow setBackgroundImage:nil forState:UIControlStateNormal];
        [_btnLow setBackgroundImage:_imgbg forState:UIControlStateSelected];
        [_btnLow addTarget:self action:@selector(onClickLow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLow;
}




- (void) onClickLow:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected) {
        return;
    }
    
    self.btnHigh.selected = NO;
    btn.selected = !btn.selected;
    
    if (_qualityBlock) {
        _qualityBlock(QualityTypeLow);
    }
    
}

- (void) onClickHigh:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected) {
        return;
    }
    
    self.btnLow.selected = NO;
    btn.selected = !btn.selected;
    
    if (_qualityBlock) {
        _qualityBlock(QualityTypeHigh);
    }
    
}


- (void)show {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.x += (2*currentframe.size.width+30);
        weakSelf.frame = currentframe;
    }];
    
}

- (void)dismiss {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.x -= (2*currentframe.size.width+30);
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
