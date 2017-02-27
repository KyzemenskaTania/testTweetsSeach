//
//  TKServerManager.h
//  TweetsSearch
//
//  Created by Tanya on 08.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSearchTweetsViewController.h"

@interface TKServerManager : NSObject

+ (TKServerManager*) sharedManager;

- (void)getSearchTweets:(NSString *)tweets
             onSuccess:(void (^)(NSArray *))success
             onFailure:(void (^)(NSError *))failure;
    
- (void)postAuthorization:(void (^)(NSArray *))success
                onFailure:(void (^)(NSError *))failure;

- (void)loadingNextTweets:(void (^)(NSArray *))success
                onFailure:(void (^)(NSError *))failure;

-(NSString *)ecodingString;

@end
