//
//  BBPostsResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@interface BBPostsResponse : BBResponse
@property (copy, nonatomic, readonly) NSNumber *page;
@property (copy, nonatomic, readonly) NSArray *posts;

@end
