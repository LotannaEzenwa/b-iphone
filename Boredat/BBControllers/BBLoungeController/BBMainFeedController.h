//
//  BBMainFeedController.h
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBMainFeedController;
@class BBMainFeedModel;

#import "BBTableViewController.h"

@protocol BBMainFeedControllerDelegate <NSObject>

@optional

- (void)mainFeedControllerDidSwitchServers:(BBMainFeedController *)controller;
- (void)mainFeedControllerDidLoadFirstPage:(BBMainFeedController *)controller;

@end

@interface BBMainFeedController : BBTableViewController

@property (weak, nonatomic, readwrite) id<BBMainFeedControllerDelegate> delegate;

@property (nonatomic, strong, readwrite) UIRefreshControl *refreshControl;

@end
