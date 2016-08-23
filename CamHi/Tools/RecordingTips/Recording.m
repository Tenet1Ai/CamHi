
//
//  Recording.m
//  CamHi
//
//  Created by HXjiang on 16/8/16.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "Recording.h"


@interface Recording ()

@property (nonatomic, strong) UIImageView *imgAlarm;
@property (nonatomic, strong) UILabel *labREC;

@end

@implementation Recording

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, RecordingW, RecordingH)]) {
     
        [self addSubview:self.imgAlarm];
        [self addSubview:self.labREC];
        
        //self.backgroundColor = [UIColor greenColor];
        _isShow = YES;
        [self dismiss];
    }
    return self;
}


- (void)show {
    _isShow = !_isShow;
    self.hidden = NO;
}

- (void)dismiss {
    _isShow = !_isShow;
    self.hidden = YES;
}

- (UIImageView *)imgAlarm {
    if (!_imgAlarm) {
        _imgAlarm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _imgAlarm.image = [UIImage imageNamed:@"round_red_30"];
    }
    return _imgAlarm;
}

- (UILabel *)labREC {
    if (!_labREC) {
        _labREC = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 20)];
        _labREC.text = @"REC";
        _labREC.textAlignment = NSTextAlignmentCenter;
        _labREC.textColor = [UIColor redColor];
        _labREC.adjustsFontSizeToFitWidth = YES;
    }
    return _labREC;
}

//round_red_30
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
