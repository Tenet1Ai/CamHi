//
//  WifiSaveViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiSaveViewController.h"
#import "VideoSetCell.h"

@interface WifiSaveViewController ()

@end

@implementation WifiSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rbtnItem = [[UIBarButtonItem alloc] initWithTitle:INTERSTR(@"Save") style:UIBarButtonItemStyleDone target:self action:@selector(rbtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbtnItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}



- (void)setup {
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
      
        
        if (cmd == HI_P2P_SET_WIFI_PARAM) {
            
            if (success) {
                
                [HXProgress showText:INTERSTR(@"Save Success")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            else {
                LOG(@">>>>>> cmd:%ld", cmd)

                [HXProgress showText:INTERSTR(@"Save Failed")];
            }
        }
        
        // check wifi
        if (cmd == HI_P2P_SET_WIFI_CHECK) {
            
            if (success) {
                
                [HXProgress showText:INTERSTR(@"Save Success")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            else {
                LOG(@">>>>>> cmd:%ld", cmd)
                
                [HXProgress showText:INTERSTR(@"Save Failed")];
            }

        }// @check wifi
    };
}


- (void)rbtnItemAction:(id)sender {
    
    [self.view endEditing:YES];
    _wifiParam.u32Check = 0;
    
    if (_wifiParam.strSSID.length > 31) {
        [HXProgress showText:INTERSTR(@"SSID maximum length of 31")];
        return;
    }
    
    if (_wifiParam) {
        [self.camera request:HI_P2P_SET_WIFI_CHECK dson:[self.camera dic:_wifiParam]];
    }
    
}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoCellID";
    VideoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[VideoSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        cell.labTitle.text = _wifiParam.strSSID;
        [cell.tfieldDetail removeFromSuperview];
    }
    
    if (row == 1) {
        cell.labTitle.text = INTERSTR(@"Password");
        cell.tfieldDetail.placeholder = INTERSTR(@"Password");
        cell.tfieldDetail.secureTextEntry = YES;
        cell.tfieldDetail.text = _wifiParam.strKey;
        cell.tfieldDetail.delegate = self;
    }
    
    return cell;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _wifiParam.strKey = textField.text;
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
