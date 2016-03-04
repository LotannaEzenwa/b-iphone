//
//  BBLoginTextField.m
//  Boredat
//
//  Created by David Pickart on 27/10/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBLoginTextField.h"
#import "UIKit+Extensions.h"

const CGFloat kLoginFieldCornerRadius = 0; // 3.0f;
const CGFloat kLoginFieldHeight = 35.0f;
const CGFloat kLoginFieldBorderWidth = 1.5f;

@interface BBLoginTextField ()
{
    CALayer *_border;
}

@end

@implementation BBLoginTextField

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.centered = NO;
        self.textAlignment = NSTextAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
//        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [BBApplicationSettings colorForKey:kColorGlobalGrayDark];
        
        // Add border
        _border = [CALayer layer];
        _border.backgroundColor = [[BBApplicationSettings colorForKey:kColorGlobalDark] CGColor];
        
        [self.layer addSublayer:_border];
        
        self.cornerRadius = kLoginFieldCornerRadius;
    }
    return self;
}

- (void)setCornerRadius:(float)cornerRadius
{
    _cornerRadius = cornerRadius;
    // Apply radius to border
    self.layer.cornerRadius = cornerRadius;
}

- (void)drawRect:(CGRect)rect
{
    _border.frame = CGRectMake(0.0f, rect.size.height - kLoginFieldBorderWidth, rect.size.width, kLoginFieldBorderWidth);
    [super drawRect:rect];
}

- (void)setCentered:(BOOL)centered
{
    self.textAlignment = NSTextAlignmentCenter;
    _centered = centered;
}

// Set placeholder text color
- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder != nil)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0.5]}];
    }
}

// inset placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
}

// inset text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
}

// If centered, clear placeholder text when clicked
- (BOOL)becomeFirstResponder
{
    if (_centered)
    {
        self.defaultPlaceholder = self.placeholder;
        self.placeholder = @"";
    }
    return [super becomeFirstResponder];
}

// If centered, return placeholder text when left
- (BOOL)resignFirstResponder
{
    if (_centered)
    {
        self.placeholder = self.defaultPlaceholder;
    }
    return [super resignFirstResponder];
}

@end
