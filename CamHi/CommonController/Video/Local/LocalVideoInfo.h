//
//  LocalVideoInfo.h
//  KncAngel
//
//  Created by zhao qi on 15/8/29.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalVideoInfo : NSObject

- (id)initWithID:(NSString*)path Time:(NSInteger)time;


@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) NSInteger time;


@end
