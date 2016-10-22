//
//  LocalVideoInfo.h
//  KncAngel
//
//  Created by zhao qi on 15/8/29.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalVideoInfo : NSObject

//- (id)initWithID:(NSString*)path Time:(NSInteger)time;
- (id)initWithRecordingName:(NSString *)name time:(NSInteger)time type:(NSInteger)type;


@property (nonatomic, copy) NSString *path; // 对应recordingName
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger type;   // 对应的录像类型


@end
