//
//  SetDownload.m
//  CamHi
//
//  Created by HXjiang on 16/8/13.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SetDownload.h"

@implementation SetDownload



- (HI_P2P_S_SET_DOWNLOAD *)model {
    
    HI_P2P_S_SET_DOWNLOAD *t_model = (HI_P2P_S_SET_DOWNLOAD *)malloc(sizeof(HI_P2P_S_SET_DOWNLOAD));
    memset(t_model, 0, sizeof(HI_P2P_S_SET_DOWNLOAD));
    
    
    t_model->u32Channel     = _u32Channel;
    
    NSInteger len = _sFileName.length > HI_DOWN_PATH_LEN ? HI_DOWN_PATH_LEN : _sFileName.length;
    [self memcopy:t_model->sFileName obj:_sFileName length:(int)len];
    
    return t_model;
}


- (void)memcopy:(char *)copyer obj:(NSString *)str length:(int)len {
    memset(copyer, 0, len);
    char *strcopy = (char *)[str UTF8String];
    memcpy(copyer, strcopy, len);
}

@end
