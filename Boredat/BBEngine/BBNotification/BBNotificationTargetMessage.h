//
//  BBNotificationTargetMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/15/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBNotificationTargetMessage : BBMessage
@property (copy, nonatomic, readwrite) NSArray *notifications;

- (BOOL)isEqualToNotificationTargetMessage:(BBNotificationTargetMessage *)message;

@end
