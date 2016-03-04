//
//  BBRequestBuilder.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBMessageProtocol;
@protocol BBRequestProtocol;


/**
Builder class to assemble message data into a boredat request. 
 */

@interface BBRequestBuilder : NSObject

/**
 Assembles message data into a boredat request. 
 
 @param		message		Object that conforms to BBMessageProtocol 
						and provides necessary data to build corresponded request.
 @return				Created request object.
 */
+ (id<BBRequestProtocol>)requestWithMessage:(id<BBMessageProtocol>)message;

@end
