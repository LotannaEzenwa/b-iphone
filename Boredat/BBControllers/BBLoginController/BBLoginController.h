//
//  BBLoginController.h
//  Boredat
//
//  Created by Dmitry Letko on 1/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "KeychainItemWrapper.h"
#import "BBViewController.h"

@class BBLoginController;
@class BBFacade;

@protocol BBLoginControllerDelegate <NSObject>

- (void)loginControllerDidLoginSuccessfully:(BBLoginController *)controller;

@end

@interface BBLoginController : BBViewController

@property (strong, nonatomic, readwrite) BBFacade *facade;
@property (weak, nonatomic, readwrite) id<BBLoginControllerDelegate> delegate;

@end
