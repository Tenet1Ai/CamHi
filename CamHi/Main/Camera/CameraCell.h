//
//  CameraCell.h
//  CamHi
//
//  Created by HXjiang on 16/7/14.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELLH   (80/1.5+10)

@interface CameraCell : UITableViewCell

@property (nonatomic, strong) UIImageView *snapImgView;
@property (nonatomic, strong) UIImageView *alarmImgView;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UILabel *labUid;


@end
