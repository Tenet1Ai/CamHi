//
//  AppDelegate.h
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"


#pragma mark - Key/app进入后台与前台通知
#define DidBecomeActive     (@"applicationDidBecomeActive")
#define DidEnterBackground  (@"applicationDidEnterBackground")


#pragma mark - XingePush/信鸽推送
// CamHi
#define XingePushID     (2200126647)
#define XingePushKey    (@"IQKRZ88762PX")
#define XingePushServer (@"hichip") //"xinge:hichip:ios"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

