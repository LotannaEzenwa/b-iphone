//
//  BBSegmentedControl.m
//  Boredat
//
//  Created by David Pickart on 12/1/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBApplicationSettings.h"
#import "BBSegmentedControl.h"
#import "UIKit+Extensions.h"

@interface BBSegmentedControl ()
{
    NSArray *_buttonArray;
    NSInteger _numButtons;
}

@end

@implementation BBSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor redColor];
        _selectedSegmentIndex = 0;
        _buttonArray = [NSArray new];
        _tintColor = [UIColor blackColor];
        
        // Set height
        CGFloat height = 40.0f;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    }
    return self;
}

#pragma mark -
#pragma mark public

- (void)setButtonsWithNames:(NSArray *)names
{
    // Remove old buttons from view
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *newButtonArray = [NSMutableArray new];
    
    _numButtons = [names count];
    
    for (int i = 0; i < _numButtons; i++)
    {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        // Set display position
        CGFloat width = [UIScreen mainScreen].bounds.size.width / _numButtons;
        CGFloat height = self.frame.size.height;
        CGPoint origin = CGPointMake(width * i, 0);
        CGRect frame = CGRectMake(origin.x, origin.y, width, height);
        newButton.frame = frame;
        
        // Set visual attributes
        newButton.backgroundColor = [UIColor whiteColor];
        [newButton setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
        CGFloat underlineHeight = 2.0f;
        CGFloat underlineInset = 8.0f;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(underlineInset, newButton.frame.size.height-underlineHeight, newButton.frame.size.width-underlineInset*2, underlineHeight)];
        [newButton addSubview:lineView];

        // Set behavior
        [newButton addTarget:self action:@selector(didPress:) forControlEvents:UIControlEventTouchUpInside];
        
        // Used for changing selectedSegmentIndex when clicked
        [newButton setTag:i];

        [self addSubview:newButton];
        [newButtonArray addObject:newButton];
    }
    
    [self layoutSubviews];
    _buttonArray = [NSArray arrayWithArray:newButtonArray];
    [self updateButtonColors];
}


#pragma mark -
#pragma mark private

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [self updateButtonColors];
}

- (void)didPress:(id)sender
{
    UIButton *button = (UIButton *)sender;

    if (button.tag != _selectedSegmentIndex)
    {
        _selectedSegmentIndex = button.tag;
        [self updateButtonColors];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)updateButtonColors
{
    for (NSInteger i = 0; i < _numButtons; i++)
    {
        UIButton *button = [_buttonArray objectAtIndex:i];
        button.tintColor = (i == _selectedSegmentIndex) ? _tintColor : [UIColor grayColor];
        UIView *underline = [button subviews][0];
        underline.backgroundColor = (i == _selectedSegmentIndex) ? _tintColor : [UIColor whiteColor];
    }
}

@end
