//
//  EmailViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/11.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "EmailViewController.h"
#import "VideoSetCell.h"
#import "SecureViewController.h"


typedef NS_ENUM(NSInteger, EmailTextField) {
    EmailTextFieldSMTPServer,
    EmailTextFieldPort,
    EmailTextFieldUsername,
    EmailTextFieldPassword,
    EmailTextFieldReceiver,
    EmailTextFieldSender,
    EmailTextFieldSubject
};



@interface EmailViewController ()

@property (nonatomic, strong) __block EmailParam *emailParam;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UITextView *emailText;
@property (nonatomic, strong) UIButton *btnTest;
@property (nonatomic, strong) UISwitch *autSwitch;

@end

@implementation EmailViewController

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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setup {
    
    
    [self.camera request:HI_P2P_GET_EMAIL_PARAM dson:nil];

    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (cmd == HI_P2P_GET_EMAIL_PARAM) {
            
            if (success) {
                
                weakSelf.emailParam = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
            }
            
        }//@HI_P2P_GET_SD_INFO
        
        if (cmd == HI_P2P_SET_EMAIL_PARAM) {
            if (success) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        
        if (cmd == HI_P2P_SET_EMAIL_PARAM_EXT) {
            
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
    
    [self.camera request:HI_P2P_SET_EMAIL_PARAM dson:[self.camera dic:_emailParam]];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.titles.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44 : 100;
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

        
        
        //cell.textLabel.text = self.titles[row];
        cell.labTitle.text = self.titles[row];
        cell.tfieldDetail.delegate = self;
        
        switch (row) {
            case 0:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"SMTP Server");
                cell.tfieldDetail.text = _emailParam.strSvr;
                cell.tfieldDetail.tag = EmailTextFieldSMTPServer;
                
                break;
            case 1:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Server Port");
                cell.tfieldDetail.text = [NSString stringWithFormat:@"%d", _emailParam.u32Port];
                cell.tfieldDetail.tag = EmailTextFieldPort;

                break;
            case 2:
                
                [cell.tfieldDetail removeFromSuperview];
                cell.detailTextLabel.text = [_emailParam connectionType];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                break;
            case 3:
                
                [cell.tfieldDetail removeFromSuperview];
                cell.accessoryView = self.autSwitch;
                self.autSwitch.on = _emailParam.u32LoginType == 1 ? YES : NO;
                
                break;
            case 4:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"User name");
                cell.tfieldDetail.text = _emailParam.strUsernm;
                cell.tfieldDetail.tag = EmailTextFieldUsername;

                break;
            case 5:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Password");
                cell.tfieldDetail.secureTextEntry = YES;
                cell.tfieldDetail.text = _emailParam.strPasswd;
                cell.tfieldDetail.tag = EmailTextFieldPassword;

                break;
            case 6:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Receiver");
                cell.tfieldDetail.text = _emailParam.strFrom;
                cell.tfieldDetail.tag = EmailTextFieldReceiver;

                break;
            case 7:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Sender");
                cell.tfieldDetail.text = _emailParam.strTo;
                cell.tfieldDetail.tag = EmailTextFieldSender;

                break;
                
            case 8:
                
                cell.tfieldDetail.placeholder = INTERSTR(@"Subject");
                cell.tfieldDetail.text = _emailParam.strSubject;
                cell.tfieldDetail.tag = EmailTextFieldSubject;
                
                break;
                
            default:
                break;
        }

        return cell;
        
    }//@section == 0

    if (section == 1) {
        
        
        static NSString *cellID = @"VideoCellID";
        HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }

        
        [cell.contentView addSubview:self.emailText];
        self.emailText.text = _emailParam.strText;
        self.emailText.delegate = self;
        
        
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.1 : 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? nil : [self setupHeaderView];
}

- (UIView *)setupHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 30)];
    labText.text = INTERSTR(@"Message");
    
    [headerView addSubview:labText];
    
    _btnTest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    _btnTest.center = CGPointMake(self.view.frame.size.width-30-20, 44/2);
    [_btnTest setTitle:INTERSTR(@"Test") forState:UIControlStateNormal];
    [_btnTest setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnTest addTarget:self action:@selector(btnTestAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnTest];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    __weak typeof(self) weakSelf = self;
    
    if (section == 0) {
        if (row == 2) {
            
            SecureViewController *secure = [[SecureViewController alloc] init];
            secure.type = _emailParam.u32Auth;
            secure.title = INTERSTR(@"Encrypt Type");
            secure.connectionTypeBlock = ^(BOOL success, NSInteger cmd, int type) {
                
                weakSelf.emailParam.u32Auth = type;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:secure animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger tag = textField.tag;
    
    if (tag > 2) {
        [self offViewWithHeight:(tag+2)*44+64];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    switch (textField.tag) {
        case EmailTextFieldSMTPServer:
            _emailParam.strSvr = text;
            break;
            
        case EmailTextFieldPort:
            _emailParam.u32Port = text.intValue;
            break;
            
        case EmailTextFieldUsername:
            _emailParam.strUsernm = text;
            break;
            
        case EmailTextFieldPassword:
            _emailParam.strPasswd = text;
            break;
            
        case EmailTextFieldReceiver:
            _emailParam.strTo = text;
            break;
            
        case EmailTextFieldSender:
            _emailParam.strFrom = text;
            break;
            
        case EmailTextFieldSubject:
            _emailParam.strSubject = text;
            break;

        default:
            break;
    }
    
    [self resetView];
}



#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGFloat h = self.view.frame.size.height;
    [self offViewWithHeight:h];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _emailParam.strText = textView.text;
    [self resetView];
}



- (UISwitch *)autSwitch {
    if (!_autSwitch) {
        _autSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_autSwitch addTarget:self action:@selector(autSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _autSwitch;
}


- (void)autSwitchAction:(id)sender {
    UISwitch *aswitch = (UISwitch *)sender;
    
    _emailParam.u32LoginType = aswitch.on ? 1 : 3;
}


- (UITextView *)emailText {
    if (!_emailText) {
        _emailText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        _emailText.font = [UIFont systemFontOfSize:14];
        
        
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        
        //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStylePlain target:self action:nil];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];

        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        doneButton.tintColor = [UIColor blackColor];
        
        
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        
        [topView setItems:buttonsArray];
        [_emailText setInputAccessoryView:topView];
        
    }
    return _emailText;
}


-(void)dismissKeyBoard {
    [_emailText resignFirstResponder];
}



- (NSArray *)titles {
    if (!_titles) {
        _titles = @[INTERSTR(@"SMTP Server"), INTERSTR(@"Server Port"), INTERSTR(@"Encrypt Type"),
                    INTERSTR(@"Authentication"), INTERSTR(@"User name"), INTERSTR(@"Password"),
                    INTERSTR(@"Send To"), INTERSTR(@"Sender"), INTERSTR(@"Subject")];
    }
    return _titles;
}


- (void)btnTestAction:(id)sender {
    [self.view endEditing:YES];
    
    [self.camera request:HI_P2P_SET_EMAIL_PARAM_EXT dson:[self.camera dic:_emailParam]];
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
