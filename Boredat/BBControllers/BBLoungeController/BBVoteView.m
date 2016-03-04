//
//  BBVoteView.m
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBVoteView.h"
#import "BBMultipleImageView.h"

#import "MgmtUtils.h"


@interface BBVoteView ()
@property (strong, nonatomic, readwrite) UITextField *textField;
@property (strong, nonatomic, readwrite) BBMultipleImageView *imageView;

@end


@implementation BBVoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        _imageView = [BBMultipleImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
        
        _textField = [UITextField new];
        _textField.enabled = NO;
        
        [self addSubview:_textField];
        [self addSubview:_imageView];
        
        [self setAutoresizesSubviews:NO];
        [self setUserInteractionEnabled:NO];
    }
    
    return self;
}

#pragma mark -
#pragma mark UIView overload

- (CGSize)sizeThatFits:(CGSize)size
{
    if (_number != 0)
    {
        CGSize textSize = [_textField sizeThatFits:size];
        CGSize imageSize = [_imageView sizeThatFits:size];
        // Add 10px of spacing to the right
        textSize.width += imageSize.width + 10;
        textSize.height += imageSize.height;
        return  textSize;
    }
    
    return CGSizeZero;
}

- (void)layoutSubviews
{    
    // Make icons to the right of the text
    CGRect imageFrame = _imageView.frame;
    imageFrame.origin = CGPointMake(_textField.frame.size.width + 1, 1);
    _imageView.frame = imageFrame;
}


#pragma mark -
#pragma mark public
- (void)setImage:(UIImage *)image
{
    [_imageView setImage:image];
}

- (UIImage *)image
{
    return _imageView.image;
}

- (void)setImagesCountMax:(NSUInteger)imagesCountMax
{
    [_imageView setCountMax:imagesCountMax];
}

- (NSUInteger)imagesCountMax
{
    return _imageView.countMax;
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    _textField.text = (number > 0) ? [NSString localizedStringWithFormat:@"%lu", (unsigned long)number] : nil;
    [_textField sizeToFit];
    [_imageView setCount:number];
    [_imageView sizeToFit];
}

@end
