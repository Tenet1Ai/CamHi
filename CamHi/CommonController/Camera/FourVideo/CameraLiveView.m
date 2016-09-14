//
//  CameraLiveView.m
//  CamHi
//
//  Created by HXjiang on 16/9/7.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "CameraLiveView.h"
#import "Masonry.h"

@interface CameraLiveView ()
{
    CGFloat w;
    CGFloat h;
}

@end

@implementation CameraLiveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        w = frame.size.width;
        h = frame.size.height;
        
        [self addSubview:self.monitor];
        [self addSubview:self.labName];
        [self addSubview:self.btnMore];
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    //__weak typeof(self) weakSelf = self;
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
}

- (UIButton *)btnMore {
    if (!_btnMore) {
        _btnMore = [[UIButton alloc] init];
        //_btnMore.backgroundColor = [UIColor redColor];
        [_btnMore setImage:[UIImage imageNamed:@"more_blue_73"] forState:UIControlStateNormal];
        //_btnMore.hidden = !self.isAddCamera;
    }
    return _btnMore;
}


- (HiGLMonitor *)monitor {
    if (!_monitor) {
        _monitor = [[HiGLMonitor alloc] initWithFrame:CGRectMake(0, 0, w, w/1.5)];
    }
    return _monitor;
}

- (UILabel *)labName {
    if (!_labName) {
        
        CGFloat ly = CGRectGetMaxY(self.monitor.frame);
        CGFloat lh = 15.0f;
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(0, ly, w, lh)];
        _labName.font = [UIFont systemFontOfSize:14];
        _labName.adjustsFontSizeToFitWidth = YES;
        //_labName.backgroundColor = [UIColor orangeColor];
    }
    return _labName;
}

- (void)setBorderColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
}

@end
