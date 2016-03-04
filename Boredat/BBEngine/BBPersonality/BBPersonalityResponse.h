//
//  BBPersonalityResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 3/20/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBPersonality;


@interface BBPersonalityResponse : BBResponse
@property (strong, nonatomic, readonly) BBPersonality *personality;

@end
