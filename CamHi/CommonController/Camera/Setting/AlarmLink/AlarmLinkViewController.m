//
//  AlarmLinkViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/29.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "AlarmLinkViewController.h"
#import "AlarmLinkCell.h"

@interface AlarmLinkViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UISegmentedControl *tsegment;
@property (nonatomic, strong) __block AlarmLink *model;
@property (nonatomic, strong) __block SnapAlarm *snapAlarm;
@property (nonatomic, strong) UILabel *labSnapShot;

@end

@implementation AlarmLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self setup];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    [self.camera request:HI_P2P_GET_ALARM_PARAM dson:nil];
    
    if ([self.camera getCommandFunction:HI_P2P_GET_SNAP_ALARM_PARAM]) {
        [self.camera request:HI_P2P_GET_SNAP_ALARM_PARAM dson:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (success) {
            
            if (cmd == HI_P2P_GET_ALARM_PARAM) {
                
                weakSelf.model = dic[@"model"];
                [weakSelf.tableView reloadData];
                
                LOG(@"dics:%@", dic);
            }
            
            if (cmd == HI_P2P_GET_SNAP_ALARM_PARAM) {
                weakSelf.snapAlarm = dic[@"model"];
                [weakSelf.tableView reloadData];
                LOG(@"HI_P2P_GET_SNAP_ALARM_PARAM/dics:%d", weakSelf.snapAlarm.u32Number);
            }
            
        }
        else {
            [HXProgress showText:NSLocalizedString(@"Command Error!", nil)];
        }
    };
    
    
    
    //XingePush
    self.camera.xingePushBlock = ^(int subID, int type, int result) {
      
        //开启
        if (type == PUSH_TYPE_BIND) {
            
            if (result == PUSH_RESULT_FAIL) {
                [HXProgress showText:INTERSTR(@"Turn on failed")];
            }
            
            if (result == PUSH_RESULT_SUCCESS) {
                [HXProgress showText:INTERSTR(@"Turn on success")];
            }
        }
        
        //关闭
        if (type == PUSH_TYPE_UNBIND) {
            
            if (result == PUSH_RESULT_FAIL) {
                [HXProgress showText:INTERSTR(@"Turn off failed")];
            }
            
            if (result == PUSH_RESULT_SUCCESS) {
                [HXProgress showText:INTERSTR(@"Turn off success")];
            }
        }

        [weakSelf.tableView reloadData];

    };
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.titles.count) {
        return 88.0f;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AlarmSettingCellID";
    AlarmLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AlarmLinkCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger row = indexPath.row;
    if (row < self.titles.count) {
        cell.textLabel.text = [self.titles objectAtIndex:row];
    }
    
    cell.tswitch.tag = row;
    [cell.tswitch addTarget:self action:@selector(tswitchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    if (row == 0) {
        
        if (self.camera.isAlarm) {
            cell.tswitch.on = YES;
        }
        else {
            cell.tswitch.on = self.camera.isPushOn == 1 ? YES : NO;
        }
        
    }
    
    if (row == 1) {
        
        cell.tswitch.on = _model.u32SDRec == 0 ? NO : YES;
    }

    if (row == 2) {
        cell.tswitch.on = _model.u32EmailSnap == 0 ? NO : YES;
    }

    if (row == 3) {
        cell.tswitch.on = _model.u32FtpSnap == 0 ? NO : YES;
    }

    if (row == 4) {
        cell.tswitch.on = _model.u32FtpRec == 0 ? NO : YES;
    }

    if (row == self.titles.count) {
        
        static NSString *cellID = @"SnapNumberCellID";
        HXCell *ncell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (ncell == nil) {
            ncell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }

        //ncell.textLabel.text = NSLocalizedString(@"Snap Number", nil);
        [ncell.contentView addSubview:self.labSnapShot];
        [ncell.contentView addSubview:self.tsegment];
        self.tsegment.selectedSegmentIndex = _snapAlarm.u32Number-1;
        return ncell;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}



- (void)tswitchAction:(id)sender {
 
    UISwitch *tswitch = (UISwitch *)sender;
    
    
    if (tswitch.tag == 0) {
        
        tswitch.on ? [self.camera turnOnXingePush] : [self.camera turnOffXingePush];
        return;
    }
    
    
    
    
    if (tswitch.tag == 1) {
        _model.u32SDRec = tswitch.on ? 1 : 0;
    }
    
    if (tswitch.tag == 2) {
        _model.u32EmailSnap = tswitch.on ? 1 : 0;
    }

    if (tswitch.tag == 3) {
        _model.u32FtpSnap = tswitch.on ? 1 : 0;
    }

    if (tswitch.tag == 4) {
        _model.u32FtpRec = tswitch.on ? 1 : 0;
    }

    NSDictionary *dic = @{@"model": _model};
    [self.camera request:HI_P2P_SET_ALARM_PARAM dson:dic];
}


- (UILabel *)labSnapShot {
    if (!_labSnapShot) {
        _labSnapShot = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 44)];
        _labSnapShot.text = NSLocalizedString(@"Snap Number", nil);
        _labSnapShot.font = [UIFont systemFontOfSize:14];
        _labSnapShot.adjustsFontSizeToFitWidth = YES;
    }
    
    return _labSnapShot;
}

#pragma mark - lazy load
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[NSLocalizedString(@"Alarm Notifications", nil),
                    NSLocalizedString(@"Alarm SD REC", nil),
                    NSLocalizedString(@"E-mail Alarm with Pictures", nil),
                    NSLocalizedString(@"Save Snapshots on FTP Server", nil),
                    NSLocalizedString(@"Save Video on FTP Server", nil)];
    }
    return _titles;
}

- (UISegmentedControl *)tsegment {
    if (!_tsegment) {
        
        NSArray *items = @[NSLocalizedString(@"1", nil),
                           NSLocalizedString(@"2", nil),
                           NSLocalizedString(@"3", nil)];
        _tsegment = [[UISegmentedControl alloc] initWithItems:items];
        _tsegment.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 30);
        _tsegment.center = CGPointMake(self.view.frame.size.width/2, 44+44/2);
        //        _tsegment.backgroundColor = [UIColor whiteColor];
        _tsegment.tintColor = [UIColor grayColor];
        [_tsegment addTarget:self action:@selector(tsegmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tsegment;
}

- (void)tsegmentAction:(id)sender {
    
    UISegmentedControl *tseg = (UISegmentedControl *)sender;
    
    NSInteger index = tseg.selectedSegmentIndex;
    
    if (index == 0) {
        _snapAlarm.u32Number = 1;
    }
    
    if (index == 1) {
        _snapAlarm.u32Number = 2;
    }
    
    if (index == 2) {
        _snapAlarm.u32Number = 3;
    }
    _snapAlarm.u32Interval = _snapAlarm.u32Interval < 5 ? 5 : _snapAlarm.u32Interval;

    NSDictionary *dic = @{@"model": _snapAlarm};
    [self.camera request:HI_P2P_SET_SNAP_ALARM_PARAM dson:dic];
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
