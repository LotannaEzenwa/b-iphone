//
//  BBAccountSwitcherController.h
//  Boredat
//
//  Created by David Pickart on 4/4/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"

@class BBFacade;
@class BBUserImageFetcher;
@class BBAccountSwitcherController;

@protocol BBAccountSwitcherControllerDelegate <NSObject>
- (void) accountControllerDidSelectAccount:(BBAccountSwitcherController *)controller;
@end

@interface BBAccountSwitcherController : BBViewController

@property (weak, nonatomic, readwrite) id<BBAccountSwitcherControllerDelegate> delegate;
@property (strong, nonatomic, readwrite) BBFacade *facade;

@end
