//
//  BBVoteMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBVoteMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *UID;

- (BOOL)isEqualToVoteMessage:(BBVoteMessage *)message;

@end
