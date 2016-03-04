//
//  BBRepliesMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 1/24/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBRepliesMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *UID;
@property (copy, nonatomic, readwrite) NSSet *fields;

- (BOOL)isEqualToRepliesMessage:(BBRepliesMessage *)message;

@end
