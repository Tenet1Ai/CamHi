//
//  CameraListViewController.h
//  CamHi
//
//  Created by HXjiang on 16/7/18.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "ViewController.h"

@protocol CameraListDelegate <NSObject>

@optional
- (void)didSelectCamera:(NSString *)uid;


@end


@interface CameraListViewController : ViewController

@property (nonatomic, assign) id<CameraListDelegate> delegate;

@end
