//
//  BBPersonalityMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 3/20/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBPersonalityMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *UID;

- (BOOL)isEqualToPersonalityMessage:(BBPersonalityMessage *)message;

@end
