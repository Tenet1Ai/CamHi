//
//  CameraViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraCell.h"
#import "AddCameraViewController.h"
#import "EditCameraViewController.h"
#import "LiveViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"


@interface CameraViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isEdit;
    UIBarButtonItem *btnItem;
}


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItem];
    [self.view addSubview:self.tableView];
    
    [self setup];

    [self setupNotifications];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    for (Camera *mycam in [GBase sharedBase].cameras) {
//        [mycam registerIOSessionDelegate:self];
//        mycam.delegate = self;
//        
//        LOG(@">>>> mycam:%@", mycam);
//    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    
    __weak typeof(self) weakSelf = self;
    
    
    for (Camera *mycam in [GBase sharedBase].cameras) {
        
        
        //发送命令
        mycam.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
            
            
            //缩略图加载完毕，刷新显示
            if (cmd == HI_P2P_GET_SNAP) {
                [weakSelf.tableView reloadData];
            }
        };
        
        //连接状态
        mycam.connectBlock = ^(NSInteger state, NSString *connection) {
            
            
            //连接完成，刷新显示
//            if (state == CAMERA_CONNECTION_STATE_LOGIN) {
//                [weakSelf.tableView reloadData];
//            }
            
            //刷新显示连接状态
            [weakSelf.tableView reloadData];
        };
        
        
        //报警状态
        mycam.alarmBlock = ^(BOOL isAlarm, NSInteger type) {
          
            //触发报警时，刷新显示
            if (isAlarm) {
                [weakSelf.tableView reloadData];
            }
        };
        
    }

}//@setup



#pragma mark - app进入后台与前台通知
- (void)setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:DidBecomeActive object:nil];
}

- (void)didReceiveNotification:(NSNotification *)notificaiton {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - setupNavigationItem
- (void)setupNavigationItem {
    
    isEdit = NO;

    btnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleDone target:self action:@selector(btnRightAction:)];
    
    self.navigationItem.rightBarButtonItem = btnItem;

    /*
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 80)];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRight setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [btnRight setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateSelected];
    [btnRight setTitleColor:RGBA_COLOR(0, 125, 255, 1) forState:UIControlStateNormal];
    [btnRight setTitleColor:RGBA_COLOR(0, 125, 255, 1) forState:UIControlStateSelected];
    [btnRight addTarget:self action:@selector(btnRightAction:) forControlEvents:UIControlEventTouchUpInside];
    */    
}

- (void)btnRightAction:(id)sender {
    
    isEdit = !isEdit;

    btnItem.title = isEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
    
    [self.tableView reloadData];

    /*
    UIBarButtonItem *btnItemDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(btnRightAction:)];
    UIBarButtonItem *btnItemEdit = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleDone target:self action:@selector(btnRightAction:)];
    
    self.navigationItem.rightBarButtonItem = isEdit ? btnItemDone : btnItemEdit;
    

    dispatch_async(dispatch_get_main_queue(), ^{
    });
     */
    
    /*
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    HiGLMonitor *monitor3 = [[HiGLMonitor alloc]initWithFrame:CGRectMake(0, 200, 300, 200)];
    //    monitor3.backgroundColor = [UIColor redColor];
    [self.view addSubview:monitor3];
    [_camera startLiveShow:0 Monitor:monitor3];
     */

}

#pragma mark - UITableViewDelegate
//- (UITableView *)tableView {
//    if (!_tableView) {
//        
//        CGFloat x = 0;
//        CGFloat y = 0;
//        CGFloat w = self.view.frame.size.width;
//        CGFloat h = self.view.frame.size.height;
//        
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.tableFooterView = [[UITableView alloc] init];
//    }
//    return _tableView;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GBase sharedBase].cameras.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEdit) {
        return 44.0f;
    }
    return CELLH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];

    if (isEdit) {
        static NSString *cellID = @"EditCameraCellID";
        HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        
        cell.textLabel.text = mycam.uid;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }//@isEdit
    
    
    if (!isEdit) {
        static NSString *cellID = @"CameraCellID";
        CameraCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CameraCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        cell.snapImgView.image = [mycam image];
        cell.labName.text = mycam.name;
        cell.labState.text = mycam.state;
        cell.labUid.text = mycam.uid;
        cell.alarmImgView.hidden = !mycam.isAlarm;
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        return cell;

    }//@!isEdit
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (isEdit) {
        return 0.1f;
    }
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (isEdit) {
        return nil;
    }
    return [self setupHeaderView];
}

- (UIView *)setupHeaderView {
    
    if (!self.headerView) {
        
        CGFloat w = self.view.frame.size.width;
        CGFloat h = 50.0f;
        
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        
        UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        
        [btnAdd setTitle:NSLocalizedString(@"Add Camera", nil) forState:UIControlStateNormal];
        [btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAdd setBackgroundImage:[UIImage imageWithColor:RGBA_COLOR(240, 240, 240, 1) wihtSize:CGSizeMake(w, h)] forState:UIControlStateNormal];
        [btnAdd setBackgroundImage:[UIImage imageWithColor:RGBA_COLOR(220, 220, 220, 1) wihtSize:CGSizeMake(w, h)] forState:UIControlStateSelected];
        [btnAdd addTarget:self action:@selector(btnAddAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerView addSubview:btnAdd];
    }
    return self.headerView;
}


- (void)btnAddAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    AddCameraViewController *addCamera = [[AddCameraViewController alloc] init];
    [self.navigationController pushViewController:addCamera animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.selected = !btn.selected;
    });
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
     
        Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];

        [GBase deleteCamera:mycam];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];

    if (isEdit) {
        EditCameraViewController *editCamera = [[EditCameraViewController alloc] init];
        editCamera.camera = mycam;
        [self.navigationController pushViewController:editCamera animated:YES];
        return;
    }
    
    if (!mycam.online) {
        [HXProgress showText:NSLocalizedString(@"Offline", nil)];
        [mycam connect];
        return;
    }

    
    SettingViewController *setting = [[SettingViewController alloc] init];
    setting.camera = mycam;
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];

    if (isEdit) {
        EditCameraViewController *editCamera = [[EditCameraViewController alloc] init];
        editCamera.camera = mycam;
        [self.navigationController pushViewController:editCamera animated:YES];
        return;
    }
    
    if (!mycam.online) {
        [HXProgress showText:NSLocalizedString(@"Offline", nil)];
        [mycam connect];
        return;
    }
    
    //进入实时画面后隐藏掉报警提示
    mycam.isAlarm = NO;
    
    LiveViewController *liveView = [[LiveViewController alloc] init];
    liveView.camera = mycam;
    liveView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liveView animated:YES];
}




#pragma mark - CameraIOSessionProtocol
//- (void)receiveIOCtrl:(HiCamera *)cam Type:(int)type Data:(char*)data Size:(int)size Status:(int)status {
//}
//
//- (void)receiveSessionState:(HiCamera *)cam Status:(int)status {
//    
//    if (status == CAMERA_CONNECTION_STATE_CONNECTING) {
////        return;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//    
//}
//
//- (void)receivePlayState:(HiCamera *)cam State:(int)state Width:(int)width Height:(int)height {
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
