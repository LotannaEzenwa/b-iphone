//
//  BBPostDetailsView.m
//  Boredat
//
//  Created by Anton Kolosov on 2/4/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostDetailsView.h"
#import "BBVoteView.h"
#import "UIKit+Extensions.h"
#import "MgmtUtils.h"

#import "BBApplicationSettings.h"
#import "BBFacade.h"

@interface BBPostDetailsView ()

{
    NSLayoutConstraint *_agreeViewVerticalConstraint;
    NSLayoutConstraint *_disagreeViewVerticalConstraint;
    NSLayoutConstraint *_newsworthyViewVerticalConstraint;
    
    NSLayoutConstraint *_agreeViewHorizontalConstraint;
    NSLayoutConstraint *_disagreeViewHorizontalConstraint;
    NSLayoutConstraint *_newsworthyViewHorizontalConstraint;
    
    NSArray *_agreeViewConstraints;
    NSArray *_disagreeViewConstraints;
    NSArray *_newsworthyViewConstraints;
}

@property (strong, nonatomic, readwrite) BBVoteView *agreeView;
@property (strong, nonatomic, readwrite) BBVoteView *disagreeView;
@property (strong, nonatomic, readwrite) BBVoteView *newsView;
@property (strong, nonatomic, readwrite) UILabel *replyLabel;

@end

@implementation BBPostDetailsView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIFont *font = [BBApplicationSettings fontForKey:kFontVote];
        
        _agreeView = [BBVoteView new];
        _agreeView.textField.textColor = [UIColor agreeColor];
        _agreeView.textField.font = font;
        _agreeView.imagesCountMax = 20;
        _agreeView.image = [UIImage imageNamed:@"agree@2x.png"];
        _agreeView.hidden = YES;
        
        _disagreeView = [BBVoteView new];
        _disagreeView.textField.textColor = [UIColor disagreeColor];
        _disagreeView.textField.font = font;
        _disagreeView.imagesCountMax = 20;
        _disagreeView.image = [UIImage imageNamed:@"disagree@2x.png"];
        _disagreeView.hidden = YES;
        
        _newsView = [BBVoteView new];
        _newsView.textField.textColor = [UIColor grayColor];
        _newsView.textField.font = font;
        _newsView.imagesCountMax = 20;
        _newsView.image = [UIImage imageNamed:@"news@2x.png"];
        _newsView.hidden = YES;
        
        _replyLabel = [UILabel new];
        _replyLabel.backgroundColor = [UIColor clearColor];
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.font = [BBApplicationSettings fontForKey:kFontReply];
        _replyLabel.textAlignment = NSTextAlignmentRight;
        _replies = -1;
        
        _iconRows = 1;
        
        [self addSubview:_agreeView];
        [self addSubview:_disagreeView];
        [self addSubview:_newsView];
        [self addSubview:_replyLabel];
        
        [self configureConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    [_agreeView sizeToFit];
    [_disagreeView sizeToFit];
    [_newsView sizeToFit];

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - 80;
    CGFloat agreeWidth = _agreeView.number > 0 ? _agreeView.frame.size.width : 0.0f;
    CGFloat disagreeWidth = _disagreeView.number > 0 ? _disagreeView.frame.size.width : 0.0f;
    CGFloat newsworthyWidth = _newsView.number > 0 ? _newsView.frame.size.width : 0.0f;
    
    CGFloat heightOffset = 20.0f;
    
    CGFloat agreeXPosition = 0.0f;
    CGFloat agreeYPosition = 0.0f;
    CGFloat disagreeXPosition = 0;
    CGFloat disagreeYPosition = 0;
    CGFloat newsworthyXPosition = 0;
    CGFloat newsworthyYPosition = 0;
    
    // Arrange votes into rows based on what can fit
    if ((agreeWidth + disagreeWidth) < screenWidth)
    {
        disagreeXPosition = agreeXPosition + agreeWidth;
        disagreeYPosition = 0.0f;

        if ((agreeWidth + disagreeWidth + newsworthyWidth) < screenWidth)
        {
            newsworthyXPosition = disagreeXPosition + disagreeWidth;
            newsworthyYPosition = 0.0f;
            _iconRows = 1;
        }
        else
        {
            newsworthyXPosition = 0.0f;
            newsworthyYPosition = heightOffset;
            _iconRows = 2;
        }
    }
    else
    {
        disagreeXPosition = 0.0f;
        disagreeYPosition = heightOffset;
        
        if ((disagreeWidth + newsworthyWidth) < screenWidth)
        {
            newsworthyXPosition = disagreeXPosition + disagreeWidth;
            newsworthyYPosition = heightOffset;
            _iconRows = 2;
        }
        else
        {
            newsworthyXPosition = 0.0f;
            newsworthyYPosition = heightOffset * 2;
            _iconRows = 3;
        }
    }

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_agreeView, _disagreeView, _newsView);
    
    NSDictionary *metrics = @{@"AgreeViewWidth": [NSNumber numberWithFloat:agreeWidth],
                              @"DisagreeViewWidth": [NSNumber numberWithFloat:disagreeWidth],
                              @"NewsworthyViewWidth": [NSNumber numberWithFloat:newsworthyWidth]};
    
    [self removeConstraints:_agreeViewConstraints];
    _agreeViewHorizontalConstraint.constant = agreeXPosition;
    _agreeViewVerticalConstraint.constant = agreeYPosition;
    _agreeViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_agreeView(AgreeViewWidth)]" options:0 metrics:metrics views:viewsDictionary];
    [self addConstraints:_agreeViewConstraints];

    [self removeConstraints:_disagreeViewConstraints];
    _disagreeViewHorizontalConstraint.constant = disagreeXPosition;
    _disagreeViewVerticalConstraint.constant = disagreeYPosition;
    _disagreeViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_disagreeView(DisagreeViewWidth)]" options:0 metrics:metrics views:viewsDictionary];
    [self addConstraints:_disagreeViewConstraints];

    [self removeConstraints:_newsworthyViewConstraints];
    _newsworthyViewHorizontalConstraint.constant = newsworthyXPosition;
    _newsworthyViewVerticalConstraint.constant = newsworthyYPosition;
    _newsworthyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_newsView(NewsworthyViewWidth)]" options:0 metrics:metrics views:viewsDictionary];
    [self addConstraints:_newsworthyViewConstraints];
    
    [super updateConstraints];
}

- (void)configureConstraints
{
    [_agreeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_disagreeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_newsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_replyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_agreeView, _disagreeView, _newsView);
    
    _agreeViewConstraints = [NSArray new];
    _disagreeViewConstraints = [NSArray new];
    _newsworthyViewConstraints = [NSArray new];
    
    // agree View
    _agreeViewVerticalConstraint = [NSLayoutConstraint constraintWithItem:_agreeView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0f];
    [self addConstraint:_agreeViewVerticalConstraint];
    
    _agreeViewHorizontalConstraint = [NSLayoutConstraint constraintWithItem:_agreeView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0
                                                                    constant:0.0f];
    
    [self addConstraint:_agreeViewHorizontalConstraint];
    _agreeViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_agreeView(50)]" options:0 metrics:nil views:viewsDictionary];
    [self addConstraints:_agreeViewConstraints];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_agreeView(25)]" options:0 metrics:nil views:viewsDictionary]];
    
    // Disagree View
    _disagreeViewVerticalConstraint = [NSLayoutConstraint constraintWithItem:_disagreeView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0f];
    [self addConstraint:_disagreeViewVerticalConstraint];
    
    _disagreeViewHorizontalConstraint = [NSLayoutConstraint constraintWithItem:_disagreeView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0.0f];
    [self addConstraint:_disagreeViewHorizontalConstraint];
    _disagreeViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_disagreeView(50)]" options:0 metrics:nil views:viewsDictionary];
    [self addConstraints:_disagreeViewConstraints];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_disagreeView(25)]" options:0 metrics:nil views:viewsDictionary]];
    
    // Newsworthy View
    _newsworthyViewVerticalConstraint = [NSLayoutConstraint constraintWithItem:_newsView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0f];
    [self addConstraint:_newsworthyViewVerticalConstraint];
    
    _newsworthyViewHorizontalConstraint = [NSLayoutConstraint constraintWithItem:_newsView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0
                                                                         constant:0.0f];
    [self addConstraint:_newsworthyViewHorizontalConstraint];
    _newsworthyViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_newsView(50)]" options:0 metrics:nil views:viewsDictionary];
    [self addConstraints:_newsworthyViewConstraints];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_newsView(25)]" options:0 metrics:nil views:viewsDictionary]];
    
    // reply Label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_replyLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-10.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_replyLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-8.0f]];
    
}

#pragma mark -
#pragma mark public

- (void)setAgrees:(NSUInteger)agrees
{
    [_agreeView setNumber:agrees];

    if (agrees != 0)
    {
        [_agreeView setHidden:NO];
        [_agreeView sizeToFit];
    }
    else
    {
        [_agreeView setHidden:YES];
    }
    
//    [self updateConstraints];
}

- (NSUInteger)agrees
{
    return _agreeView.number;
}

- (void)setDisagrees:(NSUInteger)disagrees
{
    [_disagreeView setNumber:disagrees];
    
    if (disagrees != 0)
    {
        [_disagreeView setHidden:NO];
        [_disagreeView sizeToFit];
    }
    else
    {
        [_disagreeView setHidden:YES];
    }
    
//    [self updateConstraints];
}

- (NSUInteger)disagrees
{
    return _disagreeView.number;
}

- (void)setNews:(NSUInteger)news
{
    [_newsView setNumber:news];

    if (news != 0)
    {
        [_newsView setHidden:NO];
        [_newsView sizeToFit];
    }
    else
    {
        [_newsView setHidden:YES];
    }
    
//    [self updateConstraints];
}

- (NSUInteger)news
{
    return _newsView.number;
}

- (void)setReplies:(NSInteger)replies
{
    NSInteger repliesRounded = MIN(replies, 1000);

    if (_replies != repliesRounded)
    {
        _replies = repliesRounded;
        
        if (replies >= 0)
        {
            NSString *text = nil;
            
            if (replies == 0)
            {
                text = @"";
            }
            else
                if (replies == 1)
                {
                    text = @"1 Reply";
                }
                else
                {
                    NSString *format = @"%i Replies";
                    text = [NSString localizedStringWithFormat:format, repliesRounded];
                }
            
            [_replyLabel setHidden:NO];
            [_replyLabel setText:text];
            [_replyLabel sizeToFit];
            
            [self setNeedsLayout];
        }
        else
        {
            [_replyLabel setHidden:YES];
        }
    }
}

@end
