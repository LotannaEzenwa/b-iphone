//
//  BBRegistrationController.m
//  Boredat
//
//  Created by David Pickart on 12/3/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBRegistrationController.h"
#import "UIKit+Extensions.h"

const CGFloat kRegistrationTextMargin = 20.0f;

@interface BBRegistrationController ()
{
    UIColor *_flashColor;
}

@end

@implementation BBRegistrationController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [BBApplicationSettings colorForKey:kColorLoginBackground];
    
    // Title label
    _titleLabel = [UILabel new];
    _titleLabel.font = [BBApplicationSettings fontForKey:kFontRegistrationTitle];
    _titleLabel.text = self.headerText;
    _titleLabel.textColor = [BBApplicationSettings colorForKey:kColorGlobalDark];
    
    // Text view
    _textView = [UITextView new];
    _textView.font = [BBApplicationSettings fontForKey:kFontRegistrationInfoText];
    _textView.userInteractionEnabled = NO;
    _textView.text = self.text;
    _textView.textColor = [BBApplicationSettings colorForKey:kColorGlobalGrayDark];
    _textView.backgroundColor = [UIColor clearColor];
    
    // Flash message label
    _flashLabel = [UILabel new];
    _flashLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
    _flashLabel.textAlignment = NSTextAlignmentCenter;
    _flashLabel.numberOfLines = 0;
    
    // Back button
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_backButton addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    _backButton.titleLabel.font = [BBApplicationSettings fontForKey:kFontRegisterBackButton];
    [_backButton setTitleColor:[BBApplicationSettings colorForKey:kColorGlobalGrayDark] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOnBackground)];
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
    
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_textView];
    [self.view addSubview:_flashLabel];
    [self.view addSubview:_backButton];
    [self configureLayoutConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)configureLayoutConstraints
{
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_flashLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // title label
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:0.15f
                                                           constant:0.0f]];
    
    // text view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:20.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:kRegistrationTextMargin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-kRegistrationTextMargin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_backButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-20.0f]];
    
    // flash message label
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:0.6f
                                                           constant:10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_flashLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.7f
                                                           constant:0.0f]];
    
    
    // back button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backButton
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:-50.0f]];
}

- (void)flashErrorMessage:(NSString *)message
{
    _flashColor = [UIColor redColor];
    [self flashMessage:message];
}

- (void)flashSuccessMessage:(NSString *)message
{
    _flashColor = [UIColor blackColor];
    [self flashMessage:message];
}

- (void)flashMessage:(NSString *)message
{
    [self fadeOutView:_flashLabel duration:kFadeDurationDefault completion:^{
        _flashLabel.textColor = _flashColor;
        _flashLabel.text = message;
        [self fadeInView:_flashLabel  duration:kFadeDurationDefault completion:nil];
    }];
}

#pragma mark -
#pragma mark GUI callbacks

- (void)didClickOnBackground
{
    [self hideKeyboard];
}

- (void)onBackButton:(id)sender
{
    [_delegate registrationControllerDidClickOnBack:self];
}

- (void)setText:(NSString *)text
{
    _text = text;
    _textView.text = _text;
}

- (void)setHeaderText:(NSString *)headerText
{
    _headerText = headerText;
    _titleLabel.text = _headerText;
}


#pragma mark -
#pragma mark RegistrationControllerDelegate callbacks

- (void)registrationControllerDidClickOnBack:(id)controller
{
    [self.navigationController popViewControllerWithFade:controller];
}

@end
