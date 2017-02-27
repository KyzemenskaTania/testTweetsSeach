//
//  TKTweetTableCell.h
//  TweetsSearch
//
//  Created by Tanya on 11.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TKTweetTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
