//
//  ZoomFocusDialog.m
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ZoomFocusDialog.h"

@interface ZoomFocusDialog ()
{
    CGFloat btnw;
    CGFloat btnh;
    CGFloat offx;
}

@property (nonatomic, strong) NSMutableArray *buttons;


@end

@implementation ZoomFocusDialog

- (instancetype)initWithFrame:(CGRect)frame {
        
    if (self = [super initWithFrame:frame]) {
        
        UIImage *imgNor = [UIImage imageWithColor:[UIColor lightGrayColor] wihtSize:CGSizeMake(100, 30)];
        UIImage *imgHig = [UIImage imageWithColor:[UIColor grayColor] wihtSize:CGSizeMake(100, 30)];

        _buttons = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *titles = @[INTERSTR(@"Zoom in"), INTERSTR(@"Zoom out"), INTERSTR(@"Focus in"), INTERSTR(@"Focus out")];
        
        offx = 10.0f;
        btnw = 100.0f;
        btnh = 30.0f;
        int LineCount = 2;
        
        for (int i = 0; i < titles.count; i++) {
            
            //行
            //0,1,2     =>  0
            //3,4,5     =>  1
            int row = i / LineCount;
            //列
            //0,3,6     =>  0
            //1,4,7     =>  1
            int col = i % LineCount;
            
            //视图坐标
            CGFloat x = offx+(btnw+offx)*col;
            CGFloat y = offx+(btnh+offx)*row;
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, btnw, btnh)];
            button.tag = i;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:imgNor forState:UIControlStateNormal];
            [button setBackgroundImage:imgHig forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(btnDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

            [self addSubview:button];
            [_buttons addObject:button];
        }
        
        self.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];

        _isShow = NO;
    }
    return self;
}


- (void)show {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y += (2*currentframe.size.height + 60);
        weakSelf.frame = currentframe;
    }];
    
}

- (void)dismiss {
    
    _isShow = !_isShow;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y -= (2*currentframe.size.height + 60);
        weakSelf.frame = currentframe;
    }];
    
}


- (void)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (_zoomBlock) {
        _zoomBlock(btn.tag, ZOOMFOCUS_BTN_UP);
    }
}


- (void)btnDownAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (_zoomBlock) {
        _zoomBlock(btn.tag, ZOOMFOCUS_BTN_DOWN);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
