//
//  PresetDialog.h
//  CamHi
//
//  Created by HXjiang on 16/8/15.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PresetW     (250)
#define PresetH     (130)

typedef NS_ENUM(NSInteger, PresetType) {
    PresetTypeNone,
    PresetTypeCall,
    PresetTypeSet,
};


@interface PresetDialog : UIView

@property BOOL isShow;
@property (nonatomic, copy) void(^presetBlock)(NSInteger index, PresetType type);


- (void)show;
- (void)dismiss;


@end
