//
//  BBFavoritePersonalityPostsMessage.h
//  Boredat
//
//  Created by David Pickart on 6/24/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBMessage.h"

@interface BBFavoritePersonalityPostsMessage : BBMessage

@property (copy, nonatomic, readwrite) NSNumber *page;
@property (copy, nonatomic, readwrite) NSString *UID;

@end
