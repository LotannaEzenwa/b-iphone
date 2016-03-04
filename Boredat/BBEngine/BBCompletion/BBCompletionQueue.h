//
//  BBCompletionQueue.h
//  Boredat
//
//  Created by Dmitry Letko on 5/26/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBCompletionQueueProtocol.h"


@interface BBCompletionQueue : NSObject <BBCompletionQueueProtocol>

+ (id)mainCompletionQueue;

@end
