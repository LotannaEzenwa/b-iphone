//
//  BBReplyController.m
//  Boredat
//
//  Created by Dmitry Letko on 1/23/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBModel.h"
#import "BBReplyController.h"
#import "BBReplyModel.h"
#import "BBPost.h"

#import "BBPostCellFooterView.h"
#import "BBPostCellButton.h"
#import "BBScreennameBottomView.h"
#import "BBReplyHeaderCell.h"

#import "BBPersonalityController.h"

#import "BBFacade.h"
#import "BBUserImageFetcher.h"

#import "MgmtUtils.h"
#import "LogUtils.h"

#import "UIKit+Extensions.h"
#import "NSFoundation+Extensions.h"
#import "NSObject+NULL.h"

#import "BBApplicationSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "BBPlaceholderTextView.h"
#import "BBPostCell.h"
#import "BBPostDetailsView.h"
#import "BBTextFormatter.h"

static NSString *const kCellHeaderUID = @"CellHeaderUID";
static CGFloat const kMinReplyTextViewHeight = 50;
static CGFloat const kMaxReplyTextViewHeight = 150;

@interface BBReplyController () <BBScreennameBottomViewDelegate,
                                 UITableViewDelegate,
                                 UITableViewDataSource,
                                 UITextViewDelegate,
                                 BBReplyHeaderCellDelegate>

{    
    NSLayoutConstraint *_replyToolbarHeightConstraint;
    NSLayoutConstraint *_bottomReplyToolbarConstraint;
    NSLayoutConstraint *_screennameViewHeightConstraint;
    
    CGFloat _keyboardHeight;
    BOOL _toolbarSelected;
    
    BBReplyModel *_replyModel;
}

@property (strong, nonatomic, readonly) UIToolbar *replyToolbar;
@property (strong, nonatomic, readonly) BBScreennameBottomView *bottomView;
@property (strong, nonatomic, readwrite) UIBarButtonItem *anonButtonItem;
@property (strong, nonatomic, readwrite) UIBarButtonItem *replyButtonItem;

@property (strong, nonatomic, readwrite) NSTimer *replyFetchTimer;

@property (strong, nonatomic, readwrite) BBPlaceholderTextView *textView;
@property (strong, nonatomic, readwrite) UIButton *keyboardHideButton;

- (void)onReplyButtonItem:(UIBarButtonItem *)sender;
- (void)updateScreennameToolbarHeight;
- (void)resetReplyToolbar;

- (void)assembleNavigationBar;
- (void)didInteract;

- (void)onKeyboardWillShow:(NSNotification *)notification;
- (void)onKeyboardWillHide:(NSNotification *)notification;

@end

@implementation BBReplyController

- (id)initWithPost:(BBPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self != nil)
    {
        if (post == nil)
        {
            post = [BBPost new];
        }
        
        self.tableViewModel = [BBReplyModel new];
        _replyModel = (BBReplyModel *)self.tableViewModel;
        _replyModel.post = post;
        _replyModel.delegate = self;
        
        _toolbarSelected = NO;
        
        // Important for BBTableViewController methods -
        // Tells those methods which section the selectable/expandable cells are in
        self.mainSection = 1;
    }
    
    return self;
}


#pragma mark -
#pragma mark lifecycle

- (void)loadView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    
    self.tableView = [UITableView new];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postCell"];
    [self.tableView registerClass:[BBPostCell class] forCellReuseIdentifier:@"postMainCell"];
    
    // BOARD COLORS
    UIColor *currentBoardColor = [[BBFacade sharedInstance] currentBoardColor];
    UIColor *currentBoardLightColor = [[BBFacade sharedInstance] currentBoardLightColor];
    
    // Enable tap to scroll
    [self.tableView setScrollsToTop:YES];
    
    // Remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Reply toolbar
    _replyToolbar = [UIToolbar new];
    [_replyToolbar setBarTintColor: [UIColor whiteColor]];
    
    // Necessary for setting the border color
    if ([_replyToolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)])
    {
        [_replyToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    // Set border color
    if ([_replyToolbar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)])
    {
        [_replyToolbar setShadowImage:[UIImage imageWithColor:currentBoardLightColor] forToolbarPosition:UIToolbarPositionAny];
    }
    
    // Anon switch button
    _anonButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anon_icon@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleAnonymous)];

    // Text box
    _textView = [BBPlaceholderTextView new];
    _textView.placeHolderLabel.text = @"Post a reply...";

    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font = [BBApplicationSettings fontForKey:kFontPost];
    _textView.scrollEnabled = YES;
    _textView.userInteractionEnabled = YES;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor colorForColor:currentBoardLightColor withOpacity:0.1];
    [_textView setScrollsToTop:NO];
    UIBarButtonItem *textViewItem = [[UIBarButtonItem alloc] initWithCustomView:_textView];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexibleItem.width = -10.0f;
    
    // Reply button
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton addTarget:self action:@selector(onReplyButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [replyButton setTitle:@"Send" forState:UIControlStateNormal];
    [replyButton setTitleColor:currentBoardColor forState:UIControlStateNormal];
    [replyButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontPost]];
    [replyButton sizeToFit];
    _replyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:replyButton];
    [_replyButtonItem setEnabled:YES];
    
    NSArray *items = [[NSArray alloc] initWithObjects:_anonButtonItem, textViewItem, flexibleItem, _replyButtonItem, nil];
    [_replyToolbar setItems:items];
    
    // Screenname bar
    _bottomView = [BBScreennameBottomView new];
    _bottomView.delegate = self;
        
    [self.view addSubview:self.tableView];
    [self.view addSubview:_replyToolbar];
    [self.view addSubview:_bottomView];
    
    _keyboardHideButton = [UIButton new];
    [_keyboardHideButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchDown];
   
    [self setupTextViewConstraints];
    [self configureConstraints];
}

- (void)setupTextViewConstraints
{
    [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_replyToolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_replyToolbar
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:55.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_replyToolbar
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0f
                                                         constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_replyToolbar
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:-65.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_replyToolbar
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:-20.0f]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self assembleNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _toolbarSelected = NO;
    
    // Will collapse screenname bar if needed
    [self updateScreennameToolbarHeight];
    [self.view layoutIfNeeded];
    
    [_bottomView setName:[BBFacade sharedInstance].user.personalityName];
    [_replyModel updateDataForced:YES];
}

- (BBPost *)getPost
{
    return _replyModel.post;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_textView resignFirstResponder];
    
    UIView *firstResponder = [_replyToolbar findFirstResponder];
    if (firstResponder != nil)
    {
        [firstResponder resignFirstResponder];
    }

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];

    [_replyFetchTimer invalidate];
}

- (void)setHeightForReplyToolbarWith:(CGFloat)height
{
    [self.view removeConstraint:_replyToolbarHeightConstraint];
    _replyToolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:_replyToolbar
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:height];
    [self.view addConstraint:_replyToolbarHeightConstraint];
    [self updateViewConstraints];
}


- (void)configureConstraints
{
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // bottom View
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0f]];
    
    _screennameViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.0f];
    [self.view addConstraint:_screennameViewHeightConstraint];
    
    _bottomReplyToolbarConstraint = [NSLayoutConstraint constraintWithItem:_bottomView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0f];
    [self.view addConstraint:_bottomReplyToolbarConstraint];
    
    // reply Toolbar
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_replyToolbar
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_replyToolbar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_replyToolbar
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0f]];
    _replyToolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:_replyToolbar
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:kMinReplyTextViewHeight];
    [self.view addConstraint:_replyToolbarHeightConstraint];

    // tableView
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_replyToolbar
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                                constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0f]];
}

#pragma mark -
#pragma mark GUI callbacks


- (void)hideKeyboard:(UIButton *)sender
{
    _toolbarSelected = NO;
    [self.textView resignFirstResponder];
}

// Set return action to send
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text length] == 1 && [text isEqualToString:@"\n"])
    {
        [self onReplyButtonItem:nil];
        return NO;
    }
    return YES;
}

- (void)toggleAnonymous
{
    [_replyModel toggleAnonymous];
    [self updateScreennameToolbarHeight];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)onReplyButtonItem:(UIBarButtonItem *)sender
{
    NSString *text = _textView.text;
    
    if (text.length > 0)
    {
        [self didInteract];
        
        // Disable interaction while thinking
        _textView.backgroundColor = [UIColor grayColor];
        _replyButtonItem.enabled = NO;
        
        [_replyModel replyWithText:text callback:^(void)
            {
                [self resetReplyToolbar];
            }
        ];
    }
}

- (void)resetReplyToolbar
{
    _textView.text = @"";
    _textView.backgroundColor = [UIColor colorForColor:[[BBFacade sharedInstance] currentBoardLightColor] withOpacity:0.1];
    _textView.userInteractionEnabled = YES;
    [_textView shouldHidePlaceholder:NO];
    _replyButtonItem.enabled = YES;

    [self setHeightForReplyToolbarWith:kMinReplyTextViewHeight];
    [self hideKeyboard:nil];
}


#pragma mark -
#pragma mark private

- (void)showKeyboardHideButton
{
    _keyboardHideButton.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - _keyboardHeight - CGRectGetHeight(self.replyToolbar.bounds) - 50.0f);
    _keyboardHideButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_keyboardHideButton];
}

- (void)hideKeyboardHideButton
{
    [_keyboardHideButton removeFromSuperview];
}

- (void)assembleNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle: @"Post" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[BBApplicationSettings fontForKey:kFontTitle]];
    [titleButton sizeToFit];

    [self.navigationItem setTitleView:titleButton];
    
    // Hide back button text in pushed views
    self.navigationItem.title = @"";
    
}

#pragma mark -
#pragma mark UITableViewDelegate callbacks

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        // Header
        switch (indexPath.row)
        {
            case 0:
            {
                // User info
                return 70.0f;
            }
            case 1:
            {
                // Post info
                BBPost *post = [_replyModel.post copy];
                // Because there will be no avatar image
                post.screennameName = (id)[NSNull null];
                return [BBPostCell heightForCellWithPost:post expanded:YES showParent:NO];
            }
        }
    }
    else
    {
        // Replies table
        if (_replyModel.noReplies)
        {
            // For filler text
            return 50.0f;
        }
        else
        {
            BBPost *post = [_replyModel objectAtIndex:(indexPath.row)];
            return [BBPostCell heightForCellWithPost:post expanded:(indexPath.row == self.expandedPostIndex) showParent:NO];
        }
    }
    
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0 && _replyModel.post.screennameName != (id)[NSNull null])
            {
                BBPersonality *personality = [[BBPersonality alloc] initWithPost:_replyModel.post];
                [self presentPersonalityControllerWithPersonality:personality];
            }
            break;
        }
        case 1:
            if (!_replyModel.noReplies)
            {
                [self expandCellAtIndex:indexPath.row];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        // One cell to hold the "no replies" message
        return _replyModel.noReplies ? 1 : [_replyModel numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        // Header
        switch (indexPath.row)
        {                
            case 0:
            {
                // User info
                BBReplyHeaderCell *cell = [BBReplyHeaderCell new];
                BBUserImage *userImage = [[BBUserImageFetcher sharedInstance] thumbnailImageWithImageName:_replyModel.post.screennameImage];
                
                NSString *date = [BBTextFormatter stringWithDate:_replyModel.post.created];
                NSString *anonName = _replyModel.post.screennameName == nil ? @"" : @"Anonymous";
                NSString *name = (NSStringObject(_replyModel.post.screennameName).length > 0 ? _replyModel.post.screennameName : anonName);
                
                cell.userImage = userImage;
                cell.titleLabel.text = name;
                cell.dateLabel.text = date;
                cell.networkLabel.text = _replyModel.post.localNetworkName;
                cell.delegate = self;

                return cell;
            }
                
            case 1:
            {
                // Post info
                BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postMainCell" forIndexPath:indexPath];
                
                [cell formatWithPost:_replyModel.post showParent:NO];
                cell.delegate = self;
                
                // Special stuff for top post
                [cell hideAvatarImage:YES];
                cell.messageView.selectable = YES;
                cell.footerView.replyButton.disabled = YES;
                
                // Used to determine when the top post is clicked on
                [cell setTag:0];
                
                return cell;
            }
                
            default:
                return nil;
        }
    }
    else
    {
        // Replies table
        if (_replyModel.noReplies)
        {
            return [BBPostCell fillerCellWithText:@"No replies yet."];
        }
        else
        {
            BBPost *post = [_replyModel objectAtIndex:indexPath.row];
            BBPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
            
            [cell formatWithPost:post showParent:NO];
            cell.delegate = self;
            
            // Used to determine when the top post is clicked on
            [cell setTag:1];
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark BBPostCellDelegate

// Overridden because there's a possibility of interacting with the top cell
- (void)completeAction:(BBPostAction)action withPostCell:(id)cell
{
    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
    
    BOOL isTopCell = ([cell tag] == 0);
    if (isTopCell)
    {
        [_replyModel completeActionForTopCell:action];
    }
    else
    {
        NSInteger replaceIndex = cellPath.row;
        [_replyModel completeAction:action forObjectAtIndex:replaceIndex];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cellPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [(BBPostCell *)[self.tableView cellForRowAtIndexPath:cellPath] flashForAction:action];
    
    [self didInteract];
}

- (void)didInteract
{
    [_delegate replyControllerDidInteract:self];
}


#pragma mark -
#pragma mark notification callbacks

- (void)onKeyboardWillShow:(NSNotification *)notification
{
    UIView *firstResponder = [_replyToolbar findFirstResponder];
    
    if (firstResponder != nil)
    {
        NSDictionary *userInfo = notification.userInfo;
        NSValue *kFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        _keyboardHeight = CGRectGetHeight(kFrameEndValue.CGRectValue);
        [self showKeyboardHideButton];
        
        CGFloat offset = _keyboardHeight; // - 50.0f;
    
        NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        const double duration = durationValue.doubleValue;
        
        _bottomReplyToolbarConstraint.constant = -offset;
        
        _toolbarSelected = YES;
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    if (_toolbarSelected)
    {
        [_textView becomeFirstResponder];
    }
    else
    {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        
        [self hideKeyboardHideButton];
        
        const double duration = durationValue.doubleValue;
        _bottomReplyToolbarConstraint.constant = 0.0f;
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark -
#pragma mark BBScreennameBottomView callbacks

- (void)tapOnScreennameLabel:(UILabel *)label
{
    if (_toolbarSelected)
    {
        [_textView resignFirstResponder];
    }
    
    UIAlertController *nameAlert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Enter a new screenname:"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [nameAlert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Screenname";
     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [nameAlert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *name = nameAlert.textFields.firstObject;
                                   [[BBFacade sharedInstance] updatePersonalityScreennameToName:name.text block:^(NSError *error)
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
    [nameAlert addAction:okAction];
    [self presentViewController:nameAlert animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextViewDelegate 

- (void)textViewDidChange:(UITextView *)textView
{
    BOOL shouldHideTextView = (textView.text.length == 0) ? NO : YES;
    [_textView shouldHidePlaceholder:shouldHideTextView];
    
    CGFloat heightToFit = _textView.contentSize.height + 10;
    if (heightToFit < kMaxReplyTextViewHeight)
    {
        CGFloat newHeight = MAX(heightToFit, kMinReplyTextViewHeight);
        [self setHeightForReplyToolbarWith:newHeight];
    }
    
    // Scroll so cursor is visible
    [_textView scrollRangeToVisible:[_textView selectedRange]];
}

- (void)updateScreennameToolbarHeight
{
    // Change button color
    _anonButtonItem.tintColor = _replyModel.postAsAnonymous ? [UIColor grayColor] : [[BBFacade sharedInstance] currentBoardColor];
    [self.view layoutIfNeeded];
    
    _screennameViewHeightConstraint.constant = _replyModel.postAsAnonymous ? 0.0f : 40.0f;
}

- (void)updateReplies
{
    [_replyModel updateReplies];
}

- (void)reloadTopCell
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark BBModelCallbacks

- (void)modelDidUpdateData:(id)model
{
    // Recursively updates replies every 5 seconds
    _replyFetchTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateReplies) userInfo:nil repeats:NO];
    
    NSInteger numNew = [_replyModel.freshReplies count];
    NSInteger numOld = [_replyModel numberOfObjects] - numNew;
    
    if (numNew > 0)
    {
        [self didInteract];
        
        /* CELL ANIMATION */
        [self.tableView beginUpdates];
        
        // Figure out index paths of new replies
        NSMutableArray *newRowPaths = [NSMutableArray new];
        for (int i = 0; i < numNew; i++)
        {
            [newRowPaths addObject:[NSIndexPath indexPathForRow:numOld + i inSection:1]];
        }
        
        // Remove filler cell if necessary
        if (_replyModel.noReplies)
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            _replyModel.noReplies = NO;
        }
    
        // Add new cells
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:newRowPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
        
        // Scroll to bottom if user replied
        if (_replyModel.didReply) {
            [self scrollToBottom];
            _replyModel.didReply = NO;
        }
    }
    
    [self reloadTopCell];
}

@end
