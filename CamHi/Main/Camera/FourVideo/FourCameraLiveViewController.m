//
//  FourCameraLiveViewController.m
//  CamHi
//
//  Created by HXjiang on 16/9/7.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "FourCameraLiveViewController.h"
#import "CameraLiveView.h"
#import "FourCameraViewController.h"
#import "LiveViewController.h"
#import "ToolBar.h"
#import "Masonry.h"


#pragma mark - EditModel

@interface EditModel : NSObject

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *imgSelName;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) SEL selectorSel;

@end

@implementation EditModel

+ (instancetype)modelWithName:(NSString *)imgName selector:(SEL)selector {
    EditModel *editM = [[EditModel alloc] init];
    editM.imgName = imgName;
    editM.selector = selector;
    return editM;
}

+ (instancetype)modelWithName:(NSString *)imgName selector:(SEL)selector selectImageName:(NSString *)imgSelName selectorSel:(SEL) selectorSel {
    EditModel *editM = [[EditModel alloc] init];
    editM.imgName = imgName;
    editM.selector = selector;
    editM.imgSelName = imgSelName;
    editM.selectorSel = selectorSel;
    return editM;
}

@end




@interface FourCameraLiveViewController ()
<ToolBarDelegate>
@property (nonatomic, strong) NSMutableArray *liveViews;
@property (nonatomic, strong) NSMutableArray *selCameras;
@property (nonatomic, strong) ToolBar *editBar;
@property (nonatomic, strong) NSArray *editModels;
@property (nonatomic, strong) UIView *viewbg;
@property (nonatomic, assign) NSInteger ctag;
@property (nonatomic, strong) UIButton *btnMicrophone;
@property (nonatomic, strong) CameraLiveView *g_liveView;

@end

@implementation FourCameraLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = INTERSTR(@"Scenes");
    [self setupMonitors];
    [self setupLiveViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self setupLiveViews];
    
    
//    for (CameraLiveView *t_live in self.liveViews) {
//        
//        if (t_live.camera.select) {
//            [t_live.camera startLiveShow:1 Monitor:t_live.monitor];
//        }
//        
//    }// @for

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (Camera *t_cam in [GBase sharedBase].cameras) {
        [t_cam stopLiveShow];
    }
    
//    for (CameraLiveView *t_live in self.liveViews) {
//        [t_live.camera stopLiveShow];
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didReceiveNotification:(NSNotification *)notification {
    
    NSLog(@"FourCamera_didReceiveNotification : %@", notification.name);
    
    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        [self setupLiveViews];
        
    }// @UIApplicationDidBecomeActiveNotification
    
    
    if ([notification.name isEqualToString:UIApplicationWillResignActiveNotification]) {
        for (Camera *mycam in [GBase sharedBase].cameras) {
            
            if (mycam.select) {
                [mycam stopLiveShow];
            }
        }
        
    }// @UIApplicationWillResignActiveNotification
}

- (void)setupLiveViews {
    
//    for (CameraLiveView *t_live in self.liveViews) {
//        t_live.labName.text = nil;
//        t_live.camera = nil;
//        t_live.isAddCamera = NO;
//    }
    
    for (int i = 0; i < self.selCameras.count; i++) {
        
        Camera *mycam = self.selCameras[i];
        CameraLiveView *liveView = self.liveViews[i];
        liveView.camera = mycam;
        
        LOG(@"FourCamera_startLiveShow : %@", mycam.uid)
        LOG(@"FourCamera_liveView_monitor : %@", liveView.monitor)

        [mycam startLiveShow:1 Monitor:liveView.monitor];
        liveView.labName.text = [NSString stringWithFormat:@"%@(%@)", mycam.name, mycam.uid];
        liveView.isAddCamera = YES;
    }
}

- (NSMutableArray *)selCameras {
    if (!_selCameras) {
        _selCameras = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (Camera *mycam in [GBase sharedBase].cameras) {
            
            if (mycam.select) {
                [_selCameras addObject:mycam];
            }
        }
        
    }
    return _selCameras;
}



- (void)setupMonitors {
    
    NSInteger cameras = 4;//self.selCameras.count;
    
    [self.liveViews removeAllObjects];
    
    for (int i = 0; i < cameras; i++) {
        
        NSInteger count = 2;
        CGFloat offx = 2.0f;
        CGFloat offy = 5.0f;
        CGFloat screen_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat w = (screen_w-offx*(count+1))/count;
        CGFloat h = w/1.5+15;
        
        // 行号
        //int hang = i/2;
        //int lie = i%2;
        
        
        CGFloat x = offx+(w+offx)*(i%2);
        CGFloat y = 64+offy+(h+offy)*(i/2);
        
        CameraLiveView *tcameraLive = [[CameraLiveView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        tcameraLive.tag = i;
        [tcameraLive.btnMore addTarget:self action:@selector(btnMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        tcameraLive.btnMore.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [tcameraLive addGestureRecognizer:tap];
        
        [self.view addSubview:tcameraLive];
        [self.liveViews addObject:tcameraLive];
        
    }
    
    
    UIWindow *t_window = [UIApplication sharedApplication].windows[0];
    [t_window addSubview:self.viewbg];
    //[self.view addSubview:self.viewbg];
    
    //    [self.view addSubview:self.btnMicrophone];
    //
    //    [self.view addSubview:self.editBar];
    
    [self.editBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.btnMicrophone.mas_top).offset(-5);
        
        make.height.mas_equalTo(40);
    }];

}


#pragma mark - 单击手势添加摄像机
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    
    CameraLiveView *cameraLive = (CameraLiveView *)[recognizer view];
    
    
    if (cameraLive.isAddCamera) {
        
        for (CameraLiveView *t_live in self.liveViews) {
            [t_live setBorderColor:[UIColor blackColor]];
        }

        [cameraLive setBorderColor:[UIColor redColor]];
        [cameraLive.camera stopLiveShow];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LiveViewController *live = [[LiveViewController alloc] init];
            live.camera = cameraLive.camera;
            [self.navigationController pushViewController:live animated:YES];
        });
        
    }// @isAddCamera
    
    if (!cameraLive.isAddCamera) {
        
        __weak typeof(self) weakSelf = self;
        
        FourCameraViewController *fourCamera = [[FourCameraViewController alloc] init];
        fourCamera.viewTag = cameraLive.tag;
        fourCamera.selectCameraBlock = ^(Camera *mycam, NSInteger tag) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CameraLiveView *tcameraLive = weakSelf.liveViews[tag];
                tcameraLive.labName.text = [NSString stringWithFormat:@"%@(%@)", mycam.name, mycam.uid];
            
                // 默认连接第二码流
                [mycam startLiveShow:1 Monitor:tcameraLive.monitor];

                // 加入四画面
                mycam.select = YES;
                tcameraLive.isAddCamera = YES;
                [GBase editCameraSelect:mycam];
                LOG(@"select camera:%@", mycam.uid);
                
                for (CameraLiveView *t_live in self.liveViews) {
                    [t_live setBorderColor:[UIColor blackColor]];
                }
                [tcameraLive setBorderColor:[UIColor redColor]];
                
            });// dispatch_async
            
        };// @selectCameraBlock
        
        [self.navigationController pushViewController:fourCamera animated:YES];
    }// @!cameraLive.isAddCamera
}


- (NSMutableArray *)liveViews {
    if (!_liveViews) {
        _liveViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _liveViews;
}



#pragma mark - General Function
- (void)removeCamera:(Camera *)mycam {
    
    
    if (!self.g_liveView.camera.select) {
        NSLog(@"该摄像机已删除");
        return;
    }
    
    [self dismissToolBar];
    
    NSLog(@"remove_camera : %@", self.g_liveView.camera.uid);
    
    self.g_liveView.camera.select = NO;
    [self.g_liveView.camera stopLiveShow];
    [GBase editCameraSelect:self.g_liveView.camera];
    
    self.g_liveView.labName.text = nil;
    self.g_liveView.isAddCamera = NO;
    [self.selCameras removeObject:self.g_liveView.camera];
    
    //[self setupLiveViews];
}


#pragma mark -- 编辑
- (void)btnMoreAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    self.ctag = btn.tag;
    
    self.g_liveView = self.liveViews[btn.tag];
    
    if (self.g_liveView.isAddCamera) {
        NSLog(@"g_liveView.camera:%@", self.g_liveView.camera.uid);
        
        //[self.view addSubview:self.editBar];
        //self.editBar.hidden = !self.editBar.hidden;
        self.viewbg.hidden = !self.viewbg.hidden;
        
        // 获取镜像翻转信息
        [self.g_liveView.camera request:HI_P2P_GET_DISPLAY_PARAM dson:nil];
        
        for (CameraLiveView *t_live in self.liveViews) {
            [t_live setBorderColor:[UIColor blackColor]];
        }
        
        [self.g_liveView setBorderColor:[UIColor redColor]];
        
    }// @self.g_liveView.isAddCamera
    
    
    if (!self.g_liveView.isAddCamera) {
        
        __weak typeof(self) weakSelf = self;
        
        FourCameraViewController *fourCamera = [[FourCameraViewController alloc] init];
        fourCamera.viewTag = self.g_liveView.tag;
        fourCamera.selectCameraBlock = ^(Camera *mycam, NSInteger tag) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CameraLiveView *tcameraLive = weakSelf.liveViews[tag];
                tcameraLive.labName.text = [NSString stringWithFormat:@"%@(%@)", mycam.name, mycam.uid];
                
                // 默认连接第二码流
                [mycam startLiveShow:1 Monitor:tcameraLive.monitor];
                
                // 加入四画面
                mycam.select = YES;
                tcameraLive.isAddCamera = YES;
                [GBase editCameraSelect:mycam];
                LOG(@"select camera:%@", mycam.uid);
                
                for (CameraLiveView *t_live in self.liveViews) {
                    [t_live setBorderColor:[UIColor blackColor]];
                }
                [tcameraLive setBorderColor:[UIColor redColor]];
                
            });// dispatch_async
            
        };// @selectCameraBlock
        
        [self.navigationController pushViewController:fourCamera animated:YES];
        
    }// @!self.g_liveView.isAddCamera

    
}



#pragma mark - ToolBar/ToolBarDelegate
- (ToolBar *)editBar {
    if (!_editBar) {
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = 40.0f;
        _editBar = [[ToolBar alloc] initWithFrame:CGRectMake(0, 0, w, h) btnNumber:(int)self.editModels.count];
        _editBar.center = self.view.center;
        _editBar.delegate = self;
        _editBar.tag = 0;
        
        for (int i = 0; i < self.editModels.count; i++) {
            EditModel *tmodel = self.editModels[i];
            [_editBar setImage:[UIImage imageNamed:tmodel.imgName] atIndex:i forState:UIControlStateNormal];
            [_editBar setImage:[UIImage imageNamed:tmodel.imgSelName] atIndex:i forState:UIControlStateSelected];
        }
        
        //_editBar.hidden = YES;
    }
    return _editBar;
}


//- (void)didClickTag:(NSInteger)tag atIndex:(NSInteger)index {
//    
//    
//    CameraLiveView *tliveView = self.liveViews[self.ctag];
//    
//    EditModel *tmodel = self.editModels[index];
//    SEL tselector = tmodel.selector;
//    //[self performSelector:tselector withObject:tliveView.camera];
//    
//    [self performSelector:tselector withObject:tliveView.camera afterDelay:0.0];
//}

- (void)toolBar:(NSInteger)barTag didSelectedAtIndex:(NSInteger)index selected:(BOOL)select {
    
    EditModel *t_model = self.editModels[index];
    
    // afterDelay 使用此方法能消除警告
    if (select) {
        [self performSelector:t_model.selector withObject:self.g_liveView.camera afterDelay:0.0];
    }
    else {
        [self performSelector:t_model.selectorSel withObject:self.g_liveView.camera afterDelay:0.0];
    }
}

- (NSArray *)editModels {
    if (!_editModels) {
//        _editModels = @[[EditModel modelWithName:@"mirror_white" selector:@selector(dismissToolBar)],
//                        [EditModel modelWithName:@"speaker_on" selector:@selector(showMicrophoneForCamera:)],
//                        [EditModel modelWithName:@"snopshot" selector:@selector(snapShotForCamera:)],
//                        [EditModel modelWithName:@"record_white" selector:@selector(dismissToolBar)],
//                        [EditModel modelWithName:@"delete_blue_79" selector:@selector(removeCamera:)],
//                        [EditModel modelWithName:@"fork_white_132" selector:@selector(dismissToolBar)]];
        
        _editModels = @[[EditModel modelWithName:@"mirror_white" selector:@selector(changeCameraMirror) selectImageName:@"mirror_white" selectorSel:@selector(changeCameraMirror)],
                        [EditModel modelWithName:@"flip_white" selector:@selector(changeCameraFLip) selectImageName:@"flip_white" selectorSel:@selector(changeCameraFLip)],
                        [EditModel modelWithName:@"speaker_on" selector:@selector(showMicrophoneForCamera:) selectImageName:@"speaker_off" selectorSel:@selector(dismissMicrophone)],
                        [EditModel modelWithName:@"snopshot" selector:@selector(snapShotForCamera:) selectImageName:@"snopshot" selectorSel:@selector(snapShotForCamera:)],
                        [EditModel modelWithName:@"record_white" selector:@selector(startRecord) selectImageName:@"record_red" selectorSel:@selector(stopRecord)],
                        [EditModel modelWithName:@"delete_blue_79" selector:@selector(removeCamera:) selectImageName:@"delete_blue_79" selectorSel:@selector(removeCamera:)],
                        [EditModel modelWithName:@"fork_white_132" selector:@selector(dismissToolBar) selectImageName:@"fork_white_132" selectorSel:@selector(dismissToolBar)]
                        ];

    }
    return _editModels;
}


// 镜像
- (void)changeCameraMirror {
    [self.g_liveView.camera changeMirror];
}

// 翻转
- (void)changeCameraFLip {
    [self.g_liveView.camera changeFlip];
}


- (void)dismissToolBar {
    
    for (int i = 0; i < self.editModels.count; i++) {
        [self.editBar setSelect:NO atIndex:i];
    }
    
    self.viewbg.hidden = YES;
    //self.editBar.hidden = YES;

    [self dismissMicrophone];
    [self stopRecord];
};


// 保存截图
- (void)snapShotForCamera:(Camera *)mycam {
    
    if (!mycam) {
        return;
    }
    NSLog(@"保存截图:%@", mycam.uid);
    [GBase savePictureForCamera:mycam];
}

// 录像
- (void)startRecord {
    [self.g_liveView.recordView show];
    [GBase saveRecordingForCamera:self.g_liveView.camera];
}

- (void)stopRecord {
    
    if (!self.g_liveView.recordView.isShow) {
        return;
    }
    
    [self.g_liveView.recordView dismiss];
    [self.g_liveView.camera stopRecording];
}


#pragma mark - Microphone
- (UIButton *)btnMicrophone {
    if (!_btnMicrophone) {
        
        CGFloat screen_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat screen_h = [UIScreen mainScreen].bounds.size.height;

        CGFloat w = 100.0f;
        CGFloat h = w;
        _btnMicrophone = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _btnMicrophone.center = CGPointMake(screen_w/2, screen_h-h/2-60);
        //_btnMicrophone.backgroundColor = [UIColor redColor];
        
        [_btnMicrophone setBackgroundImage:[UIImage imageNamed:@"mic_gray"] forState:UIControlStateNormal];
        [_btnMicrophone setBackgroundImage:[UIImage imageNamed:@"mic_blue"] forState:UIControlStateHighlighted];
        
        // 长按对讲
        [_btnMicrophone addTarget:self action:@selector(btnMicrophoneDownAction:) forControlEvents:UIControlEventTouchDown];
        [_btnMicrophone addTarget:self action:@selector(btnMicrophoneAction:) forControlEvents:UIControlEventTouchUpInside];

        _btnMicrophone.hidden = YES;
    }
    return _btnMicrophone;
}

- (void)btnMicrophoneAction:(id)sender {
    [self listening];
}


- (void)btnMicrophoneDownAction:(id)sender {
    [self speaking];
}

- (void)showMicrophoneForCamera:(Camera *)mycam {
    
    self.btnMicrophone.hidden = NO;
    [self listening];
}

- (void)listening {
    [self.g_liveView.camera stopTalk];
    [self.g_liveView.camera startListening];
}

- (void)speaking {
    [self.g_liveView.camera stopListening];
    [self.g_liveView.camera startTalk];
}

// close talk and listening
- (void)dismissMicrophone {
    
    if (self.btnMicrophone.hidden) {
        return;
    }
    
    self.btnMicrophone.hidden = YES;
    
    Camera *t_cam = self.g_liveView.camera;
    
    [t_cam stopListening];
    [t_cam stopTalk];
}


#pragma mark - viewbg
- (UIView *)viewbg {
    if (!_viewbg) {
        _viewbg = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [_viewbg addSubview:self.btnMicrophone];
        [_viewbg addSubview:self.editBar];
        
        _viewbg.hidden = YES;
        //_viewbg.backgroundColor = [UIColor orangeColor];
    }
    return _viewbg;
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








