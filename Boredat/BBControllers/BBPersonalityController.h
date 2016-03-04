//
//  BBPersonalityController.h
//  Boredat
//
//  Created by David Pickart on 4/30/15.
//  Copyright (c) 2015 Boredat LLC. All rights reserved.
//

@class BBPersonality;
@class BBFacade;
@class BBUserImageFetcher;
@class BBPersonalityModel;

#import "BBTableViewController.h"

@interface BBPersonalityController : BBTableViewController

- (id)initWithPersonality:(BBPersonality *)personality;

@end
