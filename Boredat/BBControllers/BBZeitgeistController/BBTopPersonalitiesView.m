//
//  BBTopPersonalitiesController.m
//  Boredat
//
//  Created by David Pickart on 3/1/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

#import "BBTopPersonalitiesView.h"
#import "BBUserImage.h"
#import "BBTopPersonalitiesAvatarView.h"
#import "BBApplicationSettings.h"

@interface BBTopPersonalitiesView () <BBTopPersonalitiesAvatarViewDelegate>

@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) BBTopPersonalitiesAvatarView *topPersonalitiesAvatarView;

@end

@implementation BBTopPersonalitiesView

#pragma mark -
#pragma mark Initialization

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    _topPersonalitiesAvatarView = [BBTopPersonalitiesAvatarView new];
    _topPersonalitiesAvatarView.delegate = self;

    _titleLabel = [UILabel new];
    _titleLabel.text = @"Top Personalities This Week";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [BBApplicationSettings fontForKey:kFontTitle];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.topPersonalitiesAvatarView];
    [self addSubview:self.titleLabel];
    
    [self configureConstraints];
    return self;
}


#pragma mark -
#pragma mark Public methods

- (void)setImages:(NSArray *)imagesArray
{
    self.topPersonalitiesAvatarView.topUsersImages = imagesArray;
}

#pragma mark -
#pragma mark Private methods

- (void)configureConstraints
{
    [_topPersonalitiesAvatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel(40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesAvatarView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesAvatarView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesAvatarView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topPersonalitiesAvatarView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

- (void)tapOnTopUserAvatarAtIndex:(int)index
{
    [_delegate tapOnTopUserAvatarAtIndex:index];
}

@end
