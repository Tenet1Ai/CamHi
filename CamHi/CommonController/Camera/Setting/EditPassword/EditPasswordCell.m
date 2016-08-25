//
//  EditPasswordCell.m
//  CamHi
//
//  Created by HXjiang on 16/7/28.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "EditPasswordCell.h"

@interface EditPasswordCell ()
{
    CGFloat w;
    CGFloat h;
}

@property (nonatomic, strong) UIView *tbgView;

@end

@implementation EditPasswordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        w = [UIScreen mainScreen].bounds.size.width;
        h = cellH;
        
        
        CGFloat vx = 5.0f;
        CGFloat vy = 5.0f;
        CGFloat vw = w-2*vx;
        CGFloat vh = h-2*vy;
        CGFloat vr = 5.0f;
        self.tbgView = [[UIView alloc] initWithFrame:CGRectMake(vx, vy, vw, vh)];
        //self.tbgView.layer.cornerRadius = vr;
        //self.tbgView.layer.borderWidth = 1.0f;
        //self.tbgView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.contentView addSubview:self.tbgView];
        
        
        CGFloat tw = 130.0f;
        CGFloat th = 40.0f;
        CGFloat tx = vr;
        CGFloat ty = (vh-th)/2;
        self.tlabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
//        self.tlabelTitle.backgroundColor = [UIColor redColor];
        self.tlabelTitle.font = [UIFont systemFontOfSize:14];
        self.tlabelTitle.adjustsFontSizeToFitWidth = YES;
        [self.tbgView addSubview:self.tlabelTitle];
        
        
        CGFloat px = tx+tw;
        CGFloat py = ty;
        CGFloat pw = vw-tw-2*vr;
        CGFloat ph = 40.0f;
        self.tfieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(px, py, pw, ph)];
        self.tfieldPassword.font = [UIFont systemFontOfSize:14];
        self.tfieldPassword.secureTextEntry = YES;
        self.tfieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tfieldPassword.clearsOnBeginEditing = YES;
        [self.tbgView addSubview:self.tfieldPassword];

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    /*
    w = rect.size.width;
    h = rect.size.height;
    
    self.tbgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, w-10, h-10)];
    self.tbgView.layer.cornerRadius = 3.0f;
    self.tbgView.layer.borderWidth = 1.0f;
    self.tbgView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:self.tbgView];
    
    self.tlabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 120, h-10)];
    self.tlabelTitle.backgroundColor = [UIColor redColor];
    [self.tbgView addSubview:self.tlabelTitle];
    
    
    self.tfieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(123, 0, w-126, h-10)];
    [self.tbgView addSubview:self.tfieldPassword];
     */
}


@end
