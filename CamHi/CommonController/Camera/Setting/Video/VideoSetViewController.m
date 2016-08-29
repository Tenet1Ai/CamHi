//
//  VideoSetViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/5.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "VideoSetViewController.h"
#import "VideoSetCell.h"

typedef NS_ENUM(NSInteger, TField) {
    TFieldFirstBit,
    TFieldFirstFrame,
    TFieldFirstQuality,
    TFieldSecondBit,
    TFieldSecondFrame,
    TFieldSecondQuality
};


@interface VideoSetViewController ()
{
    BOOL isOK;
}
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UISegmentedControl *tsegment;

@property (nonatomic, strong) __block VideoParam *videoParam1;
@property (nonatomic, strong) __block VideoParam *videoParam2;
@property (nonatomic, strong) __block VideoCode *videoCode;

@end

@implementation VideoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
    
    UIBarButtonItem *rbtnItem = [[UIBarButtonItem alloc] initWithTitle:INTERSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(rbtnItemAction:)];
    self.navigationItem.rightBarButtonItem = rbtnItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    isOK = YES;
    
    [self.camera request:HI_P2P_GET_VIDEO_PARAM1 dson:nil];
    [self.camera request:HI_P2P_GET_VIDEO_PARAM2 dson:nil];
    [self.camera request:HI_P2P_GET_VIDEO_CODE dson:nil];

    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (success) {
            
            if (cmd == HI_P2P_GET_VIDEO_PARAM1) {
                
                weakSelf.videoParam1 = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
                
                LOG(@"dics:%@", dic);
            }
            
            if (cmd == HI_P2P_GET_VIDEO_PARAM2) {
                
                weakSelf.videoParam2 = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
                
                LOG(@"dics:%@", dic);
            }
            
            if (cmd == HI_P2P_GET_VIDEO_CODE) {
                
                weakSelf.videoCode = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
            }

        }
        else {
            [HXProgress showText:NSLocalizedString(@"Command Error!", nil)];
        }
    };

}


- (void)rbtnItemAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!isOK) {
        [HXProgress showText:INTERSTR(@"Please input number!")];
        return;
    }
    
    int iBitRate1 = _videoParam1.u32BitRate;
    if (iBitRate1 < 32 || iBitRate1 >6144) {
        [HXProgress showText:INTERSTR(@"Input First Bit Rate between 30 and 6144")];
        return;
    }
    
    int iFrameRate1 = _videoParam1.u32Frame;
    
    int maxFramRate = _videoCode.u32Frequency == 50 ? 25 : 30;

    if (iFrameRate1 < 1 || iFrameRate1 > maxFramRate) {
        if (maxFramRate == 25) {
            [HXProgress showText:INTERSTR(@"Input First Frame Rate between 1 and 25")];
            return;
        }
        
        if (maxFramRate == 30) {
            [HXProgress showText:INTERSTR(@"Input First Frame Rate between 1 and 30")];
            return;
        }
    }
    
    
    int iQuality1 = _videoParam1.u32Quality;
    if (iQuality1 < 1 || iQuality1 >6) {
        [HXProgress showText:INTERSTR(@"Input First Quality between 1 and 6")];
        return;
    }

    
    int iBitRate2 = _videoParam2.u32BitRate;
    if ([self.camera isGoke]) {
        if (iBitRate2 < 32 || iBitRate2 >2048) {
            [HXProgress showText:INTERSTR(@"Input Second Bit Rate between 32 and 2048")];
            return;
        }
    }
    else {
        if (iBitRate2 < 32 || iBitRate2 >6144) {
            [HXProgress showText:INTERSTR(@"Input Second Bit Rate between 32 and 6144")];
            return;
        }
    }
    
    
    int iFrameRate2 = _videoParam2.u32Frame;
    if (iFrameRate2 < 1 || iFrameRate2 > maxFramRate) {
        if (maxFramRate == 25) {
            [HXProgress showText:INTERSTR(@"Input Second Frame Rate between 1 and 25")];
            return;
        }
        
        if (maxFramRate == 30) {
            [HXProgress showText:INTERSTR(@"Input Second Frame Rate between 1 and 30")];
            return;
        }
    }
    
    
    int iQuality2 = _videoParam2.u32Quality;
    if (iQuality2 < 1 || iQuality2 >6) {
        [HXProgress showText:INTERSTR(@"Input Second Quality between 1 and 6")];
        return;
    }

    
    [self.camera request:HI_P2P_SET_VIDEO_PARAM dson:[self.camera dic:_videoParam1]];
    [self.camera request:HI_P2P_SET_VIDEO_PARAM dson:[self.camera dic:_videoParam2]];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return self.titles.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoCellID";
    VideoSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[VideoSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    cell.tfieldDetail.delegate = self;

    if (section == 0) {
        
        //cell.labTitle.font = [UIFont systemFontOfSize:12];
        cell.labTitle.text = self.titles[row];
        
        if (row == 0) {
            cell.tfieldDetail.tag = TFieldFirstBit;
            cell.tfieldDetail.text = [self text:_videoParam1.u32BitRate];
        }
        
        if (row == 1) {
            cell.tfieldDetail.tag = TFieldFirstFrame;
            cell.tfieldDetail.text = [self text:_videoParam1.u32Frame];
        }
        
        if (row == 2) {
            cell.tfieldDetail.tag = TFieldFirstQuality;
            cell.tfieldDetail.text = [self text:_videoParam1.u32Quality];
        }
        
        
    }//@section == 0
    
    if (section == 1) {
        
        cell.labTitle.text = self.titles[row];
        
        if (row == 0) {
            cell.tfieldDetail.tag = TFieldSecondBit;
            cell.tfieldDetail.text = [self text:_videoParam2.u32BitRate];
        }
        
        if (row == 1) {
            cell.tfieldDetail.tag = TFieldSecondFrame;
            cell.tfieldDetail.text = [self text:_videoParam2.u32Frame];
        }
        
        if (row == 2) {
            cell.tfieldDetail.tag = TFieldSecondQuality;
            cell.tfieldDetail.text = [self text:_videoParam2.u32Quality];
        }

    }//@section == 1
    
    
    
    if (section == 2) {
        cell.labTitle.text = INTERSTR(@"Frequency");
        [cell.tfieldDetail removeFromSuperview];
        [cell.contentView addSubview:self.tsegment];
        self.tsegment.selectedSegmentIndex = _videoCode.u32Frequency == 50 ? 0 : 1;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return (UIView *)[UIImage imageWithColor:RGBA_COLOR(220, 220, 220, 0.5) wihtSize:CGSizeMake(self.view.frame.size.width, 20)];
//}


- (NSString *)text:(int)number {
    return [NSString stringWithFormat:@"%d", number];
}


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[INTERSTR(@"Bit Rate"), INTERSTR(@"Frame rate"), INTERSTR(@"Quality")];
    }
    return _titles;
}


- (UISegmentedControl *)tsegment {
    if (!_tsegment) {
        
        NSArray *items = @[INTERSTR(@"50Hz"), INTERSTR(@"60Hz")];
        
        CGFloat w = 100.0f;
        CGFloat h = 30.0f;
        CGFloat x = self.view.frame.size.width-w/2-20;
        CGFloat y = 44/2;
        _tsegment = [[UISegmentedControl alloc] initWithItems:items];
        _tsegment.frame = CGRectMake(0, 0, w, h);
        _tsegment.center = CGPointMake(x, y);
        _tsegment.tintColor = [UIColor grayColor];
        [_tsegment addTarget:self action:@selector(tsegmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tsegment;
}

- (void)tsegmentAction:(id)sender {
    
    UISegmentedControl *tseg = (UISegmentedControl *)sender;
    
    NSInteger index = tseg.selectedSegmentIndex;
    
    _videoCode.u32Frequency = index == 0 ? 50 : 60;
    
    [self.camera request:HI_P2P_SET_VIDEO_CODE dson:[self.camera dic:_videoCode]];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger tag = textField.tag;
    
    if (tag == TFieldSecondFrame || tag == TFieldSecondQuality) {
        [self offViewWithHeight:(tag+2)*44+64];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![self isPureInt:textField.text]) {
        isOK = NO;
        [HXProgress showText:INTERSTR(@"Please input number!")];
        //[textField becomeFirstResponder];
        return;
    }
    
    isOK = YES;
    NSInteger tag = textField.tag;
    int number = textField.text.intValue;
    
    if (tag == TFieldFirstBit) {
        _videoParam1.u32BitRate = number;
    }
    
    if (tag == TFieldFirstFrame) {
        _videoParam1.u32Frame = number;
    }
    
    if (tag == TFieldFirstQuality) {
        _videoParam1.u32Quality = number;
    }
    
    if (tag == TFieldSecondBit) {
        _videoParam2.u32BitRate = number;
    }
    
    if (tag == TFieldSecondFrame) {
        _videoParam2.u32Frame = number;
    }
    
    if (tag == TFieldSecondQuality) {
        _videoParam2.u32Quality = number;
    }
    
    [self resetView];
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
