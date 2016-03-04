//
//  BBSettingsController.h
//  Boredat
//
//  Created by David Pickart on 2/24/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"

@class BBFacade;
@class BBHeartbeatModel;
@class BBUserImageFetcher;
@class BBSettingsController;

@protocol BBSettingsControllerDelegate <NSObject>

- (void)settingsControllerDidClickOnLogout:(BBSettingsController *)controller;
- (void)settingsControllerDidSwitchAccounts:(BBSettingsController *)controller;

@end

@interface BBSettingsController : BBViewController

@property (weak, nonatomic, readwrite) id<BBSettingsControllerDelegate> delegate;
@property (strong, nonatomic, readwrite) BBHeartbeatModel *heartbeatModel;

@end
