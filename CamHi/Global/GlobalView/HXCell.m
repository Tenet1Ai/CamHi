//
//  HXCell.m
//  CamHi
//
//  Created by HXjiang on 16/7/18.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "HXCell.h"

@implementation HXCell

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
     
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
