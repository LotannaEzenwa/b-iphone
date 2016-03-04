//
//  BBRequestResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@class BBToken;


@interface BBRequestResponse : BBResponse
@property (copy, nonatomic, readonly) BBToken *token;
@property (nonatomic, readonly) NSInteger tokenTTL;
@property (nonatomic, readonly) BOOL confirmed;

@end
