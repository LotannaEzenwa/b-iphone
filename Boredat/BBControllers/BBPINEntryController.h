//
//  BBPINEntryController.h
//  Boredat
//
//  Created by David Pickart on 12/30/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBRegistrationController.h"

@interface BBPINEntryController : BBRegistrationController

@property NSString *email;
@property NSString *username;
@property NSString *attempt_code;
@property NSString *PIN;

@end
