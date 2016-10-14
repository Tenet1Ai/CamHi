//
//  AppDelegate.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "AppDelegate.h"
#import "HXTabBarController.h"

//
#import "XGPush.h"

@interface AppDelegate ()
<HiChipInitCallback>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"application_didFinishLaunchingWithOptions : %@", launchOptions);

    HXTabBarController *viewcontroller = [[HXTabBarController alloc] init];
    self.window.rootViewController = viewcontroller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // init SDK
//    [HiChipSDK init];
    [HiChipSDK initAsync:self];
    
    // init camera
    [GBase initCameras];
//    // connect camera
//    [GBase connectCameras];
    
    

    // 注册信鸽推送
    [self registerXingePushWithOptions:launchOptions];

    
    
    // 处理远程通知信息
//    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        [self checkAlarmEvent:userInfo];
//    }
    [self checkAlarmEvent:launchOptions];

    
    return YES;
}



// app即将离开前台
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"applicationWillResignActive");
    
    //disconnect camera
    [GBase disconnectCameras];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// app即将进入前台（注：是从后台进入前台，不是启动）
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"applicationWillEnterForeground");
    
    // connect camera
    [GBase connectCameras];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive");

    // connect camera
//    [GBase connectCameras];

    
    
    // 清零推送消息
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 推送消息处理
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    

    //将注册信鸽推送返回的deviceToken转换为字符串
    NSString *token = [[[deviceToken.description stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    //将注册信鸽推送返回的deviceToken存入本地磁盘，用于信鸽推送的打开与关闭
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"xinge_push_deviceToken"];

    LOG(@"xinge_push_deviceToken : %@", token)
    
    // 结果与token一样
    //NSString *xinge_token = [XGPush registerDevice:deviceToken];
    //LOG(@"xinge_push_deviceToken:%@", xinge_token)

}

// 如果deviceToken获取失败则会进入此事件
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

    if (error) {
        LOG(@"didFailToRegisterForRemoteNotificationsWithError:%@", error);
    }
}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//}

// app在前台，收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [self checkAlarmEvent:userInfo];
    
    // 推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
}



-(void)checkAlarmEvent:(NSDictionary*) dic {
    
    if (dic == nil) {
        return;
    }
    
    NSString *responseString = (NSString*)[dic objectForKey:@"hi"];
    NSLog(@"checkAlarmEvent:%@",responseString);
    
    if (responseString == nil) {
        NSLog(@"return:%@",responseString);
        
        return;
    }
    
    NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        
        NSLog(@"Dersialized JSON Dictionary = %@ %ld", dictionary[@"uid"], (long)[dictionary[@"type"] integerValue]);
        
        NSString *uid =[dictionary objectForKey:@"uid"];
        //NSInteger type =[[dictionary objectForKey:@"type"]integerValue];
        
        NSString* dictime =[dictionary objectForKey:@"time"];
        NSInteger time = 0;
        if (dictime!=nil) {
            time = [dictime integerValue];
        }
        if (time <=0) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            time = [dat timeIntervalSince1970];
        }
        NSLog(@"time:%ld",(long)time);
        
        for (Camera *cam in [GBase sharedBase].cameras) {
            
            if ([cam.uid isEqualToString:uid]) {
                cam.isAlarm = YES;
                
                if (cam.alarmBlock) {
                    cam.alarmBlock(YES, 0);
                }
                
            }//@isEqualToString
            
        }// @for
        
    }// @jsonObject
    
}



#pragma mark - 注册信鸽推送
- (void)registerXingePushWithOptions:(NSDictionary *)launchOptions {
    
    NSString *bundelDisplayName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    NSString *xingeCompany = nil;
    LOG(@"bundelDisplayName : %@", bundelDisplayName)
    
    
    // *******************************************************
    // displayName  : CamHiGH
    // appId        : 2200126647
    // appKey       : IQKRZ88762PX
    // company      : hichip
    // server       : xinge:hichip:ios
    
    if ([bundelDisplayName isEqualToString:@"CamHiGH"]) {
        [XGPush startApp:2200126647 appKey:@"IQKRZ88762PX"];
        xingeCompany = @"hichip";
    }

    
    // *******************************************************
    // displayName  : CamHi
    // appId        : 2200126647
    // appKey       : IQKRZ88762PX
    // company      : hichip
    // server       : xinge:hichip:ios
    
    if ([bundelDisplayName isEqualToString:@"CamHi"]) {
        [XGPush startApp:2200126647 appKey:@"IQKRZ88762PX"];
        xingeCompany = @"hichip";
    }

    
    // *******************************************************
    // displayName  : JS-AP131
    // appId        : 2200179317
    // appKey       : I1T7U867BBNQ
    // company      : jsap
    // server       : xinge:jsap:ios
    
    if ([bundelDisplayName isEqualToString:@"JS-AP131"]) {
        [XGPush startApp:2200179317 appKey:@"I151T1EM8JNI"];
        xingeCompany = @"jsap";
    }

    
    // *******************************************************
    // displayName  : KS-AP130
    // appId        : 2200181079
    // appKey       : I151T1EM8JNI
    // company      : ksap
    // server       : xinge:ksap:ios

    if ([bundelDisplayName isEqualToString:@"KS-AP130"]) {
        [XGPush startApp:2200181079 appKey:@"I151T1EM8JNI"];
        xingeCompany = @"ksap";
    }

    
    // *******************************************************
    // displayName  : XMcam
    // appId        : 2200196556
    // appKey       : I271ZTG2WF4I
    // company      : xmcam
    // server       : xinge:xmcam:ios
    
    if ([bundelDisplayName isEqualToString:@"XMcam"]) {
        [XGPush startApp:2200196556 appKey:@"I271ZTG2WF4I"];
        xingeCompany = @"xmcam";
    }

    
    // *******************************************************
    // displayName  : My camera+
    // appId        : 2200215126
    // appKey       : I2FA2CR676XC
    // company      : addcam
    // server       : xinge:addcam:ios
    
    if ([bundelDisplayName isEqualToString:@"My camera+"]) {
        [XGPush startApp:2200215126 appKey:@"I2FA2CR676XC"];
        xingeCompany = @"addcam";
    }

    
    // *******************************************************
    // displayName  : keye
    // appId        : 2200198425
    // appKey       : I8N175PWP9LJ
    // company      : keye
    // server       : xinge:keye:ios
    
    if ([bundelDisplayName isEqualToString:@"keye"]) {
        [XGPush startApp:2200198425 appKey:@"I8N175PWP9LJ"];
        xingeCompany = @"keye";
    }

    
    // *******************************************************
    // displayName  : Q100
    // appId        : 2200194285
    // appKey       : I53QYH9D98MM
    // company      : q100
    // server       : xinge:q100:ios
    
    if ([bundelDisplayName isEqualToString:@"Q100"]) {
        [XGPush startApp:2200194285 appKey:@"I53QYH9D98MM"];
        xingeCompany = @"q100";
    }

    
    // *******************************************************
    // displayName  : ccs
    // appId        : 2200207116
    // appKey       : I1BP9R2XZ17K
    // company      : ccs
    // server       : xinge:ccs:ios
    
    if ([bundelDisplayName isEqualToString:@"ccs"]) {
        [XGPush startApp:2200207116 appKey:@"I1BP9R2XZ17K"];
        xingeCompany = @"ccs";
    }

    
    // *******************************************************
    // displayName  : C4 CAM
    // appId        : 2200195009
    // appKey       : IVT1ZRK3873B
    // company      : cfour
    // server       : xinge:cfour:ios
    
    if ([bundelDisplayName isEqualToString:@"C4 CAM"]) {
        [XGPush startApp:2200195009 appKey:@"IVT1ZRK3873B"];
        xingeCompany = @"cfour";
    }

    
    
    // *******************************************************
    // displayName  : Camera IP EM
    // appId        : 2200216916
    // appKey       : I84UY6P1HG7L
    // company      : ipem
    // server       : xinge:ipem:ios
    
    if ([bundelDisplayName isEqualToString:@"Camera IP EM"]) {
        [XGPush startApp:2200216916 appKey:@"I84UY6P1HG7L"];
        xingeCompany = @"ipem";
    }

    [XGPush handleLaunching:launchOptions];
    SystemVersion < 8 ? [self registerPush] : [self registerPushForIOS8];
    
    [[NSUserDefaults standardUserDefaults] setObject:xingeCompany forKey:@"xinge_push_company"];

}// @registerXingePushWithOptions


- (void)registerPushForIOS8{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
#endif
    
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}



#pragma mark - HiChipInitCallback
- (void)onInitResult:(int)result {
    
    LOG(@"onInitResult :%d", result)
    
    // connect camera
    [GBase connectCameras];
}



/*
 
 简单总结一下推送消息的相应情况
 １.　当程序处于关闭状态收到推送消息时，点击图标会调用- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions　这个方法，那么消息给通过launchOptions这个参数获取到。注：这样无法获取到远程推送消息
 ２.　当程序处于前台工作时，这时候若收到消息推送，会调用- (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo这个方法
 ３.　当程序处于后台运行时，这时候若收到消息推送，如果点击消息或者点击消息图标时，也会调用- (void)application:(UIApplication*)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo这个方法
 ４.　当程序处于后台运行时，这时候若收到消息推送，如果点击桌面应用图标，则不会调用didFinishLaunchingWithOptions和didReceiveRemoteNotification方法，所以无法获取消息
 
 */



@end
