//
//  EditCameraViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/28.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "EditCameraViewController.h"
#import "EditCameraCell.h"

@interface EditCameraViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation EditCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titles = @[NSLocalizedString(@"Name", nil),
                NSLocalizedString(@"User Name", nil),
                NSLocalizedString(@"UID", nil),
                NSLocalizedString(@"Password", nil)];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rbarBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(rbarBtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbarBtnItem;

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
    
    NSInteger row = indexPath.row;
    
    static NSString *cellID = @"EditPasswordCellID";
    VideoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[VideoSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    
    cell.labTitle.text = [_titles objectAtIndex:indexPath.row];
    cell.tfieldDetail.tag = row;
    cell.tfieldDetail.delegate = self;
    
    if (row == 0) {
        cell.tfieldDetail.text = self.camera.name;
    }
    
    if (row == 1) {
        cell.tfieldDetail.text = self.camera.username;
    }

    
    if (row == 2) {
        cell.tfieldDetail.text = self.camera.uid;
    }

    
    if (row == 3) {
        cell.tfieldDetail.secureTextEntry = YES;
        cell.tfieldDetail.text = self.camera.password;
    }

    
    return cell;
}


- (void)rbarBtnItemAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.camera.name.length == 0) {
        [HXProgress showText:NSLocalizedString(@"Camera name can't be empty!", nil)];
        return;
    }
    
    if (self.camera.username.length == 0) {
        [HXProgress showText:NSLocalizedString(@"Camera username can't be empty!", nil)];
        return;
    }
    
    [HXProgress showProgress];
    [self.camera disconnect];
    [GBase editCamera:self.camera];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.camera connect];
        [HXProgress dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 0) {
        self.camera.name = textField.text;
    }
    
    if (textField.tag == 1) {
        self.camera.username = textField.text;
    }

    if (textField.tag == 2) {
        self.camera.uid = textField.text;
    }

    if (textField.tag == 3) {
        self.camera.password = textField.text;
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
