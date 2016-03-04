//
//  BBTableViewController.m
//  Boredat
//
//  Created by David Pickart on 29/10/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBReplyController.h"
#import "BBTableViewController.h"
#import "UIKit+Extensions.h"

@import SafariServices;

@interface BBTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BBTableViewController

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        self.mainSection = 0;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.expandedPostIndex = -1;
    self.selectedPostIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // No post selected anymore
    self.selectedPostIndex = -1;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // No post expanded anymore
    self.expandedPostIndex = -1;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    if (self.expandedPostIndex == self.lastIndex)
    {
        [self scrollToBottom];
    }
}

- (void)closeCell
{
    if (self.expandedPostIndex != -1)
    {
        self.expandedPostIndex = -1;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)resetView
{
    self.expandedPostIndex = -1;
    // Scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (void)scrollToBottom
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:self.lastIndex  inSection: self.mainSection];
    [self.tableView scrollToRowAtIndexPath: path atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

// the index of the last table view cell
- (NSInteger)lastIndex
{
    return [self.tableViewModel numberOfObjects]-1;
}

#pragma mark BBModelDelegate required methods

- (void)modelDidUpdateData:(id)model
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBTableViewController method needs to be overridden"
                                 userInfo:nil];
}

- (void)modelDidRecieveError:(id)model error:(NSError *)error
{
    [self showAlertViewWithError:error];
}

#pragma mark BBReplyControllerDelegate required methods

- (void)replyControllerDidInteract:(BBReplyController *)controller
{
    if (self.selectedPostIndex >= 0)
    {
        [self.tableViewModel replaceObjectAtIndex:self.selectedPostIndex withObject:[controller getPost]];
        [self.tableView reloadData];
    }
}

#pragma mark BBPostCellDelegate required methods

- (void)tapOnLink:(NSURL *)url withPostCell:(BBPostCell *)cell
{
    if ([url.absoluteString rangeOfString:@"boredat.com/post/"].length > 0) {
        [self presentReplyControllerWithPostAtURL:url];
    }
    else
    {
        SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)tapOnTextWithPostCell:(BBPostCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tapOnAvatarwithPostCell:(id)cell
{
    NSInteger postIndex = [self.tableView indexPathForCell:cell].row;
    BBPost *post = [self.tableViewModel objectAtIndex:postIndex];
    
    BBPersonality *personality = [[BBPersonality alloc] initWithPost:post];
    
    [self presentPersonalityControllerWithPersonality:personality];
}


- (void)completeAction:(BBPostAction)action withPostCell:(id)cell
{
    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
    [self.tableViewModel completeAction:action forObjectAtIndex:cellPath.row];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cellPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [(BBPostCell *)[self.tableView cellForRowAtIndexPath:cellPath] flashForAction:action];
}

- (void)postCellDidPressReply:(id)cell
{
    self.selectedPostIndex = [self.tableView indexPathForCell:cell].row;
    BBPost *post = [self.tableViewModel objectAtIndex:self.selectedPostIndex];
    [self presentReplyControllerWithPost:post];
}

#pragma mark tableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                reason:@"BBTableViewController method needs to be overridden"
                                userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBTableViewController method needs to be overridden"
                                 userInfo:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self expandCellAtIndex:indexPath.row];
}

@end
