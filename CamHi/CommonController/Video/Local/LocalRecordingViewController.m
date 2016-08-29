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

- (NSMutableArray *)recordings {
    _recordings = [GBase recordingsForCamera:self.camera];
    return _recordings;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *cellID = @"PictureCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    LocalVideoInfo* vi = self.recordings[row];
    
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalVideoInfo* vi = self.recordings[indexPath.row];

    HXAVPlayerViewController *avPlayer = [[HXAVPlayerViewController alloc] init];
    avPlayer.camera = self.camera;
    avPlayer.model = vi;
    [self.navigationController pushViewController:avPlayer animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        LocalVideoInfo* vi = self.recordings[indexPath.row];
        [GBase deleteRecording:vi.path camera:self.camera];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark - NSDateFormatter
- (NSDateFormatter *)tFormatter {
    if (!_tFormatter) {
        _tFormatter = [[NSDateFormatter alloc] init];
        _tFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _tFormatter;
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
