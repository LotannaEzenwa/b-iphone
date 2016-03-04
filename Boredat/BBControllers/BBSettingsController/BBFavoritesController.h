//
//  BBFavoritesController.h
//  Boredat
//
//  Created by David Pickart on 6/24/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

@class BBFacade;
@class BBUserImageFetcher;

#import <UIKit/UIKit.h>
#import "BBTableViewController.h"

@interface BBFavoritesController : BBTableViewController

@property (strong, nonatomic, readwrite) BBFacade *facade;
@property (strong, nonatomic, readwrite) BBUserImageFetcher *fetcher;

@end