//
//  BBPostResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 1/25/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBPost;


@interface BBPostResponse : BBResponse
@property (strong, nonatomic, readonly) BBPost *post;

@end
