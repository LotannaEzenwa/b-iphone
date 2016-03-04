//
//  BBPINEntryController.m
//  Boredat
//
//  Created by David Pickart on 12/30/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBFacade.h"
#import "BBLoginButton.h"
#import "BBLoginTextField.h"
#import "BBPINEntryController.h"
#import "BBPINControl.h"
#import "UIKit+Extensions.h"

@interface BBPINEntryController ()

@property UILabel *infoLabel;
@property BBPINControl *PINControl;
@property UIButton *helpButton;
@property BBLoginButton *continueButton;

@end

@implementation BBPINEntryController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.username = @"";
        self.attempt_code = @"";
        self.PIN = @"";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.titleLabel.text = @"Account Recovery";
    
    // Info label
    _infoLabel = [UILabel new];
    _infoLabel.text = @"Choose a password reset PIN:";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [BBApplicationSettings fontForKey:kFontRegistrationInfoText];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textColor = [BBApplicationSettings colorForKey:kColorGlobalGrayDark];
    
    _PINControl = [BBPINControl new];
    [_PINControl addTarget:self action:@selector(onPINControl:) forControlEvents:UIControlEventEditingChanged];
    
    _helpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_helpButton addTarget:self action:@selector(onHelpButton:) forControlEvents:UIControlEventTouchUpInside];
    [_helpButton setTitle:@"[?]" forState:UIControlStateNormal];
    [_helpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _helpButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:8.0f];
    
    // Continue button
    _continueButton = [BBLoginButton new];
    [_continueButton addTarget:self action:@selector(onContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    [_continueButton setTitle:@"Finish" forState:UIControlStateNormal];
    _continueButton.hidden = YES;

    [self.view addSubview:_infoLabel];
    [self.view addSubview:_PINControl];
    [self.view addSubview:_helpButton];
    [self.view addSubview:_continueButton];
    
    [self configureExtraConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self submitPIN];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_PINControl becomeFirstResponder];
}

- (void)configureExtraConstraints
{
    [_infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_PINControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_helpButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_continueButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // text label
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:40.0f]];
    
    // PIN controller view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_PINControl
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_infoLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_PINControl
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_PINControl
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_PINControl
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:kPINControlWidth]];
    
    // Help button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_helpButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_infoLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_helpButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_infoLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_helpButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:10.0f]];
    
    // Continue button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_continueButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_continueButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.backButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_continueButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:kContinueButtonWidthFactor
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_continueButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:kLoginFieldHeight]];
}

- (void)submitPIN
{
    [[BBFacade sharedInstance] registerWithEmail:_email pin:_PIN attempt_code:_attempt_code block:nil];
}


#pragma mark -
#pragma mark GUI callbacks

- (void)onHelpButton:(id)sender
{
    // Show help view
    BBRegistrationController *controller = [BBRegistrationController new];
    controller.delegate = self;
    controller.headerText = @"Password Reset PIN";
    controller.text = [BBApplicationSettings infoTextPIN];
    controller.title = @"About";
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)onPINControl:(id)sender
{
    if (_PINControl.PIN.length == 4)
    {
        _PIN = _PINControl.PIN;
        [self fadeInView:_continueButton duration:kFadeDurationDefault completion:nil];
    }
    else
    {
        if (_continueButton.hidden == NO)
        {
            [self fadeOutView:_continueButton duration:kFadeDurationDefault completion:nil];
        }
    }
}

- (void)onContinueButton:(id)sender
{
    [self submitPIN];
    
    // Show final view
    BBRegistrationController *controller = [BBRegistrationController new];
    controller.delegate = self;
    controller.headerText = @"Email Sent!";
    controller.text = [BBApplicationSettings infoTextCompletion];
    [controller.backButton setTitle:@"Return To Login" forState:UIControlStateNormal];
    [self.navigationController pushViewControllerWithFade:controller];
}

- (void)registrationControllerDidClickOnBack:(id)controller
{
    if ([[(UIViewController *)controller title] isEqualToString:@"About"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popToRootViewControllerWithFade];
    }
}

@end