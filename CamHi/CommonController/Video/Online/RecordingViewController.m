//
//  RecordingViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/18.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "RecordingViewController.h"
#import "PlayBackViewController.h"
#import "SearchViewController.h"

@interface RecordingViewController ()

@property (nonatomic, strong) NSMutableArray *recordings;
@property (nonatomic, strong) ListReq *listReq;
@property (nonatomic, strong) NSDateFormatter *tFormatter;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
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


- (ListReq *)listReq {
    if (!_listReq) {
        _listReq = [[ListReq alloc] init];
    }
    return _listReq;
}




- (void)setup {
    
    [self.camera request:HI_P2P_PB_QUERY_START dson:[self.camera dic:self.listReq]];
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
      
        if (cmd == HI_P2P_PB_QUERY_START) {
            
            weakSelf.recordings = [weakSelf.camera object:dic];
            
            if (weakSelf.recordings.count == 0) {
                [HXProgress showText:INTERSTR(@"No Recording")];
            }
            else {
                [weakSelf.tableView reloadData];
            }
            
            
            LOG(@"weakSelf.recordings.count:%ld", weakSelf.recordings.count)
        }
    };
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnItemAction:)];
}


- (void)btnItemAction:(id)sender {
    
//    UIActionSheet *action = [[UIActionSheet alloc]
//                             initWithTitle:nil
//                             delegate:self
//                             cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
//                             destructiveButtonTitle:nil
//                             otherButtonTitles:NSLocalizedString(@"Within an hour", @""),
//                             NSLocalizedString(@"Within half a day", @""),
//                             NSLocalizedString(@"Within a day", @""),
//                             NSLocalizedString(@"Within a week", @""),
//                             NSLocalizedString(@"Custom", @""),
//                             nil];
//    
//    [action showInView:self.view];

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:INTERSTR(@"Dismiss") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionhour = [UIAlertAction actionWithTitle:INTERSTR(@"With in an hour") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.listReq.startTime = [[NSDate dateWithTimeIntervalSinceNow:- (60*60)] timeIntervalSince1970];
        self.listReq.stopTime = [[NSDate date] timeIntervalSince1970];
        self.listReq.isSerach = YES;
        [self.camera request:HI_P2P_PB_QUERY_START dson:[self.camera dic:self.listReq]];

    }];
    
    UIAlertAction *actionhalfDay = [UIAlertAction actionWithTitle:INTERSTR(@"With in a half day") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.listReq.startTime = [[NSDate dateWithTimeIntervalSinceNow:- (60*60*12)] timeIntervalSince1970];
        self.listReq.stopTime = [[NSDate date] timeIntervalSince1970];
        self.listReq.isSerach = YES;
        [self.camera request:HI_P2P_PB_QUERY_START dson:[self.camera dic:self.listReq]];

    }];
    
    UIAlertAction *actionday = [UIAlertAction actionWithTitle:INTERSTR(@"With in a day") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.listReq.startTime = [[NSDate dateWithTimeIntervalSinceNow:- (60*60*24)] timeIntervalSince1970];
        self.listReq.stopTime = [[NSDate date] timeIntervalSince1970];
        self.listReq.isSerach = YES;
        [self.camera request:HI_P2P_PB_QUERY_START dson:[self.camera dic:self.listReq]];

    }];
    
    UIAlertAction *actionweek = [UIAlertAction actionWithTitle:INTERSTR(@"With in a week") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.listReq.startTime = [[NSDate dateWithTimeIntervalSinceNow:- (60*60*24*7)] timeIntervalSince1970];
        self.listReq.stopTime = [[NSDate date] timeIntervalSince1970];
        self.listReq.isSerach = YES;
        [self.camera request:HI_P2P_PB_QUERY_START dson:[self.camera dic:self.listReq]];

    }];
    
    UIAlertAction *actioncustom = [UIAlertAction actionWithTitle:INTERSTR(@"Custom") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SearchViewController *search = [[SearchViewController alloc] init];
        search.searchBlock = ^(NSTimeInterval startTime, NSTimeInterval stopTime) {
          
            self.listReq.startTime = startTime;
            self.listReq.stopTime = stopTime;
            self.listReq.isSerach = YES;
            [self.camera request:HI_P2P_PB_QUERY_START dson:[self.camera dic:self.listReq]];
        };
        
        [self.navigationController pushViewController:search animated:YES];
    }];

    [alert addAction:actionCancel];
    [alert addAction:actionhour];
    [alert addAction:actionhalfDay];
    [alert addAction:actionday];
    [alert addAction:actionweek];
    [alert addAction:actioncustom];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
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
    
    VideoInfo *evt = _recordings[row];
    
    
//    cell.textLabel.text = mycam.name;
//    cell.detailTextLabel.text = mycam.uid;
    
    
    
//    if (evt.eventStatus == EVENT_UNREADED)
//        cell.textLabel.textColor = [UIColor blackColor];
//    else if (evt.eventStatus == EVENT_READED)
//        cell.textLabel.textColor = [UIColor grayColor];
//    else
//        cell.textLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.text = [VideoInfo getEventTypeName:evt.eventType];
    
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:evt.startTime];
    NSDate *date1 = [[NSDate alloc] initWithTimeIntervalSince1970:evt.endTime];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    NSString *detail = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:date], [dateFormatter stringFromDate:date1]];

    NSString *detail = [NSString stringWithFormat:@"%@ - %@", [self.tFormatter stringFromDate:date], [self.tFormatter stringFromDate:date1]];

    cell.detailTextLabel.text = detail;
    
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
    
    VideoInfo *evt = _recordings[indexPath.row];

    PlayBackViewController *playBack = [[PlayBackViewController alloc] init];
    playBack.camera = self.camera;
    playBack.video = evt;
    
    [self.navigationController pushViewController:playBack animated:YES];
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
