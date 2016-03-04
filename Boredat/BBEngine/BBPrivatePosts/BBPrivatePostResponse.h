//
//  BBPrivatePostResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/8/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBPrivatePost;


@interface BBPrivatePostResponse : BBResponse
@property (strong, nonatomic, readonly) BBPrivatePost *post;

@end
