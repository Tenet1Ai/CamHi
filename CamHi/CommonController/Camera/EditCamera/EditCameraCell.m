//
//  EditCameraCell.m
//  CamHi
//
//  Created by HXjiang on 16/7/28.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "EditCameraCell.h"

@interface EditCameraCell ()
{
    CGFloat w;
    CGFloat h;
}

@end

@implementation EditCameraCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        w = [UIScreen mainScreen].bounds.size.width;
        h = cellH;
        
        
        CGFloat lw = 120.0f;
        CGFloat lh = 40.0f;
        CGFloat lx = 20.0f;
        CGFloat ly = (h-lh)/2;
        self.tlabel = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, lw, lh)];
        self.tlabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.tlabel];
        
        
        CGFloat th = 40.0f;
        CGFloat tx = lx+lw;
        CGFloat ty = (h-th)/2;
        CGFloat tw = w-tx;
        self.tfieldIn = [[UITextField alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
        self.tfieldIn.font = [UIFont systemFontOfSize:14];
        self.tfieldIn.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tfieldIn.clearsOnBeginEditing = NO;
        [self.contentView addSubview:self.tfieldIn];

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
