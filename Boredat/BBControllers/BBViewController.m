//
//  BBViewController.m
//  Boredat
//
//  Created by David Pickart on 29/10/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBViewController.h"
#import "BBPersonality.h"
#import "BBPersonalityController.h"
#import "BBPost.h"
#import "BBReplyController.h"

@interface BBViewController () <BBReplyControllerDelegate>

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [[BBFacade sharedInstance] currentBoardColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Personality Displays

- (void)presentPersonalityControllerWithPersonality:(BBPersonality *)personality
{
    BBPersonalityController *controller = [[BBPersonalityController alloc] initWithPersonality:personality];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

# pragma mark Reply Displays

- (void)presentReplyControllerWithPost:(BBPost *)post
{
    BBReplyController *controller = [[BBReplyController alloc] initWithPost:post];
    controller.delegate = self;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentReplyControllerWithPostAtURL:(NSURL *)url
{
    BBPost *post = [BBPost new];
    post.UID = [url.absoluteString componentsSeparatedByString:@"/post/"][1];
    [self presentReplyControllerWithPost:post];
}

- (void)replyControllerDidInteract:(BBReplyController *)controller
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"replyControllerDidInteract method needs to be overridden"
                                 userInfo:nil];
}

@end
