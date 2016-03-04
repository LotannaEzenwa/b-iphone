//
//  BBTopHeadlinesResponse.h
//  Boredat
//
//  Created by Anton Kolosov on 1/14/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"

@interface BBTopHeadlinesResponse : BBResponse

@property (copy, nonatomic, readonly) NSArray *posts;

@end
