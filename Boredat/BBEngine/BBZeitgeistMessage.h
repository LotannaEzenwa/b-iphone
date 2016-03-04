//
//  BBZeitgeistMessage.h
//  Boredat
//
//  Created by Anton Kolosov on 10/9/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"

@interface BBZeitgeistMessage : BBMessage

@property (strong, nonatomic, readwrite) NSSet *fields;

- (BOOL)isEqualToZeitgeistMessage:(BBZeitgeistMessage *)message;

@end
