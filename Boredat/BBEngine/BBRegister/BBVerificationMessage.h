//
//  BBVerificationMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 2/21/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBVerificationMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *key;

@end
