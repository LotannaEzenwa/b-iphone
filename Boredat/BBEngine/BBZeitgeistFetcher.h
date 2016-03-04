//
//  BBZeitgeistFetcher.h
//  Boredat
//
//  Created by Anton Kolosov on 2/7/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBFacade.h"
#import "BBUserImageFetcher.h"

typedef void(^completion_block)(BOOL success, id fetchedObject);

typedef NS_ENUM(NSInteger, ZeitgeistInfoType) {
    ZeitgeistInfoTypeTopPersonalities,
    ZeitgeistInfoTypeTopHeadlines,
    ZeitgeistInfoTypeBestPosts,
    ZeitgeistInfoTypeWorstPosts,
    ZeitgeistInfoTypeUsersInfo,
    ZeitgeistInfoTypeNetworkStats,
    ZeitgeistInfoTypeUsersOnlinePlot
};

@interface BBZeitgeistFetcher : NSObject

@property (strong, nonatomic, readwrite) BBFacade *facade;
@property (strong, nonatomic, readwrite) BBUserImageFetcher *fetcher;

- (void)updateInfoWithType:(ZeitgeistInfoType)type withCompletion:(completion_block)completionBlock;

@end
