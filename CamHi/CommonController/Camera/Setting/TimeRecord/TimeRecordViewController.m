//
//  TimeRecordViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/4.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "TimeRecordViewController.h"

@interface TimeRecordViewController ()

@property (nonatomic, strong) UITextField *tfieldDuration;
@property (nonatomic, strong) UISwitch *tswitch;
@property (nonatomic, strong) UISegmentedControl *tsegment;
@property (nonatomic, strong) UILabel *labRedTime;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) __block RecAutoParam *recAutoParam;
@property (nonatomic, strong) __block QuantumTime *quantumTime;
@end

@implementation TimeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rbtnItem = [[UIBarButtonItem alloc] initWithTitle:INTERSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(rbtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbtnItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    [self.camera request:HI_P2P_GET_REC_AUTO_PARAM dson:nil];
    [self.camera request:HI_P2P_GET_REC_AUTO_SCHEDULE dson:nil];

    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (success) {
            
            if (cmd == HI_P2P_GET_REC_AUTO_PARAM) {
                
                weakSelf.recAutoParam = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
                
                LOG(@"dics:%@", dic);
            }
            
            if (cmd == HI_P2P_GET_REC_AUTO_SCHEDULE) {
                weakSelf.quantumTime = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
            }
            
        }
        else {
            [HXProgress showText:NSLocalizedString(@"Command Error!", nil)];
        }
    };

}

- (void)rbtnItemAction:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *seconds = self.tfieldDuration.text;
    
    if (![self isPureInt:seconds]) {
        [HXProgress showText:INTERSTR(@"Please input number!")];
        [self.tfieldDuration becomeFirstResponder];
        return;
    }
    
    int len = seconds.intValue;
    
    if ([self.camera isGoke]) {
        if (len < 15 || len > 600) {
            [HXProgress showText:INTERSTR(@"Duration must between 15 to 600")];
            return;
        }
    }
    else {
        if (len < 15 || len > 900) {
            [HXProgress showText:INTERSTR(@"Duration must between 15 to 900")];
            return;
        }
    }
    
    _recAutoParam.u32FileLen = len;
    
    if (_recAutoParam) {
        NSDictionary *dic = @{@"model": _recAutoParam};
        [self.camera request:HI_P2P_SET_REC_AUTO_PARAM dson:dic];
    }
 }

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TimeRecordCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = [self.titles objectAtIndex:row];
    
    if (row == 0) {
        
        [cell.contentView addSubview:self.tfieldDuration];
        self.tfieldDuration.placeholder = ![self.camera isGoke] ? INTERSTR(@"15 - 900 s") : INTERSTR(@"15 - 600 s");
        self.tfieldDuration.text = [NSString stringWithFormat:@"%d", _recAutoParam.u32FileLen];
    }
    
    if (row == 1) {
        
        cell.accessoryView = self.tswitch;
        self.tswitch.on = _recAutoParam.u32Enable == 1 ? YES : NO;
    }
    
    if (row == 2) {
        [cell.contentView addSubview:self.tsegment];
        self.tsegment.selectedSegmentIndex = _quantumTime.recordTime == 0 ? 0 : 1;
        
        [cell.contentView addSubview:self.labRedTime];
        self.labRedTime.text = cell.textLabel.text;
        cell.textLabel.text = nil;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.titles.count-1 ? 88.0f : 44.0f;
}


#pragma mark - UITextFieldDelegate
- (UITextField *)tfieldDuration {
    if (!_tfieldDuration) {
        
        CGFloat w = 90.0f;
        CGFloat h = 30.0f;
        CGFloat x = self.view.frame.size.width-w/2-20;
        CGFloat y = 44/2;
        _tfieldDuration = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _tfieldDuration.center = CGPointMake(x, y);
        _tfieldDuration.textAlignment = NSTextAlignmentRight;
        _tfieldDuration.delegate = self;
        _tfieldDuration.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tfieldDuration.clearsOnBeginEditing = YES;
        _tfieldDuration.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfieldDuration.background = [UIImage imageWithColor:RGBA_COLOR(220, 220, 220, 0.5) wihtSize:CGSizeMake(w, h)];
        _tfieldDuration.adjustsFontSizeToFitWidth = YES;
    }
    return _tfieldDuration;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (UISwitch *)tswitch {
    if (!_tswitch) {
        _tswitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [_tswitch addTarget:self action:@selector(tswitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tswitch;
}

- (void)tswitchAction:(id)sender {
    UISwitch *t_switch = (UISwitch *)sender;
    
    _recAutoParam.u32Enable = t_switch.on ? 1 : 0;
    
    if (_recAutoParam) {
        NSDictionary *dic = @{@"model": _recAutoParam};
        [self.camera request:HI_P2P_SET_REC_AUTO_PARAM dson:dic];
    }
    
}


- (UILabel *)labRedTime {
    if (!_labRedTime) {
        
        CGFloat tx = 15.0f;
        CGFloat tw = [UIScreen mainScreen].bounds.size.width-2*tx;
        CGFloat th = 44.0f;
        
        _labRedTime = [[UILabel alloc] initWithFrame:CGRectMake(tx, 0, tw, th)];
        _labRedTime.font = [UIFont systemFontOfSize:14];
        _labRedTime.adjustsFontSizeToFitWidth = YES;
    }
    return _labRedTime;
}

- (UISegmentedControl *)tsegment {
    if (!_tsegment) {
        
        NSArray *items = @[INTERSTR(@"None"), INTERSTR(@"All Day")];
        
        CGFloat w = 220.0f;
        CGFloat h = 30.0f;
        CGFloat x = self.view.frame.size.width/2;
        CGFloat y = 44+44/2;
        _tsegment = [[UISegmentedControl alloc] initWithItems:items];
        _tsegment.frame = CGRectMake(0, 0, w, h);
        _tsegment.center = CGPointMake(x, y);
        _tsegment.tintColor = [UIColor grayColor];
        [_tsegment addTarget:self action:@selector(tsegmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tsegment;
}


- (void)tsegmentAction:(id)sender {
    
    UISegmentedControl *tseg = (UISegmentedControl *)sender;
    
    NSInteger index = tseg.selectedSegmentIndex;
    
    _quantumTime.recordTime = (unsigned int)index;
    
    if (_quantumTime) {
        NSDictionary *dic = @{@"model": _quantumTime};
        [self.camera request:HI_P2P_SET_REC_AUTO_SCHEDULE dson:dic];
    }
    
 }

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[INTERSTR(@"Duration"), INTERSTR(@"Enable Record"), INTERSTR(@"Record Timer")];
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
