//
//  BBUserResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBUser;


@interface BBUserResponse : BBResponse
@property (strong, nonatomic, readwrite) BBUser *user;

@end
