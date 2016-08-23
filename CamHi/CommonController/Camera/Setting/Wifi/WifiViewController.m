//
//  WifiViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiViewController.h"
#import "WifiSaveViewController.h"

@interface WifiViewController ()

@property (nonatomic, strong) __block WifiParam *wifiParam;
@property (nonatomic, strong) __block WifiList *wifiList;

@end

@implementation WifiViewController

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
    
    
    [self.camera request:HI_P2P_GET_WIFI_PARAM dson:nil];
    //[self.camera request:HI_P2P_GET_WIFI_LIST dson:nil];

    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (success) {
            
            if (cmd == HI_P2P_GET_WIFI_PARAM) {
                
                weakSelf.wifiParam = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
                
                [weakSelf.camera request:HI_P2P_GET_WIFI_LIST dson:nil];

                LOG(@"dics:%@", dic);
            }

            if (cmd == HI_P2P_GET_WIFI_LIST) {
                
                if (dic) {
                    weakSelf.wifiList = [weakSelf.camera object:dic];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                    
                    
                    LOG(@"dics:%@", dic);
                }
            }
//
//            if (cmd == HI_P2P_GET_VIDEO_CODE) {
//                
//                weakSelf.videoCode = [weakSelf.camera object:dic];
//                [weakSelf.tableView reloadData];
//            }
            
        }
        else {
            [HXProgress showText:NSLocalizedString(@"Command Error!", nil)];
        }
    };
    
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : _wifiList.wifis.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TimeRecordCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    if (section == 0) {
        cell.textLabel.text = _wifiParam.strSSID;
        cell.detailTextLabel.text = nil;
    }
    
    if (section == 1) {
        
        WifiAp *wifiap = _wifiList.wifis[row];
        
        cell.textLabel.text = wifiap.strSSID;
        
        NSString *detail = [NSString stringWithFormat:@"%@:%@    %@", INTERSTR(@"singal"), wifiap.Signal, [wifiap strEncType]];
        
        LOG(@">>> _wifiParam.strSSID:%@ detail:%@", _wifiParam.strSSID, detail)
        cell.detailTextLabel.text = detail;

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? [self setupHeaderViewWithTitle:INTERSTR(@"Current Wifi")] : [self setupHeaderViewWithTitle:INTERSTR(@"Press To Join")];
}

- (UIView *)setupHeaderViewWithTitle:(NSString *)title {
    CGFloat w = self.view.frame.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 44)];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, w-30, 30)];
    labTitle.text = title;
    labTitle.font = [UIFont systemFontOfSize:14];
    
    [headerView addSubview:labTitle];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    WifiParam *tWifiParam = _wifiParam;

    WifiSaveViewController *wifiSave = [[WifiSaveViewController alloc] init];
    wifiSave.title = INTERSTR(@"Join Wifi");
    wifiSave.camera = self.camera;

    if (section == 0) {
        wifiSave.wifiParam = tWifiParam;
    }
    
    if (section == 1) {
        WifiAp *wifiap = _wifiList.wifis[row];
        
        tWifiParam.Mode = wifiap.Mode;
        tWifiParam.EncType = wifiap.EncType;
        tWifiParam.strSSID = wifiap.strSSID;
        tWifiParam.strKey = @"";
        
        wifiSave.wifiParam = tWifiParam;
    }
    
    [self.navigationController pushViewController:wifiSave animated:YES];
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
