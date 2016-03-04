//
//  BBSegmentedControl.h
//  Boredat
//
//  Created by David Pickart on 12/1/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// This is essentially a clone of the UISegmentedControl class
// Created to add a custom visual style

@interface BBSegmentedControl : UIControl

@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic) UIColor *tintColor;

- (void)setButtonsWithNames:(NSArray *)names;

@end
