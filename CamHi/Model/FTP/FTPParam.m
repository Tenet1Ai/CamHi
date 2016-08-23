//
//  FTPParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/12.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "FTPParam.h"

@implementation FTPParam

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_FTP_PARAM_EXT *model = (HI_P2P_S_FTP_PARAM_EXT *)malloc(sizeof(HI_P2P_S_FTP_PARAM_EXT));
        memset(model, 0, sizeof(HI_P2P_S_FTP_PARAM_EXT));
        memcpy(model, data, size);
        
        
        _u32Channel     = model->u32Channel;
        _u32Port        = model->u32Port;
        _u32Mode        = model->u32Mode;
        _u32CreatePath  = model->u32CreatePath;
        _u32Check       = model->u32Check;
        
        _strSvr         = [NSString stringWithUTF8String:model->strSvr];
        _strUsernm      = [NSString stringWithUTF8String:model->strUsernm];
        _strPasswd      = [NSString stringWithUTF8String:model->strPasswd];
        _strFilePath    = [NSString stringWithUTF8String:model->strFilePath];
        _strReserved    = [NSString stringWithUTF8String:model->strReserved];
        
        free(model);
    }
    return self;
}


- (HI_P2P_S_FTP_PARAM_EXT *)model {
    
    HI_P2P_S_FTP_PARAM_EXT *t_model = (HI_P2P_S_FTP_PARAM_EXT *)malloc(sizeof(HI_P2P_S_FTP_PARAM_EXT));
    memset(t_model, 0, sizeof(HI_P2P_S_FTP_PARAM_EXT));
    
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Port        = _u32Port;
    t_model->u32Mode        = _u32Mode;
    t_model->u32CreatePath  = _u32CreatePath;
    t_model->u32Check       = _u32Check;
    
    
    [self memcopy:t_model->strSvr obj:_strSvr length:64];
    [self memcopy:t_model->strUsernm obj:_strUsernm length:64];
    [self memcopy:t_model->strPasswd obj:_strPasswd length:64];
    [self memcopy:t_model->strFilePath obj:_strFilePath length:256];
    [self memcopy:t_model->strReserved obj:_strReserved length:8];

    return t_model;
}


- (void)memcopy:(char *)copyer obj:(NSString *)str length:(int)len {
    memset(copyer, 0, len);
    char *strcopy = (char *)[str UTF8String];
    memcpy(copyer, strcopy, strlen(strcopy));
}


@end
