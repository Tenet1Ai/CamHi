//
//  SinVoiceData.h
//  CamHi
//
//  Created by zhao qi on 16/4/6.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>




#define MAX_PACK 10

@interface SinVoiceData : NSObject

- (id)initWithSSID:(NSString*)ssid KEY:(NSString*)key;


//- (id)init;
- (void)setSSID:(NSString*)ssid KEY:(NSString*)key;


- (void) startSinVoice;
- (void) stopSinVoice;


@end
