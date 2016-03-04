//
//  BBResponseProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBResponseDataProtocol;



/**
 Set of properties and methods to be implemented to act as a Server response.
 */

@protocol BBResponseProtocol <NSObject>
@required

/**
 The URL redirection which led to acquisition of response.
 */
@property (copy, nonatomic, readonly) NSURLRequest *URLRedirection;
@property (copy, nonatomic, readonly) NSURLResponse *URLResponse;

/**
 Staticaly defines for a response class the necessity 
 of retrieving the URL redirection during the connection.
 */
//+ (BOOL)redirection;

/**
 Staticaly defines for a response class the necessity 
 of retrieving the JSON data during the connection.
 */
+ (BOOL)JSONObject;


/**
 Creates a response object initialized with a given data.
 
 @param		data	Object that conforms to BBResponseDataProtocol.
 @return			A response object.
 */
+ (id)responseWithData:(id<BBResponseDataProtocol>)data;

/**
 Returns a response object initialized with a given data.  
 
 @param		data	Object that conforms to BBResponseDataProtocol.
 @return			An initialized response object.
 */
- (id)initWithData:(id<BBResponseDataProtocol>)data;

@end
