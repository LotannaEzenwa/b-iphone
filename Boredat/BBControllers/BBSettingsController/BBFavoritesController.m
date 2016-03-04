//
//  BBFavoritesController.m
//  Boredat
//
//  Created by David Pickart on 6/24/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBFavoritesController.h"
#import "BBFacade.h"
#import "BBReplyController.h"
#import "BBUserImageFetcher.h"
#import "BBApplicationSettings.h"
#import "BBPostCell.h"
#import "BBInlineWebViewController.h"
#import "BBPersonalityController.h"

@interface BBFavoritesController ()

@property (strong, nonatomic, readwrite) NSArray *posts;
@property (strong, nonatomic, readwrite) UILabel *loadingLabel;
@property (strong, nonatomic, readwrite) UIView *loadingView;

@end

@implementation BBFavoritesController

#pragma mark -
#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _facade = [BBFacade sharedInstance];
    _fetcher = [BBUserImageFetcher sharedInstance];
    
    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postCell"];
    
    // No post selected or expanded yet
    self.selectedPostIndex = -1;
    self.expandedPostIndex = -1;
    
    // Enable tap to scroll
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
    // Loading view
    _loadingView = [UIView new];
    _loadingView.backgroundColor = [UIColor clearColor];
    _loadingView.frame = self.view.bounds;
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    _loadingLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - self.navigationController.navigationBar.frame.size.height);
    _loadingLabel.text = @"Loading favorites...";
    _loadingLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.font = [BBApplicationSettings fontForKey:kFontLoading];
    
    [_loadingView addSubview:_loadingLabel];
    
    [self.view addSubview:_loadingView];

    // Hide empty cells
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:emptyView];

    [self assembleNavigationBar];

    [self updatePosts];
}

- (void)assembleNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: @"Favorites" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
    
    [self.navigationItem setTitleView:titleButton];
    
    // Hide back button text in pushed views
    self.navigationItem.title = @"";
}

- (void)updatePosts
{
    [_facade favoritePostsForPersonalityWithUID:_facade.user.personalityUID block:^(NSArray *posts, NSError *error) {
        if (error != nil)
        {
            [self showAlertViewWithError:error];
        }
        else
        {
            _posts = posts;
            if ([_posts count] > 0) {
                _loadingView.hidden = YES;
            }
            else
            {
                _loadingLabel.text = @"You have no favorite posts.";
            }
            
            [self.tableView reloadData];
        }
    }];
}


#pragma mark -
#pragma mark UITableViewDelegate callbacks

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBPost *post = [_posts objectAtIndex:indexPath.row];
    return [BBPostCell heightForCellWithPost:post expanded:(indexPath.row == self.expandedPostIndex) showParent:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self expandCellAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBPost *post = [_posts objectAtIndex:indexPath.row];
    BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    
    [cell formatWithPost:post showParent:YES];
    cell.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark BBPostHolder required methods

- (void)expandCellAtIndex:(NSInteger)postIndex
{
    if (self.expandedPostIndex != postIndex)
    {
        self.expandedPostIndex = postIndex;
    }
    else
    {
        self.expandedPostIndex = -1;
    }
    
    // Expand or close cell
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    // If last post, scroll to bottom
    if (self.expandedPostIndex == [_posts count] - 1)
    {
        NSIndexPath* path = [NSIndexPath indexPathForRow: [_posts count]-1 inSection: 0];
        [self.tableView scrollToRowAtIndexPath: path atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

#pragma mark -
#pragma mark BBPostCellDelegate

- (void)completeAction:(BBPostAction)action withPostCell:(id)cell
{
    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
    NSInteger replaceIndex = cellPath.row;
    BBPost *post = [_posts objectAtIndex:replaceIndex];
    [post updateForAction:action];
    
    // Replace post array with updated post, update table
    NSMutableArray *newPostArray = [NSMutableArray arrayWithArray:_posts];
    [newPostArray replaceObjectAtIndex:replaceIndex withObject:post];
    
    _posts = [NSArray arrayWithArray: newPostArray];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cellPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [(BBPostCell *)[self.tableView cellForRowAtIndexPath:cellPath] flashForAction:action];
    
    [_facade completePostAction:action onPost:post completion:^(NSError *error) {
         if (error != nil)
         {
             [self showAlertViewWithError:error];
         }
     }];
}

#pragma mark -
#pragma mark BBReplyControllerDelegate callbacks

- (void)replyControllerDidInteract:(BBReplyController *)controller
{
    if (self.selectedPostIndex >= 0)
    {
        // Update table with changes to post
        NSMutableArray *newPostArray = [NSMutableArray arrayWithArray:_posts];
        [newPostArray replaceObjectAtIndex:self.selectedPostIndex withObject:[controller getPost]];
        _posts = [NSArray arrayWithArray: newPostArray];
        [self.tableView reloadData];
    }
}


@end
