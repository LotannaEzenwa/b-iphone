//
//  BBLoadingIndicator.m
//  Boredat
//
//  Created by David Pickart on 1/4/16.
//  Copyright © 2016 BoredAt LLC. All rights reserved.
//

#import "BBLoadingIndicator.h"
#import "FLAnimatedImage.h"

@interface BBLoadingIndicator ()
{
    FLAnimatedImageView *_spinner;
}

@end

@implementation BBLoadingIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource: @"loader" withExtension:@"gif"]]];
        _spinner = [FLAnimatedImageView new];
        _spinner.animatedImage = image;
        [self addSubview:_spinner];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _spinner.frame = rect;
}

@end
