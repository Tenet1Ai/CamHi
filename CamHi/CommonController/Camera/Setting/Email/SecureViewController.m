//
//  SecureViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/12.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SecureViewController.h"

@interface SecureViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation SecureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    //NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = self.titles[row];
    
    if (_type == row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    if (_connectionTypeBlock) {
        _connectionTypeBlock(YES, 0, (int)indexPath.row);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"None", @"SSL", @"TLS", @"STARTTLS"];
    }
    return _titles;
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
