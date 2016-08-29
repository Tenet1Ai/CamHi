//
//  HXAVPlayer.m
//  CamHi
//
//  Created by HXjiang on 16/6/22.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HXAVPlayer.h"

#define timeP       (10)
#define STATUS      (@"status")
#define TIMERANGES  (@"loadedTimeRanges")

@interface HXAVPlayer ()
{
    CGFloat w;
    CGFloat h;
    id playback;
}

//AVPlayer
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSDateFormatter *tFormatter;
@property (nonatomic, strong) UISlider *progressSlider;

@end

@implementation HXAVPlayer


- (id)initWithFrame:(CGRect)frame withURL:(NSURL *)url {
    
    if (self = [super initWithFrame:frame]) {
        
        w = frame.size.width;
        h = frame.size.height;
        _url = url;
     
        
        [self setupPlayer];
        
        //add progressSlider
        //[self addSubview:self.progressSlider];
    }
    
    return self;
    
}//@initWithFrame



- (void)setupPlayer {
    
    [self setupPlayerItemWithURL:_url];
    _player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
    
    [self.layer addSublayer:self.playerLayer];
    
}

- (void)setupPlayerItemWithURL:(NSURL *)url {
    
    _playerItem = [[AVPlayerItem alloc] initWithURL:url];

    
    
    /*
     *  监听loadedTimeRanges属性
     *  该属性代表已经缓冲的进度，监听此属性可以在UI中更新缓冲进度
     */
    [_playerItem addObserver:self forKeyPath:TIMERANGES options:NSKeyValueObservingOptionNew context:nil];

    
    /*
     *  监听status属性三种状态
     *  AVPlayerStatusFailed
     *  AVPlayerStatusUnknown
     *  AVPlayerStatusReadyToPlay   可以调用play方法播放视频
     */
    [_playerItem addObserver:self forKeyPath:STATUS options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    
    /**/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];

}


- (AVPlayerLayer *)playerLayer {
    
    if (!_playerLayer) {
        
        /*
         *  videoGravity    视屏图像的填充方式
         *  AVLayerVideoGravityResize
         *  AVLayerVideoGravityResizeAspect     default
         *  AVLayerVideoGravityResizeAspectFill
         */
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.frame = CGRectMake(0, 0, w, h);
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _playerLayer;
}


- (UISlider *)progressSlider {
    
    if (!_progressSlider) {
        
        CGFloat sliderw = w;
        CGFloat sliderH = 30.0f;
        CGFloat sliderx = 0;
        CGFloat slidery = h - sliderH;
        
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(sliderx, slidery, sliderw, sliderH)];
//        _progressSlider.minimumValue = 0;
//        _progressSlider.maximumValue = 100.0f;
        [_progressSlider addTarget:self action:@selector(progressSliderAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _progressSlider;
}

- (void)progressSliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    float seconds = slider.value;
    CMTime dragedCMTime = CMTimeMake(seconds, 1);
    
    [_player pause];
    [_player seekToTime:dragedCMTime completionHandler:^(BOOL finished) {
        
        [_player play];
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    NSLog(@"keyPath:%@ %@ %@ %@", keyPath, object, change, context);
    
    
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;

    if ([keyPath isEqualToString:STATUS]) {
        
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            CMTime duration = playerItem.duration;  //获取视频总长度
            CGFloat totalSecond = duration.value / duration.timescale;    //转换成秒
            NSLog(@"totalSecond:%f", totalSecond);
            
            [self monitoringPlayback:playerItem];   //监听播放状态
//            [self startPlaying];
            [_player play];
            
            //取消 kvo 注册
            //开始播放后移除status观察
            [_playerItem removeObserver:self forKeyPath:STATUS context:nil];
 
        }//@AVPlayerStatusReadyToPlay
        else {
            NSLog(@"!AVPlayerStatusReadyToPlay");
            
            //取消 kvo 注册
            //失败后移除status观察
            [_playerItem removeObserver:self forKeyPath:STATUS context:nil];
            //失败后移除loadedTimeRanges观察
            //[_playerItem removeObserver:self forKeyPath:TIMERANGES context:nil];

            
        }
    }
    
    
    
    if ([keyPath isEqualToString:TIMERANGES]) {
        
//        NSTimeInterval timeInterval = [self availableDuration]; //计算缓冲进度
        
        CMTime cmTime = _player.currentItem.asset.duration;
        float totalS = CMTimeGetSeconds(cmTime);
        NSLog(@"总时长:%f", totalS);
        
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = totalS;
        
        //开始播放后移除loadedTimeRanges观察
        [_playerItem removeObserver:self forKeyPath:TIMERANGES context:nil];
        
    }//@loadedTimeRanges

}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    __block CGFloat value = 0;
    
//    playback = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:NULL usingBlock:^(CMTime time) {
//        
//        
//        
//        double currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;  //计算当前在第几秒
//        double totalSecond = playerItem.duration.value/playerItem.duration.timescale;
//        
//        NSString *timeString = [self convertTime:currentSecond];
//        
//        CGFloat valueP = 10.0/totalSecond;
//        value = value + valueP;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [UIView animateWithDuration:1/10 animations:^{
////                self.progressView.progress = value/100;
//                self.progressSlider.value = value;
//            }];
//        });
//        
////                NSLog(@"timeString:%@, cseconds:%.2f, tseconds:%.2f, value:%.2f", timeString, currentSecond, totalSecond, value);
//        
//    }];
    
    __weak typeof(self) wself = self;
    
    playback = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, timeP) queue:NULL usingBlock:^(CMTime time) {
        
        
        
        double currentSecond = (CGFloat)playerItem.currentTime.value/playerItem.currentTime.timescale;  //计算当前在第几秒
        double totalSecond = (CGFloat)playerItem.duration.value/playerItem.duration.timescale;
        
//        NSLog(@"currentSecond:%f", currentSecond);
        
//        NSString *timeString = [self convertTime:currentSecond];
        
        wself.totalSeconds = totalSecond;
        
        NSString *ctime = [wself convertSeconds:currentSecond byDateFormatter:wself.tFormatter];
        NSString *ttime = [wself convertSeconds:totalSecond byDateFormatter:wself.tFormatter];
        
        if (wself.playBlock) {
            wself.playBlock(ctime, ttime, (CGFloat)currentSecond/totalSecond, 1);
        }
        
        
        
//        CGFloat valueP = 10.0/totalSecond;
//        value = value + 1.0/timeP;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [UIView animateWithDuration:1 animations:^{
//                //                self.progressView.progress = value/100;
////                                _progressSlider.value = value;
//                _progressSlider.value = currentSecond;
//                NSLog(@"_progressSlider.value:%f", _progressSlider.value);
//            }];
            
            [UIView animateWithDuration:timeP delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                wself.progressSlider.value = currentSecond;
                
//                NSLog(@"_progressSlider.value:%f", _progressSlider.value);
//                NSLog(@"value:%f", value);


            } completion:^(BOOL finished) {
                
                value = 0;
                
            }];//@animateWithDuration
            
        });//@dispatch_async
        
//                        NSLog(@"timeString:%@, cseconds:%.2f, tseconds:%.2f, value:%.2f", timeString, currentSecond, totalSecond, value);
        
    }];//@addPeriodicTimeObserverForInterval

    
    
}



//转换时间
- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)tFormatter {
    if (!_tFormatter) {
        _tFormatter = [[NSDateFormatter alloc] init];
        _tFormatter.dateFormat = @"HH:mm:ss";
    }
    return _tFormatter;
}

//转换时间
- (NSString *)convertSeconds:(CGFloat)seconds byDateFormatter:(NSDateFormatter *)formatter {
    //大于 1H
    seconds/3600 >= 1 ? [formatter setDateFormat:@"HH:mm:ss"] : [formatter setDateFormat:@"mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSString *second = [formatter stringFromDate:date];
    return second;
}

//视频播放结束通知
- (void)moviePlayDidEnd:(NSNotification *)notification {
    /*
     *  当播放结束时，再次调用play方法无效，需调用seekToTime把播放头移动到起始位置
     *  AVPlayerItemDidPlayToEndTimeNotification
     *  侦听此属性，播放结束时自动调用seekToTime
     */
    
    NSString *ttime = [self convertSeconds:_totalSeconds byDateFormatter:self.tFormatter];
    NSString *ctime = [self convertSeconds:0 byDateFormatter:self.tFormatter];

    if (_playBlock) {
        _playBlock(ctime, ttime, 0, 0);
    }
    
    NSLog(@"notification.name:%@", notification.name);
    
    [self.player seekToTime:kCMTimeZero];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        self.progressSlider.value = 0;
//        if (playback != nil) {
//            [self.player removeTimeObserver:playback];
//            playback = nil;
//        }
//    });
    
//    [self setupPlayerItemWithURL:_url];

}


#pragma mark - General Function
- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)playNextURL:(NSURL *)nextUrl
{
    
    if (playback != nil) {
        [_player removeTimeObserver:playback];
        playback = nil;
    }
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
    [self setupPlayerItemWithURL:nextUrl];

    
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    
}



- (void)fastForward {
    
    CMTime cTime = _player.currentItem.currentTime;
    double currentSecond = (CGFloat)cTime.value/cTime.timescale;  //计算当前在第几秒
    currentSecond += 2;
    
    CMTime forwardTime = CMTimeMake(currentSecond, 1);
    
    [_player pause];
    [_player seekToTime:forwardTime completionHandler:^(BOOL finished) {
        
        [_player play];
    }];
}


- (void)fastBack {
    
    CMTime cTime = _player.currentItem.currentTime;
    double currentSecond = (CGFloat)cTime.value/cTime.timescale;  //计算当前在第几秒
    currentSecond -= 2;
    
    CMTime backTime = CMTimeMake(currentSecond, 1);
    
    [_player pause];
    [_player seekToTime:backTime completionHandler:^(BOOL finished) {
        
        [_player play];
    }];

}

- (void)moveProfress:(CGFloat)progress {
    
    CMTime cTime = _player.currentItem.currentTime;
    double currentSecond = (CGFloat)cTime.value/cTime.timescale;  //计算当前在第几秒
    currentSecond = currentSecond + progress;
    
    CMTime backTime = CMTimeMake(currentSecond, 1);
    
    [_player pause];
    [_player seekToTime:backTime completionHandler:^(BOOL finished) {
        
        [_player play];
    }];

}



- (void)dismiss {
    
    if (playback != nil) {
        
        [_player removeTimeObserver:playback];
        playback = nil;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
