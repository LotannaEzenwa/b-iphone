//
//  BBPersonalityModel.h
//  Boredat
//
//  Created by David Pickart on 16/09/2015.
//  Copyright (c) 2015 Scand Ltd. All rights reserved.
//

#import "BBModel.h"
#import "BBPost.h"

typedef enum {
    kPersonalitySectionRecent = 0,
    kPersonalitySectionBest,
    kPersonalitySectionWorst
} BBPersonalitySection;

@class BBPost;
@class BBUserImageFetcher;
@class BBPersonality;

@interface BBPersonalityModel : BBModel

@property (strong, nonatomic, readwrite) BBPersonality *personality;

- (BBPersonalityModel *)initWithPersonality:(BBPersonality *)personality;
- (void)switchToSection:(BBPersonalitySection)section;

@end
