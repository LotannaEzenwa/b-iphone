//
//  BBVerificationResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 2/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@interface BBVerificationResponse : BBResponse
@property (copy, nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) BOOL isVerified;

@end
