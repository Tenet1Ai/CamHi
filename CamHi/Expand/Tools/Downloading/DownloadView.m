//
//  DownloadView.m
//  CamHi
//
//  Created by HXjiang on 16/9/1.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "DownloadView.h"

@interface DownloadView ()
{
    CGFloat w;
    CGFloat h;
}

@property (nonatomic, strong) UIView *viewbg;
@property (nonatomic, copy) NSString *title;

@end

@implementation DownloadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithTitle:(NSString *)title {
    
    if (self = [super init]) {
        
        w = [UIScreen mainScreen].bounds.size.width*0.8;
        h = w/2;
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0.9;
        _title = title;
        
        [self addSubview:self.viewbg];

    }
    return self;
}


//- (instancetype)init {
//    if (self = [super init]) {
//        
//        w = [UIScreen mainScreen].bounds.size.width*0.8;
//        h = w/2;
//        
//        self.backgroundColor = [UIColor lightGrayColor];
//        self.frame = [UIScreen mainScreen].bounds;
//        self.alpha = 0.8;
//        
//        [self addSubview:self.viewBackground];
//        
//    }
//    return self;
//}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (UIView *)viewbg {
    if (!_viewbg) {
        
        _viewbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _viewbg.backgroundColor = [UIColor whiteColor];
        _viewbg.layer.cornerRadius = 8.0f;
        _viewbg.center = self.center;
        //_viewbg.alpha = 0;
        
//        UIImage *image = [UIImage imageWithColor:RGBA_COLOR(220, 220, 220, 1) wihtSize:_viewbg.bounds.size];
//        _viewbg.image = image;
        
        [_viewbg addSubview:self.labTitle];
        [_viewbg addSubview:self.labProgress];
        [_viewbg addSubview:self.progrssView];
        [_viewbg addSubview:self.btnCancel];
        
    }
    return _viewbg;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, w-40, h/3)];
        _labTitle.adjustsFontSizeToFitWidth = YES;
        _labTitle.text = _title;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (UIProgressView *)progrssView {
    if (!_progrssView) {
        
        CGFloat px = 15.0f;
        CGFloat pw = w-30-CGRectGetWidth(self.labProgress.frame)-5;
        
        _progrssView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, pw, h/3)];
        _progrssView.center = CGPointMake(px+pw/2, h/2);
        
    }
    return _progrssView;
}


- (UILabel *)labProgress {
    if (!_labProgress) {
        
        CGFloat pw = 50.0f;
        CGFloat ph = h/3;
        CGFloat px = w-15-pw;
        CGFloat py = h/3;
        
        _labProgress = [[UILabel alloc] initWithFrame:CGRectMake(px, py, pw, ph)];
        _labProgress.textAlignment = NSTextAlignmentCenter;
        _labProgress.font = [UIFont systemFontOfSize:12];
        _labProgress.adjustsFontSizeToFitWidth = YES;
    }
    return _labProgress;
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
        _cancelBlock(0);
    }
    
    [self removeFromSuperview];
}



- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
