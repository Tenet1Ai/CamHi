//
//  ModelWhiteLight.m
//  CamHi
//
//  Created by HXjiang on 16/9/23.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "ModelWhiteLight.h"

@implementation ModelWhiteLight

- (id)initWithData:(char *)data size:(int)size {
    if (self = [super init]) {
        
        if (size != sizeof(HI_P2P_WHITE_LIGHT_INFO)) {
            return self;
        }
        
        HI_P2P_WHITE_LIGHT_INFO *white_light = (HI_P2P_WHITE_LIGHT_INFO *)malloc(sizeof(HI_P2P_WHITE_LIGHT_INFO));
        memset(white_light, 0, sizeof(HI_P2P_WHITE_LIGHT_INFO));
        memcpy(white_light, data, size);
        
        self.u32Chn = white_light->u32Chn;
        self.u32State = white_light->u32State;
        self.sReserved = [NSString stringWithUTF8String:(char *)white_light->sReserved];
        
    }
    return self;
}

- (id)initWithData:(char *)data size:(int)size command:(int)cmd {
    
    if (self = [super init]) {
        
        if (cmd == HI_P2P_WHITE_LIGHT_GET_EXT) {
            
            if (size != sizeof(HI_P2P_WHITE_LIGHT_INFO_EXT)) {
                return self;
            }
            
            HI_P2P_WHITE_LIGHT_INFO_EXT *white_light = (HI_P2P_WHITE_LIGHT_INFO_EXT *)malloc(sizeof(HI_P2P_WHITE_LIGHT_INFO_EXT));
            memset(white_light, 0, sizeof(HI_P2P_WHITE_LIGHT_INFO_EXT));
            memcpy(white_light, data, size);
            
            self.u32Chn = white_light->u32Chn;
            self.u32State = white_light->u32State;
            self.sReserved = [NSString stringWithUTF8String:(char *)white_light->sReserved];

        }
        
        
        if (cmd == HI_P2P_WHITE_LIGHT_GET) {
            
            if (size != sizeof(HI_P2P_WHITE_LIGHT_INFO)) {
                return self;
            }
            
            HI_P2P_WHITE_LIGHT_INFO *white_light = (HI_P2P_WHITE_LIGHT_INFO *)malloc(sizeof(HI_P2P_WHITE_LIGHT_INFO));
            memset(white_light, 0, sizeof(HI_P2P_WHITE_LIGHT_INFO));
            memcpy(white_light, data, size);
            
            self.u32Chn = white_light->u32Chn;
            self.u32State = white_light->u32State;
            self.sReserved = [NSString stringWithUTF8String:(char *)white_light->sReserved];

        }
        
        NSLog(@"white_light_u32State : %d", self.u32State);
    }
    
    return self;
}

- (HI_P2P_WHITE_LIGHT_INFO *)model {
    
    HI_P2P_WHITE_LIGHT_INFO *white_light = (HI_P2P_WHITE_LIGHT_INFO *)malloc(sizeof(HI_P2P_WHITE_LIGHT_INFO));
    memset(white_light, 0, sizeof(HI_P2P_WHITE_LIGHT_INFO));

    white_light->u32Chn = self.u32Chn;
    white_light->u32State = self.u32State;
    
    const char *reserved = [self.sReserved UTF8String];
    memcpy(white_light->sReserved, reserved, 4);
    
    
    return white_light;
}

- (HI_P2P_WHITE_LIGHT_INFO_EXT *)modelExt {
    
    HI_P2P_WHITE_LIGHT_INFO_EXT *white_light = (HI_P2P_WHITE_LIGHT_INFO_EXT *)malloc(sizeof(HI_P2P_WHITE_LIGHT_INFO_EXT));
    memset(white_light, 0, sizeof(HI_P2P_WHITE_LIGHT_INFO_EXT));
    
    white_light->u32Chn = self.u32Chn;
    white_light->u32State = self.u32State;
    
    const char *reserved = [self.sReserved UTF8String];
    memcpy(white_light->sReserved, reserved, 4);
    
    
    return white_light;
}


@end
