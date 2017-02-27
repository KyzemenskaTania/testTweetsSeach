//
//  TKServerManager.m
//  TweetsSearch
//
//  Created by Tanya on 08.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//
#import "AFNetworking.h"
#import "TKServerManager.h"
#import "TKSearchTweetsViewController.h"
#import "TKTweet.h"
#import <Mantle/Mantle.h>

@interface TKServerManager ()
    
@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong,nonatomic) NSString *nextTweets;
    
@end

@implementation TKServerManager
    

+ (TKServerManager*) sharedManager {
    
    static TKServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    manager = [[TKServerManager alloc] init];
    NSURL *baseURL = [NSURL URLWithString:@"https://api.twitter.com"];
        NSString *quaryString = [manager ecodingString];
    manager.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [manager.sessionManager.requestSerializer setValue:quaryString forHTTPHeaderField:@"Authorization"];
    [manager.sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

});

    return manager;
}
- (void)getSearchTweets:(NSString *)tweets
              onSuccess:(void (^)(NSArray *))success
              onFailure:(void (^)(NSError *))failure{
    
    NSString *path = @"/1.1/search/tweets.json";
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     tweets, @"q",nil];
    [self.sessionManager GET:path
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id response) {
                         NSError *error;
                         NSDictionary *responseDictionary =  [response objectForKey:@"search_metadata" ];
                         self.nextTweets = [responseDictionary objectForKey:@"next_results"];
                         NSArray *responseArray =  [response objectForKey:@"statuses" ];
                         NSArray *tweetsArray = [MTLJSONAdapter modelsOfClass:[TKTweet class] fromJSONArray:responseArray error:&error];
                           success(tweetsArray);
                        
                        }failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         NSLog(@"Failure: %@", error);
                     }];
}

- (void)loadingNextTweets:(void (^)(NSArray *))success
                onFailure:(void (^)(NSError *))failure{
    
    NSString *path = [NSString stringWithFormat:@"/1.1/search/tweets.json%@",
                                                                            self.nextTweets];
        [self.sessionManager GET:path
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id response) {
                         NSError *error;
                         NSDictionary *responseDictionary =  [response objectForKey:@"search_metadata" ];
                         self.nextTweets = [responseDictionary objectForKey:@"next_results"];
                         NSArray *responseArray =  [response objectForKey:@"statuses" ];
                         NSArray *tweetsArray = [MTLJSONAdapter modelsOfClass:[TKTweet class] fromJSONArray:responseArray error:&error];
                         success(tweetsArray);
                         
                     }failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         NSLog(@"Failure: %@", error);
                     }];
}

- (void)postAuthorization :(void (^)(NSArray *))success
                       onFailure:(void (^)(NSError *))failure{
    
    NSString *path = @"/oauth2/token";
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
    @"client_credentials",@"grant_type",nil];
    [self.sessionManager POST:path
                   parameters:params
                      success:^(NSURLSessionDataTask *task, id response) {
                          TKServerManager *manager = [TKServerManager sharedManager];
                          NSString *receivedString = [response objectForKey:@"access_token"];
                          NSString *quaryString = [ NSString stringWithFormat:@"Bearer %@",receivedString];
                          [manager.sessionManager.requestSerializer setValue:quaryString forHTTPHeaderField:@"Authorization"];
                         
                     }failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         NSLog(@"Failure: %@", error);
                     }];
}

-(NSString *)ecodingString{
    NSString *consumerKey = @"5pn3EiWfjwULJjeGr2AgJ0Vqq";
    NSString *consumerSecret = @"HmNJ9Fd1G6LAeLIMzurJgKj30KEUpvTONU17SXDuv68FTHHPLb";
    NSString *summ = [ NSString stringWithFormat:@"%@:%@",consumerKey,consumerSecret];
    NSData *encodindString = [summ dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodindString base64EncodedStringWithOptions:0];
    NSString *quaryString = [ NSString stringWithFormat:@"Basic %@",base64String];
    return  quaryString;
    
}
    


@end
