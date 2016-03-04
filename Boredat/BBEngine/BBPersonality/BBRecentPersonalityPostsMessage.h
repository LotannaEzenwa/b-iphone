//
//  BBRecentPersonalityPostsMessage.h
//  Boredat
//
//  Created by David Pickart on 5/20/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBMessage.h"

@interface BBRecentPersonalityPostsMessage : BBMessage

@property (copy, nonatomic, readwrite) NSNumber *page;
@property (copy, nonatomic, readwrite) NSString *UID;

@end
