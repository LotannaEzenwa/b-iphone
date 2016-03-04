//
//  BBNotificationController.m
//  Boredat
//
//  Created by David Pickart on 7/17/15.
//  Copyright (c) BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBFacade.h"
#import "BBNotificationController.h"
#import "BBNotificationAggregate.h"
#import "BBNotificationDetailsCell.h"
#import "BBNotificationModel.h"
#import "BBReplyController.h"
#import "BBPersonalityController.h"
#import "BBUserImageFetcher.h"

@interface BBNotificationController ()
{
    BBNotificationModel *_notificationModel;
}

@property (strong, nonatomic, readonly) UITableViewController *embeddedController;
@property (strong, nonatomic, readwrite) UILabel *loadingLabel;
@property (strong, nonatomic, readwrite) UIView *loadingView;
@property (strong, nonatomic, readwrite) BBNotificationStatistics *statistics;

- (void)onNotificationsUpdated;

@end

@implementation BBNotificationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _notificationModel = (BBNotificationModel *)self.tableViewModel;
    _notificationModel.delegate = self;
    
    // If we want to use the refresh view, we have to embed a table view controller
    _embeddedController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:_embeddedController];
    self.tableView = _embeddedController.tableView;
    self.tableView.frame = self.view.frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[BBNotificationDetailsCell class] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postCell"];
    
    // No post selected or expanded yet
    self.selectedPostIndex = -1;
    self.expandedPostIndex = -1;
    
    // Loading view
    _loadingView = [UIView new];
    _loadingView.backgroundColor = [UIColor clearColor];
    _loadingView.frame = self.view.bounds;
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    _loadingLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - self.navigationController.navigationBar.frame.size.height);
    _loadingLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.font = [BBApplicationSettings fontForKey:kFontLoading];
    
    [_loadingView addSubview:_loadingLabel];
    
    [self.view addSubview:_loadingView];
    
    // Hide empty cells
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:emptyView];
    
    // Enable tap to scroll
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _loadingView.hidden = NO;
    _loadingLabel.text = @"Loading notifications...";
    
    if (_notificationModel.hasData)
    {
        _loadingView.hidden = YES;
    }
    else
    {
        [_notificationModel updateDataForced:YES];
    }
    
    [self.tableView reloadData];
}

- (void)assembleNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: @"Notifications" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];
    
    [self.navigationItem setTitleView:titleButton];
    
    // Hide back button text in pushed views
    self.navigationItem.title = @"";
}

- (void)onNotificationsUpdated
{
    if ([_notificationModel numberOfObjects] == 0)
    {
        _loadingLabel.text = @"No notifications to show.";
    }
    else
    {
        _loadingView.hidden = YES;
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate callbacks

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = floor(indexPath.row / 2.0f);
    BBNotificationAggregate *notification = [_notificationModel objectAtIndex:index];
    
    // Every other cell is a details cell
    if (indexPath.row % 2 == 0)
    {
        return [BBNotificationDetailsCell heightForCellWithNotification:notification];
    }
    else
    {
        BBPost *post = notification.post;
        if (post == nil)
        {
            return 0.0f;
        }
        else
        {
            return [BBPostCell heightForCellWithPost:post expanded:(indexPath.row == self.expandedPostIndex) showParent:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPostIndex = floor(indexPath.row / 2);
    BBNotificationAggregate *notification = [_notificationModel objectAtIndex:self.selectedPostIndex];
    BBPost *post = notification.post;
    if (post != nil)
    {
        // Expand post by clicking on post, or vote details
        NSInteger expandIndex = indexPath.row;
        if (expandIndex % 2 == 0)
        {
            expandIndex = expandIndex + 1;
        }
        [self expandCellAtIndex:expandIndex];
    }
    else if (notification.profileViews > 0)
    {
        // Show profile for profile views
        BBPersonality *personality = [BBPersonality new];
        personality.personalityName = [BBFacade sharedInstance].user.personalityName;
        [self presentPersonalityControllerWithPersonality:personality];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // For each descriptor cell and post cell
    return [_notificationModel numberOfObjects] * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = floor(indexPath.row / 2.0f);
    BBNotificationAggregate *notification = [_notificationModel objectAtIndex:index];
    
    // Every other cell is a details cell
    if (indexPath.row % 2 == 0)
    {
        BBNotificationDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        [cell formatWithNotification:notification];
        return cell;
    }
    else
    {
        BBPost *post = notification.post;
        BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
        
        [cell formatWithPost:post showParent:YES];
        cell.delegate = self;
        
        return cell;
    }
}

#pragma mark -
#pragma mark BBTableViewController overrides

// Overridden because post index is different than usual (used for scrolling to bottom)
- (NSInteger)lastIndex
{
    return ([self.tableViewModel numberOfObjects] * 2) - 1;
}

// Overridden because post needs to be obtained from aggregate
- (void)replyControllerDidInteract:(BBReplyController *)controller
{
    if (self.selectedPostIndex >= 0)
    {
        // Update table with changes to post
        BBNotificationAggregate *notification = [_notificationModel objectAtIndex:self.selectedPostIndex];
        notification.post = [controller getPost];
        [_notificationModel replaceObjectAtIndex:self.selectedPostIndex withObject:notification];
        [self.tableView reloadData];
    }
}

// Overridden because post needs to be obtained from aggregate
- (void)tapOnAvatarwithPostCell:(id)cell
{
    NSInteger postIndex = [self.tableView indexPathForCell:cell].row / 2;
    BBNotificationAggregate *notification = [_notificationModel objectAtIndex:postIndex];
    BBPost *post = notification.post;
    
    BBPersonality *personality = [[BBPersonality alloc] initWithPost:post];
    
    [self presentPersonalityControllerWithPersonality:personality];
}

// Overridden because post index is different than usual
- (void)completeAction:(BBPostAction)action withPostCell:(id)cell
{
    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
    NSInteger replaceIndex = cellPath.row / 2;
    [_notificationModel completeAction:action forObjectAtIndex:replaceIndex];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cellPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [(BBPostCell *)[self.tableView cellForRowAtIndexPath:cellPath] flashForAction:action];
}

// Overridden because post needs to be obtained from aggregate
- (void)postCellDidPressReply:(id)cell
{
    BBNotificationAggregate *aggregate = [_notificationModel objectAtIndex:self.selectedPostIndex];
    [self presentReplyControllerWithPost:aggregate.post];
}

#pragma mark -
#pragma mark BBNotificationRetrieverDelegate callbacks

- (void)modelDidUpdateData:(id)model
{
    [self onNotificationsUpdated];
}

@end