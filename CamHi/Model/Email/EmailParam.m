
//
//  EmailParam.m
//  CamHi
//
//  Created by HXjiang on 16/8/11.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "EmailParam.h"

@implementation EmailParam

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        HI_P2P_S_EMAIL_PARAM_EXT *model = (HI_P2P_S_EMAIL_PARAM_EXT *)malloc(sizeof(HI_P2P_S_EMAIL_PARAM_EXT));
        memset(model, 0, sizeof(HI_P2P_S_EMAIL_PARAM_EXT));
        memcpy(model, data, size);
        
        
        _u32Channel     = model->u32Channel;
        _u32Port        = model->u32Port;
        _u32Auth        = model->u32Auth;
        _u32LoginType   = model->u32LoginType;
        _u32Check       = model->u32Check;
        
        _strSvr         = [NSString stringWithUTF8String:model->strSvr];
        _strUsernm      = [NSString stringWithUTF8String:model->strUsernm];
        _strPasswd      = [NSString stringWithUTF8String:model->strPasswd];
        _strFrom        = [NSString stringWithUTF8String:model->strFrom];
        _strTo          = [NSString stringWithUTF8String:model->strTo[0]];
        _strSubject     = [NSString stringWithUTF8String:model->strSubject];
        _strText        = [NSString stringWithUTF8String:model->strText];
        _strReserved    = [NSString stringWithUTF8String:model->strReserved];
        
        free(model);
    }
    return self;
}




- (HI_P2P_S_EMAIL_PARAM_EXT *)checkModel {
    
    HI_P2P_S_EMAIL_PARAM_EXT *t_model = (HI_P2P_S_EMAIL_PARAM_EXT *)malloc(sizeof(HI_P2P_S_EMAIL_PARAM_EXT));
    memset(t_model, 0, sizeof(HI_P2P_S_EMAIL_PARAM_EXT));
    
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Port        = _u32Port;
    t_model->u32Auth        = _u32Auth;
    t_model->u32LoginType   = _u32LoginType;
    t_model->u32Check       = 1;
    
    
    [self memcopy:t_model->strSvr obj:_strSvr length:64];
//    memset(t_model->strSvr, 0, 64);
//    char* strSvr = (char *)[_strSvr UTF8String];
//    memcpy(t_model->strSvr, strSvr, strlen(strSvr));
    
    [self memcopy:t_model->strUsernm obj:_strUsernm length:64];
//    memset(email_param->strUsernm, 0, 64);
//    char* userName = (char *)[textFieldUserName.text UTF8String];
//    memcpy(email_param->strUsernm, userName, strlen(userName));

    [self memcopy:t_model->strPasswd obj:_strPasswd length:64];
//    memset(email_param->strPasswd, 0, 64);
//    char* password = (char *)[textFieldPassword.text UTF8String];
//    memcpy(email_param->strPasswd, password, strlen(password));

    
    [self memcopy:t_model->strTo[0] obj:_strTo length:64];
//    memset(email_param->strTo[0], 0, 64);
//    char* strTo = (char *)[textFieldSendTo.text UTF8String];
//    memcpy(email_param->strTo[0], strTo, strlen(strTo));

    
    [self memcopy:t_model->strFrom obj:_strFrom length:64];
//    memset(email_param->strFrom, 0, 64);
//    char* strFrom = (char *)[textFieldSender.text UTF8String];
//    memcpy(email_param->strFrom, strFrom, strlen(strFrom));

    [self memcopy:t_model->strSubject obj:_strSubject length:128];
//    memset(email_param->strSubject, 0, 128);
//    char* strSubject = (char *)[textFieldSubject.text UTF8String];
//    memcpy(email_param->strSubject, strSubject, strlen(strSubject));

    [self memcopy:t_model->strText obj:_strText length:256];
//    memset(email_param->strText, 0, 256);
//    char* strText = (char *)[_textMessage.text UTF8String];
//    memcpy(email_param->strText, strText, strlen(strText));

    return t_model;
}

- (HI_P2P_S_EMAIL_PARAM *)model {
    
    HI_P2P_S_EMAIL_PARAM *t_model = (HI_P2P_S_EMAIL_PARAM *)malloc(sizeof(HI_P2P_S_EMAIL_PARAM));
    memset(t_model, 0, sizeof(HI_P2P_S_EMAIL_PARAM));
    
    
    t_model->u32Channel     = _u32Channel;
    t_model->u32Port        = _u32Port;
    t_model->u32Auth        = _u32Auth;
    t_model->u32LoginType   = _u32LoginType;
    
    
    [self memcopy:t_model->strSvr obj:_strSvr length:64];
    [self memcopy:t_model->strUsernm obj:_strUsernm length:64];
    [self memcopy:t_model->strPasswd obj:_strPasswd length:64];
    [self memcopy:t_model->strTo[0] obj:_strTo length:64];
    [self memcopy:t_model->strFrom obj:_strFrom length:64];
    [self memcopy:t_model->strSubject obj:_strSubject length:128];
    [self memcopy:t_model->strText obj:_strText length:256];
    
    return t_model;
}


- (void)memcopy:(char *)copyer obj:(NSString *)str length:(int)len {
    memset(copyer, 0, len);
    char *strcopy = (char *)[str UTF8String];
    memcpy(copyer, strcopy, strlen(strcopy));
}


- (NSString *)connectionType {
    
    NSString *type = @"Unknown";
    switch (_u32Auth) {
        case 0:
            type = @"None";
            break;
            
        case 1:
            type = @"SSL";
            break;
            
        case 2:
            type = @"TLS";
            break;
            
        case 3:
            type = @"STARTTLS";
            break;
            
        default:
            break;
    }

    return type;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@", _strText, _strSubject, _strFrom, _strTo, _strPasswd, _strUsernm, _strSvr, _strReserved];
}


@end
