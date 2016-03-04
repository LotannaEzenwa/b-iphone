//
//  BBAccountCreationController.h
//  Boredat
//
//  Created by David Pickart on 12/21/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBRegistrationController.h"

@interface BBAccountCreationController : BBRegistrationController

@property NSString *email;
@property NSString *username;
@property NSString *attempt_code;

@end
