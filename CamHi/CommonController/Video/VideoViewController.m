//
//  VideoViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "VideoViewController.h"
#import "RecordingViewController.h"
#import "LocalRecordingViewController.h"

@interface VideoViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.title = nil;
    self.navigationItem.titleView = self.segmentedControl;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UISegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 120.0f, 30.0f) ];
        [_segmentedControl insertSegmentWithTitle:NSLocalizedString(@"local", @"") atIndex:0 animated:YES];
        [_segmentedControl insertSegmentWithTitle:NSLocalizedString(@"online", @"") atIndex:1 animated:YES];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.multipleTouchEnabled = NO;
        [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)segmentedControlAction:(id)sender {
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GBase sharedBase].cameras.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"PictureCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];
    
    NSInteger picCount = [GBase recordingsForCamera:mycam].count;
    
    cell.textLabel.text = mycam.name;
    
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%ld)", mycam.uid, picCount];
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%ld)", mycam.uid, mycam.onlineRecordings.count];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", mycam.uid];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        NSInteger picCount = [GBase recordingsForCamera:mycam].count;
        
        if (picCount == 0) {
            [HXProgress showText:INTERSTR(@"No Recording")];
            return;
        }
        
        
        LocalRecordingViewController *localRecording = [[LocalRecordingViewController alloc] init];
        localRecording.camera = mycam;
        localRecording.title = INTERSTR(@"Video List");
        [self .navigationController pushViewController:localRecording animated:YES];

    }
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        
//        if (mycam.onlineRecordings == 0) {
//            [HXProgress showText:INTERSTR(@"No Recording")];
//            return;
//        }
        
        if (!mycam.online) {
            [HXProgress showText:INTERSTR(@"Offline")];
            return;
        }
        
        RecordingViewController *recording = [[RecordingViewController alloc] init];
        recording.camera = mycam;
        recording.title = INTERSTR(@"Video List");
        [self.navigationController pushViewController:recording animated:YES];
    }
}


//- (NSInteger)recordings:(Camera *)mycam {
//    
//    [mycam request:HI_P2P_PB_QUERY_START dson:nil];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    mycam.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
//        
//        if (cmd == HI_P2P_PB_QUERY_START) {
//            
//            NSMutableArray *recordings = [weakSelf.camera object:dic];
//            
//            return recordings.count;
////            if (weakSelf.recordings.count == 0) {
////                [HXProgress showText:INTERSTR(@"No Recording")];
////            }
////            else {
////                [weakSelf.tableView reloadData];
////            }
////            
////            
////            LOG(@"weakSelf.recordings.count:%ld", weakSelf.recordings.count)
//        }
//    };
//    
//    return 0;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
