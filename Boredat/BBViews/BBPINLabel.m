//
//  BBPINTextField.m
//  Boredat
//
//  Created by David Pickart on 12/31/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBPINLabel.h"

@interface BBPINLabel ()
{
    CALayer *_border;
}

@end

@implementation BBPINLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        self.font = [UIFont fontWithName:@"Helvetica-Light" size:28];
        self.textColor = [BBApplicationSettings colorForKey:kColorGlobalGrayDark];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor= [UIColor clearColor];
        
        _border = [CALayer layer];
        _border.backgroundColor = [BBApplicationSettings colorForKey:kColorGlobalDark].CGColor;

        [self.layer addSublayer:_border];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _border.frame = CGRectMake(0.0f, rect.size.height - 2.0, rect.size.width, 2.0f);
    [super drawRect:rect];
}

@end
