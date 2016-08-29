//
//  VideoSetCell.m
//  CamHi
//
//  Created by HXjiang on 16/8/8.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "VideoSetCell.h"

@implementation VideoSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.labTitle];
        [self.contentView addSubview:self.tfieldDetail];
    }
    return self;
}


- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
    }
    return _labTitle;
}

- (UITextField *)tfieldDetail {
    if (!_tfieldDetail) {
        _tfieldDetail = [[UITextField alloc] init];
        _tfieldDetail.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tfieldDetail.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfieldDetail.adjustsFontSizeToFitWidth = YES;
        _tfieldDetail.font = [UIFont systemFontOfSize:14];
    }
    return _tfieldDetail;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.labTitle.frame     = [self frameForTitle:self.labTitle.text font:self.labTitle.font];
    self.tfieldDetail.frame = [self frameForText:_labTitle.text font:_labTitle.font];
    
    self.labTitle.font = [UIFont systemFontOfSize:14];
    self.labTitle.adjustsFontSizeToFitWidth = YES;
    //self.labTitle.font = [UIFont systemFontOfSize:16];
}






- (NSString *)currentLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
    //NSLog(@"languages = %@", languages);
    NSString *language = [languages objectAtIndex:0];
    return language;
}

#pragma mark -
- (CGRect)frameForText:(NSString *)text textFont:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributesDic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    //NSLog(@"rect:%f,%f", rect.size.width, rect.size.height);
    return rect;
}

- (CGFloat)widthForText:(NSString *)text font:(UIFont *)font {
    CGRect rect = [self frameForText:text textFont:font];
    return rect.size.width;
}

- (CGFloat)xForText:(NSString *)text font:(UIFont *)font {
    CGFloat x = [self widthForText:text font:font];
    x = x < 110 ? 110 : x;
    x += (15+5);
    return x;
}

- (CGRect)frameForText:(NSString *)text font:(UIFont *)font {
    CGFloat fx = [self xForText:text font:font];
    CGFloat fy = (cellH-25)/2;
    CGFloat fw = [UIScreen mainScreen].bounds.size.width-fx-15;
    CGFloat fh = 25.0f;
    return CGRectMake(fx, fy, fw, fh);
}

- (CGRect)frameForTitle:(NSString *)title font:(UIFont *)font {
    CGRect frame = [self frameForText:title textFont:font];
    CGFloat lx = 15.0f;
    CGFloat ly = (cellH-30)/2;
    CGFloat lw = frame.size.width;
   
    //lw = lw < 110 ? 110 : lw;
    
    CGFloat lh = 30;
    return CGRectMake(lx, ly, lw, lh);
}

@end
