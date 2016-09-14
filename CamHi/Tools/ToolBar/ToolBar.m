//
//  ToolBar.m
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "ToolBar.h"

@interface ToolBar ()
{
    CGFloat w;
    CGFloat h;
}

@property (nonatomic, strong) NSMutableArray *btnArray;

@end



@implementation ToolBar

@synthesize tag;

- (id)initWithFrame:(CGRect)frame btnNumber:(int)num {
    if (self = [super initWithFrame:frame]) {
        
        w = frame.size.width;
        h = frame.size.height;
        _isUp    = NO;
        
        self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5];
        self.btnArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        CGFloat offspace = (w-h*num)/(num+1);
        for (int i = 0; i < num; i++) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offspace+(offspace+h)*i, 0, h, h)];
            btn.tag = i;
            //btn.backgroundColor = [UIColor redColor];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            //[btn addTarget:self action:@selector(btnDownAction:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:btn];
            [self.btnArray addObject:btn];
        }
    }
    return self;
}

- (void)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
//    if (self.delegate) {
//        [self.delegate didClickTag:self.tag atIndex:btn.tag];
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTag:atIndex:)]) {
        [self.delegate didClickTag:self.tag atIndex:btn.tag];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBar:didSelectedAtIndex:selected:)]) {
        [self.delegate toolBar:self.tag didSelectedAtIndex:btn.tag selected:btn.selected];
    }
}

- (void)btnDownAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDownTag:atIndex:)]) {
        [self.delegate didClickDownTag:self.tag atIndex:btn.tag];
    }

}


#pragma mark -- General Function
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index forState:(UIControlState)state {
    if (index >= self.btnArray.count) {
        return;
    }
    [(UIButton *)[self.btnArray objectAtIndex:index] setTitle:title forState:state];
}

- (void)setTitleColor:(UIColor *)color atIndex:(NSInteger)index forState:(UIControlState)state {
    [(UIButton *)[self.btnArray objectAtIndex:index] setTitleColor:color forState:state];
}

- (void)setBackgroudImage:(UIImage*)img atIndex:(NSInteger)index forState:(UIControlState)state {
    [(UIButton *)[self.btnArray objectAtIndex:index] setBackgroundImage:img forState:state];
}

- (void)setImage:(UIImage*)img atIndex:(NSInteger)index forState:(UIControlState)state {
    [(UIButton *)[self.btnArray objectAtIndex:index] setImage:img forState:state];
}

- (void)setWidth:(CGFloat)width atIndex:(NSInteger)index {
    
    UIButton *sbtn = [self.btnArray objectAtIndex:index];
    CGPoint point = sbtn.center;
    CGRect rect = sbtn.frame;
    rect.size.width = width;
    sbtn.frame = rect;
    sbtn.center = point;
}

- (void)setSelect:(BOOL)flag atIndex:(int)index {
    [(UIButton *)[self.btnArray objectAtIndex:index] setSelected:flag];
}

- (void)setEnable:(BOOL)flag atIndex:(int)index {
    [(UIButton *)[self.btnArray objectAtIndex:index] setEnabled:flag];
}

- (void)setBackgroudColor:(UIColor*)color atIndex:(int)index {
    ((UIButton *)[self.btnArray objectAtIndex:index]).backgroundColor=color;
}

- (void)moveDown {
    
//    if (!_isUp) {
//        return;
//    }
    
    _isUp = !_isUp;
    
    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y += currentframe.size.height;
        weakSelf.frame = currentframe;
    }];
}

- (void)moveUp {
    
//    if (_isUp) {
//        return;
//    }
    
    _isUp = !_isUp;

    __block CGRect currentframe = self.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        currentframe.origin.y -= currentframe.size.height;
        weakSelf.frame = currentframe;
    }];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    w = rect.size.width;
    h = rect.size.height;
    
    NSInteger num = self.btnArray.count;
    
    CGFloat offspace = (w-h*num)/(num+1);
    for (int i = 0; i < num; i++) {
        CGFloat x = offspace+(offspace+h)*i;
        UIButton *btn = [self.btnArray objectAtIndex:i];
        btn.frame = CGRectMake(x, 0, h, h);
        
        //LOG(@"button(w:%f, x:%f, h:%f)", w, x, h);
    }
    
}


@end
