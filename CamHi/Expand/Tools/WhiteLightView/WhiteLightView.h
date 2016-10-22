//
//  WhiteLightView.h
//  CamHi
//
//  Created by HXjiang on 16/9/23.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhiteLightView : UIView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Camera *camera;
@property (nonatomic, assign) BOOL isShow;

- (void)reloadWithIndex:(NSInteger)index;

- (void)show;
- (void)dismiss;

@end
