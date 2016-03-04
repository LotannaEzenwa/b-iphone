//
//  BBRegistrationController.h
//  Boredat
//
//  Created by David Pickart on 12/3/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBViewController.h"

@protocol BBRegistrationControllerDelegate <NSObject>

- (void)registrationControllerDidClickOnBack:(id)controller;

@end

@interface BBRegistrationController : BBViewController <BBRegistrationControllerDelegate>

@property (weak) id<BBRegistrationControllerDelegate> delegate;

@property (nonatomic) NSString *headerText;
@property (nonatomic) NSString *text;

@property UILabel *titleLabel;
@property UITextView *textView;
@property UILabel *flashLabel;
@property UIButton *backButton;

- (void)flashErrorMessage:(NSString *)message;
- (void)flashSuccessMessage:(NSString *)message;

@end