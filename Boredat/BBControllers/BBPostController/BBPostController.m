//
//  BBPostController.m
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostController.h"

#import "BBScreennameBottomView.h"

#import "BBPost.h"
#import "BBFacade.h"
#import "NSFoundation+Extensions.h"

#import "BBPlaceholderTextView.h"

#import "MgmtUtils.h"

#import "UIKit+Extensions.h"

#import <QuartzCore/QuartzCore.h>

#import "BBApplicationSettings.h"


@interface BBPostController () <UITextViewDelegate, BBScreennameBottomViewDelegate>
{
    NSLayoutConstraint *_bottomConstraint;
    UIButton *_titleButton;
    UIButton *_postButton;
    
    NSLayoutConstraint *_screennameViewHeightConstraint;
}

@property (strong, nonatomic, readwrite) BBPlaceholderTextView *textView;
@property (strong, nonatomic, readwrite) UIBarButtonItem *anonButtonItem;
@property (strong, nonatomic, readonly) UIToolbar *anonToolbar;
@property (strong, nonatomic, readwrite) BBScreennameBottomView *bottomView;
@property (nonatomic, readwrite) BOOL postAsAnonymous;
@property (nonatomic, readwrite) BOOL posting;


- (void)onPostButtonItem:(UIButton *)sender;
- (void)onCancelButtonItem:(UIBarButtonItem *)sender;

- (void)assembleNavigationBar;

@end


@implementation BBPostController



#pragma mark -
#pragma mark lifecycle

- (void)loadView
{
    _facade = [BBFacade sharedInstance];
    
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Text view
    _textView = [BBPlaceholderTextView new];
    _textView.placeHolderLabel.text = @"Type your thoughts here...";
    _textView.delegate = self;
    [_textView setFont:[BBApplicationSettings fontForKey:kFontPost]];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.enablesReturnKeyAutomatically = YES;

    
    // Anon switch toolbar
    _anonToolbar = [UIToolbar new];
    
    // Necessary for setting the border color
    if ([_anonToolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)])
    {
        [_anonToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    // Remove border
    if ([_anonToolbar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)])
    {
        [_anonToolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    }
    
    // Anon switch button
    _anonButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anon_icon@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleAnonymous)];
    [_anonToolbar setItems:[[NSArray alloc] initWithObjects:_anonButtonItem, nil]];
    
    
    // Screenname fotoer
    _bottomView = [BBScreennameBottomView new];
    _bottomView.delegate = self;
    
    [self.view addSubview:_anonToolbar];
    [self.view addSubview:_textView];
    [self.view addSubview:_bottomView];
    
    [self configureConstraints];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    _posting = NO;
    
    // Show keyboard
    [_textView becomeFirstResponder];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    _bottomView.name = _facade.user.personalityName;
    
    // Will collapse screenname bar if needed
    self.postAsAnonymous = _facade.postAsAnonymous;
    [self.view layoutIfNeeded];
    
    [self.view updateConstraintsIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //Hide keyboard
    [_textView resignFirstResponder];
    
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark -
#pragma mark GUI callbacks
- (void)toggleAnonymous
{
    [_facade toggleAnonymous];
    // Will expand screenname bar if needed
    self.postAsAnonymous = [_facade postAsAnonymous];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// Set return action to send
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text length] == 1 && [text isEqualToString:@"\n"]) {
        [self onPostButtonItem:nil];
        return NO;
    }
    return YES;
}

- (void)onPostButtonItem:(UIButton *)sender
{
    if (_textView.hasText && _posting == NO)
    {
        self.posting = YES;
        NSString *text = _textView.text;
        
        [_facade replyText:text UID:nil anonymously:_postAsAnonymous block:^(NSError *error) {
            if (error != nil)
            {
                [self showAlertViewWithError:error];
                self.posting = NO;
            }
            else
            {
                [_facade postsFromPage:0 block:^(NSArray *posts, NSNumber *page, NSError *error1) {
                    if (error1 != nil)
                    {
                        [self showAlertViewWithError:error1];
                        self.posting = NO;
                    }
                    else
                    {
                        _posts = posts;
                        [_delegate performSelector:@selector(postControllerDidReceiveDone:) withObject:self];
                    }

                }];
            }
        }];
    }
}

- (void)onCancelButtonItem:(UIBarButtonItem *)sender
{
    [_facade cancelAllRequests];
    [_delegate performSelector:@selector(postControllerDidReceiveCancel:) withObject:self];
}


#pragma mark -
#pragma mark private

- (void)assembleNavigationBar
{
    _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_postButton setTitle: @"Send" forState:UIControlStateNormal];
    [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_postButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.15f] forState: UIControlStateHighlighted];
    [_postButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.15f] forState: UIControlStateDisabled];
    [_postButton addTarget:self action:@selector(onPostButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_postButton sizeToFit];
    
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc]
                                         initWithCustomView:_postButton];
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setTitle: @"New Post" forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [_titleButton sizeToFit];

    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                          target:self action:@selector(onCancelButtonItem:)];
    
    UINavigationItem *navigationItem = self.navigationItem;
    [navigationItem setRightBarButtonItem:postButtonItem];
    [navigationItem setTitleView:_titleButton];
    [navigationItem setLeftBarButtonItem:cancelButtonItem];
    
}

- (void)configureConstraints
{
    [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_anonToolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // textView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_anonToolbar
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    // anon toolbar
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_anonToolbar
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_anonToolbar
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_anonToolbar
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0f]];
    
    // bottom view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    _screennameViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_bottomView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:0.0
                                                                    constant:40.0f];
    [self.view addConstraint:_screennameViewHeightConstraint];
    _bottomConstraint = [NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f];
    [self.view addConstraint:_bottomConstraint];
}

- (void)onKeyboardDidShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *kFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyboardHeight = CGRectGetHeight(kFrameEndValue.CGRectValue);
    
    _bottomConstraint.constant = -(keyboardHeight);
    
    NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    const double duration = durationValue.doubleValue;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    BOOL shouldHideTextView = (textView.text.length == 0) ? NO : YES;
    [_textView shouldHidePlaceholder:shouldHideTextView];
}

#pragma mark -
#pragma mark BBScreennameBottomView callbacks

- (void)tapOnScreennameLabel:(UILabel *)label
{
    [_textView resignFirstResponder];

    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:@"Enter a new screenname:"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Screenname";
     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *name = alert.textFields.firstObject;
                                   [_facade updatePersonalityScreennameToName:name.text block:^(NSError *error)
                                    {
                                        if (error != nil)
                                        {
                                            [self showAlertViewWithError:error];
                                        }
                                        else
                                        {
                                            _bottomView.name = name.text;
                                        }
                                    }];
                               }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark Getters & setters

- (void)setPostAsAnonymous:(BOOL)postAsAnonymous
{
    _postAsAnonymous = postAsAnonymous;
    _anonButtonItem.tintColor = _postAsAnonymous ? [UIColor grayColor] : [_facade currentBoardColor];
    [self.view layoutIfNeeded];
    _screennameViewHeightConstraint.constant = _postAsAnonymous ? 0.0f : 40.0f;
}

- (void)setPosting:(BOOL)posting
{
    _posting = posting;
    if (_posting)
    {
        _postButton.enabled = NO;
        [_titleButton.titleLabel setText:@"Posting..."];
    }
    else
    {
        _postButton.enabled = YES;
        [_titleButton.titleLabel setText:@"New Post"];
    }
}

@end
