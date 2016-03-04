//
//  BBLoginView.m
//  Boredat
//

#import "BBLoginButton.h"
#import "BBLoginView.h"
#import "BBLoginTextField.h"
#import "MgmtUtils.h"
#import "LogUtils.h"

#import "UIKit+Extensions.h"

#import <QuartzCore/QuartzCore.h>
#import "BBApplicationSettings.h"

@interface BBLoginView () <UITextFieldDelegate>

@property (strong, nonatomic, readwrite) BBLoginTextField *loginField;
@property (strong, nonatomic, readwrite) BBLoginTextField *passwordField;

- (void)onLoginButton:(UIButton *)sender;
- (void)onRegisterButton:(UIButton *)sender;

@end


@implementation BBLoginView

@synthesize login = _login;
@synthesize password = _password;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // Login Field
        _loginField = [BBLoginTextField new];
        _loginField.font = [BBApplicationSettings fontForKey:kFontLoginField];
        _loginField.placeholder = @"Username";
        _loginField.centered = YES;
        _loginField.returnKeyType = UIReturnKeyNext;
        _loginField.delegate = self;
        
        // Password Field
        _passwordField = [BBLoginTextField new];
        _passwordField.font = [BBApplicationSettings fontForKey:kFontLoginField];
        _passwordField.placeholder = @"Password";
        _passwordField.centered = YES;
        _passwordField.secureTextEntry = YES;
        _passwordField.returnKeyType = UIReturnKeyGo;
        _passwordField.delegate = self;
        
        // Login Button
        _loginButton = [BBLoginButton new];
        [_loginButton addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        
        // Register button
        _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_registerButton addTarget:self action:@selector(onRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.titleLabel.font = [BBApplicationSettings fontForKey:kFontRegisterButton];
        [_registerButton setTitleColor:[BBApplicationSettings colorForKey:kColorGlobalGrayDark] forState:UIControlStateNormal];
        [_registerButton setTitle:@"Create Account" forState:UIControlStateNormal];
        
        // About button
        _aboutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_aboutButton addTarget:self action:@selector(onAboutButton:) forControlEvents:UIControlEventTouchUpInside];
        _aboutButton.hidden = YES;
        _aboutButton.titleLabel.font = [BBApplicationSettings fontForKey:kFontRegisterBackButton];
        [_aboutButton setTintColor:[UIColor colorForColor:[UIColor blackColor] withOpacity:0.8]];
        [_aboutButton setTitle:@"About b@" forState:UIControlStateNormal];

        [self addSubview:_loginField];
        [self addSubview:_passwordField];
        [self addSubview:_loginButton];
        [self addSubview:_registerButton];
        [self addSubview:_aboutButton];

        [self configureLayoutConstraints];
    }
    
    return self;
}

#pragma mark -
#pragma mark

- (void)configureLayoutConstraints
{
    [_loginField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_registerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_aboutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // login text field
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginField
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:10.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0f
                                                           constant:kLoginFieldHeight]];
    
    // password text field
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_loginField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:20.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_passwordField
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0f
                                                      constant:kLoginFieldHeight]];
    
    // login button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_passwordField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:40.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0f
                                                      constant:kLoginFieldHeight]];
    
    // register button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_registerButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_registerButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_loginButton
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:25.0f]];
    
    // about button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aboutButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aboutButton
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:-50.0f]];
}

#pragma mark -
#pragma mark public

- (NSString *)login
{
    return _loginField.text;
}

- (void)setLogin:(NSString *)login
{
    _login = login;
    _loginField.text = _login;
}

- (NSString *)password
{
    return _passwordField.text;
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    _passwordField.text = password;
}

- (void)reset
{
    _loginField.text = nil;
    _passwordField.text = nil;
}

- (BOOL)filled
{
    return (_loginField.text.length > 0 && _passwordField.text.length > 0);
}

#pragma mark -
#pragma mark GUI callbacks

- (void)onLoginButton:(UIButton *)sender
{
    [_passwordField resignFirstResponder];
    [_loginField resignFirstResponder];
    [_delegate loginViewDidClickOnLogin:self];
}

- (void)onRegisterButton:(UIButton *)sender
{
    [_passwordField resignFirstResponder];
    [_loginField resignFirstResponder];
    [_delegate loginViewDidClickOnRegister:self];
}

- (void)onAboutButton:(UIButton *)sender
{
    [_passwordField resignFirstResponder];
    [_loginField resignFirstResponder];
    [_delegate loginViewDidClickOnAbout:self];
}


#pragma mark -
#pragma mark UITextFieldDelegate callbacks

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(loginViewDidBeginEdit:)] == YES)
    {
        // Nothing responds to this
        [_delegate loginViewDidBeginEdit:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == _loginField) && [_passwordField canBecomeFirstResponder])
    {
        return [_passwordField becomeFirstResponder];
    }
    else if ((textField == _passwordField) && [_passwordField canResignFirstResponder] &&
            [_passwordField resignFirstResponder] && self.filled)
    {
        if ([_delegate respondsToSelector:@selector(loginViewDidClickOnLogin:)])
        {
            [_delegate loginViewDidClickOnLogin:self];
        }
    }

    return NO;
}

- (void)hideKeyboard
{
    [_loginField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end
