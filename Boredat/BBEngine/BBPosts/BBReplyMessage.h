//
//  BBReplyMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBReplyMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *text;
@property (copy, nonatomic, readwrite) NSNumber *anonymously;
@property (copy, nonatomic, readwrite) NSString *locationUID;
@property (copy, nonatomic, readwrite) NSString *UID;

- (BOOL)isEqualToReplyMessage:(BBReplyMessage *)message;

@end
