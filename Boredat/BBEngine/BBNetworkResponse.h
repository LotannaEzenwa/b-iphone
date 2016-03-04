//
//  BBNetworkResponse.h
//  Boredat
//
//  Created by David Pickart on 12/18/15.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import "BBResponse.h"

@class BBNetwork;

@interface BBNetworkResponse : BBResponse

@property (strong, nonatomic, readonly) BBNetwork *network;

@end