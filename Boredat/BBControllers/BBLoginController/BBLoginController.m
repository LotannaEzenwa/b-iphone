//
//  BBLoginController.m
//  Boredat
//
//  Created by Dmitry Letko on 1/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBAccountCreationController.h"
#import "BBAccountManager.h"
#import "BBApplicationSettings.h"
#import "BBFacade.h"

#import "BBLoadingIndicator.h"
#import "BBLoginController.h"
#import "BBLoginButton.h"
#import "BBLoginView.h"
#import "BBRegistrationController.h"
#import "BBEmailVerificationController.h"
#import "BBPINEntryController.h"

#import "MgmtUtils.h"
#import "LogUtils.h"

#import "UIKit+Extensions.h"
#import <CoreText/CoreText.h>


@interface BBLoginController () <BBLoginViewDelegate, BBRegistrationControllerDelegate>
{
    BOOL _keyboardShown;
    
    BBLoginView *_loginView;
    
    UIImageView *_logoImageView;
    BBLoadingIndicator *_loadingIndicator;
}

@property (strong, nonatomic, readwrite) NSTimer *timeoutTimer;

- (void)authenticateWithUserID:(NSString *)userID password:(NSString *)password block:(void (^)(NSError *error))block;

- (void)showConnectingViewWithCompletion:(void (^)(void))completion;
- (void)hideConnectingViewWithCompletion:(void (^)(void))completion;

- (void)onKeyboardWillShow:(NSNotification *)notification;
- (void)onKeyboardWillHide:(NSNotification *)notification;

-(void)resetWithError:(NSError *)error;

@end

@implementation BBLoginController


#pragma mark -
#pragma mark lifecycle

- (void)loadView
{
    _facade = [BBFacade sharedInstance];
    
    UIView *view = [UIView new];
    view.backgroundColor = [BBApplicationSettings colorForKey:kColorLoginBackground];
    view.frame = [UIScreen mainScreen].bounds;
    
    // Logo
    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    [view addSubview:_logoImageView];
    
    // Login and connecting view
    _loginView = [BBLoginView new];
    _loginView.delegate = self;
    
    [view addSubview:_loginView];
    
    _loadingIndicator = [BBLoadingIndicator new];
    [view addSubview:_loadingIndicator];

    [self setView:view];
    
    [self configureLayoutConstraints];
}

- (void)configureLayoutConstraints
{
    [_logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_loginView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_loadingIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];

    // logo label constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:-30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.8
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_logoImageView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.66
                                                           constant:0.0f]];
     // login view constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loginView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loginView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_logoImageView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loginView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loginView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_logoImageView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:(2.2/3)
                                                           constant:0.0f]];
    
    
    // Connecting label constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingIndicator
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:0.8
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingIndicator
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingIndicator
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:30.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingIndicator
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:30.0f]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_loginView reset];
    _loginView.hidden = NO;
    [_loginView setAlpha:1.0];
    _keyboardShown = NO;
    _loadingIndicator.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Check if there's a current user stored
    NSString *userID = [BBAccountManager currentUserID];
    NSString *password = nil;
    if (userID != nil)
    {
        password = [BBAccountManager currentPassword];
    }
    
    //If login info was stored, attempt login
    if (userID != nil && password != nil)
    {
        // First of all, paste info into login view
        _loginView.login = userID;
        _loginView.password = password;

        _loginView.hidden = YES;
        
        [self showConnectingViewWithCompletion:^{
            [self attemptLoginWithUserID:userID password:password];
        }];
    }
    else
    {
        [self hideConnectingViewWithCompletion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark -
#pragma mark private

- (void)showConnectingViewWithCompletion:(void (^)(void))completion
{
    [self fadeOutView:_loginView duration:kFadeDurationDefault completion:^{
        [self fadeInView:_loadingIndicator duration:kFadeDurationDefault completion:^{
            if (completion != nil)
            {
                completion();
            }
        }];
    }];
}

- (void)hideConnectingViewWithCompletion:(void (^)(void))completion
{
    [self fadeOutView:_loadingIndicator duration:kFadeDurationDefault completion:^{
        [self fadeInView:_loginView duration:kFadeDurationDefault completion:^{
            if (completion != nil)
            {
                completion();
            }
        }];
    }];
}

- (void)attemptLoginWithUserID:(NSString *)userID password:(NSString *)password
{
    // Timeout timer
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(didTimeout) userInfo:nil repeats:NO];
    
    [self showConnectingViewWithCompletion:^{

        [self authenticateWithUserID:userID password:password block:^(NSError *error) {
            if (error != nil)
            {
                [self resetWithError:error];
            }
            else
            {
                // Stop timeout timer
                [_timeoutTimer invalidate];
                
                // Will create user if doesn't exist
                [BBAccountManager addAccountToCurrentUserWithUserID:userID andPassword:password];
                [_delegate loginControllerDidLoginSuccessfully:self];
            }
        }];
    }];

}

- (void)authenticateWithUserID:(NSString *)userID password:(NSString *)password block:(void (^)(NSError *error))block
{
    [_facade loginWithUserID:userID password:password block:^(NSError *error) {
        if (error == nil)
        {
            [_facade userInfoWithBlock:^(BBUser *user, NSError *error1) {
                if (error1 == nil)
                {
                    block(error1);
                }
            }];
        }
        else
        {
            if (block != nil)
            {
                block(error);
            }
        }
    }];
    
}

- (void)didTimeout
{
    [self hideConnectingViewWithCompletion:^{
        [_facade cancelAllRequests];
        [self showAlertViewWithMessage:@"Request timed out"];
    }];
}

- (void)resetWithError:(NSError *)error
{
    // Clear stored password
    [self hideConnectingViewWithCompletion:^{
        [_facade cancelAllRequests];
        [self showAlertViewWithError:error];
        [BBAccountManager clearCurrentUser];
    }];
}

#pragma mark -
#pragma mark

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Hide keyboard view if other areas are touched
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark notification callbacks

- (void)onKeyboardWillShow:(NSNotification *)notification
{
    
    // Move up view to see fields / button
    UIView *firstResponder = [self.view findFirstResponder];
    
    if (firstResponder != nil && _keyboardShown == NO)
    {
        _keyboardShown = YES;
        NSDictionary *userInfo = notification.userInfo;
        NSValue *kFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        const CGFloat keyboardHeight = CGRectGetHeight(kFrameEndValue.CGRectValue);
        const CGFloat loginViewMaxY =  CGRectGetMinY(_loginView.frame) + CGRectGetMaxY(_loginView.loginButton.frame) + 20;
        const CGFloat totalHeight = CGRectGetMaxY(self.view.frame);
        const CGFloat overlap = loginViewMaxY - (totalHeight - keyboardHeight);

        if (overlap > 0.0f)
        {
            NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];

            const double duration = durationValue.doubleValue;
            const CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, - overlap);
            
            [UIView animateWithDuration:duration animations:^{
                self.view.transform = transform;
            }completion:nil];
        }
    }
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    UIView *view = self.view;
    _keyboardShown = NO;
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    const double duration = durationValue.doubleValue;
    
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformIdentity;
    }completion:nil];
}

#pragma mark -
#pragma mark BBLoginViewDelegate callbacks

- (void)loginViewDidClickOnLogin:(BBLoginView *)loginView
{
    if (loginView.filled == YES)
    {
        NSString *userID = loginView.login;
        NSString *password = loginView.password;
        
        NSDictionary *user = [BBAccountManager userWithUserID:userID];
        
        if (user != nil) {
            [BBAccountManager setCurrentUser:user];
            userID = [BBAccountManager currentUserID];
            password = [BBAccountManager currentPassword];
            [self attemptLoginWithUserID:userID password:password];
        }
        else
        {
            [self attemptLoginWithUserID:userID password:password];
        }
    }
}

- (void)loginViewDidClickOnRegister:(BBLoginView *)loginView
{
    // Show registration controller
    BBEmailVerificationController *controller = [BBEmailVerificationController new];
    controller.delegate = self;
    
    [self.navigationController pushViewControllerWithFade:controller];
}

- (void)loginViewDidClickOnAbout:(BBLoginView *)loginView
{
//    // Show registration controller
//    BBRegistrationController *controller = [BBRegistrationController new];
//    controller.delegate = self;
//    controller.headerText = @"About b@";
//    controller.text = [BBApplicationSettings infoTextAbout];
//    
//    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark -
#pragma mark BBRegistrationControllerDelegate callbacks

- (void)registrationControllerDidClickOnBack:(id)controller
{
    // Hide registration controller
    [self.navigationController popViewControllerWithFade:controller];
}

@end
