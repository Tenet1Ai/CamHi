//
//  SettingViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/13.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "SettingViewController.h"
#import "MSettingController.h"

#import "EditPasswordViewController.h"
#import "AlarmSettingViewController.h"
#import "AlarmLinkViewController.h"
#import "TimeRecordViewController.h"
#import "AudioViewController.h"
#import "VideoSetViewController.h"
#import "WifiViewController.h"
#import "SDCardViewController.h"
#import "DeviceTimeViewController.h"
#import "EmailViewController.h"
#import "FTPViewController.h"
#import "SystemViewController.h"
#import "DeviceInfoViewController.h"
#import "TemAndHumViewController.h"


#define HeaderH (70)

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *controllers;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Camera Setting", nil);
    
    [self.view addSubview:self.tableView];
    [self setupControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupControllers {
    
    // EditPasswordViewController
    [self.controllers addObject:[MSettingController initWithName:@"EditPasswordViewController" title:@"Edit Password"]];
    
    
    // AlarmSettingViewController
    [self.controllers addObject:[MSettingController initWithName:@"AlarmSettingViewController" title:@"Alarm Setting"]];
    
    
    // AlarmLinkViewController
    [self.controllers addObject:[MSettingController initWithName:@"AlarmLinkViewController" title:@"Action with Alarm"]];

    
    // TimeRecordViewController
    if ([self.camera getCommandFunction:HI_P2P_GET_REC_AUTO_SCHEDULE] && [self.camera getCommandFunction:HI_P2P_GET_REC_AUTO_PARAM]) {
        [self.controllers addObject:[MSettingController initWithName:@"TimeRecordViewController" title:@"Timing Record"]];
    }
    
    // AudioViewController
    if ([self.camera getCommandFunction:HI_P2P_GET_AUDIO_ATTR]) {
        [self.controllers addObject:[MSettingController initWithName:@"AudioViewController" title:@"Audio Setting"]];
    }
    
    // VideoSetViewController
    if ([self.camera getCommandFunction:HI_P2P_GET_VIDEO_PARAM] &&[self.camera getCommandFunction:HI_P2P_GET_VIDEO_CODE]) {
        [self.controllers addObject:[MSettingController initWithName:@"VideoSetViewController" title:@"Video Setting"]];
    }
    
    
    // WifiViewController
    [self.controllers addObject:[MSettingController initWithName:@"WifiViewController" title:@"Wi-Fi Setting"]];

    
    
    // SDCardViewController
    [self.controllers addObject:[MSettingController initWithName:@"SDCardViewController" title:@"SD Card Setting"]];
    
    
    // DeviceTimeViewController
    [self.controllers addObject:[MSettingController initWithName:@"DeviceTimeViewController" title:@"Time Setting"]];

    
    
    // EmailViewController
    if ([self.camera getCommandFunction:HI_P2P_SET_EMAIL_PARAM_EXT]) {
        [self.controllers addObject:[MSettingController initWithName:@"EmailViewController" title:@"Email Setting"]];
    }
    
    
    // FTPViewController
    if ([self.camera getCommandFunction:HI_P2P_GET_FTP_PARAM_EXT]) {
        [self.controllers addObject:[MSettingController initWithName:@"FTPViewController" title:@"FTP Setting"]];
    }
    
    
    
    // SystemViewController
    if ([self.camera getCommandFunction:HI_P2P_SET_RESET] || [self.camera getCommandFunction:HI_P2P_SET_REBOOT]) {
        [self.controllers addObject:[MSettingController initWithName:@"SystemViewController" title:@"System Setting"]];
    }
    
    
    // DeviceInfoViewController
    [self.controllers addObject:[MSettingController initWithName:@"DeviceInfoViewController" title:@"Device Information"]];

    
    
    if (DisplayNameCamHiGH) {
        
        // TemAndHumViewController
        if ([self.camera getCommandFunction:HI_P2P_TEMPERATURE_ALARM_GET] &&
            [self.camera getCommandFunction:HI_P2P_TEMPERATURE_ALARM_SET] &&
            [self.camera getCommandFunction:HI_P2P_HUMIDITY_ALARM_GET] &&
            [self.camera getCommandFunction:HI_P2P_HUMIDITY_ALARM_SET]) {
            
            [self.controllers addObject:[MSettingController initWithName:@"TemAndHumViewController" title:@"Tem&Hum Alarm"]];
        }
    }
    
    
    
    
    
    //LOG(@"setting_controllers : %@", self.controllers);

    [self.tableView reloadData];
}

- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _controllers;
}

#pragma mark - UITableViewDelegate
/*
- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UITableView alloc] init];
    }
    return _tableView;
}
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.dataArray.count;
    return self.controllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"SettingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    MSettingController *controller = self.controllers[indexPath.row];
    
    cell.textLabel.text = NSLocalizedString(controller.classTitle, nil);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self setupHeaderView];
}

- (UIView *)setupHeaderView {
    if (!self.headerView) {
     
        CGFloat w = self.view.frame.size.width;
        CGFloat h = HeaderH;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        self.headerView.backgroundColor = RGBA_COLOR(220, 220, 220, 1);
        
        //UIImage *image = [UIImage imageWithColor:RGBA_COLOR(1, 0, 0, 1) wihtSize:CGSizeMake(80, 60)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 80, 60)];
        imgView.image = [self.camera image];
        [self.headerView addSubview:imgView];
        
        CGFloat x = CGRectGetMaxX(imgView.frame)+5;
        CGFloat y = CGRectGetMinY(imgView.frame);
        UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 135, 30)];
        labName.text = self.camera.name;
        [self.headerView addSubview:labName];
        
        UILabel *labUid = [[UILabel alloc] initWithFrame:CGRectMake(x, y+30, 135, 30)];
        labUid.text = self.camera.uid;
        labUid.adjustsFontSizeToFitWidth = YES;
        labUid.textColor = [UIColor grayColor];
        [self.headerView addSubview:labUid];
        
    }
    return self.headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSettingController *mcontroller = self.controllers[indexPath.row];
    
    ViewController *viewcontroller = [[NSClassFromString(mcontroller.className) alloc] init];

    viewcontroller.camera = self.camera;
    viewcontroller.title = NSLocalizedString(mcontroller.classTitle, nil);

    [self.navigationController pushViewController:viewcontroller animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
