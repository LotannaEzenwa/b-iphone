//
//  BBVerificationButton.m
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBVerificationButton.h"
#import "BBLoginTextField.h"
#import "UIKit+Extensions.h"

@interface BBVerificationButton ()

@property UIView *unverifiedView;
@property UIActivityIndicatorView *verifyingView;
@property UIView *verifiedView;
@property NSArray *views;

@end

@implementation BBVerificationButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _verificationState = kVerificationStateUnverified;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = kLoginFieldHeight/2;
        self.layer.borderWidth = 1.0f;
        [self addSlightShadow];
        
        // Unverified view (chevron)
        UIImage *chevron = [[UIImage imageNamed:@"unverified@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _unverifiedView = [[UIImageView alloc] initWithImage:chevron];
        _unverifiedView.tintColor = [BBApplicationSettings colorForKey:kColorGlobalDark];
        
        // Verifying view (loading circle)
        _verifyingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _verifyingView.hidesWhenStopped = YES;
        
        // Unverified view (checkmark)
        UIImage *checkmark = [[UIImage imageNamed:@"verified@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _verifiedView = [[UIImageView alloc] initWithImage:checkmark];
        _verifiedView.tintColor = [UIColor agreeColor];

        [self addSubview:_unverifiedView];
        [self addSubview:_verifyingView];
        [self addSubview:_verifiedView];

        [self configureConstraints];
        
        [self draw];
    }
    return self;
}

- (void)configureConstraints
{
    // Center everything!
    for (UIView *view in @[_unverifiedView, _verifyingView, _verifiedView])
    {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0f
                                                          constant:0.0f]];
    }
}

- (void)draw
{
    UIColor *borderColor = [BBApplicationSettings colorForKey:kColorGlobalDark];
    
    _unverifiedView.hidden = YES;
    _verifyingView.hidden = YES;
    [_verifyingView stopAnimating];
    _verifiedView.hidden = YES;
    
    switch (_verificationState) {
        case kVerificationStateUnverified:
            _unverifiedView.hidden = NO;
            break;
            
        case kVerificationStateVerifying:
            _verifyingView.hidden = NO;
            [_verifyingView startAnimating];
            break;
            
        case kVerificationStateVerified:
            _verifiedView.hidden = NO;
            borderColor = [UIColor agreeColor];
            break;
            
        default:
            break;
    }
    
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setVerificationState:(BBVerificationState)verificationState
{
    _verificationState = verificationState;
    [self draw];
}

@end
