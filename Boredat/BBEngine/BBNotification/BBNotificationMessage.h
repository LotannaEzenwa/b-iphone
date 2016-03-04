//
//  BBNotificationMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBNotificationMessage : BBMessage
@property (copy, nonatomic, readwrite) NSNumber *page;
//@property (copy, nonatomic, readwrite) NSSet *fields;
@property (copy, nonatomic, readwrite) NSNumber *count;
@property (copy, nonatomic, readwrite) NSString *lastID;

- (BOOL)isEqualToNotificationMessage:(BBNotificationMessage *)message;

@end
