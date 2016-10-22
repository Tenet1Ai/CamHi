//
//  Recording.h
//  CamHi
//
//  Created by HXjiang on 16/8/16.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>


#define RecordingW  (60)
#define RecordingH  (20)

@interface Recording : UIView

@property BOOL isShow;
- (void)show;
- (void)dismiss;

@end
