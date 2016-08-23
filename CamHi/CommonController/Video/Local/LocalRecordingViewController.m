//
//  LocalRecordingViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/18.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "LocalRecordingViewController.h"
#import "HXAVPlayerViewController.h"

@interface LocalRecordingViewController ()

@property (nonatomic, strong) NSMutableArray *recordings;
@property (nonatomic, strong) NSDateFormatter *tFormatter;

@end

@implementation LocalRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _recordings = [GBase recordingsForCamera:self.camera];
    
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *cellID = @"PictureCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    LocalVideoInfo* vi = [_recordings objectAtIndex:row];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:vi.time];
    //    NSDate *date1 = [[NSDate alloc] initWithTimeIntervalSince1970:evt.endTime];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    
    //    NSString *detail = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:date], [dateFormatter stringFromDate:date1]];
    
    cell.detailTextLabel.text = [self.tFormatter stringFromDate:date];
    
    cell.textLabel.text = self.camera.uid;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSDateFormatter *)tFormatter {
    if (!_tFormatter) {
        _tFormatter = [[NSDateFormatter alloc] init];
        _tFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _tFormatter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalVideoInfo* vi = [_recordings objectAtIndex:indexPath.row];

    HXAVPlayerViewController *avPlayer = [[HXAVPlayerViewController alloc] init];
    avPlayer.camera = self.camera;
    avPlayer.model = vi;
    [self.navigationController pushViewController:avPlayer animated:YES];
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
