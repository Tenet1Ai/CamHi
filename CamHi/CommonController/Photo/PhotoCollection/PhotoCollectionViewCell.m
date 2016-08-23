//
//  PhotoCollectionViewCell.m
//  CamHi
//
//  Created by HXjiang on 16/8/17.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()
{
    CGFloat w;
    CGFloat h;
}

@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        w = frame.size.width;
        h = frame.size.height;
        
        [self.contentView addSubview:self.bImage];
        [self.contentView addSubview:self.fImage];
        
    }
    return self;
}


- (UIImageView *)bImage {
    if (!_bImage) {
        _bImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    }
    return _bImage;
}

- (UIImageView *)fImage {
    if (!_fImage) {
        _fImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    }
    return _fImage;
}


@end
