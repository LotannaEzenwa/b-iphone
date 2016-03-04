//
//  BBPostController.h
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBPostController;
@class BBFacade;
@class BBPost;

#import "BBViewController.h"

@protocol BBPostControllerDelegate <NSObject>

- (void)postControllerDidReceiveDone:(BBPostController *)controller;
- (void)postControllerDidReceiveCancel:(BBPostController *)controller;

@end

@interface BBPostController : BBViewController

@property id<BBPostControllerDelegate> delegate;
@property BBFacade *facade;
@property NSArray *posts;

@end
