//
//  EditPasswordViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/25.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "EditPasswordCell.h"
#import "hi_base64.h"

@interface EditPasswordViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *placeholders;

@property (nonatomic, copy) NSString *opwd;
@property (nonatomic, copy) NSString *npwd;
@property (nonatomic, copy) NSString *cpwd;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titles = @[NSLocalizedString(@"Old Password", nil),
                NSLocalizedString(@"New Password", nil),
                NSLocalizedString(@"Confirm Password", nil)];
    
    _placeholders = @[NSLocalizedString(@"Old Password", nil),
                NSLocalizedString(@"New Password", nil),
                NSLocalizedString(@"Confirm Password", nil)];

    [self.camera registerIOSessionDelegate:self];
    
    [self.view addSubview:self.tableView];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *rbarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(rbarBtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbarBtnItem;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.camera unregisterIOSessionDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"EditPasswordCellID";
    EditPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[EditPasswordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tlabelTitle.text = [_titles objectAtIndex:indexPath.row];
    cell.tfieldPassword.placeholder = [_placeholders objectAtIndex:indexPath.row];
    cell.tfieldPassword.tag = indexPath.row;
    cell.tfieldPassword.delegate = self;

    return cell;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 0) {
        _opwd = textField.text;
    }
    
    if (textField.tag == 1) {
        _npwd = textField.text;
    }

    if (textField.tag == 2) {
        _cpwd = textField.text;
    }
}


- (void)rbarBtnItemAction:(id)sender {
 
    [self.view endEditing:YES];
    
    LOG(@"_opwd:%@  _npwd:%@    _cpwd:%@", _opwd, _npwd, _cpwd)

    /*
     * instruction
     * 密码不能为nil，但用户不输入时，默认为@""
     * 下发指令设置密码时，需传入@" " (空格)
     */
    
    // 未输入时
    if (!_opwd) {
        _opwd = @"";
    }
    
    if (![_opwd isEqualToString:self.camera.password]) {
        [HXProgress showText:NSLocalizedString(@"Old password incorrect", nil)];
        return;
    }
    
    // 允许密码为空 
    if (_npwd == nil || _npwd.length == 0) {
        _npwd = @" ";
    }
    
    if (_cpwd == nil || _cpwd.length == 0) {
        _cpwd = @" ";
    }

    
    if (![_npwd isEqualToString:_cpwd]) {
        [HXProgress showText:NSLocalizedString(@"New password and confirm password do not match", nil)];
        return;
    }
    
    
    
    [HXProgress showProgress];
    [self setUpCamera:self.camera WithNewUserName:self.camera.username NewPassword:_npwd];
    
}


- (void)receiveIOCtrl:(HiCamera *)camera Type:(int)type Data:(char *)data Size:(int)size Status:(int)status {
 
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 修改用户名与密码
        if (type == HI_P2P_SET_USERNAME) {
            LOG(@">>>修改密码 {%@, %d, %d}", camera.uid, type, size)
            
            if (size >= 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HXProgress dismiss];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else {
                [HXProgress showText:NSLocalizedString(@"Save Failed", nil)];
            }
        }
        
        // 只能修改密码
        if (type == HI_P2P_SET_USER_PARAM) {
            LOG(@">>>修改密码 {%@, %d, %d}", camera.uid, type, size)
            
            if (size >= 0) {
                
                //self.camera.password = _npwd;
                self.camera.password = [self isEmpty:_npwd] ? @"" : _npwd;
                
                
                [GBase editCamera:self.camera];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HXProgress dismiss];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else {
                [HXProgress showText:NSLocalizedString(@"Save Failed", nil)];
            }
        }

    });//@dispatch_async
}


//修改用户名和密码
- (void)setUpCamera:(Camera *)myCamera WithNewUserName:(NSString *)newUserName NewPassword:(NSString *)newPassword {
    
    NSLog(@"%@ setUpCamera:%@ newUserName:%@   newPassword:%@", self.title, myCamera.uid, newUserName, newPassword);
    
    HI_P2P_SET_AUTH *auth = (HI_P2P_SET_AUTH*)malloc(sizeof(HI_P2P_SET_AUTH));
    memset(auth, 0, sizeof(HI_P2P_SET_AUTH));
    
    auth->sOldUser.u32UserLevel = 0;
    base64Encode((char *)[myCamera.username UTF8String],(char *)auth->sOldUser.u8UserName);
    base64Encode((char *)[myCamera.password UTF8String],(char *)auth->sOldUser.u8Password);
    
    
    auth->sNewUser.u32UserLevel = 0;
    base64Encode((char *)[newUserName UTF8String],(char *)auth->sNewUser.u8UserName);
    base64Encode((char *)[newPassword UTF8String],(char *)auth->sNewUser.u8Password);
    
    /*
     *  HI_P2P_SET_USERNAME     可以修改用户名与密码  （暂时失效）
     *  HI_P2P_SET_USER_PARAM   修改密码
     */
//    [myCamera sendIOCtrl:HI_P2P_SET_USERNAME Data:(char *)auth Size:sizeof(HI_P2P_SET_AUTH)];
    [myCamera sendIOCtrl:HI_P2P_SET_USER_PARAM Data:(char*)auth Size:sizeof(HI_P2P_SET_AUTH)];

    
    free(auth);
}


- (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return YES;
    }
    
    // 用于过滤空格和Tab换行符
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    // 去除空格与换行符
    NSString *retStr = [str stringByTrimmingCharactersInSet:characterSet];
    
    return retStr.length == 0 ? YES : NO ;
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
