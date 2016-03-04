//
//  BBPersonalityDetailsView.m
//  Boredat
//
//  Created by David Pickart on 5/13/15.
//  Copyright (c) 2015 Scand Ltd. All rights reserved.
//

#import "BBPersonalityDetailsView.h"
#import "BBApplicationSettings.h"
#import "BBUserImage.h"

@interface BBPersonalityDetailsView ()
@property (strong, nonatomic, readwrite) UILabel *dateLabel;
@property (strong, nonatomic, readwrite) UILabel *networkLabel;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UIButton *avatarImageView;

@end

@implementation BBPersonalityDetailsView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIColor *whiteColor = [UIColor whiteColor];
    self.backgroundColor = whiteColor;
    
    UIFont *smallFont = [BBApplicationSettings fontForKey:kFontDetailsSmall];
    
    _titleLabel = [UILabel new];
    _titleLabel.backgroundColor = whiteColor;
    _titleLabel.font = [BBApplicationSettings fontForKey:kFontPersonalityName];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor darkGrayColor];
    
    _networkLabel = [UILabel new];
    [_networkLabel setBackgroundColor:whiteColor];
    _networkLabel.font = smallFont;
    _networkLabel.textColor = [UIColor lightGrayColor];
    
    _postsLabel = [UILabel new];
    [_postsLabel setBackgroundColor:whiteColor];
    _postsLabel.font = smallFont;
    _postsLabel.textColor = [UIColor lightGrayColor];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setBackgroundColor:whiteColor];
    [_indicatorView setUserInteractionEnabled:NO];
    [_indicatorView setHidesWhenStopped:NO];
    [_indicatorView setHidden:YES];
    
    _avatarImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarImageView.userInteractionEnabled = NO;
    
    [self addSubview:_titleLabel];
    [self addSubview:_networkLabel];
    [self addSubview:_postsLabel];
    [self addSubview:_indicatorView];
    [self addSubview:_avatarImageView];
    
    [self setAutoresizesSubviews:NO];
    
    [self configureConstraints];

    return self;
}

- (void)configureConstraints
{
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_postsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_networkLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_avatarImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat leftTextMargin = 123.0f;
    CGFloat verticalTextSpacing = 5.0f;
    
    // title label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0
                                               constant:10.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:leftTextMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-10.0f]];
    
    // network label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_networkLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:verticalTextSpacing]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_networkLabel
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0f
                                               constant:leftTextMargin]];
    
    // posts label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_postsLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_networkLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:verticalTextSpacing]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_postsLabel
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:leftTextMargin]];
    
    // avatar imageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:10.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatarImageView(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatarImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarImageView(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatarImageView)]];
    
    
    // indicator view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_avatarImageView
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                               constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_avatarImageView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_avatarImageView
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0f
                                               constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_avatarImageView
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0
                                               constant:0.0f]];
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

- (void)setUserImage:(BBUserImage *)userImage
{
    _userImage = userImage;
    [self updateAvatar];
}

- (void)updateAvatar
{
    NSString *filepath = _userImage.filepath;
    
    if (filepath != nil)
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
    }
    else
    {
        [_avatarImageView setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

@end
