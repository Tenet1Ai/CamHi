//
//  HXTabBarController.m
//  LastMissor
//
//  Created by HXjiang on 16/6/16.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "HXTabBarController.h"
#import "HXNavigationController.h"

//child viewcontroller
#import "CameraViewController.h"
#import "PhotoViewController.h"
#import "VideoViewController.h"
#import "AboutViewController.h"


#define keyClass   (@"viewcontroller")
#define keyTtitle   (@"title")
#define keyBtitle   (@"tabBarItemTitle")
#define keyNimage   (@"image")
#define keySimage   (@"selectedImage")

@interface HXTabBarController ()

@end

@implementation HXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化控制器
    [self setUpChildViewControllers];
    
    
    /*
    //设置tabbarcontroller的tabbaritem图片的大小
    UIImage *tabbarimage=[[UIImage imageNamed:@"home-10.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    //tabBarBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;//效果将按原图原来的比例缩放
    tabBarBackgroundImageView.image =tabbarimage;
    [self.tabBar insertSubview:tabBarBackgroundImageView atIndex:1]; //atIndex决定你的图片显示在标签栏的哪一层
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 添加所有子控制器
- (void)setUpChildViewControllers
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 
    NSArray *childViewControllers = @[
                                      @{keyClass:@"CameraViewController",
                                        keyTtitle:NSLocalizedString(@"Camera", nil),
                                        keyBtitle:NSLocalizedString(@"Camera", nil),
                                        keyNimage:@"tabbar_camera",
                                        keySimage:@"tabbar_cameraclick"},
                                      
                                      @{keyClass:@"PhotoViewController",
                                        keyTtitle:NSLocalizedString(@"Picture", nil),
                                        keyBtitle:NSLocalizedString(@"Picture", nil),
                                        keyNimage:@"tabbar_pictures",
                                        keySimage:@"tabbar_picturesclick"},
                                      
                                      @{keyClass:@"VideoViewController",
                                        keyTtitle:NSLocalizedString(@"Video", nil),
                                        keyBtitle:NSLocalizedString(@"Video", nil),
                                        keyNimage:@"tabbar_video",
                                        keySimage:@"tabbar_videoclick"},
                                      
                                      @{keyClass:@"AboutViewController",
                                        keyTtitle:NSLocalizedString(@"About", nil),
                                        keyBtitle:NSLocalizedString(@"About", nil),
                                        keyNimage:@"tabbar_about",
                                        keySimage:@"tabbar_aboutclick"}
                                      ];
    
    
    [childViewControllers enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        [self setUpController:dict[keyClass] Title:dict[keyTtitle] ItemTitle:dict[keyBtitle] Image:dict[keyNimage] SelectImage:dict[keySimage]];
        
    }];//@enumerateObjectsUsingBlock

}//@setUpChildViewControllers


/**
 *  将所有的子控制器包装成导航控制器
 *
 *  @param vc                   控制器
 *  @param title                控制器的标题
 *  @param itemTitle            tabbarItem 的标题
 *  @param imageName                正常图片
 *  @param selectImageName          选中图片
 */

- (void)setUpController:(NSString *)class Title:(nullable NSString *)title ItemTitle:(NSString *)itemTitle Image:(NSString *)imageName SelectImage:(NSString *)selectImageName {
    
    UIViewController *vc = [[NSClassFromString(class) alloc] init];
    
    
    HXNavigationController *HXNaVc = [[HXNavigationController alloc] initWithRootViewController:vc];
    //设置导航栏背景图片
    /*
    UIImage *bgImage = [self imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] size:CGSizeMake(self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [HXNaVc.navigationBar setBackgroundImage:[bgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    */
    
    //添加阴影图片，用来隐藏导航栏底部线条
    /*
    UIImage *shadowImage = [self imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0] size:CGSizeMake(self.tabBar.frame.size.width, 1)];
    [HXNaVc.navigationBar setShadowImage:shadowImage];
    */
    
    //导航栏上title字体的颜色
    //    HXNaVc.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
//    HXNaVc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //导航栏上字体的颜色，不包括title
    //    HXNaVc.navigationBar.tintColor = [UIColor redColor];
    //    HXNaVc.navigationBar.backgroundColor = [UIColor redColor];
    
    //设置统一的返回按钮样式,设置返回按钮图片和文字偏移,图片设置拉伸变形厉害，暂未使用
    //UIBarMetricsCompact 只显示文字
    //    UIImage *backImage = [UIImage imageNamed:@"back_white.png"];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundVerticalPositionAdjustment:CGFLOAT_MIN forBarMetrics:UIBarMetricsDefault];//调整返回图片上下移动
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
//    LOG(@">>>>>>>> title:%@, itemtitle:%@", title, itemTitle)
    
        vc.title = title;//与navigationItem.title效果相同
//        vc.navigationItem.title = title;
    
    vc.tabBarItem.title = itemTitle;
    
    //不知为何，设置vc.tabBarItem.title不生效，需设置nvc.tabBarItem.title 才有效果 20160711
//    HXNaVc.tabBarItem.title = itemTitle;

    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    
//        vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //selectedImage支持iOS7以后的系统
//    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem图片位置
//    CGFloat offset = 5.0f;
//    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    
    

    
    [self addChildViewController:HXNaVc];
    
}


/*
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
    
}
 */


#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
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
