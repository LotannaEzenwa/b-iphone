//
//  BBAccessMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@class BBToken;


@interface BBAccessMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *verifier;

@end
