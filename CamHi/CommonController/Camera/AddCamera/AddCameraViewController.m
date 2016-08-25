//
//  AddCameraViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/14.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "AddCameraViewController.h"
#import "CameraListViewController.h"
#import "WifiSetViewController.h"
#import "OCScanLifeViewController.h"

@interface AddCameraViewController ()<CameraListDelegate, OCScanLifeViewControllerDelegate>

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UITextField *tfieldName;
@property (nonatomic, strong) UITextField *tfieldUser;
@property (nonatomic, strong) UITextField *tfieldUID;
@property (nonatomic, strong) UITextField *tfieldPwd;

@end

@implementation AddCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Add Camera", nil);
    self.titleArr = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Name", nil), NSLocalizedString(@"User Name", nil), NSLocalizedString(@"UID", nil), NSLocalizedString(@"Password", nil), nil];
    [self setupBarButtonItem];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupBarButtonItem {
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(btnDoneAction:)];
    
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)btnDoneAction:(id)sender {
    
    //close keyboard
    [self.view endEditing:YES];
    
    NSString *tname = self.tfieldName.text;
    NSString *tuser = self.tfieldUser.text;
    NSString *tuid  = self.tfieldUID.text;
    NSString *tpwd  = self.tfieldPwd.text;
    
    tname = [tname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tuser = [tuser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tuid  = [tuid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tpwd  = [tpwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if (tname == nil || tname.length == 0) {
        [HXProgress showText:NSLocalizedString(@"Camera Name can not be empty", nil)];
        return;
    }
    
    if (tuser == nil || tuser.length == 0) {
        [HXProgress showText:NSLocalizedString(@"Camera Account can not be empty", nil)];
        return;
    }

    if (tuid == nil || tuid.length == 0) {
        [HXProgress showText:NSLocalizedString(@"Camera UID can not be empty", nil)];
        return;
    }

    if (tpwd == nil || tpwd.length == 0) {
        [HXProgress showText:NSLocalizedString(@"Camera Password can not be empty", nil)];
        return;
    }
    
    //add unexist device
    for (Camera *mycam in [GBase sharedBase].cameras) {
        if ([mycam.uid isEqualToString:tuid]) {
            [HXProgress showText:NSLocalizedString(@"This device is already exists", nil)];
            return;
        }
    }//@for

    
    //init camera
    Camera *mycam = [[Camera alloc] initWithUid:tuid Name:tname Username:tuser Password:tpwd];
    [mycam registerIOSessionDelegate:self];
    [mycam connect];
    [HXProgress showProgress];
    
    //add camera to database
    [GBase addCamera:mycam];
    
}


#pragma mark - CameraIOSessionProtocol
- (void)receiveSessionState:(HiCamera *)camera Status:(int)status {
    
    LOG(@">>> camera:%@ status:%d", camera.uid, status)
    
    if (status == CAMERA_CONNECTION_STATE_CONNECTING) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HXProgress dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellID = @"AddCameraCellID";
        HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.titleArr.count != 0) {
            cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
        }
        
        
        
        if (indexPath.row == 0) {
            if (self.tfieldName == nil) {
                self.tfieldName = [self setupTextField];
            }
            self.tfieldName.tag = 0;
            self.tfieldName.text = NSLocalizedString(@"Camera", nil);
            [cell.contentView addSubview:self.tfieldName];
        
        }//@row == 0
        
        
        if (indexPath.row == 1) {
            if (self.tfieldUser == nil) {
                self.tfieldUser = [self setupTextField];
            }
            self.tfieldUser.tag = 1;
            self.tfieldUser.text = NSLocalizedString(@"admin", nil);
            [cell.contentView addSubview:self.tfieldUser];
        
        }//@row == 1

        
        if (indexPath.row == 2) {
            if (self.tfieldUID == nil) {
                self.tfieldUID = [self setupTextField];
            }
            self.tfieldUID.tag = 2;
            self.tfieldUID.placeholder = NSLocalizedString(@"Camera UID", nil);
            [cell.contentView addSubview:self.tfieldUID];
            
        }//@row == 1

        
        if (indexPath.row == 3) {
            if (self.tfieldPwd == nil) {
                self.tfieldPwd = [self setupTextField];
            }
            self.tfieldPwd.tag = 1;
            self.tfieldPwd.secureTextEntry = YES;
            self.tfieldPwd.placeholder = NSLocalizedString(@"Camera Password", nil);
            [cell.contentView addSubview:self.tfieldPwd];
            
        }//@row == 1

        
        return cell;
        
    }//@section == 0
    
    
    if (indexPath.section != 0) {
        
        static NSString *cellID = @"AddCameraCellID";
        HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == 1) {
            cell.textLabel.text = INTERSTR(@"Search Camera from LAN");
        }
        
        if (indexPath.section == 2) {
            cell.textLabel.text = INTERSTR(@"Wireless Installation");
        }
        
        if (indexPath.section == 3) {
            cell.textLabel.text = INTERSTR(@"Scan QR Code");
        }
        
        return cell;
        
    }//@section != 0
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        CameraListViewController *cameraList = [[CameraListViewController alloc] init];
        cameraList.delegate = self;
        [self.navigationController pushViewController:cameraList animated:YES];
    }
    
    if (indexPath.section == 2) {
        WifiSetViewController *wifiSet = [[WifiSetViewController alloc] init];
        wifiSet.title = INTERSTR(@"Wireless Installation");
        
        wifiSet.setwifiBlock = ^(BOOL success, NSInteger type) {
            if (success) {
                CameraListViewController *cameraList = [[CameraListViewController alloc] init];
                cameraList.delegate = self;
                [self.navigationController pushViewController:cameraList animated:YES];
            }
        };
        
        [self.navigationController pushViewController:wifiSet animated:YES];
    }
    
    if (indexPath.section == 3) {
        
        OCScanLifeViewController *scan = [[OCScanLifeViewController alloc] init];
        scan.title = INTERSTR(@"Scan QR Code");
        scan.delegate = self;
        
        [self.navigationController pushViewController:scan animated:YES];
    }
}


#pragma mark - UITextFieldDelegate
- (id)setupTextField {
    
    CGFloat x = 115.0f;
    CGFloat y = 11.0f;
    CGFloat w = 180.0f;
    CGFloat h = 25.0f;
    UITextField *tfield = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    tfield.delegate = self;
    tfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfield.font = [UIFont systemFontOfSize:14];
    
    return tfield;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - CameraListDelegate
- (void)didSelectCamera:(NSString *)uid {
    
    if (self.tfieldUID) {
        self.tfieldUID.text = uid;
    }
    
    [self.tableView reloadData];
}


#pragma mark - OCScanLifeViewControllerDelegate
- (void)scanResult:(NSString *)result {
    
    if (self.tfieldUID) {
        self.tfieldUID.text = result;
    }
    
    [self.tableView reloadData];

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
