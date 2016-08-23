//
//  SearchViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/19.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    CGFloat w;
    
}
@property (nonatomic, strong) UILabel *labFrom;
@property (nonatomic, strong) UILabel *labTo;
@property (nonatomic, strong) UIDatePicker *pickerFrom;
@property (nonatomic, strong) UIDatePicker *pickerTo;

@property NSTimeInterval startTime;
@property NSTimeInterval stopTime;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = INTERSTR(@"Search Video");
    w = self.view.frame.size.width;
    
    [self.view addSubview:self.labFrom];
    [self.view addSubview:self.labTo];
    [self.view addSubview:self.pickerFrom];
    [self.view addSubview:self.pickerTo];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:INTERSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(btnItemAction:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)btnItemAction:(id)sender {
    
    if (_searchBlock) {
        _searchBlock(_startTime, _stopTime);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UILabel *)labFrom {
    if (!_labFrom) {
        
        CGFloat h = 30.0f;
        _labFrom = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, w, h)];
        _labFrom.text = INTERSTR(@"From");
        _labFrom.textAlignment = NSTextAlignmentCenter;
    }
    return _labFrom;
}

- (UILabel *)labTo {
    if (!_labTo) {
        
        CGFloat h = 30.0f;
        CGFloat y = self.view.frame.size.height/2;
        _labTo = [[UILabel alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _labTo.text = INTERSTR(@"To");
        _labTo.textAlignment = NSTextAlignmentCenter;
    }
    return _labTo;
}


- (UIDatePicker *)pickerFrom {
    if (!_pickerFrom) {
        
        CGFloat y = CGRectGetMaxY(self.labFrom.frame);
        CGFloat h = 200;
        
        _pickerFrom = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _pickerFrom.tag = 1;
        [_pickerFrom addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _pickerFrom;
}


- (UIDatePicker *)pickerTo {
    if (!_pickerTo) {
        
        CGFloat y = CGRectGetMaxY(self.labTo.frame);
        CGFloat h = 200;
        
        _pickerTo = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _pickerTo.tag = 2;
        [_pickerTo addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _pickerTo;
}


- (void)dateChanged:(id)sender {
 
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    NSLog(@"picker.date:%@", picker.date);
    
    if (picker.tag == 1) {
        
        _startTime = [picker.date timeIntervalSince1970];
    }
    
    
    if (picker.tag == 2) {
        _stopTime = [picker.date timeIntervalSince1970];
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
