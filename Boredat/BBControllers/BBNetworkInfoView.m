//
//  BBNetworkInfoView.m
//  Boredat
//
//  Created by David Pickart on 12/20/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBNetworkInfoView.h"

@interface BBNetworkInfoView ()
{
    UILabel *_topLabel;
    UILabel *_nameLabel;
}

@end

@implementation BBNetworkInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _topLabel = [UILabel new];
        _topLabel.text = @"Your network is:";
        _topLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _nameLabel.text = @"Hello world";
        
        [self addSubview:_topLabel];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self configureConstraints];
    [super drawRect:rect];
}

- (void)configureConstraints
{
    [_topLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // top text label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:-20.0f]];

    // network name label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:5.0f]];
}

# pragma mark -
#pragma mark getters and setters

- (void)setNetworkName:(NSString *)networkName
{
    _networkName = networkName;
    _nameLabel.text = _networkName;
}

@end
