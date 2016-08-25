//
//  WifiSetViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/19.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WifiSetViewController.h"
#import "VideoSetCell.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "GUAAlertView.h"
#import "HiSmartLink.h"
#import "SinVoiceData.h"

@interface WifiSetViewController ()
<GUAAlertViewDelegate>
{
    NSTimer* pTimer;
    BOOL isSinVioce;

}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) NSString *wifissid;
@property (nonatomic, copy) NSString *wifipassword;
@property (nonatomic, strong) UIProgressView* progressView;
@property (nonatomic, strong) GUAAlertView *progerssAlertView;

@property (nonatomic, strong) SinVoiceData *sinVoice;


@end

@implementation WifiSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[INTERSTR(@"SSID"), INTERSTR(@"Password")];
    }
    return _titles;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.titles.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoCellID";
    VideoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[VideoSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    if (section == 0) {
        
        cell.tfieldDetail.delegate = self;
        cell.tfieldDetail.tag = row;
        
        cell.textLabel.text = self.titles[row];
        
        if (row == 0) {
            cell.tfieldDetail.text = [self getDeviceSSID];
        }
        
        if (row == 1) {
            cell.tfieldDetail.placeholder = self.titles[row];
        }
        
        
    }//@section == 0
    
    if (section == 1) {
        [cell.tfieldDetail removeFromSuperview];
        
        cell.textLabel.text = INTERSTR(@"Set");
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }//@section == 1
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //close keyboard
    [self.view endEditing:YES];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if(section == 1) {
        if (row == 0) {
            
            NSLog(@"didSelectRowAtIndexPath  wifiSmart");
            
            
            _wifissid = [self getDeviceSSID];
            _wifissid = [_wifissid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _wifipassword = [_wifipassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            
            if (_wifissid == nil || [_wifissid length] == 0) {
                
                [HXProgress showText:INTERSTR(@"SSID can not be empty")];
                return;
            }
            
            if (_wifipassword == nil || [_wifipassword length] == 0) {
                
                [HXProgress showText:INTERSTR(@"Password can not be empty")];
                return;
            }
            
            
            if (SystemVersion >= 8.0) {
                [self presentAlertTitle:INTERSTR(@"Warning") message:INTERSTR(@"Do you hear the sound from camera?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
                    
                    [self showSinVoiceAlertView];
                    [self startSinVoice];
                    [self startSmartConfig];
                    
                    
                } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
                    
                }];

            }
            else {
                [self presentAlertViewBeforeIOS8];
            }
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [self presentAlertViewBeforeIOS8];
//                
//            });


            
            
        }//row == 0
        
    }//section == 1

}


#pragma mark - UIAlertViewDelegate
- (void)presentAlertViewBeforeIOS8 {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:INTERSTR(@"Warning") message:INTERSTR(@"Do you hear the sound from Device?") delegate:self cancelButtonTitle:INTERSTR(@"No") otherButtonTitles:INTERSTR(@"Yes"), nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"buttonIndex:%ld", buttonIndex);
    
    if (buttonIndex == 1) {
        [self showSinVoiceAlertView];
        [self startSinVoice];
        [self startSmartConfig];
    }
    
}





- (void) showSinVoiceAlertView {
    //    isSmart = 1;
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    
    _progerssAlertView = [GUAAlertView alertViewWithTitle:NSLocalizedString(@"Please wait for connect", @"")  view:_progressView
                                             buttonTitle:NSLocalizedString(@"Cancel", @"")
                                     buttonTouchedAction:^{
                                         NSLog(@"button touched");
                                     } dismissAction:^{
                                         
                                         NSLog(@"dismiss");
                                         
                                     }];
    [_progerssAlertView show];
    //    [progerssAlertView setTag:0];
    _progerssAlertView.clickeddelegate = self;
    
    pTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressMethod:) userInfo:nil repeats:YES];
}


- (void)progressMethod : (id)sender {
    
    NSLog(@"progressMethod");
    
    _progressView.progress += 1.0f/SMART_WIFI_TIME;
    
    if (_progressView.progress >= 1) {

    //if (_progressView.progress >= 1 || !isSinVioce) {
        [pTimer invalidate];
        
        [self.navigationController popViewControllerAnimated:YES];

        if (_progressView.progress >= 1 ) {
            [_progerssAlertView dismiss];
            
            if (_setwifiBlock) {
                _setwifiBlock(YES, 0);
            }
            
            //[self.delegate WifiInfo:nil password:nil];
            
        }
    }
}


- (void)clickedButtonAtIndex:(int)index {
    if (index == 0) {
        
        [pTimer invalidate];
        [self stopSinVoice];
    }
}


- (void)startSinVoice {
    [self.sinVoice startSinVoice];
}

- (void)stopSinVoice {
    [self.sinVoice stopSinVoice];
}

- (SinVoiceData *)sinVoice {
    if (!_sinVoice) {
        
        LOG(@"_wifissid:%@, _wifipassword:%@", _wifissid, _wifipassword)
        _sinVoice = [[SinVoiceData alloc] initWithSSID:_wifissid KEY:_wifipassword];
    }
    return _sinVoice;
}


- (void)startSmartConfig {
    HiStartSmartConnection(_wifissid.UTF8String, _wifipassword.UTF8String);
}

- (void)stopSmartConfig {
    
    HiStopSmartConnection();
}


- (NSString *) getDeviceSSID {
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    
    NSDictionary *dctySSID = (NSDictionary *)info;
    //    NSString *ssid = [[dctySSID objectForKey:@"SSID"] lowercaseString];
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    return ssid;
    
}



#pragma mark - 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 0) {
        _wifissid = textField.text;
    }
    
    if (textField.tag == 1) {
        _wifipassword = textField.text;
    }
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
