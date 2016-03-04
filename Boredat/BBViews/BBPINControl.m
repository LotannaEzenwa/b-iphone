//
//  BBPINControl.m
//  Boredat
//
//  Created by David Pickart on 12/31/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBPINControl.h"
#import "BBPinLabel.h"
#import "UIKit+Extensions.h"

const CGFloat kPINControlWidth = 175.0f;

@interface BBPINControl () <UITextFieldDelegate>
{
    BBPINLabel *_labelA;
    BBPINLabel *_labelB;
    BBPINLabel *_labelC;
    BBPINLabel *_labelD;
    UIColor *_labelHighlightColor;
    
    UITextField *_hiddenField;
    NSArray *_labels;
    UIView *_clickView;
}

@end

@implementation BBPINControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        self.PIN =  @"";
        _labelHighlightColor = [UIColor colorForColor:[UIColor blackColor] withOpacity:0.05];
        _labelA = [BBPINLabel new];
        _labelB = [BBPINLabel new];
        _labelC = [BBPINLabel new];
        _labelD = [BBPINLabel new];
    
        _labels = @[_labelA, _labelB, _labelC, _labelD];
    
        for (UILabel *label in _labels)
        {
            [self addSubview:label];
        }
    
        [self updateLabelsForPIN];
    
        _clickView = [UIView new];
        [_clickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOnPINField)]];
    
        _hiddenField = [UITextField new];
        _hiddenField.keyboardType = UIKeyboardTypeNumberPad;
        _hiddenField.alpha = 0.0f;
        [_hiddenField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:_hiddenField];
        [self addSubview:_clickView];
        [self configureConstraints];
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    _clickView.frame = rect;
}

- (void)configureConstraints
{
    CGFloat fieldWidth = 30.0f;
    CGFloat spacing = (kPINControlWidth - (4 * fieldWidth)) / 3;
    CGFloat leftDistance = 0.0f;
    
    for (UIView *view in _labels)
    {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftDistance]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:0.0
                                                               constant:fieldWidth]];
        leftDistance = leftDistance + fieldWidth + spacing;
    }
}


#pragma mark -
#pragma mark GUI callbacks

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_hiddenField.text.length > 3)
    {
        [_hiddenField resignFirstResponder];
    }
    self.PIN = textField.text;
}

- (void)updateLabelsForPIN
{
    // Display PIN contents in correct labels
    // and highlight next label
    for (BBPINLabel *label in _labels)
    {
        label.text = @" ";
        label.backgroundColor = [UIColor clearColor];
    }
    for (int i = 0; i < [self.PIN length]; i++)
    {
        BBPINLabel *label = [_labels objectAtIndex:i];
        label.text = [self.PIN substringWithRange:NSMakeRange(i, 1)];
    }
    if ([self.PIN length] < 4)
    {
        [(UILabel *)[_labels objectAtIndex:[self.PIN length]] setBackgroundColor:_labelHighlightColor];
    }
}

- (void)didClickOnPINField
{
    // Clear PIN if it's full
    if (_hiddenField.text.length > 3)
    {
        self.PIN = @"";
    }

    [_hiddenField becomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [_hiddenField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_hiddenField resignFirstResponder];
}

#pragma mark -
#pragma mark Getters and setters

- (NSString *)PIN
{
    return _hiddenField.text;
}

- (void)setPIN:(NSString *)PIN
{
    _hiddenField.text = PIN;
    [self updateLabelsForPIN];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

@end
