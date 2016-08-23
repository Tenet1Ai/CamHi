//
//  HXAVPlayerViewController.m
//  CamHi
//
//  Created by HXjiang on 16/5/18.
//  Copyright © 2016年 ouyang. All rights reserved.
//

//#import <AVFoundation/AVFoundation.h>
#import "HXAVPlayerViewController.h"
#import "HXAVPlayer.h"
#import "PlayView.h"

#define STATUS  (@"status")
#define RANGES  (@"loadedTimeRanges")

@interface HXAVPlayerViewController ()
<UIAlertViewDelegate>
{
    NSInteger indexOfCurrent;
    id playback;
}

@property BOOL isPlaying;
@property CGFloat cValue;

@property (nonatomic, strong) HXAVPlayer *hxplayer;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) PlayView *playView;


@end

@implementation HXAVPlayerViewController


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setup];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)setup {
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);

    
    
    
    
    
    ///var/mobile/Containers/Data/Application/DA072F1E-6A42-474D-AD69-B679D1E56488/Documents/AAAA-000066-JNMED/AAAA-000066-JNMED_2016-06-23_09-41-05.mp4
    ///var/mobile/Containers/Data/Application/607B054C-8AB4-4B51-85EB-091A9978586F/Documents/AAAA-000076-VNMZN/AAAA-000076-VNMZN_2016-08-18_11-11-38.mp4
    //http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4
    
    //NSURL *videoURL = [NSURL URLWithString:@"/Users/jiang/Downloads/AAAA-000066-JNMED/AAAA-000066-JNMED_2016-07-19_16-22-57.mp4"];
    
    
    

    //NSString *urlPath = [self videoPath:self.model.path];
    NSString *urlPath = [self recordingFilePath:self.camera fileName:self.model.path];

    NSLog(@"urlPath:%@", urlPath);
    
    //NSString *urlPath = @"http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4";
    //self.url = [NSURL URLWithString:urlPath];
    self.url = [NSURL fileURLWithPath:urlPath];

    [self.view addSubview:self.hxplayer];
    
    [self.view addSubview:self.playView];
    
    
    __weak typeof(self) wself = self;
    
    self.hxplayer.playBlock = ^(NSString *ctime, NSString *ttime, CGFloat progress, NSInteger endFlag) {
      
        if (endFlag == 0) {
            wself.playView.btnPlay.selected = YES;
            wself.isPlaying = NO;
        }
        
        wself.playView.labCurSeconds.text = ctime;
        wself.playView.labTotalSeconds.text = ttime;
        wself.playView.sliderProgress.value = progress*100;
        wself.cValue = progress*100;
        
        //NSLog(@"ctime:%@, ttime:%@ progress:%f", ctime, ttime, progress*100);
    };
    
    
    _isPlaying = YES;
    
    self.playView.playBlock = ^(NSInteger type, CGFloat value) {
      
        
        if (type == 0) {
            //播放／暂停
            wself.isPlaying ? [wself.hxplayer pause] : [wself.hxplayer play];
            wself.isPlaying = !wself.isPlaying;
        }
        
        
        if (type == 1) {
            //停止播放，退出
            [wself.hxplayer dismiss];
            [wself.navigationController popViewControllerAnimated:YES];
            
         }
        
        
        if (type == 2) {
            
            //快进／快退
            CGFloat pValue = (CGFloat)value-wself.cValue;
            [wself.hxplayer moveProfress:pValue];

         }

        
    };
    
    
    
}

- (HXAVPlayer *)hxplayer {
    if (!_hxplayer) {
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        
        //avplayer 封装使用
        //video size 1280/720
        _hxplayer = [[HXAVPlayer alloc] initWithFrame:CGRectMake(0, 0, h, w) withURL:self.url];
        _hxplayer.center = CGPointMake(h/2, w/2);
        //avplayer 封装使用 end
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_hxplayer addGestureRecognizer:tap];

        
    }
    return _hxplayer;
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


- (void)tap:(UITapGestureRecognizer *)recognizer {
    self.playView.isShow ? [self.playView dismiss] : [self.playView show];
}


- (NSString *)videoPath:(NSString *)videoName {
    return [NSString stringWithFormat:@"%@/Documents/%@/%@",NSHomeDirectory(),self.camera.uid, videoName];
}


- (NSString *)recordingFilePath:(Camera *)mycam fileName:(NSString *)fileName {
    
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:mycam.uid];
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    strPath = [strPath stringByAppendingPathComponent:fileName];
    
    NSLog(@"strPath:%@",strPath);
    
    
    return strPath;
}










- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



















@end
