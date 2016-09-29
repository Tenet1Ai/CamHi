//
//  LocalRecordingViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/18.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "LocalRecordingViewController.h"
#import "HXAVPlayerViewController.h"
#import "LocalVideoInfo.h"

@interface LocalRecordingViewController ()

@property (nonatomic, strong) NSMutableArray *recordings;
@property (nonatomic, strong) NSDateFormatter *tFormatter;
@property (nonatomic, strong) UISegmentedControl *tsegmented;

@end

@implementation LocalRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    [self setupRecordingsWithType:0];
    
    [self.view addSubview:self.tableView];

    
    if ([DisplayName isEqualToString:@"CamHiGH"]) {
        self.navigationItem.titleView = self.tsegmented;
    }
    else {
        self.navigationItem.title = INTERSTR(@"Record");
    }
    

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


#pragma mark - 
- (UISegmentedControl *)tsegmented {
    if (!_tsegmented) {
        
        NSArray *segTitles = @[INTERSTR(@"Record"), INTERSTR(@"Download")];
        
        _tsegmented = [[UISegmentedControl alloc] initWithItems:segTitles];
        _tsegmented.frame = CGRectMake(0, 0, 120, 30);
        _tsegmented.selectedSegmentIndex = 0;
        [_tsegmented addTarget:self action:@selector(tsegmentedAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tsegmented;
}

- (void)tsegmentedAction:(id)sender {
    
    UISegmentedControl *ts = (UISegmentedControl *)sender;
    
    [self setupRecordingsWithType:ts.selectedSegmentIndex];
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}



- (void)setupRecordingsWithType:(NSInteger)type {
    NSMutableArray *localVideoInfos = [GBase recordingsForCamera:self.camera];
    
    [self.recordings removeAllObjects];
    for (LocalVideoInfo *vinfo in localVideoInfos) {
        
        if (vinfo.type == type) {
            [self.recordings addObject:vinfo];
        }
    }
}

- (NSMutableArray *)recordings {
    if (!_recordings) {
        _recordings = [[NSMutableArray alloc] initWithCapacity:0];
    }
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
        [self.recordings removeObject:vi];
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
