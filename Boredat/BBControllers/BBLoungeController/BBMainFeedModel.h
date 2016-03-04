//
//  BBMainFeedModel.h
//  Boredat
//
//  Created by David Pickart on 8/3/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBGlobalEnums.h"
#import "BBModel.h"
#import <Foundation/Foundation.h>

@class BBPost;

@interface BBMainFeedModel : BBModel

@property (nonatomic, readwrite) NSInteger pageNumber;
@property (copy, nonatomic, readwrite) NSMutableArray *oldPosts;


- (NSMutableDictionary *)getPostDictionary;
- (void)setPosts:(NSArray *)posts;

@end
