//
//  HXAVPlayer.h
//  CamHi
//
//  Created by HXjiang on 16/6/22.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXAVPlayer : UIView


@property CGFloat totalSeconds;
@property CGFloat currentSeconds;


/**
 *  @param  currentSecond
 *  @param  totalSecond
 *  @param  progress
 *  @param  endFlag     播放结束标志 0 结束 1 未结束
 */
@property (nonatomic, copy) void(^playBlock)(NSString *currentSecond, NSString *totalSecond, CGFloat progress, NSInteger endFlag);

/**/
- (id)initWithFrame:(CGRect)frame withURL:(NSURL *)url;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *  播放下一个
 */
- (void)playNextURL:(NSURL *)nextUrl;

/**
 *快进（2s）
 */
- (void)fastForward;

/* 
 *  快退（2s）
 */
- (void)fastBack;

/*
 *  快进活快退 
 */
- (void)moveProfress:(CGFloat)progress;

/* 
 *  停止播放
 */
- (void)dismiss;



@end
