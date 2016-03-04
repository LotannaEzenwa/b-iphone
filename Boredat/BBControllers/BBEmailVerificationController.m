//
//  BBEmailVerificationController.m
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBAccountCreationController.h"
#import "BBApplicationSettings.h"
#import "BBEmailVerificationController.h"
#import "BBFacade.h"
#import "BBNetwork.h"
#import "BBNetworkInfoView.h"
#import "BBVerificationButton.h"
#import "BBLoginButton.h"
#import "BBLoginTextField.h"
#import "UIKit+Extensions.h"

@interface BBEmailVerificationController () <UITextFieldDelegate>

@property (nonatomic) BBVerificationState verificationState;
@property (nonatomic) BBNetwork *network;
@property UILabel *emailLabel;
@property BBLoginTextField *emailField;
@property BBVerificationButton *verifyButton;
@property BBNetworkInfoView *networkInfoView;

@property BBLoginButton *continueButton;

@end

@implementation BBEmailVerificationController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.verificationState = kVerificationStateUnverified;
        self.email = @"";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.verificationState = kVerificationStateUnverified;
    
    self.headerText = @"Sign Up";
    
    // Email label
    _emailLabel = [UILabel new];
    _emailLabel.text = @"Enter a valid \".edu\" email address:";
    _emailLabel.font = [BBApplicationSettings fontForKey:kFontRegistrationInfoText];
    _emailLabel.textAlignment = NSTextAlignmentCenter;
    _emailLabel.numberOfLines = 0;
    _emailLabel.textColor = [BBApplicationSettings colorForKey:kColorGlobalGrayDark];
    
    // Email input field
    _emailField = [BBLoginTextField new];
    _emailField.font = [BBApplicationSettings fontForKey:kFontLoginField];
    _emailField.placeholder = @"you@school.edu";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.returnKeyType = UIReturnKeyGo;
    _emailField.delegate = self;
    [_emailField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    
    // Verify button
    _verifyButton = [BBVerificationButton new];
    [_verifyButton addTarget:self action:@selector(onVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Network info label
    _networkInfoView = [BBNetworkInfoView new];
    _networkInfoView.backgroundColor = [UIColor clearColor];
    _networkInfoView.hidden = YES;
    
    // Continue button
    _continueButton = [BBLoginButton new];
    [_continueButton addTarget:self action:@selector(onContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    [_continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    _continueButton.hidden = YES;
    
    [self.view addSubview:_emailLabel];
    [self.view addSubview:_emailField];
    [self.view addSubview:_verifyButton];
    [self.view addSubview:_networkInfoView];
    [self.view addSubview:_continueButton];
    
    [self configureExtraConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_emailField becomeFirstResponder];
}

- (void)configureExtraConstraints
{
    [_emailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_verifyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_networkInfoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_continueButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat emailFieldAndButtonMargins = (0.3 * screenWidth)/2;
    CGFloat emailFieldAndButtonSpace = 20.0f;

    
    // email text label
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:40.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:emailFieldAndButtonMargins]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-emailFieldAndButtonMargins]];
    
    // email input field
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:emailFieldAndButtonMargins]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_emailLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_verifyButton
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:-emailFieldAndButtonSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0f
                                                      constant:kLoginFieldHeight]];
    
    // verify button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_verifyButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_emailField
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_verifyButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-emailFieldAndButtonMargins]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_verifyButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0f
                                                           constant:kLoginFieldHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_verifyButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0f
                                                           constant:kLoginFieldHeight]];
    // Network info view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_networkInfoView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_networkInfoView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_emailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_networkInfoView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_continueButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_networkInfoView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
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

#pragma mark -
#pragma mark GUI callbacks

- (void)onVerifyButton:(id)sender
{
    if (self.verificationState != kVerificationStateVerified && _emailField.text.length > 0)
    {
        [self verifyEmail];
    }
}

- (void)onContinueButton:(id)sender
{
    BBAccountCreationController *controller = [BBAccountCreationController new];
    controller.delegate = self;
    controller.email = _email;
    [self.navigationController pushViewControllerWithFade:controller];
}

#pragma mark - 
#pragma mark Engine

- (void)verifyEmail
{
    self.verificationState = kVerificationStateVerifying;

    NSString *email = _emailField.text;
    
    // Check email syntax with regex to start
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^.+@.+\\.edu$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    
    if (match == nil)
    {
        self.verificationState = kVerificationStateUnverified;
        [self flashErrorMessage:@"Invalid address format."];
    }
    else
    {
        // Now verify affiliation with server
        [[BBFacade sharedInstance] networkWithEmail:email block:^(BBNetwork *network, NSError *error) {
            if (error != nil)
            {
                self.verificationState = kVerificationStateUnverified;
                [self flashErrorMessage:error.localizedDescription];
            }
            else
            {
                self.network = network;
                _email = email;
                self.verificationState = kVerificationStateVerified;
            }
        }];
    }
}

#pragma mark - 
#pragma mark UITextFieldDelegate callbacks

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Attempt verification on return
    [self onVerifyButton:nil];
    return NO;
}

- (void)textFieldDidChange:(id)sender
{
    // If email is changed, unverify
    if (_verificationState != kVerificationStateUnverified)
    {
        _email = @"";
        self.verificationState = kVerificationStateUnverified;
    }
}

#pragma mark -
#pragma mark Getters and Setters

- (void)setNetwork:(BBNetwork *)network
{
    _network = network;
    _networkInfoView.networkName = _network.networkName;
}

- (void)setVerificationState:(BBVerificationState)verificationState
{
    if (_verificationState != verificationState)
    {
        _verificationState = verificationState;
        _verifyButton.verificationState = verificationState;
        
        if (_verificationState == kVerificationStateVerified)
        {
            self.flashLabel.hidden = YES;
            [self fadeInViews:@[_networkInfoView, _continueButton]  duration:kFadeDurationDefault completion:nil];
            [self hideKeyboard];
        }
        else if (_verificationState == kVerificationStateUnverified)
        {
            [self fadeOutViews:@[_networkInfoView, _continueButton]  duration:kFadeDurationDefault completion:nil];
        }
        else
        {
            [self hideKeyboard];
        }
    }
}

@end
