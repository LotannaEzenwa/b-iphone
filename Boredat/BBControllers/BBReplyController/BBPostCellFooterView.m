//
//  BBPostCellFooterView.m
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPostCellFooterView.h"
#import "BBPostCellButton.h"

#import "MgmtUtils.h"

#import "UIKit+Extensions.h"
#import "BBApplicationSettings.h"

@interface BBPostCellFooterView ()
{
    UIView *_topBorder;
}

@end


@implementation BBPostCellFooterView
 
- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        // This will intercept all taps which don't hit a button
        [self addGestureRecognizer:[UITapGestureRecognizer new]];
        
        _topBorder = [UIView new];
        _topBorder.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.10f];
        [self addSubview:_topBorder];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.02f]];
        
        _agreeButton = [self newButton];
        _agreeButton.defaultImage = [UIImage imageNamed:@"agree_default@2x.png"];
        _agreeButton.clickedImage = [UIImage imageNamed:@"agree_clicked@2x.png"];
        [_agreeButton addTarget:self action:@selector(onAgree:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton setClickedColor:[UIColor agreeColor]];
        [self addSubview:_agreeButton];
        
        _disagreeButton = [self newButton];
        _disagreeButton.defaultImage = [UIImage imageNamed:@"disagree_default@2x.png"];
        _disagreeButton.clickedImage = [UIImage imageNamed:@"disagree_clicked@2x.png"];
        [_disagreeButton addTarget:self action:@selector(onDisagree:) forControlEvents:UIControlEventTouchUpInside];
        [_disagreeButton setClickedColor:[UIColor disagreeColor]];
        [self addSubview:_disagreeButton];
        
        _newsworthyButton = [self newButton];
        _newsworthyButton.defaultImage = [UIImage imageNamed:@"newsworthy_default@2x.png"];
        _newsworthyButton.clickedImage = [UIImage imageNamed:@"newsworthy_clicked@2x.png"];
        [_newsworthyButton addTarget:self action:@selector(onNewsworthy:) forControlEvents:UIControlEventTouchUpInside];
        [_newsworthyButton setClickedColor:[UIColor grayColor]];
        [self addSubview:_newsworthyButton];
        
        _replyButton = [self newButton];
        _replyButton.defaultImage = [UIImage imageNamed:@"reply_default@2x.png"];
        _replyButton.defaultImage = [UIImage imageNamed:@"reply_default@2x.png"];
        [_replyButton addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_replyButton];
        
        _anonButton = [self newButton];
//        [_anonButton setImage:[UIImage imageNamed:@"anon_default@2x.png"] forState:UIControlStateNormal];
//        [_anonButton addTarget:self action:@selector(onNewsworthy:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_anonButton];
        
        [self configureConstraints];
    }
    
    return self;
}

- (BBPostCellButton *)newButton
{
    BBPostCellButton *button = [BBPostCellButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [BBApplicationSettings fontForKey:kFontLink];
    button.showsTouchWhenHighlighted = NO;
    return button;
}

- (void)configureConstraints
{
    [_topBorder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_agreeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_disagreeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_newsworthyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_replyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_anonButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Top border
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_topBorder
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:1.0f]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_topBorder
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1.0
                                                       constant:0.0f]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_topBorder
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0.0f]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_topBorder
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0
                                                       constant:15.0f]];

    
    const NSInteger totalButtonWidth = 200;
    NSInteger spacing = ([UIScreen mainScreen].bounds.size.width - totalButtonWidth) / 4.0;
    
    // Agree
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_agreeButton
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_agreeButton
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_agreeButton
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:spacing]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_agreeButton
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0
                                                       constant:0.0f]];

    // Disagree
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_disagreeButton
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_disagreeButton
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_disagreeButton
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_agreeButton
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant: spacing]];
     [self addConstraint: [NSLayoutConstraint constraintWithItem:_disagreeButton
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0f]];

    // Newsworthy
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_newsworthyButton
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_newsworthyButton
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
     [self addConstraint: [NSLayoutConstraint constraintWithItem:_newsworthyButton
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:_disagreeButton
                                                       attribute:NSLayoutAttributeRight
                                                      multiplier:1.0
                                                        constant:spacing]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_newsworthyButton
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0f]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_replyButton
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_replyButton
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_replyButton
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_newsworthyButton
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1.0
                                                       constant:spacing]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:_replyButton
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0
                                                       constant:0.0f]];
}

#pragma mark -
#pragma mark button events

- (void)onAgree:(BBPostCellButton *)sender
{
    if (!sender.disabled) {
        [_delegate footerViewDidPressAgree:self];
    }
}

- (void)onDisagree:(BBPostCellButton *)sender
{
    if (!sender.disabled) {
        [_delegate footerViewDidPressDisagree:self];
    }
}

- (void)onNewsworthy:(BBPostCellButton *)sender
{
    if (!sender.disabled) {
        [_delegate footerViewDidPressNewsworthy:self];
    }
}

- (void)onReply:(BBPostCellButton *)sender
{
    if (!sender.disabled) {
        [_delegate footerViewDidPressReply:self];
    }
}

@end
