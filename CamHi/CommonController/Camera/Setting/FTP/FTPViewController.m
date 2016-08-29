//
//  FTPViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/12.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "FTPViewController.h"
#import "VideoSetCell.h"


typedef NS_ENUM(NSInteger, FTPTextField) {
    FTPTextFieldServer,
    FTPTextFieldPort,
    FTPTextFieldUsername,
    FTPTextFieldPassword,
    FTPTextFieldPath,
};

@interface FTPViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) __block FTPParam *ftpParam;
@property (nonatomic, strong) UISwitch *modeSwitch;

@end

@implementation FTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
    
    UIBarButtonItem *rbarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(rbarBtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbarBtnItem;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    
    [self.camera request:HI_P2P_GET_FTP_PARAM_EXT dson:nil];
    
    
    __weak typeof(self) weakSelf = self;

    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (cmd == HI_P2P_GET_FTP_PARAM_EXT) {
            
            if (success) {
                
                weakSelf.ftpParam = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
            }
            
        }//
        
//        if (cmd == HI_P2P_SET_EMAIL_PARAM) {
//            if (success) {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
//        }
//        
        if (cmd == HI_P2P_SET_FTP_PARAM_EXT) {
            
            if (_ftpParam.u32Check == 0) {
                return ;
            }
            
            if (success) {
                [HXProgress showText:INTERSTR(@"Test Successful")];
            }
            else {
                [HXProgress showText:INTERSTR(@"Test Failed")];
            }
        }
        
    };
    
}


- (void)rbarBtnItemAction:(id)sender {
    
    [self.view endEditing:YES];
    
    _ftpParam.u32Check = 0;
    
    [self.camera request:HI_P2P_SET_FTP_PARAM_EXT dson:[self.camera dic:_ftpParam]];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.titles.count : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        
        
        static NSString *cellID = @"VideoCellID";
        VideoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[VideoSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        
        
        
        cell.labTitle.text = self.titles[row];
        //cell.labTitle.text = self.titles[row];
        cell.tfieldDetail.delegate = self;
        
        switch (row) {
            case 0:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Server Addr.");
                cell.tfieldDetail.text = _ftpParam.strSvr;
                cell.tfieldDetail.tag = FTPTextFieldServer;
                
                break;
            case 1:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Server Port");
                cell.tfieldDetail.text = [NSString stringWithFormat:@"%d", _ftpParam.u32Port];
                cell.tfieldDetail.tag = FTPTextFieldPort;
                
                break;
            case 2:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"User Name");
                cell.tfieldDetail.text = _ftpParam.strUsernm;
                cell.tfieldDetail.tag = FTPTextFieldUsername;
                
                break;
            case 3:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Password");
                cell.tfieldDetail.secureTextEntry = YES;
                cell.tfieldDetail.text = _ftpParam.strPasswd;
                cell.tfieldDetail.tag = FTPTextFieldPassword;

                break;
            case 4:
                
                [cell.tfieldDetail removeFromSuperview];
                cell.accessoryView = self.modeSwitch;
                self.modeSwitch.on = _ftpParam.u32Mode == 1 ? YES : NO;
                
                break;
            case 5:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Path");
                cell.tfieldDetail.text = _ftpParam.strFilePath;
                cell.tfieldDetail.tag = FTPTextFieldPath;
                
                break;
                
            default:
                break;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        return cell;
        
    }//@section == 0
    
    if (section == 1) {
        
        
        static NSString *cellID = @"VideoCellID";
        HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        
        
        cell.textLabel.text = INTERSTR(@"Test FTP Settings");
        cell.textLabel.textColor = [UIColor blueColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;

        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        _ftpParam.u32Check = 1;
        
        [self.camera request:HI_P2P_SET_FTP_PARAM_EXT dson:[self.camera dic:_ftpParam]];
    }
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    switch (textField.tag) {
        case FTPTextFieldServer:
            _ftpParam.strSvr = text;
            break;
            
        case FTPTextFieldPort:
            _ftpParam.u32Port = text.intValue;
            break;
            
        case FTPTextFieldUsername:
            _ftpParam.strUsernm = text;
            break;
            
        case FTPTextFieldPassword:
            _ftpParam.strPasswd = text;
            break;
            
        case FTPTextFieldPath:
            _ftpParam.strFilePath = text;
            break;
            
            
        default:
            break;
    }
}





- (NSArray *)titles {
    if (!_titles) {
        _titles = @[INTERSTR(@"Server Addr."), INTERSTR(@"Server Port"),INTERSTR(@"User Name"),
                    INTERSTR(@"Password"), INTERSTR(@"Passive Mode"), INTERSTR(@"Path")];
    }
    return _titles;
}

- (UISwitch *)modeSwitch {
    if (!_modeSwitch) {
        _modeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_modeSwitch addTarget:self action:@selector(modeSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _modeSwitch;
}

- (void)modeSwitchAction:(id)sender {
    UISwitch *mswitch = (UISwitch *)sender;
    
    _ftpParam.u32Mode = mswitch.on ? 1 : 0;
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
