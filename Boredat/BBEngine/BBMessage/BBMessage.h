//
//  BBMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessageProtocol.h"


/**
 This constant defines the HTTP GET method.
 */
extern NSString *const cHTTPMethodGET;

/**
 This constant defines the HTTP POST method.
 */
extern NSString *const cHTTPMethodPOST;


@class BBConsumer;
@class BBToken;


/**
 Class provides basic functionality for Server message in accordance with the BBMessageProtocol.
 
 @see	BBMessageProtocol
 */

@interface BBMessage : NSObject <BBMessageProtocol>

/**
 The base URL string (e.g.: scheme://hostname.domain/path) which is considered 
 to be used for constructing an URL string. 
 */
@property (copy, nonatomic, readwrite) NSString *server;

/** 
 @see	BBMessageProtocol
 */
@property (copy, nonatomic, readwrite) BBConsumer *consumer;

/** 
 @see	BBMessageProtocol
 */
@property (copy, nonatomic, readwrite) BBToken *token;

/** 
 @see	BBMessageProtocol
 */
@property (copy, nonatomic, readwrite) NSString *callback;

/** 
 @see	BBMessageProtocol
 */
@property (copy, nonatomic, readwrite) id<BBSignatureMethodProtocol> signatureMethod;

/**
 @see	BBMessageProtocol
 */
@property (nonatomic, readwrite) NSOperationQueuePriority priority;



/**
 Creates new message object.
 
 @return	A newly created message object.
 */
+ (id)message;

- (NSString *)pathComponent;

@end
