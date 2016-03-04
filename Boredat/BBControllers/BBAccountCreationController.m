//
//  BBAccountCreationController.m
//  Boredat
//
//  Created by David Pickart on 12/21/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBAccountCreationController.h"
#import "BBApplicationSettings.h"
#import "BBFacade.h"
#import "BBLoginButton.h"
#import "BBLoginTextField.h"
#import "BBPINEntryController.h"
#import "BBVerificationButton.h"
#import "UIKit+Extensions.h"

@interface BBAccountCreationController () <UITextFieldDelegate>

@property (nonatomic) BBVerificationState verificationState;

@property UILabel *infoLabel;
@property BBLoginTextField *usernameField;
@property BBLoginTextField *passwordField;
@property UIView *fieldBackgroundView;
@property BBVerificationButton *verifyButton;
@property BBLoginButton *continueButton;


@end

@implementation BBAccountCreationController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.verificationState = kVerificationStateUnverified;
        self.username = @"";
        self.attempt_code = @"";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.headerText = @"Create Account";
    
    // Username label
    _infoLabel = [UILabel new];
    _infoLabel.text = @"Choose a username and password:";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [BBApplicationSettings fontForKey:kFontRegistrationInfoText];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textColor = [BBApplicationSettings colorForKey:kColorGlobalGrayDark];
    
    // Username input field
    _usernameField = [BBLoginTextField new];
    _usernameField.font = [BBApplicationSettings fontForKey:kFontLoginField];
    _usernameField.placeholder = @"Username";
    _usernameField.returnKeyType = UIReturnKeyNext;
    _usernameField.delegate = self;
    [_usernameField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    // Password input field
    _passwordField = [BBLoginTextField new];
    _passwordField.font = [BBApplicationSettings fontForKey:kFontLoginField];
    _passwordField.placeholder = @"Password";
    _passwordField.secureTextEntry = YES;
    _passwordField.returnKeyType = UIReturnKeyGo;
    _passwordField.delegate = self;
    [_passwordField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    _fieldBackgroundView = [UIView new];
    _fieldBackgroundView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.02].CGColor;
    _fieldBackgroundView.layer.borderWidth = 4;
    _fieldBackgroundView.backgroundColor = [UIColor whiteColor];
    _fieldBackgroundView.layer.cornerRadius = 3;
    [_fieldBackgroundView addSlightShadow];
    
    // Verify button
    _verifyButton = [BBVerificationButton new];
    [_verifyButton addTarget:self action:@selector(onVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Continue button
    _continueButton = [BBLoginButton new];
    [_continueButton addTarget:self action:@selector(onContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    [_continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    _continueButton.hidden = YES;
    
    [self.view addSubview:_fieldBackgroundView];
    [self.view addSubview:_infoLabel];
    [self.view addSubview:_usernameField];
    [self.view addSubview:_passwordField];
    [self.view addSubview:_verifyButton];
    [self.view addSubview:_continueButton];
    
    [self configureExtraConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_usernameField becomeFirstResponder];
}

- (void)configureExtraConstraints
{
    [_infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_usernameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_verifyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_fieldBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_continueButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat fieldAndButtonMargins = (0.2 * screenWidth)/2;
    CGFloat fieldAndButtonSpace = 10.0f;
    
    
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
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:fieldAndButtonMargins]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-fieldAndButtonMargins]];
    
    // username input field
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:fieldAndButtonMargins]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_infoLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_verifyButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:-fieldAndButtonSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_usernameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0f
                                                           constant:kLoginFieldHeight]];
    
    // password input field
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:20.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
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
                                                             toItem:_passwordField
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_verifyButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-fieldAndButtonMargins]];
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
    // field background view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fieldBackgroundView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fieldBackgroundView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_passwordField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fieldBackgroundView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_usernameField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:-10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fieldBackgroundView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_verifyButton
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
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

- (void)createAccount
{
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    
    // Check to see if username is an email
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^.+@.+\\.edu$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:username options:0 range:NSMakeRange(0, [username length])];
    
    if (match != nil)
    {
        [self flashErrorMessage:@"Username should not be an email address."];
    }
    else
    {
        // Atttempt to create account
        self.verificationState = kVerificationStateVerifying;
        
        [[BBFacade sharedInstance] createUserWithID:username password:password block:^(NSString *attempt_code, NSError *error) {
            if (error != nil)
            {
                self.verificationState = kVerificationStateUnverified;
                [self flashErrorMessage:error.localizedDescription];
            }
            else
            {
                _username = username;
                _attempt_code = attempt_code;
                self.verificationState = kVerificationStateVerified;
                [self flashSuccessMessage:@"Username created!"];
            }
        }];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate callbacks

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == _usernameField) && [_passwordField canBecomeFirstResponder])
    {
        return [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField && [_passwordField canResignFirstResponder])
    {
        [_passwordField resignFirstResponder];
        [self createAccount];
    }
    return NO;
}

- (void)textFieldDidChange:(id)sender
{
    // If username or password is changed, unverify
    if (_verificationState != kVerificationStateUnverified)
    {
        _username = @"";
        _attempt_code = @"";
        self.verificationState = kVerificationStateUnverified;
    }
}

#pragma mark -
#pragma mark GUI callbacks

- (void)onVerifyButton:(id)sender
{
    if (self.verificationState != kVerificationStateVerified && _usernameField.text.length > 0 && _passwordField.text.length > 0)
    {
        [self createAccount];
    }
}

- (void)onContinueButton:(id)sender
{
    BBPINEntryController *controller = [BBPINEntryController new];
    controller.delegate = self;
    controller.email = _email;
    controller.username = _username;
    controller.attempt_code = _attempt_code;
    [self.navigationController pushViewControllerWithFade:controller];
}

#pragma mark -
#pragma mark Getters and Setters

- (void)setVerificationState:(BBVerificationState)verificationState
{
    if (_verificationState != verificationState)
    {
        _verificationState = verificationState;
        _verifyButton.verificationState = verificationState;
        
        if (_verificationState == kVerificationStateVerified)
        {
            self.flashLabel.hidden = YES;
            [self fadeInView:_continueButton duration:kFadeDurationDefault completion:nil];
        }
        else if (_verificationState == kVerificationStateUnverified)
        {
            [self fadeOutView:_continueButton  duration:kFadeDurationDefault completion:nil];
        }
    }
}

@end
