//
//  BBLoginTextField.h
//  Boredat
//
//  Created by David Pickart on 27/10/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kLoginFieldCornerRadius;
extern const CGFloat kLoginFieldHeight;
extern const CGFloat kLoginFieldBorderWidth;

@interface BBLoginTextField : UITextField

@property (nonatomic, readwrite) float cornerRadius;
@property NSString *defaultPlaceholder;
@property (nonatomic) BOOL centered;

@end
