//
//  DownloadView.h
//  CamHi
//
//  Created by HXjiang on 16/9/1.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnCancel)(NSInteger type);

@interface DownloadView : UIView


@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labProgress;
@property (nonatomic, strong) UIProgressView *progrssView;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, copy) btnCancel cancelBlock;

- (id)initWithTitle:(NSString *)title;
- (void)show;
- (void)dismiss;



@end
