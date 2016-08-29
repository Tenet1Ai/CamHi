//
//  SettingViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/13.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "SettingViewController.h"
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

#define HeaderH (70)

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titleArr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Camera Setting", nil);
    
    [self setupDataArray];
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"SettingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
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

- (void)setupDataArray {
    if (!self.dataArray) {
        
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.titleArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        [self.dataArray addObject:@"EditPasswordViewController"];
        [self.titleArr addObject:NSLocalizedString(@"Edit Password", nil)];
        
        
        //AlarmSettingViewController
        [self.dataArray addObject:@"AlarmSettingViewController"];
        [self.titleArr addObject:NSLocalizedString(@"Alarm Setting", nil)];

        
        //AlarmLinkViewController
        [self.dataArray addObject:@"AlarmLinkViewController"];
        [self.titleArr addObject:NSLocalizedString(@"Action with Alarm", nil)];

        //TimeRecordViewController
        if ([self.camera getCommandFunction:HI_P2P_GET_REC_AUTO_SCHEDULE] && [self.camera getCommandFunction:HI_P2P_GET_REC_AUTO_PARAM]) {
            [self.dataArray addObject:@"TimeRecordViewController"];
            [self.titleArr addObject:NSLocalizedString(@"Timing Record", nil)];
        }

        //AudioViewController
        if ([self.camera getCommandFunction:HI_P2P_GET_AUDIO_ATTR]) {
            [self.dataArray addObject:@"AudioViewController"];
            [self.titleArr addObject:NSLocalizedString(@"Audio Setting", nil)];
        }

        //VideoSetViewController
        if ([self.camera getCommandFunction:HI_P2P_GET_VIDEO_PARAM] &&[self.camera getCommandFunction:HI_P2P_GET_VIDEO_CODE]) {
            [self.dataArray addObject:@"VideoSetViewController"];
            [self.titleArr addObject:NSLocalizedString(@"Video Setting", nil)];
        }
        
        
        //WifiViewController
        [self.dataArray addObject:@"WifiViewController"];
        [self.titleArr addObject:NSLocalizedString(@"Wi-Fi Setting", nil)];
        
        
        //SDCardViewController
        [self.dataArray addObject:@"SDCardViewController"];
        [self.titleArr addObject:NSLocalizedString(@"SD Card Setting", nil)];

        
        //DeviceTimeViewController
        [self.dataArray addObject:@"DeviceTimeViewController"];
        [self.titleArr addObject:NSLocalizedString(@"Time Setting", nil)];
        
        
        //EmailViewController
        if ([self.camera getCommandFunction:HI_P2P_SET_EMAIL_PARAM_EXT]) {
            [self.dataArray addObject:@"EmailViewController"];
            [self.titleArr addObject:NSLocalizedString(@"Email Setting", nil)];
        }

        
        //FTPViewController
        if ([self.camera getCommandFunction:HI_P2P_GET_FTP_PARAM_EXT]) {
            [self.dataArray addObject:@"FTPViewController"];
            [self.titleArr addObject:NSLocalizedString(@"FTP Setting", nil)];
        }
        
        
        
        //FTPViewController
        if ([self.camera getCommandFunction:HI_P2P_SET_RESET] || [self.camera getCommandFunction:HI_P2P_SET_REBOOT]) {
            [self.dataArray addObject:@"SystemViewController"];
            [self.titleArr addObject:NSLocalizedString(@"System Setting", nil)];
        }


        //DeviceInfoViewController
        [self.dataArray addObject:@"DeviceInfoViewController"];
        [self.titleArr addObject:NSLocalizedString(@"Device Information", nil)];

        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ViewController *viewcontroller = [[NSClassFromString([self.dataArray objectAtIndex:indexPath.row]) alloc] init];
    
    viewcontroller.camera = self.camera;
    viewcontroller.title = [self.titleArr objectAtIndex:indexPath.row];
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
