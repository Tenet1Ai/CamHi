//
//  PlayBackViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/18.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PlayBackViewController.h"
#import "VideoInfo.h"
#import "PlayView.h"

@interface PlayBackViewController ()

@property (nonatomic, strong) HiGLMonitor *monitor;
@property (nonatomic, strong) PlayView *playView;
@property long playTime;
@property long firstPlayTime;
@property BOOL isFirstPlayTime;
@property BOOL isPlaying;
@property BOOL isEndingFlag;



@end

@implementation PlayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)setup {
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    [self.view addSubview:self.monitor];
    [self.view addSubview:self.playView];
    
    _playTime = self.video.endTime - self.video.startTime;
    
    STimeDay stime = [VideoInfo getTimeDay:self.video.startTime];
    
    [self.camera startPlayback:&stime Monitor:self.monitor];

    _isFirstPlayTime = YES;
    _isPlaying = YES;
    _isEndingFlag = NO;

    __weak typeof(self) wself = self;
    
//    __block NSDateFormatter *tFormatter = [[NSDateFormatter alloc] init];
//    tFormatter.dateFormat = @"HH:mm:ss";
    
    self.camera.playBackBlock = ^(NSInteger cmd, int seconds) {
        
        if(wself.isFirstPlayTime) {
            wself.firstPlayTime = seconds;
            wself.isFirstPlayTime = NO;
        }

//        NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970: (CGFloat)seconds/1000.0];
//        NSLog(@">>> : %@", [tFormatter stringFromDate:d]);
        
        double per = (double)(seconds - wself.firstPlayTime)/(double)(wself.playTime*10);

        NSLog(@">>> seconds:%d", seconds);

        NSLog(@">>> per:%f", per);
        
        wself.playView.sliderProgress.value = per;
    };
    
    
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
      
        if (cmd == HI_P2P_DEV_PLAYBACK_END_FLAG) {
            
            LOG(@"HI_P2P_DEV_PLAYBACK_END_FLAG >>>")
            
            wself.isEndingFlag = YES;
            wself.playView.sliderProgress.value = 0;
            wself.playView.btnPlay.selected = YES;
        }
    };
    
    
    
    
    
    
    
    
    
    
    
    self.playView.playBlock = ^(NSInteger type, CGFloat value) {
      
        if (type == 0) {
            
            if (wself.isEndingFlag) {
                
                HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
                memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
                req->command = HI_P2P_PB_PLAY;
                req->u32Chn = 0;
                STimeDay st = [VideoInfo getTimeDay:wself.video.startTime];
                memcpy(&req->sStartTime, &st, sizeof(STimeDay));
                
                [wself.camera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
                
                free(req);

                wself.isEndingFlag = !wself.isEndingFlag;
            }
            else {
             
                if (wself.isPlaying) {
                    
                    //暂停时，发送暂停继续播放，做完任何操作都需要发送stop
                    HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
                    memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
                    req->command = HI_P2P_PB_PAUSE;
                    req->u32Chn = 0;
                    STimeDay st = [VideoInfo getTimeDay:wself.video.startTime];
                    memcpy(&req->sStartTime, &st, sizeof(STimeDay));
                    
                    [wself.camera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
                    
                    free(req);
                    
                    
                }
                else {
                    
                    HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
                    memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
                    req->command = HI_P2P_PB_PAUSE;
                    req->u32Chn = 0;
                    STimeDay st = [VideoInfo getTimeDay:wself.video.startTime];
                    memcpy(&req->sStartTime, &st, sizeof(STimeDay));
                    
                    [wself.camera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
                    
                    free(req);
                    
                    
                }
                
                wself.isPlaying = !wself.isPlaying;

            }
            
            
        }
        
        
        if (type == 1) {
            
            //[wself.camera stopPlayback];
            
            HI_P2P_S_PB_PLAY_REQ* req = (HI_P2P_S_PB_PLAY_REQ*)malloc(sizeof(HI_P2P_S_PB_PLAY_REQ));
            memset(req, 0, sizeof(HI_P2P_S_PB_PLAY_REQ));
            req->command = HI_P2P_PB_STOP;
            req->u32Chn = 0;
            STimeDay st = [VideoInfo getTimeDay:wself.video.startTime];
            memcpy(&req->sStartTime, &st, sizeof(STimeDay));
            
            [wself.camera sendIOCtrl:HI_P2P_PB_PLAY_CONTROL Data:(char *)req Size:sizeof(HI_P2P_S_PB_PLAY_REQ)];
            
            free(req);

            
            [wself.navigationController popViewControllerAnimated:YES];
        }
        
        
        if (type == 2) {
            
            
            HI_P2P_PB_SETPOS_REQ* req = (HI_P2P_PB_SETPOS_REQ*)malloc(sizeof(HI_P2P_PB_SETPOS_REQ));
            STimeDay st = [VideoInfo getTimeDay:wself.video.startTime];
            memcpy(&req->sStartTime, &st, sizeof(STimeDay));
            req->s32Pos = value;
            req->u32Chn = 0;
            [wself.camera sendIOCtrl:HI_P2P_PB_POS_SET Data:(char *)req Size:sizeof(HI_P2P_PB_SETPOS_REQ)];
            
            free(req);

            
        }
        
    };
    
}


- (void)tap:(UITapGestureRecognizer *)recognizer {
    self.playView.isShow ? [self.playView dismiss] : [self.playView show];
}

//视频渲染器
- (HiGLMonitor *)monitor {
    if (!_monitor) {
        
        CGFloat WIDTH = [UIScreen mainScreen].bounds.size.height;
        CGFloat h = [UIScreen mainScreen].bounds.size.width;//WIDTH/1.5;
        
        _monitor = [[HiGLMonitor alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        _monitor.center = CGPointMake(WIDTH/2, h/2);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_monitor addGestureRecognizer:tap];
    }
    return _monitor;
}


- (PlayView *)playView {
    if (!_playView) {
        
        CGFloat WIDTH = [UIScreen mainScreen].bounds.size.height;
        CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.width;//WIDTH/1.5;
        CGFloat h = 50.0f;//WIDTH/1.5;

        _playView = [[PlayView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        _playView.center = CGPointMake(WIDTH/2, HEIGHT-h/2);
    }
    return _playView;
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
