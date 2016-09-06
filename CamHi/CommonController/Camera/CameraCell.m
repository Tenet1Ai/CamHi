//
//  CameraCell.m
//  CamHi
//
//  Created by HXjiang on 16/7/14.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "CameraCell.h"
#import "HeaderView.h"

@interface CameraCell ()
{
    CGFloat x;
    CGFloat y;
    CGFloat w;
    CGFloat h;
    CGFloat labH;
}

@end

@implementation CameraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        x = 5.0f;
        y = 5.0f;
        w = [UIScreen mainScreen].bounds.size.width;
        h = CELLH;
        labH = 135.0f;
        
        [self.contentView addSubview:self.snapImgView];
        [self.contentView addSubview:self.labName];
        [self.contentView addSubview:self.labState];
        [self.contentView addSubview:self.labUid];
        [self.contentView addSubview:self.alarmImgView];
        
//        HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(90, y, 135, 59)];
//        [self.contentView addSubview:header];
//        
//        _labName = header.labt;
//        _labState = header.labc;
//        _labUid = header.labb;
        
    }
    return self;
}

- (UIImageView *)snapImgView {
    if (!_snapImgView) {
        
        CGFloat ow = 80.0f;
        CGFloat oh = ow/1.5;//h - 2*y;
        _snapImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ow, oh)];
    }
    return _snapImgView;
}

- (UILabel *)labName {
    if (!_labName) {
        
        CGFloat ox = CGRectGetMaxX(self.snapImgView.frame)+5;
        CGFloat oy = CGRectGetMinY(self.snapImgView.frame);
        CGFloat ow = labH;
        CGFloat oh = CGRectGetHeight(self.snapImgView.frame)/3;
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(ox, oy, ow, oh)];
        _labName.font = [UIFont boldSystemFontOfSize:17];
    }
    return _labName;
}

- (UILabel *)labState {
    if (!_labState) {
        
        CGFloat ox = CGRectGetMaxX(self.snapImgView.frame)+5;
        CGFloat oy = CGRectGetMaxY(self.labName.frame);
        CGFloat ow = labH;
        CGFloat oh = CGRectGetHeight(self.snapImgView.frame)/3;
        _labState = [[UILabel alloc] initWithFrame:CGRectMake(ox, oy, ow, oh)];
        _labState.font = [UIFont systemFontOfSize:14];
        _labState.adjustsFontSizeToFitWidth = YES;
    }
    return _labState;

}

- (UILabel *)labUid {
    if (!_labUid) {
        
        CGFloat ox = CGRectGetMaxX(self.snapImgView.frame)+5;
        CGFloat oy = CGRectGetMaxY(self.labState.frame);
        CGFloat ow = labH;
        CGFloat oh = CGRectGetHeight(self.snapImgView.frame)/3;
        _labUid = [[UILabel alloc] initWithFrame:CGRectMake(ox, oy, ow, oh)];
        _labUid.font = [UIFont systemFontOfSize:12];
        _labUid.textColor = [UIColor grayColor];
//        _labUid.backgroundColor = [UIColor redColor];
    }
    return _labUid;
    
}

- (UIImageView *)alarmImgView {
    if (!_alarmImgView) {
        
        CGFloat ow = 30.0f;
        CGFloat oh = ow;
        CGFloat ox = CGRectGetMaxX(self.labUid.frame)+ow/2;
        CGFloat oy = CELLH/2;

        _alarmImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ow, oh)];
        _alarmImgView.center = CGPointMake(ox, oy);
        _alarmImgView.image = [UIImage imageNamed:@"ic_alarm_event"];
    }
    return _alarmImgView;
}

@end
