//
//  BBViewController.m
//  Boredat
//
//  Created by Dmitry Letko on 2/11/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBViewController.h"

#import "UIKit+Extensions.h"


@interface BBViewController ()
{
@private
    BOOL _needsUpdateLayout;
}

@end


@implementation BBViewController

#pragma mark -
#pragma mark lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsUpdateLayout];
}

- (void)viewDidLayoutSubviews
{
    [self updateLayoutIfNecessary];
}


#pragma mark -
#pragma mark public

- (void)updateLayoutIfNecessary
{
    if (_needsUpdateLayout == YES)
    {
        [self updateLayout];
    }
}

- (void)updateLayout
{
    _needsUpdateLayout = NO;
}


#pragma mark -
#pragma mark private

- (void)setNeedsUpdateLayout
{
    if (_needsUpdateLayout == NO)
    {
        _needsUpdateLayout = YES;
        
        if (UIVIewControllerSupportsDidLayout == NO)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLayoutIfNecessary) object:nil];
            [self performSelector:@selector(updateLayoutIfNecessary) withObject:nil afterDelay:0.0];
        }
        else
        {
            [self.view setNeedsLayout];
        }
    }
}

@end
