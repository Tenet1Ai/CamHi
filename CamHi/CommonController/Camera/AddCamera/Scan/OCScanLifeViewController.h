//
//  OCScanLifeViewController.h
//  OcTrain
//
//  Created by HXjiang on 16/3/25.
//  Copyright © 2016年 蒋林. All rights reserved.
//

#import "HXViewController.h"

@protocol OCScanLifeViewControllerDelegate <NSObject>

- (void)scanResult:(NSString *)result;

@end

@interface OCScanLifeViewController : HXViewController

@property (nonnull, retain) id<OCScanLifeViewControllerDelegate> delegate;

@end
