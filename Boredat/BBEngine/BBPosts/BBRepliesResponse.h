//
//  BBRepliesResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 1/24/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@interface BBRepliesResponse : BBResponse
@property (copy, nonatomic, readonly) NSArray *posts;

@end
