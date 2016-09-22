//
//  DeviceTimeViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "DeviceTimeViewController.h"
#import "TimeZoneViewController.h"

@interface DeviceTimeViewController ()

@property (nonatomic, strong) __block TimeParam *timeParam;
@property (nonatomic, strong) __block TimeZone *timeZone;

@end

@implementation DeviceTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //LOG(@"self.timeZones:%@", self.timeZones)

    [self setup];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    [self.camera request:HI_P2P_GET_TIME_PARAM dson:nil];
    [self.camera request:HI_P2P_GET_TIME_ZONE dson:nil];
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (cmd == HI_P2P_GET_TIME_PARAM) {
            
            if (success) {
                
                weakSelf.timeParam = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
            }
            
        }//@HI_P2P_GET_TIME_PARAM
        
        if (cmd == HI_P2P_SET_TIME_PARAM) {
            [weakSelf.camera request:HI_P2P_GET_TIME_PARAM dson:nil];
        }
        
        
        if (cmd == HI_P2P_GET_TIME_ZONE) {
            
            weakSelf.timeZone = [weakSelf.camera object:dic];
            [weakSelf.tableView reloadData];
            
            LOG(@"_timeZone.u32DstMode:%d", weakSelf.timeZone.u32DstMode)

        }
        
        if (cmd == HI_P2P_SET_TIME_ZONE) {
            
            if (success) {
                [weakSelf.camera request:HI_P2P_SET_REBOOT dson:nil];
            }
        }
        
        
        if (cmd == HI_P2P_SET_REBOOT) {
            
            if (success) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
    };
    
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        
        if (row == 0) {
            cell.textLabel.text = INTERSTR(@"Device Time");
            cell.detailTextLabel.text = INTERSTR(@"Loading");
            cell.detailTextLabel.text = [_timeParam time];
        }
        
        if (row == 1) {
            cell.textLabel.text = INTERSTR(@"Sync with Phone Time");
            cell.textLabel.textColor = [UIColor blueColor];
        }
        
    }//@section == 0
    
    if (section == 1) {
        
        if (row == 0) {
            cell.textLabel.text = INTERSTR(@"Device Time Zone");
            cell.detailTextLabel.text = INTERSTR(@"Loading");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            for (TimeZoneInfo *timezone in self.timeZones) {
                if (timezone.timeZone == _timeZone.s32TimeZone) {
                    cell.detailTextLabel.text = timezone.abbreviation;
                    break;
                }
            }
            
        }
        
        if (row == 1) {
            cell.textLabel.text = INTERSTR(@"Phone Time Zone");
            
            NSTimeZone *czone = [NSTimeZone systemTimeZone];
            cell.detailTextLabel.text = czone.abbreviation;
        }
        
        if (row == 2) {
            cell.textLabel.text = INTERSTR(@"Saving Time Zone For Device");
            cell.textLabel.textColor = [UIColor blueColor];
        }

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            [self syncWithPhoneTime];
        }
    }
    
    if (indexPath.section == 1) {
        
        __weak typeof(self) weakSelf = self;
        
        if (indexPath.row == 0) {
            
            TimeZoneViewController *timezone = [[TimeZoneViewController alloc] init];
            timezone.timeZone = _timeZone;
            timezone.title = INTERSTR(@"Zones");
            timezone.timezoneBlock = ^(BOOL success, NSInteger cmd, TimeZone *tzone) {
                weakSelf.timeZone = tzone;
                [weakSelf.tableView reloadData];
            };
            
            [self.navigationController pushViewController:timezone animated:YES];
        }
        
        if (indexPath.row == 2) {
            
           // [self presentAlertViewBeforeIOS8];

            if (SystemVersion >= 8.0) {
                
                
                [self presentAlertTitle:nil message:INTERSTR(@"Set Device Time Zone will REBOOT device") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
                    
                    [weakSelf.camera request:HI_P2P_SET_TIME_ZONE dson:[weakSelf.camera dic:_timeZone]];
                    
                } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
                    
                }];
            }
            else {
                [self presentAlertViewBeforeIOS8];
            }

        }//@row == 2
        
    }//@section == 1
}


- (void)syncWithPhoneTime {
    
    [_timeParam syncCurrentTime];
    
    [self.camera request:HI_P2P_SET_TIME_PARAM dson:[self.camera dic:_timeParam]];
}


#pragma mark - UIAlertViewDelegate
- (void)presentAlertViewBeforeIOS8 {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INTERSTR(@"Set Device Time Zone will REBOOT device") delegate:self cancelButtonTitle:INTERSTR(@"No") otherButtonTitles:INTERSTR(@"Yes"), nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"buttonIndex:%d", (int)buttonIndex);
    
    if (buttonIndex == 1) {
        [self.camera request:HI_P2P_SET_TIME_ZONE dson:[self.camera dic:_timeZone]];
    }
    
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
