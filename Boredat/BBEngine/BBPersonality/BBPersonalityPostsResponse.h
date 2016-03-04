//
//  BBPersonalityPostsResponse.h
//  Boredat
//
//  Created by David Pickart on 5/20/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBResponse.h"

@interface BBPersonalityPostsResponse : BBResponse

@property (copy, nonatomic, readonly) NSArray *posts;

@end