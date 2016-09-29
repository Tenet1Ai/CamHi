//
//  PresetDialog.m
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PresetDialog.h"

@interface PresetDialog ()
{
    CGFloat offx;
    CGFloat btnw;
    CGFloat btnh;
    NSInteger selectTag;
}

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *btnCall;
@property (nonatomic, strong) UIButton *btnSet;

@end

@implementation PresetDialog


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImage *imgSel = [UIImage imageWithColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8] wihtSize:CGSizeMake(100, 30)];
        UIImage *imgNor = [UIImage imageWithColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8] wihtSize:CGSizeMake(100, 30)];
        
        int num = 8;
        offx = 10.0f;
        btnw = 100.0f;
        btnh = 30.0f;

        
        CGFloat offspace = (PresetW-2*btnw)/3;
        
        _btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCall.frame = CGRectMake(offspace, offx, btnw, btnh);
        [_btnCall setTitle:NSLocalizedString(@"Call", @"") forState:UIControlStateNormal];
        _btnCall.tintColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        [_btnCall setBackgroundImage:imgSel forState:UIControlStateHighlighted];
        [_btnCall setBackgroundImage:imgNor forState:UIControlStateNormal];
        _btnCall.tag = PresetTypeCall;
        [self  addSubview:_btnCall];
        [_btnCall addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _btnSet = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSet.frame = CGRectMake(offspace*2+btnw, offx, btnw, btnh);
        [_btnSet setTitle:NSLocalizedString(@"Set", @"") forState:UIControlStateNormal];
        _btnSet.tintColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        [_btnSet setBackgroundImage:imgSel forState:UIControlStateHighlighted];
        [_btnSet setBackgroundImage:imgNor forState:UIControlStateNormal];
        _btnSet.tag = PresetTypeSet;
        [self  addSubview:_btnSet];
        [_btnSet addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        
        
        selectTag = 0;
        _buttons = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < num; i++) {
            
            CGFloat buttonw = 50.0f;
            CGFloat btnx = offx+i%4*(offx+buttonw);
            CGFloat btny = 50 + i/4*(offx+btnh);
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btnx, btny, buttonw, btnh)];
            [button setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:imgNor forState:UIControlStateNormal];
            [button setBackgroundImage:imgSel forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            
            [self addSubview:button];
            [_buttons addObject:button];
            
            if (button.tag == selectTag) {
                button.selected = YES;
            }
        }
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];

        _isShow = NO;
    }
    return self;
}



- (void)buttonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;

    if (button.selected) {
        return;
    }
    
    for (UIButton *btn in _buttons) {
        btn.selected = NO;
    }
    
    button.selected = !button.selected;
    
    selectTag = button.tag;
}

- (void) onClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    
    if (_presetBlock) {
        _presetBlock(selectTag, btn.tag);
    }
    
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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
