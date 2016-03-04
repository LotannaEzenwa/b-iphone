//
//  BBReplyBottomView.m
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBScreennameBottomView.h"

#import "MgmtUtils.h"

#import "BBApplicationSettings.h"
#import "UIKit+Extensions.h"

#import "BBFacade.h"


@interface BBScreennameBottomView ()
@property (strong, nonatomic, readwrite) UILabel *nameLabel;
@property (strong, nonatomic, readwrite) UIView *topBorder;

@end


@implementation BBScreennameBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        self.backgroundColor = [UIColor colorForColor:[[BBFacade sharedInstance] currentBoardColor] withOpacity:0.7];
        
        _topBorder = [UIView new];
        _topBorder.backgroundColor = [UIColor greyColor];
        
        _nameLabel = [UILabel new];
        _nameLabel.font = [BBApplicationSettings fontForKey:kFontScreennameSwitcher];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.userInteractionEnabled = YES;
        [_nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabel:)]];
        
        [self addSubview:_topBorder];
        [self addSubview:_nameLabel];
        
        self.clipsToBounds = YES;
        [self setAutoresizesSubviews:NO];
        
        [self configureConstraints];
    }
    
    return self;
}

- (void)configureConstraints
{
    [_topBorder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Top border
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topBorder
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topBorder
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topBorder
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:1.0f]];
    // Name label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:-12.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:-20.0f]];
}

#pragma mark -
#pragma mark public

- (void)setBorderColor:(UIColor *)color
{
    _topBorder.backgroundColor = color;
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    if (_name == nil || _name.length == 0)
    {
        _nameLabel.text = @"Click here to add a screenname.";
    }
    else
    {
        _nameLabel.text = [[NSString alloc] initWithFormat:@"Posting as %@", name];
    }

    [_nameLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)tapOnLabel:(UIGestureRecognizer *)sender
{
    [_delegate tapOnScreennameLabel:_nameLabel];
}

@end
