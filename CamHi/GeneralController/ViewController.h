//
//  ViewController.h
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraIOSessionProtocol.h"
#import "HXCell.h"
#import "VideoSetCell.h"
#import "TimeZoneInfo.h"


@interface ViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UITextViewDelegate,
UIAlertViewDelegate,
CameraIOSessionProtocol
>

@property (nonatomic, strong) Camera *camera;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *timeZones;



- (BOOL)isPureInt:(NSString*)string;


//收起键盘
- (void)offViewWithFrame:(CGRect)frame;
- (void)offViewWithHeight:(CGFloat)height;
- (void)resetView;


- (void)presentAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock;

@end

