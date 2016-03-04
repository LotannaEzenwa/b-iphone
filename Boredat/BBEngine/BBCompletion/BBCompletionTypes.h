//
//  BBCompletionTypes.h
//  Boredat
//
//  Created by Dmitry Letko on 5/21/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBResponseProtocol;


/**
 
 */
typedef void (^completion_block_t)(id<BBResponseProtocol> response, NSError *error);


/**
 
 */
typedef void (^result_block_t)(NSError *error);