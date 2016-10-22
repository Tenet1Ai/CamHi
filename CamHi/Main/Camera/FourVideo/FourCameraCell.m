//
//  FourCameraCell.m
//  CamHi
//
//  Created by HXjiang on 16/9/7.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "FourCameraCell.h"

@interface FourCameraCell ()
{
    CGFloat cw;
    CGFloat ch;
    CGFloat cx;
    CGFloat cy;
}

@end

@implementation FourCameraCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        cw = [UIScreen mainScreen].bounds.size.width;
        ch = FourCameraCellH;
        cx = 15.0f;
        cy = 5.0f;
        
        [self.contentView addSubview:self.imgLive];
        [self.contentView addSubview:self.btnSelect];
        [self.contentView addSubview:self.labUid];
        [self.contentView addSubview:self.labName];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (UIImageView *)imgLive {
    if (!_imgLive) {
        
        CGFloat x = cx;
        CGFloat y = cy;
        CGFloat h = ch-2*y;
        CGFloat w = h/0.75;
        
        _imgLive = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    }
    return _imgLive;
}

- (UIButton *)btnSelect {
    if (!_btnSelect) {
        
        CGFloat h = 30.0f;//ch-2*cy;
        CGFloat x = cw - h/2 - cx;
        CGFloat y = FourCameraCellH/2;
        
        _btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, h, h)];
        _btnSelect.center = CGPointMake(x, y);
        
    }
    return _btnSelect;
}


- (UILabel *)labUid {
    if (!_labUid) {
        
        CGFloat x = CGRectGetMaxX(self.imgLive.frame)+5;
        CGFloat y = CGRectGetMinY(self.imgLive.frame);
        CGFloat w = CGRectGetMinX(self.btnSelect.frame)-x;
        CGFloat h = CGRectGetHeight(self.imgLive.frame)/2;
        
        _labUid = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _labUid.font = [UIFont systemFontOfSize:14];
        _labUid.adjustsFontSizeToFitWidth = YES;
    }
    return _labUid;
}


- (UILabel *)labName {
    if (!_labName) {
        
        CGFloat x = CGRectGetMaxX(self.imgLive.frame)+5;
        CGFloat y = CGRectGetMaxY(self.labUid.frame);
        CGFloat w = CGRectGetMinX(self.btnSelect.frame)-x;
        CGFloat h = CGRectGetHeight(self.imgLive.frame)/2;
        
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _labName.font = [UIFont systemFontOfSize:14];
        _labName.adjustsFontSizeToFitWidth = YES;
    }
    return _labName;
}


@end
