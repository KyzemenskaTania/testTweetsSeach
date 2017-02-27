//
//  TKTweet.m
//  TweetsSearch
//
//  Created by Tanya on 11.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//

#import "TKTweet.h"

@implementation TKTweet
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tweetsText": @"text",
             @"userName": @"user.name",
             @"userPhoto": @"user.profile_image_url_https"
            };
    
}


@end
