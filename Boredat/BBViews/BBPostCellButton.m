//
//  BBPostCellButton.m
//  Boredat
//
//  Created by David Pickart on 6/18/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBPostCellButton.h"
#import "UIKit+Extensions.h"
#import "BBFacade.h"

@implementation BBPostCellButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    BBPostCellButton *button = [super buttonWithType:buttonType];
    
    if (button != nil)
    {
        button.disabled = NO;
        button.clicked = NO;
        button.clickedColor = [UIColor blackColor];
    }
    return button;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [super setImage:templateImage forState:state];
}

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    [self updateView];
}

- (void)setClicked:(BOOL)clicked
{
    _clicked = clicked;
    [self updateView];
}

- (void)updateView
{
    UIColor *tintColor;
    UIImage *image;
    
    if (_clicked)
    {
        tintColor = self.clickedColor;
        image = self.clickedImage;
    }
    else if (_disabled)
    {
        tintColor = [UIColor colorForColor:[UIColor blackColor] withOpacity:0.2];
        image = self.defaultImage;
    }
    else
    {
        tintColor = [UIColor colorForColor:[UIColor blackColor] withOpacity:0.6];
        image = self.defaultImage;
    }

    [self setTintColor:tintColor];
    [self setImage:image forState:UIControlStateNormal];
}

@end
