//
//  AlarmLinkCell.m
//  CamHi
//
//  Created by HXjiang on 16/7/29.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "AlarmLinkCell.h"

@interface AlarmLinkCell ()
{
    CGFloat w;
    CGFloat h;
}

@end

@implementation AlarmLinkCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        w = [UIScreen mainScreen].bounds.size.width;
        h = cellH;
        
        self.accessoryView = self.tswitch;
        
    }
    return self;
}


- (UISwitch *)tswitch {
    if (!_tswitch) {
        _tswitch = [[UISwitch alloc] init];
    }
    return _tswitch;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
