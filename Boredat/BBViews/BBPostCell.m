//
//  BBPostCell.m
//  Boredat
//
//  Created by Anton Kolosov on 2/4/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBPostCell.h"
#import "BBPost.h"
#import "BBTextFormatter.h"
#import "BBUserImageFetcher.h"
#import "BBApplicationSettings.h"
#import "BBUserImage.h"
#import "MgmtUtils.h"
#import "BBPostDetailsView.h"
#import "BBPostCellFooterView.h"
#import "BBPostCellButton.h"
#import <CoreText/CoreText.h>
#import "UIKit+Extensions.h"
#import "BBPostDetailsView.h"


static NSString *const kUserImage = @"userImage";
static NSString *const kUserImageFilepath = @"userImage.filepath";
static NSString *const kUserImageLoading = @"userImage.loading";

NSInteger const kPostMinimumHeight = 40.0f;
NSInteger const kPostBorderWidth = 20.0f;
NSInteger const kPostExpandedHeight = 40.0f;
NSInteger const kDetailViewRowHeight = 20.0f;


static CGFloat const kDetailsViewHeight = 30.0f;

@interface BBPostCell () <BBPostCellFooterViewDelegate>
{
    NSArray *_detailViewConstraints;
}

@property (strong, nonatomic, readwrite) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic, readwrite) UIButton *avatarImageView;
@property (strong, nonatomic, readwrite) UIView *flashView;
@property (strong, nonatomic, readwrite) BBPostDetailsView *detailsView;

- (void)updateImage;
- (void)updateLoading;

- (void)onAvatarButton:(UIButton *)sender;

@end

@implementation BBPostCell

@synthesize footerView = _footerView;

+ (id)fillerCell
{
    UITableViewCell *cell = [UITableViewCell new];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 25);
    [activityView startAnimating];
    [cell addSubview:activityView];
    return cell;
}

+ (id)fillerCellWithText:(NSString *)text
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.font = [BBApplicationSettings fontForKey:kFontPost];
    cell.textLabel.text = text;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)heightOfFillerCell
{
    return 50.0f;
}

+ (BOOL)automaticallyNotifiesObserversOfUserImage
{
    return NO;
}

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil)
    {
        // Hides overflow
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _flashView = [UIView new];
        [self.contentView addSubview:_flashView];
        
        [self.contentView addSubview:self.messageView];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.indicatorView];
        
        [self addObserver:self forKeyPath:kUserImageFilepath options:0 context:@selector(updateImage)];
        [self addObserver:self forKeyPath:kUserImageLoading options:0 context:@selector(updateLoading)];
        
        _detailsView = [BBPostDetailsView new];
        [self.contentView addSubview:_detailsView];
        
        [self.contentView addSubview:self.footerView];
        
        [self configureConstraints];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kUserImageFilepath];
    [self removeObserver:self forKeyPath:kUserImageLoading];
}

- (void)updateConstraints
{
    NSDictionary *detailsMetrics = @{@"detailsViewHeight" : [NSNumber numberWithUnsignedInteger:kDetailViewRowHeight * _detailsView.iconRows]};
    [self.contentView removeConstraints:_detailViewConstraints];
    _detailViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_detailsView(detailsViewHeight)]" options:0 metrics:detailsMetrics views:NSDictionaryOfVariableBindings(_detailsView)];
    [self.contentView addConstraints:_detailViewConstraints];
    
    [super updateConstraints];
}

- (void)configureConstraints
{
    [_flashView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_avatarImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_messageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_detailsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Flash view
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_flashView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_flashView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_flashView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_flashView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0f]];

    // Image view
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:15.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10.0f]];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_avatarImageView, _messageView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarImageView(25.0)]" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatarImageView(25.0)]" options:0 metrics:nil views:viewsDictionary]];
    
    
    // Indicator view (loading circle)
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0f]];
    
    // Message view (text)
    
    [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.contentView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:10.0f]];
    [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0f]];

    [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-10.0f]];
    
    // Details view (stats)
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:15.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                    toItem:_messageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailsView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:5.0f]];
    
    NSDictionary *detailsMetrics = @{@"detailsViewHeight" : [NSNumber numberWithFloat:kDetailsViewHeight]};
    _detailViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_detailsView(detailsViewHeight)]" options:0 metrics:detailsMetrics views:NSDictionaryOfVariableBindings(_detailsView)];
    [self.contentView addConstraints:_detailViewConstraints];
    
    
    //  Footer view (A/D/N)
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_detailsView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:0.0f]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_footerView
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:0.0
                                                        constant:40.0]];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark Properties getters

- (UIButton *)avatarImageView
{
    if (_avatarImageView == nil)
    {
        _avatarImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarImageView addTarget:self action:@selector(onAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
        _avatarImageView.userInteractionEnabled = NO;
    }
    
    return _avatarImageView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setBackgroundColor:[UIColor whiteColor]];
        [_indicatorView setUserInteractionEnabled:NO];
        [_indicatorView setHidesWhenStopped:NO];
        [_indicatorView setHidden:YES];
    }
    
    return _indicatorView;
}

- (UITextView *)messageView
{
    if (_messageView == nil)
    {
        _messageView = [UITextView new];
        _messageView.editable = NO;
        _messageView.backgroundColor = [UIColor clearColor];
        _messageView.userInteractionEnabled = YES;
        _messageView.scrollEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextView:)];
        [_messageView addGestureRecognizer:tap];
    }
    
    return _messageView;
}

- (BBPostCellFooterView *)footerView
{
    if (_footerView == nil)
    {
        _footerView = [BBPostCellFooterView new];
        _footerView.delegate = self;
    }
    
    return _footerView;
}

#pragma mark -
#pragma mark format cell for specific post

- (void)formatWithPost:(BBPost *)post showParent:(BOOL)showParent
{
    self.userImage = [[BBUserImageFetcher sharedInstance] thumbnailImageWithImageName:post.screennameImage];
    
    // If nil, make generic cell
    if (post.text == nil) {
        _messageView.attributedText = [NSMutableAttributedString new];
        
        [_detailsView setAgrees:0];
        [_detailsView setDisagrees:0];
        [_detailsView setNews:0];
        [_detailsView setReplies:0];
        
        _footerView.agreeButton.clicked = NO;
        _footerView.disagreeButton.clicked = NO;
        _footerView.newsworthyButton.clicked = NO;
        _footerView.anonButton.clicked = NO;
        
        _footerView.agreeButton.disabled = YES;
        _footerView.disagreeButton.disabled = YES;
        _footerView.newsworthyButton.disabled = YES;
        _footerView.anonButton.disabled = YES;
        
        return;
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString: post.attributedText];
    
    // Add a link to the parent post if applicable
    if (showParent && ([post.parentUID isEqualToString:@"0"] == NO))
    {
        attributedText = [BBTextFormatter addParentLinkToText:attributedText withUID:post.parentUID];
    }

    _messageView.attributedText = attributedText;
    _messageView.selectable = NO;
    
    // Vote view (icons)
    [_detailsView setAgrees:post.totalAgrees];
    [_detailsView setDisagrees:post.totalDisagrees];
    [_detailsView setNews:post.totalNewsworthies];
    [_detailsView setReplies:post.totalReplies];
    [_detailsView updateConstraints];
    
    // Footer view (A/D/N)
    _footerView.agreeButton.clicked = post.hasVotedAgree;
    _footerView.disagreeButton.clicked = post.hasVotedDisagree;
    _footerView.newsworthyButton.clicked = post.hasVotedNewsworthy;
    
    BOOL voted = (post.hasVotedAgree | post.hasVotedDisagree);
    
    _footerView.agreeButton.disabled = voted;
    _footerView.disagreeButton.disabled = voted;
    _footerView.newsworthyButton.disabled = post.hasVotedNewsworthy;

    _footerView.replyButton.disabled = NO;
    _footerView.replyButton.clicked = NO;
    
    [self updateConstraints];
}

+ (CGFloat)heightForCellWithPost:(BBPost *)post expanded:(BOOL)expanded showParent:(BOOL)showParent
{
    UITextView *textView = [UITextView new];
    const CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - kPostBorderWidth;
    const CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    // Height of detail view
    BBPostDetailsView *detailsView = [BBPostDetailsView new];
    [detailsView setAgrees:post.totalAgrees];
    [detailsView setDisagrees:post.totalDisagrees];
    [detailsView setNews:post.totalNewsworthies];
    [detailsView updateConstraints];
    
    if (post.screennameName != (id)[NSNull null])
    {
        // Make wrap for avatar
        UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 35, 30)];
        textView.textContainer.exclusionPaths = @[imgRect];
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString: post.attributedText];
    
    // Add a link to the parent post if applicable
    if (showParent && ([post.parentUID isEqualToString:@"0"] == NO))
    {
        attributedText = [BBTextFormatter addParentLinkToText:attributedText withUID:post.parentUID];
    }
    
    textView.attributedText = attributedText;
    CGSize size = [textView sizeThatFits:maxSize];
    
    size.height = MAX(size.height, kPostMinimumHeight);
    
    CGFloat additionalHeight = expanded ? kPostExpandedHeight : 0;
    additionalHeight += kDetailViewRowHeight * detailsView.iconRows;
    
    return size.height + additionalHeight;
}

#pragma mark -
#pragma mark

- (void)tapTextView:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textView.textStorage.length)
    {
        // Check if character is in a link
        NSRange range;
        NSURL *url = (NSURL *)[textView.attributedText attribute:@"containsLink" atIndex:characterIndex effectiveRange:&range];
        if (url)
        {
            [_delegate tapOnLink:url withPostCell:self];
        }
        else
        {
            [_delegate tapOnTextWithPostCell:self];
        }
    }
}

#pragma mark -
#pragma mark NSKeyValueObserving callbacks

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    IMP imp = [self methodForSelector:context];
    void (*func)(id, SEL) = (void *)imp;
    func(self, context);
}


#pragma mark -
#pragma mark public

// Used in reply view header
- (void)hideAvatarImage:(BOOL)state
{
    _avatarImageView.hidden = state;
    _indicatorView.hidden = state;
    
    // Remove wrap for avatar
    _messageView.textContainer.exclusionPaths = [NSArray new];
    
    _detailsView.replies = -1;
}

- (void)setUserImage:(BBUserImage *)userImage
{
    if (_userImage != userImage)
    {
        [self willChangeValueForKey:kUserImage];
        
        _userImage = userImage;
        
        [self didChangeValueForKey:kUserImage];
    }
}

#pragma mark -
#pragma mark private

- (void)updateImage
{
    NSString *filepath = _userImage.filepath;
    
    if (filepath != nil || _userImage.loading)
    {
        // If screenname exists but doesn't have an avatar yet, give it a default avatar
        if ([filepath isEqualToString:@""])
        {
            UIImage *image = [UIImage imageNamed:@"profile_anonymous-50x50.png"];
            [_avatarImageView setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filepath];
            [_avatarImageView setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        _avatarImageView.userInteractionEnabled = YES;
        
        // Make wrap for avatar
        UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 35, 30)];
        _messageView.textContainer.exclusionPaths = @[imgRect];
    }
    else
    {
        [_avatarImageView setBackgroundImage:nil forState:UIControlStateNormal];
        _avatarImageView.userInteractionEnabled = NO;
    
        _messageView.textContainer.exclusionPaths = [NSArray new];
    }
}

- (void)updateLoading
{
    if (_userImage.loading == YES)
    {
        [_indicatorView setHidden:NO];
        [_indicatorView startAnimating];
    }
    else
    {
        [_indicatorView setHidden:YES];
        [_indicatorView stopAnimating];
    }
}

#pragma mark -
#pragma mark flashes

- (void)flashForAction:(BBPostAction)action
{
    switch (action) {
        case kPostActionAgree:
            [self flashWithColor:[[UIColor agreeColor] colorWithAlphaComponent:0.7f]];
            break;
            
        case kPostActionDisagree:
            [self flashWithColor:[[UIColor disagreeColor] colorWithAlphaComponent:0.7f]];
            break;
            
        case kPostActionNewsworthy:
            [self flashWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.7f]];
            break;
            
        case kPostActionReply:
            [self flashWithColor:[[UIColor goldColor] colorWithAlphaComponent:0.7f]];
            break;
            
        default:
            break;
    }
}

- (void)flashWithColor:(UIColor *)color
{
    [UIView animateWithDuration:0.1f animations:^{
        _flashView.backgroundColor = color;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0f animations:^{
            _flashView.backgroundColor = [UIColor clearColor];
        }];
    }];
}

#pragma mark -
#pragma mark GUI callbacks

- (void)footerViewDidPressAgree:(BBPostCellFooterView *)view
{
    [_delegate completeAction:kPostActionAgree withPostCell:self];
}

- (void)footerViewDidPressDisagree:(BBPostCellFooterView *)view
{
    [_delegate completeAction:kPostActionDisagree withPostCell:self];
}

- (void)footerViewDidPressNewsworthy:(BBPostCellFooterView *)view
{
    [_delegate completeAction:kPostActionNewsworthy withPostCell:self];
}

- (void)footerViewDidPressReply:(BBPostCellFooterView *)view
{
    [_delegate postCellDidPressReply:self];
}

- (void)onAvatarButton:(UIButton *)sender
{
    [_delegate tapOnAvatarwithPostCell:self];
}

@end
