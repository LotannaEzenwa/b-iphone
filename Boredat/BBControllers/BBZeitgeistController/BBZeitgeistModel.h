//
//  BBZeitgeistModel.h
//  Boredat
//
//  Created by David Pickart on 7/21/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBModel.h"
#import "BBPost.h"

typedef enum {
    kZeitgeistSectionNewsworthy = 0,
    kZeitgeistSectionBest,
    kZeitgeistSectionWorst
} BBZeitgeistSection;

@class BBPost;
@class BBUserImageFetcher;

@interface BBZeitgeistModel : BBModel

@property (strong, nonatomic, readwrite) BBUserImageFetcher *fetcher;
@property (strong, nonatomic, readwrite) NSMutableArray *topPersonalities;
@property (strong, nonatomic, readwrite) NSMutableArray *topPersonalityImages;

- (void)switchToSection:(BBZeitgeistSection)section;

@end
