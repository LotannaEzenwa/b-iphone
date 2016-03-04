//
//  BBTopPersonalitiesView.m
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBTopPersonalitiesAvatarView.h"
#import "BBUserImage.h"

static NSInteger const kImagesMax = 10;
static NSInteger const kImagesSize = 25;

@interface BBTopPersonalitiesAvatarView ()
{
    NSInteger _numImages;
}

- (void)onAvatarButton:(UIButton *)sender;

@end

@implementation BBTopPersonalitiesAvatarView

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _topUsersImages = [NSArray new];
        _numImages = kImagesMax;
    }
    return self;
}

#pragma mark -
#pragma mark Public methods

- (void)setTopUsersImages:(NSArray *)topUsersImages
{
    if (_topUsersImages != topUsersImages)
    {
        _topUsersImages = topUsersImages;
        _numImages = MIN(kImagesMax, [_topUsersImages count]);
        [self refreshImages];
    }
}

// Keep refreshing while there are images still loading
- (void)refreshImages
{
    // Refresh
    [self setNeedsDisplay];
    
    // Check if any are loading
    BOOL anyLoading = NO;

    for (int i = 0; i < _numImages; i++) {
        BBUserImage *image = [_topUsersImages objectAtIndex:i];
        if (image.loading == YES)
        {
            anyLoading = YES;
        }
    }
    
    // Recursively call if so
    if (anyLoading)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector: @selector(refreshImages)
                                       userInfo:nil
                                        repeats:NO];
    }
}

#pragma mark -
#pragma mark Private methods

- (void)drawRect:(CGRect)rect
{
    if (_topUsersImages.count)
    {
        CGFloat spacing = (self.frame.size.width - (_numImages*kImagesSize)) / (_numImages + 3);
        CGFloat shift = spacing*2;
        for (int i = 0; i < _numImages; i++)
        {
            BBUserImage *userImage = [_topUsersImages objectAtIndex:i];
            
            UIImage *image = [UIImage imageWithContentsOfFile:userImage.filepath];
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton addTarget:self action:@selector(onAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
            [imageButton setBackgroundImage:image forState:UIControlStateNormal];
            
            // Used to determine which personality is clicked on
            [imageButton setTag:i];
            
            [self addSubview:imageButton];
            
            [imageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:imageButton
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f
                                                              constant:shift]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:imageButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.0f]];
            
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(imageButton);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageButton(25.0)]" options:0 metrics:nil views:viewsDictionary]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageButton(25.0)]" options:0 metrics:nil views:viewsDictionary]];
            
            shift += kImagesSize + spacing;
        }
    }
}

- (void)onAvatarButton:(UIButton *)sender
{
    [_delegate tapOnTopUserAvatarAtIndex:(int)[sender tag]];
}

@end
