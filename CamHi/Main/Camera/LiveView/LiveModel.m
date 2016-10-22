//
//  LiveModel.m
//  CamHi
//
//  Created by HXjiang on 16/9/22.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel

+ (instancetype)modelWithNormalImage:(NSString *)normalImg selectImage:(NSString *)selectImg normalSel:(SEL)normalSelector selectSel:(SEL)selectSelector {

    LiveModel *live = [[LiveModel alloc] init];
    
    live.normalImgName = normalImg;
    live.selectImgName = selectImg;
    live.normalSelector = normalSelector;
    live.selectSelector = selectSelector;
    
    return live;
}


@end
