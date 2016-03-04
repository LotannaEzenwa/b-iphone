//
//  BBRegistrationMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 2/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBRegistrationMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *email;
@property (copy, nonatomic, readwrite) NSString *attempt_code;
@property (copy, nonatomic, readwrite) NSString *pin;

@end
