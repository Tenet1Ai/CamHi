//
//  TemAndHumViewController.m
//  CamHi
//
//  Created by HXjiang on 2016/10/20.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "TemAndHumViewController.h"

@interface TemAndHumViewController ()

@property (nonatomic, strong) NSArray *temperatureInfos;
@property (nonatomic, strong) NSArray *humidityInfos;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TemAndHumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tableView.backgroundColor = RGBA_COLOR(240, 240, 240, 1);
    [self.view addSubview:self.tableView];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    self.temperatureInfos = @[@"Enable Alarm", @"MinTemperature", @"MaxTemperature"];
    self.humidityInfos = @[@"Enable Alarm", @"MinHumidity", @"MaxHumidity"];

    [self.camera requestTemperatureAndHumidity];
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.returnCommandBlock = ^(BOOL success, NSInteger cmd, id obj, id info) {
        
        if (success) {
            
            if (cmd == HI_P2P_TEMPERATURE_ALARM_GET) {
                [weakSelf.tableView reloadData];
            }
            
            if (cmd == HI_P2P_HUMIDITY_ALARM_GET) {
                [weakSelf.tableView reloadData];
            }
            
        }
        
        
        if (!success) {
            [HXProgress showText:INTERSTR(@"Request Error!")];
        }

    };
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"TemHumCellID";
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
//    cell.backgroundColor = RGBA_COLOR(240, 240, 240, 1);
    
    if (section == 0) {
        
        cell.textLabel.text = NSLocalizedString(self.temperatureInfos[row], nil);
        
        if (self.camera.gmTemperature) {
            
            if (row == 0) {
                //cell.textLabel.text = NSLocalizedString(@"Enable Alarm", nil);
            }
            
            if (row == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", self.camera.gmTemperature.fMinTemperature];
            }

            if (row == 2) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", self.camera.gmTemperature.fMaxTemperature];
            }
        }
    }
    
    if (section == 1) {
        
        cell.textLabel.text = NSLocalizedString(self.humidityInfos[row], nil);

        if (self.camera.gmHumidity) {
            
            if (row == 0) {
//                cell.textLabel.text = NSLocalizedString(@"Enable Alarm", nil);
            }
            
            if (row == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", self.camera.gmHumidity.fMinHumidity];
            }
            
            if (row == 2) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", self.camera.gmHumidity.fMaxHumidity];
            }

        }
    }
    
    
    
 
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor orangeColor];
    
    [headerView addSubview:self.titleLabel];
//    self.titleLabel.frame = headerView.frame;
    self.titleLabel.backgroundColor = [UIColor greenColor];
    
    if (section == 0) {
        self.titleLabel.text = NSLocalizedString(@"Temperature", nil);
    }
    
    if (section == 1) {
        self.titleLabel.text = NSLocalizedString(@"Humidity", nil);
    }
    
    return headerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 30)];
    }
    return _titleLabel;
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
