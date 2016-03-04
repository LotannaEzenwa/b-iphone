//
//  BBPostsMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBPostsMessage : BBMessage
@property (copy, nonatomic, readwrite) NSNumber *page;
@property (copy, nonatomic, readwrite) NSSet *fields;

- (BOOL)isEqualToPostsMessage:(BBPostsMessage *)message;

@end
