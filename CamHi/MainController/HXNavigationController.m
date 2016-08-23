//
//  HXNavigationController.m
//  LastMissor
//
//  Created by HXjiang on 16/6/16.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "HXNavigationController.h"

@interface HXNavigationController ()

@end

@implementation HXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.navigationBar.tintColor = [UIColor blackColor];
    
    /*
    // 设置导航栏为半透明
    UINavigationBar *navigationBar = self.navigationBar;
//    [navigationBar setBarStyle:UIBarStyleDefault];
//    [navigationBar setTranslucent:YES];
    
    //修改标题的颜色
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //修改导航栏背景颜色为黑色，并且状态栏的字体颜色为白色
    [self.navigationBar setBarStyle:UIBarStyleBlack];

    //    UINavigationBar *bar = [UINavigationBar appearance];
    //    CGFloat rgb = 0.1;
    //    bar.barTintColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.9];
    //    bar.tintColor = [UIColor whiteColor];
    //    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    //全局隐藏tabbar
//    self.navigationBar.hidden = YES;
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 旋转屏幕
//是否支持设备旋转
- (BOOL)shouldAutorotate
{
    //    if (self.topViewController.shouldAutorotate)
    //    {
    //        NSLog(@"YES--------------");
    //    }
    //    else
    //    {
    //        NSLog(@"NO---------------");
    //    }
    
    return self.topViewController.shouldAutorotate;
}
//支持的界面指向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    //    UIInterfaceOrientationMask orientation = self.topViewController.supportedInterfaceOrientations;
    //    if (orientation == UIInterfaceOrientationLandscapeLeft)
    //    {
    //        NSLog(@"UIInterfaceOrientationLandscapeLeft------");
    //    }
    //    if (orientation == UIInterfaceOrientationLandscapeRight)
    //    {
    //        NSLog(@"UIInterfaceOrientationLandscapeRight------");
    //    }
    //    if (orientation == UIInterfaceOrientationPortrait)
    //    {
    //        NSLog(@"UIInterfaceOrientationPortrait-------------");
    //    }
    //    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    //    {
    //        NSLog(@"UIInterfaceOrientationPortraitUpsideDown-----");
    //    }
    
    return self.topViewController.supportedInterfaceOrientations;
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
