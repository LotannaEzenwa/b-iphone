//
//  BBLoginButton.m
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBLoginButton.h"
#import "BBLoginTextField.h"
#import "UIKit+Extensions.h"

const CGFloat kContinueButtonWidthFactor = 0.5;

@implementation BBLoginButton

+ (id)new
{
    return [self buttonWithType:UIButtonTypeRoundedRect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.titleLabel.font = [BBApplicationSettings fontForKey:kFontLoginButton];
        self.backgroundColor = [BBApplicationSettings colorForKey:kColorGlobalDark];
        self.layer.cornerRadius = kLoginFieldCornerRadius;
        self.tintColor = [UIColor whiteColor];
        
        [self addSlightShadow];
    }
    return self;
}

@end
