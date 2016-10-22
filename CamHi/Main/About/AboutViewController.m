//
//  AboutViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UILabel *labAppName;
@property (nonatomic, strong) UILabel *labAppVersion;
@property (nonatomic, strong) UILabel *labSDKVersion;


@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat UISCREEN_W = self.view.frame.size.width;
    
    // information of NSBundle
    NSDictionary *informationDic = [NSBundle mainBundle].infoDictionary;
    
    // App Name
    self.labAppName = [[UILabel alloc] initWithFrame:CGRectMake(0, 102, UISCREEN_W, 24)];
    self.labAppName.font = [UIFont systemFontOfSize:19];
    self.labAppName.text = [informationDic objectForKey:@"CFBundleDisplayName"];
    self.labAppName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labAppName];
    
    // App Version
    self.labAppVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, 133, UISCREEN_W, 20)];
    self.labAppVersion.font = [UIFont systemFontOfSize:17];
    self.labAppVersion.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Version", nil), [informationDic objectForKey:@"CFBundleShortVersionString"]];
    self.labAppVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labAppVersion];
    
    // SDK Version
    self.labSDKVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, 162, UISCREEN_W, 20)];
    self.labSDKVersion.font = [UIFont systemFontOfSize:17];
    self.labSDKVersion.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SDK Version", nil), [HiChipSDK getSDKVersion]];
    self.labSDKVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labSDKVersion];
    
    
    //    self.labSDKVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, 162, UISCREEN_W, 20)];
    //    self.labSDKVersion.font = [UIFont systemFontOfSize:17];
    //    self.labSDKVersion.text = [NSString stringWithFormat:@"%@ %s", NSLocalizedString(@"SDK Version", nil), [Camera instanceVersion]];
    //    self.labSDKVersion.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:self.labSDKVersion];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
