//
//  BBPostMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBPostMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *UID;
@property (copy, nonatomic, readwrite) NSSet *fields;

- (BOOL)isEqualToPostMessage:(BBPostMessage *)message;

@end
