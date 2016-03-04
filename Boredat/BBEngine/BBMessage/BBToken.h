//
//  BBToken.h
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

/**
 Class represents token used by the Consumer in different requests to obtain
 authorization from the User, and exchanged for an Access Token or to gain 
 access to the Protected Resources.
 */

@interface BBToken : NSObject <NSCopying, NSCoding>

/**
 A string used to identify token. 
 */
@property (copy, nonatomic, readonly) NSString *key;

/**
 A string used by the Consumer to establish ownership of a given Token.  
 */
@property (copy, nonatomic, readonly) NSString *secret;


/**
 Creates and returns a token object using the specified key and secret. 
 
 @param		key			The key string.
 @param		secret		The secret string.
 @return				A token object.
 */
+ (id)tokenWithKey:(NSString *)key secret:(NSString *)secret;

/**
 Initializes and returns a token object using the specified key and secret. 
 
 @param		key			The key string.
 @param		secret		The secret string.
 @return				An initialized token object.
 */
- (id)initWithKey:(NSString *)key secret:(NSString *)secret;

/**
 Returns a BOOL value that indicates whether the receiver and a given
 token object are equal.
 
 @param		token	The consumer object with which to compare the receiver.
 @return			YES if token is equivalent to the 
					receiver (if they have the same key and secret),
					otherwise NO.
 */
- (BOOL)isEqualToToken:(BBToken *)token;

@end
