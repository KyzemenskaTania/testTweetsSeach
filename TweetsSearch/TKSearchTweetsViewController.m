//
//  TKSearchTweetsViewController.m
//  TweetsSearch
//
//  Created by Tanya on 08.02.17.
//  Copyright © 2017 Tanya. All rights reserved.
//
#import "TKServerManager.h"
#import "TKSearchTweetsViewController.h"
#import "AFNetworking.h"
#import "TKTweet.h"
#import "TKTweetTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface TKSearchTweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) NSMutableArray<TKTweet*> *tweetsArray;
@property(strong,nonatomic) NSString *searchBarText;
@property(assign,nonatomic) BOOL isLoadingNextTweets;
@end

@implementation TKSearchTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TKServerManager *manager = [TKServerManager sharedManager];
    [manager postAuthorization:^(NSArray *array){
                   }
                   onFailure:^(NSError *error){
                   }];

    UINib *cellNib = [UINib nibWithNibName:@"TKTweetTableCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TKTweetTableCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
    
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TKTweetTableCell";
    TKTweetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    TKTweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweetTextView.text = tweet.tweetsText;
    cell.nameLabel.text = tweet.userName;
    [cell.avatarImageView sd_setImageWithURL:
           [NSURL URLWithString:tweet.userPhoto] placeholderImage:
           [UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    TKServerManager *manager = [TKServerManager sharedManager];
           [manager getSearchTweets:searchBar.text
                         onSuccess:^(NSArray *array){
                             self.searchBarText = searchBar.text;
                             self.tweetsArray = [NSMutableArray arrayWithArray:array];
                             [self.tableView reloadData];
                             [searchBar resignFirstResponder];
                                                 }
                         onFailure:^(NSError *error){
                         }];
    
}

#pragma mark - NSNotificationCenter

- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;

}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
         self.tableView.contentInset = UIEdgeInsetsZero;
         self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshTable:(UIRefreshControl*) refreshControl{
    TKServerManager *manager = [TKServerManager sharedManager];
    [manager getSearchTweets:self.searchBarText
                   onSuccess:^(NSArray *array){
                        self.tweetsArray = [NSMutableArray arrayWithArray:array];
                       [refreshControl endRefreshing];
                       [self.tableView reloadData];

                   }
                   onFailure:^(NSError *error){
                   }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat difference = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (difference < scrollView.frame.size.height && self.isLoadingNextTweets == NO) {
         [self loadNextTweets];
     }
}

-(void)loadNextTweets{
    self.isLoadingNextTweets = YES;
    TKServerManager *manager = [TKServerManager sharedManager];
    [manager loadingNextTweets:^(NSArray *array){
        [self.tweetsArray addObjectsFromArray:array];
        [self.tableView reloadData];
        self.isLoadingNextTweets = NO;
    }
                     onFailure:^(NSError *error){
                     }];

    
}



@end
