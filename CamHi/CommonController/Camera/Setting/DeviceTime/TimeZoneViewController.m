//
//  TimeZoneViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "TimeZoneViewController.h"

@interface TimeZoneViewController ()

@property (nonatomic, strong) UISwitch *enableSwitch;

@end

@implementation TimeZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
    
    LOG(@"_timeZone.u32DstMode:%d", _timeZone.u32DstMode)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.timeZones.count;
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
        
        cell.textLabel.text = INTERSTR(@"Daylight Saving Time");
        cell.accessoryView = self.enableSwitch;
        self.enableSwitch.on = _timeZone.u32DstMode == 1 ? YES : NO;
        
    }//@section == 0
    
    if (section == 1) {
        
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        TimeZoneInfo *zone = self.timeZones[row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", zone.abbreviation, zone.detail];
        
        if (zone.timeZone == _timeZone.s32TimeZone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    TimeZoneInfo *zone = self.timeZones[indexPath.row];

    _timeZone.s32TimeZone = zone.timeZone;
    _timeZone.u32DstMode = zone.dstMode;
    
    self.enableSwitch.on = _timeZone.u32DstMode == 1 ? YES : NO;
    
    if (_timezoneBlock) {
        _timezoneBlock(YES, 0, _timeZone);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UISwitch *)enableSwitch {
    if (!_enableSwitch) {
        _enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    }
    return _enableSwitch;
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
