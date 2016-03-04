//
//  BBMainFeedController.m
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMainFeedController.h"
#import "BBMainFeedPagesView.h"
#import "BBNavigationController.h"

#import "BBReplyController.h"

#import "BBPostController.h"

#import "BBPersonalityController.h"

#import "BBPostDetailsView.h"

#import "BBFacade.h"
#import "BBMainFeedModel.h"

#import "BBApplicationSettings.h"
#import "KeychainItemWrapper.h"

#import "MgmtUtils.h"
#import "LogUtils.h"

#import "UIKit+Extensions.h"

#import <CoreText/CoreText.h>
#import "BBPostCell.h"
#import "BBPostCellFooterView.h"
#import "BBPostCellButton.h"

@interface BBMainFeedController () <BBMainFeedPagesViewDelegate,
                                    BBPostControllerDelegate>
{
    UIView *_emptyView;
    BBMainFeedModel *_mainFeedModel;
}

@property (strong, nonatomic, readonly) UITableViewController *embeddedController;
@property (strong, nonatomic, readonly) BBMainFeedPagesView *pagesView;
@property (strong, nonatomic, readonly) BBMainFeedPagesView *pagesViewTop;

@property (strong, nonatomic, readwrite) UIRefreshControl *refresher;
@property (strong, nonatomic, readwrite) UILabel *loadingLabel;
@property (strong, nonatomic, readwrite) UIView *loadingView;
@property (strong, nonatomic, readwrite) UIButton *titleButton;
@property (strong, nonatomic, readwrite) UIBarButtonItem *globalButton;

- (void)assembleNavigationBar;
- (void)onPostButton:(UIButton *)sender;
- (void)refreshPosts;

@end

@implementation BBMainFeedController

#pragma mark -
#pragma mark lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _mainFeedModel = (BBMainFeedModel *)self.tableViewModel;
    _mainFeedModel.delegate = self;
    
    // Table view
    // To use the refresh view, we have to embed a table view controller
    _embeddedController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:_embeddedController];
    self.tableView = _embeddedController.tableView;
    self.tableView.frame = self.view.frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postCell"];
    
    // Enable tap to scroll
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
    // Init refresh view (pull to update)
    _refresher = [UIRefreshControl new];
    _refresher.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _refresher.tintColor = [[BBFacade sharedInstance] currentBoardColor];
    [_refresher addTarget:self
                       action:@selector(refreshPosts)
             forControlEvents:UIControlEventValueChanged];
    
    // Loading view
    _loadingView = [UIView new];
    _loadingView.backgroundColor = [UIColor whiteColor];
    _loadingView.frame = self.view.bounds;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    loadingLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - self.navigationController.navigationBar.frame.size.height);
    loadingLabel.text = @"Loading posts...";
    loadingLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.font = [BBApplicationSettings fontForKey:kFontLoading];
    
    [_loadingView addSubview:loadingLabel];
    
    [self.view addSubview:_loadingView];
    
    // Init paginator
    _pagesView = [[BBMainFeedPagesView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kPagesViewHeight)];
    _pagesView.backgroundColor = [UIColor whiteColor];
    _pagesView.currentIndex = _mainFeedModel.pageNumber;
    _pagesView.pageDelegate = self;

    _pagesViewTop = [[BBMainFeedPagesView alloc  ]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kPagesViewHeight)];
    _pagesViewTop.backgroundColor = [UIColor whiteColor];
    _pagesViewTop.pageDelegate = self;
    
    // Get count of pages, used for paginator
    [self getCount];
    
    _emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Hide empty cells
    [self.tableView setTableFooterView:_emptyView];
    
    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Delay enabling of global button so board isn't accidentally switched
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector: @selector(enableGlobalButton)
                                   userInfo:nil
                                    repeats:NO];
    [self resetRefreshView];
}

- (void)setRefreshControl:(UIRefreshControl *)refreshControl
{
    // We need to add it to embedded controller
    _refreshControl = refreshControl;
    _embeddedController.refreshControl = _refreshControl;
}

- (void)resetView
{
    [super resetView];
    [self reloadView];
}

- (void)enableGlobalButton
{
    _globalButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _globalButton.enabled = NO;
}

- (void)refreshPosts
{
    // Close any expanded cell
    [self.tableView beginUpdates];
    self.expandedPostIndex = -1;
    [self.tableView endUpdates];
    
    [_mainFeedModel updateDataForced:YES];
}

- (void)reloadView
{
    if (_mainFeedModel.hasData)
    {
        [self hideLoadingView];
    }
    else
    {
        [self showLoadingView];
    }
    [self layoutPagesView];
//    
//    if ([self.tableView numberOfRowsInSection:0] == 0)
//    {
        [self.tableView reloadData];
//    }
//    else
//    {
//        for (NSIndexPath *path in [self.tableView indexPathsForVisibleRows])
//        {
//            BBPost *oldPost = [_mainFeedModel.oldPosts objectAtIndex:path.row];
//            BBPost *newPost = [[_mainFeedModel getPostDictionary] objectForKey:oldPost.UID];
//            NSArray *actions = [oldPost actionsForUpdatedPost:newPost];
//            if ([actions count] > 0) {
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
//            }
//            BBPostCell *cell = (BBPostCell *)[self.tableView cellForRowAtIndexPath:path];
//            for (NSNumber *number in actions)
//            {
//                BBPostAction action = [number intValue];
//                [cell flashForAction:action];
//            }
//        }
//    }
}

#pragma mark -
#pragma mark UITableViewDelegate callbacks

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBPost *post = [_mainFeedModel objectAtIndex:indexPath.row];
    return [BBPostCell heightForCellWithPost:post expanded:(indexPath.row == self.expandedPostIndex) showParent:NO];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mainFeedModel numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBPost *post = [_mainFeedModel objectAtIndex:indexPath.row];
    BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    
    [cell formatWithPost:post showParent:NO];
    cell.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark private

- (void)layoutPagesView
{
    _pagesViewTop.pages = _pagesView.pages;
    _pagesViewTop.currentIndex = _pagesView.currentIndex;
    
    if(_mainFeedModel.hasData == NO)
    {
        if (_mainFeedModel.pageNumber == 1)
        {
            [self.tableView setTableHeaderView:_emptyView];
            [self.tableView setTableFooterView:_emptyView];
        }
        else
        {
            [self.tableView setTableHeaderView:_pagesViewTop];
            [self.tableView setTableFooterView:_emptyView];
        }
        [self disableRefreshing];
    }
    else
    {
        if (_mainFeedModel.pageNumber == 1)
        {
            [self.tableView setTableHeaderView:_emptyView];
            [self.tableView setTableFooterView:_pagesView];
            [self enableRefreshing];
        }
        else
        {
            [self.tableView setTableHeaderView:_pagesViewTop];
            [self.tableView setTableFooterView:_pagesView];
            [self disableRefreshing];
        }
        // If there aren't enough posts for multiple pages
        if (_mainFeedModel.numberOfObjects < 50)
        {
            [self.tableView setTableFooterView:_emptyView];
        }
    }
    
    
    [self updateViewConstraints];
}

- (void)assembleNavigationBar
{
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                          target:self action:@selector(onPostButton:)];

    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setTitle:[[BBFacade sharedInstance] currentBoardName] forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [_titleButton sizeToFit];

    UIButton *iconButton = [UIButton new];
    [iconButton setImage:[UIImage imageNamed:@"global_button.png"] forState:UIControlStateNormal];
    iconButton.frame = CGRectMake(0, 0, 35, 25);
    iconButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    iconButton.adjustsImageWhenDisabled = NO;
    [iconButton addTarget:self action:@selector(onSwitchButton:)forControlEvents:UIControlEventTouchUpInside];
    _globalButton = [[UIBarButtonItem alloc] initWithCustomView:iconButton];

    // Set distance from left edge
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = -5.0f;
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationItem setRightBarButtonItem:postButtonItem];
    [self.navigationItem setTitleView:_titleButton];
    [self.navigationItem setLeftBarButtonItems:@[spaceButton, _globalButton]];

    // Hide back button text in pushed views
    self.navigationItem.title = @"";
    
}

- (void)getCount
{
    _pagesView.pages = 100;
}

- (void)showLoadingView
{
    _loadingView.hidden = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)hideLoadingView
{
    _loadingView.hidden = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)enableRefreshing
{
    if (self.refreshControl == nil)
    {
        self.refreshControl = _refresher;
    }
}

- (void)disableRefreshing
{
    if (self.refreshControl != nil)
    {
        [_refresher endRefreshing];
        self.refreshControl = nil;
    }
}

- (void)resetRefreshView
{
    [_refresher endRefreshing];
}

#pragma mark -
#pragma mark GUI callbacks

- (void)onPostButton:(UIButton *)sender
{
    UINavigationController *postWrapper = [BBNavigationController new];
    [postWrapper.navigationBar setTranslucent:NO];
    
    BBPostController *postController = [BBPostController new];
    postController.delegate = self;
    
    [postWrapper pushViewController:postController animated:NO];
    
    [self presentViewController:postWrapper animated:YES completion:nil];
}

- (void)onSwitchButton:(UIButton *)sender
{
    [[BBFacade sharedInstance] cancelAllRequests];
    [[BBFacade sharedInstance] toggleBoards];

    [_mainFeedModel clearData];
    self.expandedPostIndex = -1;
    [self layoutPagesView];
    
    [self.tableView reloadData];
    
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{} completion:^(BOOL finished)
    {
        self.navigationController.navigationBar.barTintColor = [[BBFacade sharedInstance] currentBoardColor];
        [_titleButton setTitle:[[BBFacade sharedInstance] currentBoardName] forState:UIControlStateNormal];
        [_titleButton sizeToFit];
        [self showLoadingView];
        [_mainFeedModel updateDataForced:YES];
    }];
    
    //Scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    
    // This will make the application delegate change the tab bar color
    if ([_delegate respondsToSelector:@selector(mainFeedControllerDidSwitchServers:)])
    {
        [_delegate mainFeedControllerDidSwitchServers:self];
    }
}

#pragma mark -
#pragma mark BBPostControllerDelegate callbacks

- (void)postControllerDidReceiveDone:(BBPostController *)controller
{
    // Navigate to first page
    if (_mainFeedModel.pageNumber > 1)
    {
        _mainFeedModel.pageNumber = 1;
        [self layoutPagesView];
    }
    
    // Scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    // Refresh posts, update table
    [_mainFeedModel setPosts:controller.posts];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postControllerDidReceiveCancel:(BBPostController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark BBMainFeedPageView callbacks

- (void)pagesViewClickonPage:(NSInteger)page
{
    self.expandedPostIndex = -1;
    _pagesView.currentIndex = page;
    _mainFeedModel.pageNumber = page;
    
    // Scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.tableView reloadData];
    [self reloadView];
}

#pragma mark - 
#pragma mark BBMainFeedModelCallbacks

- (void)modelDidUpdateData:(id)model
{
    [self reloadView];
    
    if (_refresher)
    {
        [_refresher endRefreshing];
    }
    
    if (_mainFeedModel.pageNumber == 0 || _mainFeedModel.pageNumber == 1)
    {
        if ([_delegate respondsToSelector:@selector(mainFeedControllerDidLoadFirstPage:)])
        {
            [_delegate mainFeedControllerDidLoadFirstPage:self];
        }
    }
}

@end
