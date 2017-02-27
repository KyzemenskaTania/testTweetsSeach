//
//  TKTweet.h
//  TweetsSearch
//
//  Created by Tanya on 11.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TKTweet : MTLModel <MTLJSONSerializing>
@property(strong,nonatomic) NSString *tweetsText;
@property(strong,nonatomic) NSString *userName;
@property(strong,nonatomic) NSString *userPhoto;

+(NSDictionary *)JSONKeyPathsByPropertyKey;

@end
