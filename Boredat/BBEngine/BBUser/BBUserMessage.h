//
//  BBUserMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBUserMessage : BBMessage
@property (copy, nonatomic, readwrite) NSSet *fields;

- (BOOL)isEqualToUserMessage:(BBUserMessage *)message;

@end
