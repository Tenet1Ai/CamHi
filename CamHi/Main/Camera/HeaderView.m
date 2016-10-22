//
//  HeaderView.m
//  CamHi
//
//  Created by HXjiang on 16/7/14.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        
        NSMutableArray *labArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        int N = 3;
        for (int i = 0; i < N; i++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, h/3*i, w, h/3)];
            label.tag = i;
            label.adjustsFontSizeToFitWidth = YES;
            [self addSubview:label];
            
            [labArr addObject:label];
        }
        
        _labt = [labArr objectAtIndex:0];
        _labc = [labArr objectAtIndex:1];
        _labb = [labArr objectAtIndex:2];

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
