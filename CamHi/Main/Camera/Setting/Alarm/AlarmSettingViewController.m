//
//  AlarmSettingViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/28.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "AlarmSettingViewController.h"

@interface AlarmSettingViewController ()

@property (nonatomic, strong) UISwitch *tswitch;
@property (nonatomic, strong) UILabel *tlabel;
@property (nonatomic, strong) UISegmentedControl *tsegment;
@property (nonatomic, strong) __block MdParam *mdparam;

@end

@implementation AlarmSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    MdParam *tmdparam = [[MdParam alloc] init];
    [self.camera request:HI_P2P_GET_MD_PARAM dson:[self.camera dic:tmdparam]];
    
    __weak typeof(self) wself = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (cmd == HI_P2P_GET_MD_PARAM) {
            if (success) {
                
                wself.mdparam = [wself.camera object:dic];
                [wself.tableView reloadData];
            }
        }
    };
    
    
}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44.0f;
    }
    return 88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AlarmSettingCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger row = indexPath.row;
    
    
    if (row == 0) {
        //The motion detecting sensitivity
        cell.textLabel.text = NSLocalizedString(@"Motion Detection", nil);
        cell.accessoryView = self.tswitch;
        self.tswitch.on = _mdparam.u32Enable == 1 ? YES : NO;
    }
    
    if (row == 1) {
        
        [cell.contentView addSubview:self.tlabel];
        [cell.contentView addSubview:self.tsegment];
        
        self.tsegment.selectedSegmentIndex = [_mdparam sensi];
    }
    
    return cell;
}






#pragma mark - lazy load
- (UISwitch *)tswitch {
    if (!_tswitch) {
        _tswitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_tswitch addTarget:self action:@selector(tswitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tswitch;
}

- (UISegmentedControl *)tsegment {
    if (!_tsegment) {
        
        NSArray *items = @[NSLocalizedString(@"Low", nil),
                           NSLocalizedString(@"Medium", nil),
                           NSLocalizedString(@"High", nil)];
        _tsegment = [[UISegmentedControl alloc] initWithItems:items];
        _tsegment.frame = CGRectMake(0, 0, 200, 30);
        _tsegment.center = CGPointMake(self.view.frame.size.width/2, 66);
//        _tsegment.backgroundColor = [UIColor whiteColor];
        _tsegment.tintColor = [UIColor grayColor];
        [_tsegment addTarget:self action:@selector(tsegmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tsegment;
}

- (UILabel *)tlabel {
    if (!_tlabel) {
        _tlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, self.view.frame.size.width-30, 30)];
        _tlabel.text = NSLocalizedString(@"Level", nil);
        _tlabel.font = [UIFont systemFontOfSize:14];
    }
    return _tlabel;
}

- (void)tswitchAction:(id)sender {
    
    UISwitch *twitch = (UISwitch *)sender;
    
    _mdparam.u32Enable = twitch.on ? 1 : 0;
    
    [self.camera request:HI_P2P_SET_MD_PARAM dson:[self.camera dic:_mdparam]];
}

- (void)tsegmentAction:(id)sender {
    
    UISegmentedControl *tseg = (UISegmentedControl *)sender;
    
    NSInteger index = tseg.selectedSegmentIndex;
    
    if (index == 0) {
        _mdparam.u32Sensi = 25;
    }
    
    if (index == 1) {
        _mdparam.u32Sensi = 50;
    }
    
    if (index == 2) {
        _mdparam.u32Sensi = 75;
    }
    
    [self.camera request:HI_P2P_SET_MD_PARAM dson:[self.camera dic:_mdparam]];

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
