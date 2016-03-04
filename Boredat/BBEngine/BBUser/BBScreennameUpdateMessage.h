//
//  BBScreennameUpdateMessage.h
//  Boredat
//
//  Created by David Pickart on 7/2/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBMessage.h"

@interface BBScreennameUpdateMessage : BBMessage

@property (copy, nonatomic, readwrite) NSString *screenname;

@end
