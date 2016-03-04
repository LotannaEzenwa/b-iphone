//
//  BBAuthenticateResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/17/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBToken;


@interface BBAuthenticateResponse : BBResponse
@property (copy, nonatomic, readonly) NSString *host;
@property (copy, nonatomic, readonly) BBToken *token;
@property (copy, nonatomic, readonly) NSString *verifier;

@end
