//
//  OpenGLView20.h
//
//
//  Created by zhao qi on 14-11-27.
//  Copyright (c) 2014年 ouyang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>
//#import "Monitor.h"




@interface HiGLMonitor: UIView

- (void)setYuvFrame:(char*)yuvdata Lenght:(int)lenght Width:(int)width Height:(int)height;
- (void)cleanWithR:(float)r G:(float)g B:(float)b;

@end


