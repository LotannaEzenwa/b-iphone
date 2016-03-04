//
//  BBPrivatePostMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBPrivatePostMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *UID;
@property (copy, nonatomic, readwrite) NSSet *fields;

- (BOOL)isEqualToPrivatePostMessage:(BBPrivatePostMessage *)message;

@end
