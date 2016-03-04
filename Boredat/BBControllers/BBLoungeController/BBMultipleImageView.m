//
//  BBMultipleImageView.m
//  Boredat
//
//  Created by Dmitry Letko on 1/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMultipleImageView.h"

#import "MgmtUtils.h"

#import <QuartzCore/QuartzCore.h>


@interface BBMultipleImageView ()
@property (strong, nonatomic, readwrite) CALayer *content;

@end


@implementation BBMultipleImageView

+ (Class)layerClass
{
    return [CAReplicatorLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        _content = [CALayer new];
        _content.contentsGravity = kCAGravityResizeAspect;
        
        CAReplicatorLayer *replicator = (CAReplicatorLayer *)self.layer;
        [replicator addSublayer:_content];
        
        [self setAutoresizesSubviews:NO];
        [self setUserInteractionEnabled:NO];
    }
    
    return self;
}


#pragma mark -
#pragma mark UIView overload

- (void)drawRect:(CGRect)rect
{
    //  empty implementation
}

- (void)displayLayer:(CALayer *)layer
{
    const CGSize imageSize = _image.size;
    const NSInteger height = CGRectGetHeight(self.bounds);
    const NSInteger imageWidth = MIN((NSInteger)imageSize.width, height);
    const NSInteger imageHeight = MIN((NSInteger)imageSize.height, height);
    const CATransform3D transform = CATransform3DMakeTranslation(imageWidth, 0.0f, 0.0f);
    const NSUInteger count = MIN(_count, _countMax);
    
    _content.frame = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
    _content.contents = (id)_image.CGImage;
    
    CAReplicatorLayer *replicator = (CAReplicatorLayer *)layer;
    replicator.instanceTransform = transform;
    replicator.instanceCount = count;   
}

- (CGSize)sizeThatFits:(CGSize)size
{
    const CGSize imageSize = _image.size;
    const NSUInteger count = MIN(_count, _countMax);
        
    return CGSizeMake(imageSize.width * (CGFloat)count, imageSize.height);
}


#pragma mark -
#pragma mark public

- (void)setImage:(UIImage *)image
{
    if ([_image isEqual:image] == NO)
    {        
        if (image != nil)
        {
            _image = image;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setCount:(NSUInteger)count
{
    if (_count != count)
    {
        _count = count;
        
        [self setNeedsDisplay];
    }
}

- (void)setCountMax:(NSUInteger)countMax
{
    if (_countMax != countMax)
    {
        _countMax = countMax;
        
        [self setNeedsDisplay];
    }
}

@end
