//
//  BBVerificationButton.h
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kVerificationStateUnverified = 0,
    kVerificationStateVerifying,
    kVerificationStateVerified
} BBVerificationState;

@interface BBVerificationButton : UIControl

@property (nonatomic) BBVerificationState verificationState;

@end
