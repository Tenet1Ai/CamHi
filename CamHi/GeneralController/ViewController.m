//
//  ViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //统一返回按钮
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = NSLocalizedString(@"Back", nil);
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.camera registerIOSessionDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self.camera unregisterIOSessionDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate
- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}


#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}



- (void)presentAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        defaultBlock();
    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        cancelBlock();
    }];
    
    //    [actionNO setValue:LightBlueColor forKey:@"_titleTextColor"];
    //    [actionOk setValue:LightBlueColor forKey:@"_titleTextColor"];
    
    [alertController addAction:actionNO];
    [alertController addAction:actionOk];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (NSMutableArray *)timeZones {
    if (!_timeZones) {
        
        _timeZones = [[NSMutableArray alloc] initWithCapacity:0];
        
        TimeZoneInfo* timaZoneInfo = nil;
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-11 DstMode:0 Abbreviation:@"GMT-11" Detail:NSLocalizedString(@"Midway Islands;Samoa;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-10 DstMode:1 Abbreviation:@"GMT-10" Detail:NSLocalizedString(@"Hawaii;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-9 DstMode:1 Abbreviation:@"GMT-9" Detail:NSLocalizedString(@"Alaska;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-8 DstMode:1 Abbreviation:@"GMT-8" Detail:NSLocalizedString(@"Pacific Time(USA or Canada);", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-7 DstMode:1 Abbreviation:@"GMT-7" Detail:NSLocalizedString(@"Mountain Time(USA or Canada);", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-6 DstMode:1 Abbreviation:@"GMT-6" Detail:NSLocalizedString(@"Central Time(USA or Canada);", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-5 DstMode:1 Abbreviation:@"GMT-5" Detail:NSLocalizedString(@"Eastern Time(USA or Canada);", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-4 DstMode:1 Abbreviation:@"GMT-4" Detail:NSLocalizedString(@"Atlantic Time(Canada);", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-3 DstMode:1 Abbreviation:@"GMT-3" Detail:NSLocalizedString(@"Atlantic Time(Canada);", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-2 DstMode:1 Abbreviation:@"GMT-2" Detail:NSLocalizedString(@"Mid-Atlantic;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:-1 DstMode:0 Abbreviation:@"GMT-1" Detail:NSLocalizedString(@"Azores;Cape Verde;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:0 DstMode:0 Abbreviation:@"GMT 0" Detail:NSLocalizedString(@"London;Iceland;Lisbon;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:1 DstMode:1 Abbreviation:@"GMT+1" Detail:NSLocalizedString(@"Paris;Rome;Berlin;Madrid;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:2 DstMode:2 Abbreviation:@"GMT+2" Detail:NSLocalizedString(@"Paris;Rome;Berlin;Madrid;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:3 DstMode:0 Abbreviation:@"GMT+3" Detail:NSLocalizedString(@"Moscow;Nairobi;Riyadh;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:4 DstMode:1 Abbreviation:@"GMT+4" Detail:NSLocalizedString(@"Baku;Tbilisi;Abu Dhabi;Mascot;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:5 DstMode:0 Abbreviation:@"GMT+5" Detail:NSLocalizedString(@"New Delhi;Islamabad;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:6 DstMode:0 Abbreviation:@"GMT+6" Detail:NSLocalizedString(@"Dakar;Alma Ata;Novosibirsk;Astana;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:7 DstMode:0 Abbreviation:@"GMT+7" Detail:NSLocalizedString(@"Bangkok;Hanoi;Jakarta;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:8 DstMode:0 Abbreviation:@"GMT+8" Detail:NSLocalizedString(@"Beijing;Singapore;Hongkong;Taipei;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:9 DstMode:0 Abbreviation:@"GMT+9" Detail:NSLocalizedString(@"Tokyo;Seoul;Yakutsk;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:10 DstMode:0 Abbreviation:@"GMT+10" Detail:NSLocalizedString(@"Guam;Melbourne;Sydney;", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:11 DstMode:0 Abbreviation:@"GMT+11" Detail:NSLocalizedString(@"Magadan;New Caledonia;Solomon Islands;  ", @"")];
        [_timeZones addObject:timaZoneInfo];
        
        timaZoneInfo = [[TimeZoneInfo alloc]initWithTimeZone:12 DstMode:1 Abbreviation:@"GMT+12" Detail:NSLocalizedString(@"Wellington;Auckland;fiji", @"")];
        [_timeZones addObject:timaZoneInfo];

    }
    return _timeZones;
}




//根据键盘移动视图高度
- (void)offViewWithFrame:(CGRect)frame
{
    NSLog(@"frame.origin.y:%f", frame.origin.y);
    NSLog(@"frame.size.height:%f", frame.size.height);
    
    //键盘高度
    int offset = frame.origin.y + frame.size.height + 64 - (self.view.frame.size.height - 216);
    
    NSLog(@"offset:%d", offset);
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0)
    {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= offset;
        self.view.frame = viewFrame;
        
        [UIView commitAnimations];
    }
    
}

- (void)offViewWithHeight:(CGFloat)height {
    NSLog(@"height:%f", height);
    //键盘高度
    //int offset = height - (self.view.frame.size.height - 216);
    int offset = height - (self.view.frame.size.height/2);
    NSLog(@"offset:%d", offset);
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0)
    {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= offset;
        self.view.frame = viewFrame;
        
        [UIView commitAnimations];
    }
    
}


//收起键盘是恢复视图高度
- (void)resetView
{
    /* 恢复位置时同样要启动动画，不然会使视图跳跃 2016.1.6 */
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}



@end
