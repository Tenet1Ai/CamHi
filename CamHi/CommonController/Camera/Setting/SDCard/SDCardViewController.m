//
//  SDCardViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/9.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SDCardViewController.h"

@interface SDCardViewController ()


@property (nonatomic, strong) __block SDCard *sdcard;

@end

@implementation SDCardViewController

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
    
    
    [self.camera request:HI_P2P_GET_SD_INFO dson:nil];
    
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (cmd == HI_P2P_GET_SD_INFO) {
            
            if (success) {
                
                weakSelf.sdcard = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
            }
            
        }//@HI_P2P_GET_SD_INFO
        
        if (cmd == HI_P2P_SET_FORMAT_SD) {
            [weakSelf.camera request:HI_P2P_GET_SD_INFO dson:nil];
        }
        
    };
    
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 1;
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
    
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = INTERSTR(@"Loading");
        
        if (row == 0) {
            cell.textLabel.text = INTERSTR(@"Total Size");
            cell.detailTextLabel.text = [_sdcard total];
        }
        
        if (row == 1) {
            cell.textLabel.text = INTERSTR(@"Free size");
            cell.detailTextLabel.text = [_sdcard available];
        }
        
    }//@section == 0
    
    if (section == 1) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = INTERSTR(@"Format SD Card");
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        if (SystemVersion >= 8.0) {
            
            __weak typeof(self) weakSelf = self;
            
            [self presentAlertTitle:nil message:INTERSTR(@"Format command will ERASE all data of SDCard") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
                
                [weakSelf.camera request:HI_P2P_SET_FORMAT_SD dson:nil];
                
            } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
                
            }];
        }
        else {
            [self presentAlertViewBeforeIOS8];
        }
    }
}


#pragma mark - UIAlertViewDelegate
- (void)presentAlertViewBeforeIOS8 {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INTERSTR(@"Format command will ERASE all data of SDCard") delegate:self cancelButtonTitle:INTERSTR(@"No") otherButtonTitles:INTERSTR(@"Yes"), nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"buttonIndex:%d", (int)buttonIndex);
    
    if (buttonIndex == 1) {
        [self.camera request:HI_P2P_SET_FORMAT_SD dson:nil];
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
