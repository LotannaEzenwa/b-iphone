//
//  BBPlaceholderTextView.m
//  Boredat
//
//  Created by Anton Kolosov on 10/2/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBPlaceholderTextView.h"
#import "BBApplicationSettings.h"

@implementation BBPlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.placeHolderLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    [_placeHolderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeHolderLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:7.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeHolderLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:7.0f]];
}

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil)
    {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.font = [BBApplicationSettings fontForKey:kFontPost];
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor grayColor];
    }
    
    return _placeHolderLabel;
}

- (void)shouldHidePlaceholder:(BOOL)shouldHide
{
    if (shouldHide == YES)
    {
        self.placeHolderLabel.hidden = YES;
    }
    else
    {
        self.placeHolderLabel.hidden = NO;
    }
}

@end
