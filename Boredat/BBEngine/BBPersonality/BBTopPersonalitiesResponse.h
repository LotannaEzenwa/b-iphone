//
//  BBPersonalitiesResponse.h
//  Boredat
//
//  Created by Anton Kolosov on 10/7/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"

@interface BBTopPersonalitiesResponse : BBResponse
@property (copy, nonatomic, readonly) NSArray *personalities;

@end
