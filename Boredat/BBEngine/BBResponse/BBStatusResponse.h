//
//  BBStatusResponse.h
//  Boredat
//
//  Created by Dmitry Letko on 5/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBResponse.h"


@interface BBStatusResponse : BBResponse
@property (nonatomic, readonly) NSInteger status;
@property (copy, nonatomic, readonly) NSString *message;

@end
