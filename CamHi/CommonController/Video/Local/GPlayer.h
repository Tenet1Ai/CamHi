//
//  GPlayer.h
//  CamHi
//
//  Created by HXjiang on 16/8/26.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPlayer : UIView

@property (nonatomic, assign) CGFloat csecond;  //当前时间
@property (nonatomic, assign) CGFloat tseconds; //总时间





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
//- (void)fastForward;

/*
 *  快退（2s）
 */
//- (void)fastBack;

/*
 *  快进或快退
 */
//- (void)moveProfress:(CGFloat)progress;

/*
 *  停止播放
 */
- (void)dismiss;


@end
