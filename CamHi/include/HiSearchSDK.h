//
//  HiSearchSDK.h
//  CamHi
//
//  Created by zhao qi on 16/7/14.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol OnSearchResult <NSObject>
@optional

- (void)searchResult:(NSMutableArray *)array;

@end



@interface HiSearchResult : NSObject
{
    NSString* uid;
    NSString* ip;
    NSInteger port;
    NSString* name;
    NSString* version;
}

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;

- (id)initWithUid:(NSString*)uid_ Ip:(NSString *)ip_ Port:(NSInteger)port_ Name:(NSString *)name_ Version:(NSString *)version_;


@end





@interface HiSearchSDK : NSObject
{
    NSMutableArray* deviceList;
    id<OnSearchResult> delegate;
}

- (id)init;


@property (atomic, retain) NSMutableArray* deviceList;
@property (nonatomic, assign) id<OnSearchResult> delegate;


-(void) search;





@end
