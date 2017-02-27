//
//  TKTweetTableCell.m
//  TweetsSearch
//
//  Created by Tanya on 11.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//

#import "TKTweetTableCell.h"

@implementation TKTweetTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 4.0;
    self.backView.layer.cornerRadius = 4.0;
    self.tweetTextView.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

@end
