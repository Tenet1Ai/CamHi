//
//  GPlayer.m
//  CamHi
//
//  Created by HXjiang on 16/8/26.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "GPlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface GPlayer ()
{
    CGFloat gw;
    CGFloat gh;
    id playback;
}

@property (nonatomic, strong) AVPlayer *gPlayer;
@property (nonatomic, strong) AVPlayerLayer *gPlayerLayer;
@property (nonatomic, strong) NSDateFormatter *tFormatter;

@end



@implementation GPlayer




- (id)initWithFrame:(CGRect)frame url:(NSURL *)url {
    if (self = [super initWithFrame:frame]) {
        
        gw = frame.size.width;
        gh = frame.size.height;
        
        
        self.gPlayer = [AVPlayer playerWithPlayerItem:[self tPlayerItemWithUrl:url]];
       
        [self.layer addSublayer:self.gPlayerLayer];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (AVPlayerLayer *)gPlayerLayer {
    
    if (!_gPlayerLayer) {
        
        /*
         *  videoGravity    视屏图像的填充方式
         *  AVLayerVideoGravityResize
         *  AVLayerVideoGravityResizeAspect     default
         *  AVLayerVideoGravityResizeAspectFill
         */
        _gPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.gPlayer];
        _gPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _gPlayerLayer.frame = CGRectMake(0, 0, gw, gh);
        _gPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _gPlayerLayer;
}


//获取palyerItem
- (AVPlayerItem *)tPlayerItemWithUrl:(NSURL *)url {

    AVAsset *tasset = [AVAsset assetWithURL:url];
    
    AVPlayerItem *tPlayerItem = [AVPlayerItem playerItemWithAsset:tasset];
    
    /*
     *  监听loadedTimeRanges属性
     *  该属性代表已经缓冲的进度，监听此属性可以在UI中更新缓冲进度
     */
    [tPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
    /*
     *  监听status属性三种状态
     *  AVPlayerStatusFailed
     *  AVPlayerStatusUnknown
     *  AVPlayerStatusReadyToPlay   可以调用play方法播放视频
     */
    [tPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    

    /*
     *  注册播放结束通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:tPlayerItem];
    
    return tPlayerItem;
}


//视频播放结束通知
- (void)didPlayToEndTime:(NSNotification *)notification {
 
    /*
     *  当播放结束时，再次调用play方法无效，需调用seekToTime把播放头移动到起始位置
     *  AVPlayerItemDidPlayToEndTimeNotification
     *  侦听此属性，播放结束时自动调用seekToTime
     */

    
    if ([notification.object isKindOfClass:[AVPlayerItem class]]) {
        
        AVPlayerItem *tPlayerItem = notification.object;
        
        // 移除播放结束通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:tPlayerItem];
        
        [self.gPlayer seekToTime:kCMTimeZero];
    }
}


// kvc
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        
        AVPlayerItem *tPlayerItem = (AVPlayerItem *)object;
        
        
        if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            //        NSTimeInterval timeInterval = [self availableDuration]; //计算缓冲进度
            
            
            
            //开始播放后移除loadedTimeRanges观察
            [tPlayerItem removeObserver:self forKeyPath:keyPath context:nil];
            
        }//@loadedTimeRanges

        
        if ([keyPath isEqualToString:@"status"]) {
            
            
            if (tPlayerItem.status == AVPlayerStatusReadyToPlay) {
                NSLog(@"AVPlayerStatusReadyToPlay");
                
                //获取总时长
                CMTime duration = tPlayerItem.asset.duration;
                //_tseconds = duration.value / duration.timescale;  //转换成秒
                _tseconds = CMTimeGetSeconds(duration);     //转换成秒
                NSLog(@"总时长:%f", _tseconds);

                //监听播放状态
                [self monitoringPlayback:tPlayerItem];
                
                //开始播放
                [self.gPlayer play];
                
            }//@AVPlayerStatusReadyToPlay
            else {
                
                NSLog(@"!AVPlayerStatusReadyToPlay");
                
            }//@!AVPlayerStatusReadyToPlay
            
            //开始播放或获取信息失败后移除status观察
            [tPlayerItem removeObserver:self forKeyPath:keyPath context:nil];

        }//@status

        
    }

}//@observeValueForKeyPath



//监听播放状态
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) wself = self;
    
    CMTime timeInterval = CMTimeMake(1, 1);
    
    playback = [self.gPlayer addPeriodicTimeObserverForInterval:timeInterval queue:NULL usingBlock:^(CMTime time) {
        
        
        
        wself.csecond = (CGFloat)playerItem.currentTime.value/playerItem.currentTime.timescale;  //计算当前在第几秒
        
        
//        wself.totalSeconds = totalSecond;
//        
//        NSString *ctime = [wself convertSeconds:currentSecond byDateFormatter:wself.tFormatter];
//        NSString *ttime = [wself convertSeconds:totalSecond byDateFormatter:wself.tFormatter];
//        
//        if (wself.playBlock) {
//            wself.playBlock(ctime, ttime, (CGFloat)currentSecond/totalSecond, 1);
//        }
        
    }];//@addPeriodicTimeObserverForInterval

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


#pragma mark - General Function
- (void)play {
    [self.gPlayer play];
}

- (void)pause {
    [self.gPlayer pause];
}

- (void)playNextURL:(NSURL *)nextUrl {
    
    //移除playback
    [self.gPlayer removeTimeObserver:playback];
    playback = nil;
    
    AVPlayerItem *tPlayerItem = [self tPlayerItemWithUrl:nextUrl];
    
    [self.gPlayer replaceCurrentItemWithPlayerItem:tPlayerItem];
}



//- (void)fastForward {
//    
//    CMTime cTime = _player.currentItem.currentTime;
//    double currentSecond = (CGFloat)cTime.value/cTime.timescale;  //计算当前在第几秒
//    currentSecond += 2;
//    
//    CMTime forwardTime = CMTimeMake(currentSecond, 1);
//    
//    [_player pause];
//    [_player seekToTime:forwardTime completionHandler:^(BOOL finished) {
//        
//        [_player play];
//    }];
//}


//- (void)fastBack {
//    
//    CMTime cTime = _player.currentItem.currentTime;
//    double currentSecond = (CGFloat)cTime.value/cTime.timescale;  //计算当前在第几秒
//    currentSecond -= 2;
//    
//    CMTime backTime = CMTimeMake(currentSecond, 1);
//    
//    [_player pause];
//    [_player seekToTime:backTime completionHandler:^(BOOL finished) {
//        
//        [_player play];
//    }];
//    
//}

//- (void)moveProfress:(CGFloat)progress {
//    
//    CMTime cTime = _player.currentItem.currentTime;
//    double currentSecond = (CGFloat)cTime.value/cTime.timescale;  //计算当前在第几秒
//    currentSecond = currentSecond + progress;
//    
//    CMTime backTime = CMTimeMake(currentSecond, 1);
//    
//    [_player pause];
//    [_player seekToTime:backTime completionHandler:^(BOOL finished) {
//        
//        [_player play];
//    }];
//    
//}



- (void)dismiss {
    
    if (playback != nil) {
        
        [self.gPlayer removeTimeObserver:playback];
        playback = nil;
    }
}



@end
