//
//  BBMessageProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@protocol BBSignatureMethodProtocol;
@protocol BBResponseProtocol;
@class BBConsumer;
@class BBToken;


/**
 Set of properties and methods are necessary to construct corresponded HTTP request.
 */

@protocol BBHTTPProtocol <NSObject>
@required

/**
 The URL string for message excluding queries.
 */
@property (copy, nonatomic, readonly) NSString *URLString;

/**
  A dictionary containing queries concatenated and appended to URL string.
 */
@property (copy, nonatomic, readonly) NSDictionary *URLQueries;

/**
 The receiver’s HTTP request method.
 */
@property (copy, nonatomic, readonly) NSString *HTTPMethod;

/**
 A dictionary containing parameters included in HTTP body as a string. 
 The standard format for concatenating parameters is "name1=value1&name2=value2&...";
 */
@property (copy, nonatomic, readonly) NSDictionary *HTTPBodyParameters;

/**
 A dictionary containing receiver’s HTTP header fields.
 */
@property (copy, nonatomic, readonly) NSDictionary *HTTPHeaders;

@end



/**
 Set of properties and methods to be implemented to enable the authorization functionality.
 */

@protocol BBAuthorizationProtocol <BBHTTPProtocol>
@required

/**
 The flag to enable (YES) / disable (NO) the completion of 
 authorization data and signing it.
 */
@property (nonatomic, readonly) BOOL authorization;

/**
 The consumer object attached to the message.
 */
@property (copy, nonatomic, readonly) BBConsumer *consumer;

/**
 The token object attached to the message.
 */
@property (copy, nonatomic, readonly) BBToken *token;

/**
 The string of URL to which to return the user after authorization.
 It is used globally for more handy interception of corresponded request.
 */
@property (copy, nonatomic, readonly) NSString *callback;

/**
 A dictionary with additional OAuth parameters.
 */
@property (copy, nonatomic, readonly) NSDictionary *additional;

/**
 The signature method object used to sign authorization data.
 */
@property (copy, nonatomic, readonly) id<BBSignatureMethodProtocol> signatureMethod;

@end



/**
 Set of properties and methods to be implemented to act as a Server message.
 */

@protocol BBMessageProtocol <BBAuthorizationProtocol, NSMutableCopying>
@required

/**
 A class that conforms to BBResponseProtocol used to build corresponded response to a message.
 */
@property (nonatomic, readonly) Class<BBResponseProtocol> BBResponseClass;

/**
 Returns a BOOL value that indicates whether the receiver and a given
 message object are equal.
 
 @param		message		The consumer object with which to compare the receiver.
 @return				YES if message is equivalent to the 
						receiver, otherwise NO.
 */
- (BOOL)isEqualToMessage:(id<BBMessageProtocol>)message;

/**
 Returns a new instance that is a copy of the receiver.
 The main aim of this method is to create a local copy and to make sure
 it cannot be modified outside.
 
 @return	The cloned object.
 */

@property (nonatomic, readwrite) NSOperationQueuePriority priority;

- (id)clone;

- (id)mutableCopy;

@end
