//
//  base64.h
//  HiCam
//
//  Created by zhao qi on 15/3/4.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#ifndef HiCam_hi_base64_h
#define HiCam_hi_base64_h

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */


void base64Encode(char *intext, char *output);
int base64decode(const unsigned char *input, int input_length, unsigned char *output);
    
#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

    
    
#endif
