//
//  DeviceInfoViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "DeviceInfoViewController.h"

@interface DeviceInfoViewController ()


@property (nonatomic, strong) __block DeviceInfo *deviceInfo;
@property (nonatomic, strong) __block NetParam *netParam;
@property (nonatomic, strong) NSMutableArray *infos;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) NSArray *infoTitles;
@property (nonatomic, strong) NSArray *paramTitles;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    [self.camera request:HI_P2P_GET_DEV_INFO dson:nil];

    _infos = [[NSMutableArray alloc] initWithCapacity:0];
    _params = [[NSMutableArray alloc] initWithCapacity:0];
    _infoTitles = @[INTERSTR(@"Device ID"), INTERSTR(@"Network"), INTERSTR(@"Current Users"), INTERSTR(@"Soft Version")];
    _paramTitles = @[INTERSTR(@"IP Address"), INTERSTR(@"Subnet Mask"), INTERSTR(@"Gateway"), INTERSTR(@"DNS")];

    __weak typeof(self) wself = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (cmd == HI_P2P_GET_DEV_INFO) {
            
            [wself.camera request:HI_P2P_GET_NET_PARAM dson:nil];

            wself.deviceInfo = [wself.camera object:dic];
            [wself.infos addObject:wself.deviceInfo.strDeviceName];
            [wself.infos addObject:[wself.deviceInfo netType]];
            [wself.infos addObject:[NSString stringWithFormat:@"%d", wself.deviceInfo.sUserNum]];
            [wself.infos addObject:wself.deviceInfo.strSoftVer];
            
            [wself.tableView reloadData];
        }
        
        if (cmd == HI_P2P_GET_NET_PARAM) {
            
            wself.netParam = [wself.camera object:dic];
            [wself.params addObject:wself.netParam.strIPAddr];
            [wself.params addObject:wself.netParam.strNetMask];
            [wself.params addObject:wself.netParam.strGateWay];
            [wself.params addObject:wself.netParam.strFDNSIP];
            
            [wself.tableView reloadData];
        }

    };
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _infos.count : _params.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SystemCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        cell.textLabel.text = _infoTitles[row];
        cell.detailTextLabel.text = _infos[row];
    }
    
    if (section == 1) {
        cell.textLabel.text = _paramTitles[row];
        cell.detailTextLabel.text = _params[row];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
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
