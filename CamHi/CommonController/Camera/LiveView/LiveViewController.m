//
//  LiveViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/19.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "LiveViewController.h"
#import "ToolBar.h"
#import "MirrorView.h"
#import "ZoomFocusDialog.h"
#import "PresetDialog.h"
#import "Microphone.h"
#import "Recording.h"
#import "QualityDialog.h"
#import "iToast.h"


#define SMONITOR    (100)


typedef NS_ENUM(NSInteger, SwipeDirection) {
    SwipeDirectionNone,
    SwipeDirectionUp,
    SwipeDirectionDown,
    SwipeDirectionRight,
    SwipeDirectionLeft,
};


typedef NS_ENUM(NSInteger, DeviceOrientation) {
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationLandscapeLeft,
    DeviceOrientationLandscapeRight
};



@interface LiveViewController ()
<ToolBarDelegate>
{
    BOOL isFullScreen;
    CGFloat WIDTH;
    CGFloat HEIGHT;
    double ptz_ctrl_time;

    DeviceOrientation deviceOrientation;
    QualityType qualityType;
}

@property (nonatomic, assign) BOOL isShowing;

// model
@property (nonatomic, strong) __block Display *display;
@property (nonatomic, strong) __block TimeParam *timeParam;

// view
@property (nonatomic, strong) UIScrollView *smonitor;
@property (nonatomic, strong) HiGLMonitor *monitor;

@property (nonatomic, strong) ToolBar *topToolBar;
@property (nonatomic, strong) ToolBar *bottomToolBar;
@property (nonatomic, strong) MirrorView *mirror;
@property (nonatomic, strong) ZoomFocusDialog *zoomfocus;
@property (nonatomic, strong) PresetDialog *preset;
@property (nonatomic, strong) Microphone *microphone;
@property (nonatomic, strong) Recording *record;
@property (nonatomic, strong) QualityDialog *quality;


@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.camera registerIOSessionDelegate:self];

    [self setupView];
    [self setup];
    
    
    //注册屏幕旋转通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationsDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    //强制横屏
//    [self forceChangeToOrientation:UIInterfaceOrientationLandscapeRight];
   // self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    //stop live
    [self.camera stopLiveShow];
    
    //delete all views
//    for (UIView *v in self.view.subviews) {
//        [v removeFromSuperview];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - setup
- (void)setup {
    
    // 连接图像时，摄像机时间自动同步为手机时间
    [self syncWithPhoneTime];

    
    
    [self.camera request:HI_P2P_GET_DISPLAY_PARAM dson:nil];
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
      
        if (cmd == HI_P2P_GET_DISPLAY_PARAM) {
            weakSelf.display = [weakSelf.camera object:dic];
            
            weakSelf.mirror.switchMirror.on = weakSelf.display.u32Mirror == 1 ? YES : NO;
            weakSelf.mirror.switchFlip.on = weakSelf.display.u32Flip == 1 ? YES : NO;

        }
    };

    
    qualityType = QualityTypeNone;
    
    
    //连接状态
    self.camera.connectBlock = ^(NSInteger state, NSString *connection) {
      
        if (state == CAMERA_CONNECTION_STATE_LOGIN) {
            
            [HXProgress dismiss];
            
            if (qualityType == QualityTypeHigh) {
                
                [weakSelf.camera startLiveShow:0 Monitor:weakSelf.monitor];
            }
            
            if (qualityType == QualityTypeLow) {
                
                [weakSelf.camera startLiveShow:1 Monitor:weakSelf.monitor];
            }

        }
    };
    
    
    _isShowing = NO;
    // 画面显示状态/录像状态
    self.camera.playStateBlock = ^(NSInteger state) {
        
        if (state == 0) {
            weakSelf.isShowing = YES;
        }
    };
    
    //注册通知，进入后台时退回主界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
  
}


- (void)syncWithPhoneTime {
    
    _timeParam = [[TimeParam alloc] init];
    [_timeParam syncCurrentTime];
    
    [self.camera request:HI_P2P_SET_TIME_PARAM dson:[self.camera dic:_timeParam]];
}



- (void)didReceiveNotification:(NSNotification *)notification {
    
    [self exit];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)setupView {
    
    ptz_ctrl_time = 0;
    
    WIDTH   = [UIScreen mainScreen].bounds.size.width;
    HEIGHT  = [UIScreen mainScreen].bounds.size.height;
    
    deviceOrientation = DeviceOrientationPortrait;
    
    
    
    
    
    
    
    
    //isFullScreen = NO;
    [self setupMonitor:isFullScreen];
    [self setupTopToolBar:isFullScreen];
    [self setupBottomToolBar:isFullScreen];
    
    
    [self.view addSubview:self.mirror];
    [self.view addSubview:self.zoomfocus];
    [self.view addSubview:self.preset];
    [self.view addSubview:self.microphone];
    [self.view addSubview:self.record];
    [self.view addSubview:self.quality];
    
    [self transformLandscapeLeft];

}



- (void)transformPortrait {
    
    isFullScreen = NO;
    deviceOrientation = DeviceOrientationPortrait;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        //    self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        
        self.view.bounds = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.view.center = CGPointMake(WIDTH/2, HEIGHT/2);
        
        [self transformMonitorPortrait];
        [self transformTopToolBarPortrait];
        [self transformBottomToolBarPortrait];
        [self transformMirrorPortrait];
        [self transformZoomfocusPortrait];
        [self transformPresetPortrait];
        [self transformMicrophonePortrait];
        [self transformRecordingPortrait];
        [self transformQualityPortrait];
        
    }];
}

- (void)transformLandscapeLeft {
    
    isFullScreen = YES;
    deviceOrientation = DeviceOrientationLandscapeLeft;

    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        self.view.bounds = CGRectMake(0, 0, HEIGHT, WIDTH);
        self.view.center = CGPointMake(WIDTH/2, HEIGHT/2);
        
        [self transformMonitorLandscapeLeft];
        [self transformTopToolBarLandscapeLeft];
        [self transformBottomToolBarLandscapeLeft];
        [self transformMirrorLandscapeLeft];
        [self transformZoomfocusLandscapeLeft];
        [self transformPresetLandscapeLeft];
        [self transformMicrophoneLandscapeLeft];
        [self transformRecordingLandscapeLeft];
        [self transformQualityLandscapeLeft];

    }];
}

- (void)transformLandscapeRight {
    
    isFullScreen = YES;
    deviceOrientation = DeviceOrientationLandscapeRight;

}



#pragma mark - UIScrollViewDelegate
//返回缩放对象
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (scrollView.tag == SMONITOR) {
        return self.monitor;
    }
    return nil;
}


//实现对象在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    //    NSLog(@">>>zoomScalec:%f", _smonitor.zoomScale);
    //    NSLog(@"s(%2f %2f %2f %2f)", scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
    //    NSLog(@"m(%2f %2f %2f %2f)", _monitor.frame.origin.x, _monitor.frame.origin.y, _monitor.frame.size.width, _monitor.frame.size.height);
    //    NSLog(@"s(%2f %2f)", scrollView.center.x, scrollView.center.y);
    //    NSLog(@"m(%2f %2f)", scrollView.center.x, scrollView.center.y);
    
    if (scrollView.tag == SMONITOR) {
        
        scrollView.zoomScale = scrollView.zoomScale <= 1 ? 1.0f :scrollView.zoomScale;
        
        CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
        
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
        
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
        
        self.monitor.center = CGPointMake(xcenter, ycenter);
    }
}

- (void)setupMonitor:(BOOL)fullScreen {
    
    [self.view addSubview:self.smonitor];
    //[self transfromMonitorLandscapeLeft];
    [self addGestureRecognizer];

}


- (UIScrollView *)smonitor {
    if (!_smonitor) {
        
        _smonitor = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        
        //_smonitor.backgroundColor = [UIColor blueColor];
        _smonitor.delegate = self;
        _smonitor.bounces = NO;
        _smonitor.multipleTouchEnabled = YES;
        _smonitor.minimumZoomScale = 1.0;
        _smonitor.maximumZoomScale = 10.0;
        _smonitor.showsVerticalScrollIndicator = NO;
        _smonitor.showsHorizontalScrollIndicator = NO;
        _smonitor.tag = SMONITOR;
        _smonitor.userInteractionEnabled = YES;

        [_smonitor addSubview:self.monitor];
    }
    return _smonitor;
}

//视频渲染器
- (HiGLMonitor *)monitor {
    if (!_monitor) {
        
        CGFloat h = WIDTH/1.5;
        _monitor = [[HiGLMonitor alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        _monitor.center = self.view.center;
        [self.camera startLiveShow:0 Monitor:_monitor];
    }
    return _monitor;
}

- (void)transformMonitorPortrait {
    
    CGRect monitorBounds = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    self.smonitor.zoomScale = 1.0f;
    self.smonitor.frame = monitorBounds;
    self.smonitor.contentSize = CGSizeMake(WIDTH, HEIGHT);
    
    self.monitor.bounds = CGRectMake(0, 0, WIDTH, WIDTH/1.5);
    self.monitor.center = CGPointMake(WIDTH/2, HEIGHT/2);
}

- (void)transformMonitorLandscapeLeft {
    
    CGRect monitorBounds = CGRectMake(0, 0, HEIGHT, WIDTH);
    
    self.smonitor.zoomScale = 1.0f;
    self.smonitor.frame = monitorBounds;
    //_smonitor.center = CGPointMake(HEIGHT/2, WIDTH/2);
    self.smonitor.contentSize = CGSizeMake(HEIGHT, WIDTH);
    
    self.monitor.frame = monitorBounds;
}



#pragma mark -- 添加手势
- (void)addGestureRecognizer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.monitor addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.monitor addGestureRecognizer:pan];
}

- (void)tap:(UIGestureRecognizer *)recognizer {
    
    //隐藏工具栏
    self.topToolBar.isUp ? [self.topToolBar moveDown] : [self.topToolBar moveUp];
    self.bottomToolBar.isUp ? [self.bottomToolBar moveUp] : [self.bottomToolBar moveDown];
    
    [self dismissAll];
}


- (void)pan:(UIPanGestureRecognizer *)recognizer {
    
    UIView *view = recognizer.view;
    
    if(view.bounds.size.width - view.frame.size.width == 0)
    {
        
        CGPoint translation = [recognizer translationInView:view.superview];
        
        
        if (recognizer.state == UIGestureRecognizerStateBegan )
        {
            
            //direction = kCameraMoveDirectionNone;
            NSLog(@"x:%f    y:%f",translation.x,translation.y);
            
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded )
        {
            //命令发送间隔为500ms
            double new_time = ((double)[[NSDate date] timeIntervalSince1970])*1000.0;
            BOOL isCtrl = NO;
            
            if (new_time - ptz_ctrl_time > 500 ) {
                isCtrl = YES;
                ptz_ctrl_time = new_time;
            }
            
            if (isCtrl) {
                NSInteger directon = [self.camera direction:translation];
                [self.camera moveDirection:directon runMode:HI_P2P_PTZ_MODE_STEP];
            }
            
        }
        
    }//@if
}


#pragma mark - 屏幕旋转(暂时未使用该系列方法)
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//切换横竖屏
- (void)forceChangeToOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
}

- (void)statusBarOrientationsDidChange:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (orientation == UIInterfaceOrientationPortrait) {
        isFullScreen = NO;
    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        isFullScreen = YES;
    }
    
    [self setupMonitor:isFullScreen];
    [self setupTopToolBar:isFullScreen];
    [self setupBottomToolBar:isFullScreen];

}


#pragma mark - ToolBarDelegate

- (void)toolBar:(NSInteger)barTag didSelectedAtIndex:(NSInteger)index selected:(BOOL)select {
    
}

- (void)didClickTag:(NSInteger)tag atIndex:(NSInteger)index {
    
    
    if (tag == 0) {
        
        if (index == 0) {
            [self showMirror];
        }
        
        if (index == 1) {
            [self showZoomFocus];
        }

        if (index == 2) {
            [self showPreset];
        }
        
        if (index == 3) {
            [self exit];
        }
        
    }
    
    
    if (tag == 1) {
        
        if (index == 0) {
            [self showMicrophone];
        }
        
        if (index == 1) {
            [self takeSnapShot];
        }
        
        if (index == 2) {
            [self takeRecording];
        }
        
        
        if (index == 3) {
            [self showQuality];
        }
        
        if (index == 4) {
            isFullScreen ? [self transformPortrait] : [self transformLandscapeLeft];
        }
    }
}


// 退出
- (void)exit {
    
    if (self.mirror) {
        [self.mirror removeFromSuperview];
    }
    
    
    //Goke版本的摄像机每次退出实时界面时更换显示画面
    if ([self.camera isGoke]) {
        if (self.isShowing) {
            [self.camera saveImage:[self.camera getSnapshot]];
        }
    }
    
    
    [self.camera stopLiveShow];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)showZoomFocus {
    
    //隐藏镜像翻转
    self.mirror.isShow ? [self.mirror dismiss]: nil;
    //隐藏预置位
    self.preset.isShow ? [self.preset dismiss] : nil;

    if ([self.camera getCommandFunction:HI_P2P_SET_PTZ_CTRL]) {
        self.zoomfocus.isShow ? [self.zoomfocus dismiss] : [self.zoomfocus show];
    }
}

- (void)showPreset {
    //隐藏镜像翻转
    self.mirror.isShow ? [self.mirror dismiss]: nil;
    //隐藏变焦
    self.zoomfocus.isShow ? [self.zoomfocus dismiss] : nil;

    if ([self.camera getCommandFunction:HI_P2P_SET_PTZ_PRESET]) {
        self.preset.isShow ? [self.preset dismiss] : [self.preset show];
    }
}

- (void)dismissAll {
    //隐藏镜像翻转
    self.mirror.isShow ? [self.mirror dismiss]: nil;
    //隐藏变焦
    self.zoomfocus.isShow ? [self.zoomfocus dismiss] : nil;
    //隐藏预置位
    self.preset.isShow ? [self.preset dismiss] : nil;
    
    //隐藏高清流畅切换
    !self.quality.isShow ? [self.quality show] : nil ;

}


#pragma mark -- topToolBar
- (void)setupTopToolBar:(BOOL)fullScreen {
    
    [self.view addSubview:self.topToolBar];
}

- (ToolBar *)topToolBar {
    if (!_topToolBar) {
        
        CGFloat h = 40.0f;
        int num = 4;
        
        _topToolBar = [[ToolBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h) btnNumber:num];
        _topToolBar.tag = 0;
        _topToolBar.delegate = self;
        
        NSArray *images = @[[UIImage imageNamed:@"mirror_white"], [UIImage imageNamed:@"zoom_focus"],
                            [UIImage imageNamed:@"mark"], [UIImage imageNamed:@"exitbutton"]];
        
        for (int i = 0; i < num; i++) {
            [_topToolBar setImage:images[i] atIndex:i forState:UIControlStateNormal];
        }
        
    }
    return _topToolBar;
}

- (void)transformTopToolBarPortrait {
    
    CGFloat h = self.topToolBar.frame.size.height;
    self.topToolBar.frame = CGRectMake(0, 0, WIDTH, h);
    [self.topToolBar setNeedsDisplay];
}

- (void)transformTopToolBarLandscapeLeft {
    
    CGFloat h = self.topToolBar.frame.size.height;
    self.topToolBar.frame = CGRectMake(0, 0, HEIGHT, h);
    [self.topToolBar setNeedsDisplay];
}


#pragma mark --- MirrorView
//控制画面镜像与翻转
- (MirrorView *)mirror {
    if (!_mirror) {
        
        CGFloat y = CGRectGetMaxY(self.topToolBar.frame)+20;
        _mirror = [[MirrorView alloc] initWithFrame:CGRectMake(-2*MirrorW, y, MirrorW, MirrorH)];
        //_mirror.switchMirror.on = _display.u32Mirror == 1 ? YES : NO;
        //_mirror.switchFlip.on = _display.u32Flip == 1 ? YES : NO;
        
        __weak typeof(self) weakSelf = self;
        
        _mirror.mirrorBlock = ^(SwitchTag tag, UISwitch *tswitch) {
          
            if (tag == SwitchTagMirror) {
                weakSelf.display.u32Mirror = tswitch.on ? 1 : 0;
            }
            
            if (tag == SwitchTagFlip) {
                weakSelf.display.u32Flip = tswitch.on ? 1 : 0;
            }
            
            [weakSelf.camera request:HI_P2P_SET_DISPLAY_PARAM dson:[weakSelf.camera dic:weakSelf.display]];
            
        };
    }
    return _mirror;
}

- (void)transformMirrorPortrait {
    self.mirror.isShow ? [self.mirror dismiss] : nil;
    CGFloat y = CGRectGetMaxY(self.topToolBar.frame)+20;
    self.mirror.frame = CGRectMake(-2*MirrorW, y, MirrorW, MirrorH);
}

- (void)transformMirrorLandscapeLeft {
    self.mirror.isShow ? [self.mirror dismiss] : nil;
    CGFloat y = CGRectGetMaxY(self.topToolBar.frame)+20;
    self.mirror.frame = CGRectMake(-2*MirrorW, y, MirrorW, MirrorH);
}

- (void)showMirror {
    
    //隐藏变焦
    self.zoomfocus.isShow ? [self.zoomfocus dismiss] : nil;
    //隐藏预置位
    self.preset.isShow ? [self.preset dismiss] : nil;
    
    if ([self.camera getCommandFunction:HI_P2P_SET_DISPLAY_PARAM]) {
        self.mirror.isShow ? [self.mirror dismiss] : [self.mirror show];
    }
}



#pragma mark -- ZoomFocusDialog
//变焦
- (ZoomFocusDialog *)zoomfocus {
    if (!_zoomfocus) {
        
        _zoomfocus = [[ZoomFocusDialog alloc] initWithFrame:CGRectMake(0, 0, ZoomW, ZoomH)];
        _zoomfocus.center = CGPointMake(WIDTH/2, -ZoomH-ZoomH/2);
        
        __weak typeof(self) weakSelf = self;
        
        _zoomfocus.zoomBlock = ^(NSInteger tag, NSInteger type) {
          
            if (type == ZOOMFOCUS_BTN_DOWN) {
             
                if (tag == 0) {
                    [weakSelf.camera zoomWithCtrl:HI_P2P_PTZ_CTRL_ZOOMIN];
                }
                
                if (tag == 1) {
                    [weakSelf.camera zoomWithCtrl:HI_P2P_PTZ_CTRL_ZOOMOUT];
                }

                if (tag == 2) {
                    [weakSelf.camera zoomWithCtrl:HI_P2P_PTZ_CTRL_FOCUSIN];
                }

                if (tag == 3) {
                    [weakSelf.camera zoomWithCtrl:HI_P2P_PTZ_CTRL_FOCUSOUT];
                }
            }
            
            if (type == ZOOMFOCUS_BTN_UP) {
                
                [weakSelf.camera zoomWithCtrl:HI_P2P_PTZ_CTRL_STOP];
            }

        };//@zoomBlock
        
    }
    return _zoomfocus;
}


- (void)transformZoomfocusPortrait {
    self.zoomfocus.isShow ? [self.zoomfocus show] : nil;
    self.zoomfocus.center = CGPointMake(WIDTH/2, -ZoomH/2-ZoomH);
}

- (void)transformZoomfocusLandscapeLeft {
    self.zoomfocus.isShow ? [self.zoomfocus show] : nil;
    self.zoomfocus.center = CGPointMake(HEIGHT/2, -ZoomH/2-ZoomH);
}


#pragma mark -- PresetDialog/预置位
- (PresetDialog *)preset {
    if (!_preset) {
        
        _preset = [[PresetDialog alloc] initWithFrame:CGRectMake(0, 0, PresetW, PresetH)];
        _preset.center = CGPointMake(WIDTH/2, -PresetH-PresetH/2);
        
        __weak typeof(self) weakSelf = self;
        
        _preset.presetBlock = ^(NSInteger index, PresetType type) {
            
            if (type == PresetTypeCall) {
                [weakSelf.camera presetWithNumber:index action:HI_P2P_PTZ_PRESET_ACT_CALL];
            }
            
            if(type == PresetTypeSet) {
                [weakSelf.camera presetWithNumber:index action:HI_P2P_PTZ_PRESET_ACT_SET];
            }
        };

    }
    return _preset;
}


- (void)transformPresetPortrait {
    self.preset.isShow ? [self.preset show] : nil;
    self.preset.center = CGPointMake(WIDTH/2, -PresetH/2-PresetH);
}

- (void)transformPresetLandscapeLeft {
    self.preset.isShow ? [self.preset show] : nil;
    self.preset.center = CGPointMake(HEIGHT/2, -PresetH/2-PresetH);
}


#pragma mark -- bottomToolBar／底部工具栏
- (void)setupBottomToolBar:(BOOL)fullScreen {
    [self.view addSubview:self.bottomToolBar];
}


- (ToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        
        CGFloat h = 40.0f;
        CGFloat y = HEIGHT - h;

        int num = 4;
        
        _bottomToolBar = [[ToolBar alloc] initWithFrame:CGRectMake(0, y, WIDTH, h) btnNumber:num];
        _bottomToolBar.tag = 1;
        _bottomToolBar.delegate = self;
        //    self.bottomToolBar.frame = CGRectMake(x, y, w, h);
        
        [_bottomToolBar setImage:[UIImage imageNamed:@"speaker_on"] atIndex:0 forState:UIControlStateNormal];
        [_bottomToolBar setImage:[UIImage imageNamed:@"speaker_off"] atIndex:0 forState:UIControlStateSelected];
        [_bottomToolBar setImage:[UIImage imageNamed:@"snopshot"] atIndex:1 forState:UIControlStateNormal];
        [_bottomToolBar setImage:[UIImage imageNamed:@"record_white"] atIndex:2 forState:UIControlStateNormal];
        [_bottomToolBar setImage:[UIImage imageNamed:@"record_red"] atIndex:2 forState:UIControlStateSelected];
        [_bottomToolBar setImage:[UIImage imageNamed:@"share"] atIndex:3 forState:UIControlStateNormal];
        [_bottomToolBar setTitle:@"Full" atIndex:4 forState:UIControlStateNormal];
    }
    return _bottomToolBar;
}

- (void)transformBottomToolBarPortrait {
    CGFloat h = self.bottomToolBar.frame.size.height;
    CGFloat y = HEIGHT-h;
    self.bottomToolBar.frame = CGRectMake(0, y, WIDTH, h);
    [self.bottomToolBar setNeedsDisplay];
}

- (void)transformBottomToolBarLandscapeLeft {
    CGFloat h = self.bottomToolBar.frame.size.height;
    CGFloat y = WIDTH-h;
    self.bottomToolBar.frame = CGRectMake(0, y, HEIGHT, h);
    [self.bottomToolBar setNeedsDisplay];
}


#pragma mark -- Microphone/麦克风按钮
- (Microphone *)microphone {
    
    if (!_microphone) {
        
        CGFloat px = WIDTH+MicrophoneH/2+MicrophoneH;
        CGFloat py = HEIGHT-MicrophoneH/2-40;
        
        _microphone = [[Microphone alloc] initWithFrame:CGRectMake(0, 0, MicrophoneH, MicrophoneH)];
        _microphone.center = CGPointMake(px, py);
        
        __weak typeof(self) weakSelf = self;
        _microphone.microphoneBlock = ^(PressType type) {
            
            if (type == PressTypeDown) {
                
                [weakSelf.camera stopListening];
                [weakSelf.camera startTalk];

            }
            
            if (type == PressTypeUpInside) {
               
                [weakSelf.camera stopTalk];
                [weakSelf.camera startListening];
            }

        };
    }
    
    return _microphone;
}

- (void)transformMicrophonePortrait {
//    self.microphone.isShow ? [self.microphone dismiss] : nil;
//    self.microphone.center = CGPointMake(WIDTH+MicrophoneH/2+MicrophoneH, HEIGHT-MicrophoneH/2-40);
    
    if (self.microphone.isShow) {
        self.microphone.center = CGPointMake(WIDTH-MicrophoneH/2, HEIGHT-MicrophoneH/2-40);
    }
    else {
        self.microphone.center = CGPointMake(WIDTH+MicrophoneH/2+MicrophoneH, HEIGHT-MicrophoneH/2-40);
    }
}

- (void)transformMicrophoneLandscapeLeft {
//    self.microphone.isShow ? [self.microphone dismiss] : nil;
//    self.microphone.center = CGPointMake(HEIGHT+MicrophoneH/2+MicrophoneH, WIDTH-MicrophoneH/2-40);
    
    if (self.microphone.isShow) {
        self.microphone.center = CGPointMake(HEIGHT-MicrophoneH/2, WIDTH-MicrophoneH/2-40);
    }
    else {
        self.microphone.center = CGPointMake(HEIGHT+MicrophoneH/2+MicrophoneH, WIDTH-MicrophoneH/2-40);
    }
}

- (void)showMicrophone {
    
    [self dismissAll];
    
    if (self.microphone.isShow) {
        
        [self.camera stopTalk];
        [self.camera stopListening];
        
        [self.microphone dismiss];
    }
    else {
        
        [self.camera startListening];
        [self.camera stopTalk];
        
        [self.microphone show];
    }

}



#pragma mark -- 截图
- (void)takeSnapShot {
    
    
    BOOL success = [GBase savePictureForCamera:self.camera];
    if (success) {
        
        //NSMutableArray *pictures = [GBase picturesForCamera:self.camera];
        //LOG(@"pictures.count:%ld", pictures.count)
        
        [self presentMessage:INTERSTR(@"Snapshot Saved") atDeviceOrientation:deviceOrientation];
    }
    else {
        
    }
}

- (void)presentMessage:(NSString *)message atDeviceOrientation:(DeviceOrientation)orientation {
    
    if (orientation == DeviceOrientationPortrait) {
        [[iToast makeText:message] show];
    }
    
    if (orientation == DeviceOrientationLandscapeLeft) {
        [[iToast makeText:message] showRota];
    }
    
    if (orientation == DeviceOrientationLandscapeRight) {
        [[iToast makeText:message] showUnRota];
    }
}

#pragma mark -- 录像
- (void)takeRecording {
    //self.record.isShow ? [self.record dismiss] : [self.record show];

    if (self.record.isShow) {
        
        [self.record dismiss];
        
        [self.camera stopRecording];
        
        //NSMutableArray *recordings = [GBase recordingsForCamera:self.camera];
        //LOG(@"recordings.count:%ld", recordings.count)

    }
    else {
        
        [self.record show];
        
        [GBase saveRecordingForCamera:self.camera];
    }

}


#pragma mark -- Recording/录像
- (Recording *)record {
    if (!_record) {
        
        CGFloat px = CGRectGetMaxX(self.monitor.frame)-50;
        CGFloat py = CGRectGetMinY(self.monitor.frame)+30;
        
        _record = [[Recording alloc] initWithFrame:CGRectMake(0, 0, RecordingW, RecordingH)];
        _record.center = CGPointMake(px, py);
    }
    return _record;
}

- (void)transformRecordingPortrait {
    CGFloat px = CGRectGetMaxX(self.monitor.frame)-50;
    CGFloat py = CGRectGetMinY(self.monitor.frame)+30;
    
    self.record.center = CGPointMake(px, py);
}

- (void)transformRecordingLandscapeLeft {
    CGFloat px = CGRectGetMaxX(self.monitor.frame)-50;
    CGFloat py = CGRectGetMinY(self.monitor.frame)+60;
    
    self.record.center = CGPointMake(px, py);
}


#pragma mark -- QualityDialog
- (QualityDialog *)quality {
    if (!_quality) {
        _quality = [[QualityDialog alloc] initWithFrame:CGRectMake(0, 0, QualityW, QualityH)];
        CGFloat px = WIDTH+QualityW/2+QualityW;
        CGFloat py = HEIGHT-QualityH/2-60;
        _quality.center = CGPointMake(px, py);
        _quality.btnHigh.selected = YES;//默认第一码流
        
        __weak typeof(self) weakSelf = self;
        
        _quality.qualityBlock = ^(QualityType type) {
          
            [HXProgress showProgress];
            
            if (type == QualityTypeHigh) {
                
                qualityType = QualityTypeHigh;
                
                [weakSelf.camera stopLiveShow];
                [weakSelf.camera disconnect];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.camera connect];
                });

            }
            
            if (type == QualityTypeLow) {
             
                qualityType = QualityTypeLow;
                
                [weakSelf.camera stopLiveShow];
                [weakSelf.camera disconnect];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.camera connect];
                });
                
            }

        };// @qualityBlock
        
    }
    return _quality;
}

- (void)transformQualityPortrait {
    !self.quality.isShow ? [self.quality dismiss] : nil ;
    
    CGFloat px = WIDTH+QualityW/2+QualityW;
    CGFloat py = HEIGHT-QualityH/2-60;
    
    self.quality.center = CGPointMake(px, py);
}

- (void)transformQualityLandscapeLeft {
    !self.quality.isShow ? [self.quality dismiss] : nil ;

    CGFloat px = HEIGHT+QualityW/2+QualityW;
    CGFloat py = WIDTH-QualityH/2-60;
    
    self.quality.center = CGPointMake(px, py);
}

- (void)showQuality {
    
    if (self.microphone.isShow) {
        [self presentMessage:INTERSTR(@"Can't change quality while Speaking") atDeviceOrientation:deviceOrientation];
        return;
    }
    
    self.quality.isShow ? [self.quality dismiss] : [self.quality show];
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
