//
//  BBReplyController.h
//  Boredat
//
//  Created by Dmitry Letko on 1/23/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBPost;
@class BBFacade;
@class BBUserImageFetcher;
@class BBReplyController;

#import "BBTableViewController.h"

@protocol BBReplyControllerDelegate <NSObject>

- (void)replyControllerDidInteract:(BBReplyController *)controller;

@end


@interface BBReplyController : BBTableViewController

@property (weak, nonatomic, readwrite) id<BBReplyControllerDelegate> delegate;

- (id)initWithPost:(BBPost *)post;
- (BBPost *)getPost;

@end
