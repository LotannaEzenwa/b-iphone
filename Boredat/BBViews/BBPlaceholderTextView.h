//
//  BBPlaceholderTextView.h
//  Boredat
//
//  Created by Anton Kolosov on 10/2/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBPlaceholderTextView : UITextView

@property (strong, nonatomic, readwrite) UILabel *placeHolderLabel;

- (void)shouldHidePlaceholder:(BOOL)shouldHide;

@end
