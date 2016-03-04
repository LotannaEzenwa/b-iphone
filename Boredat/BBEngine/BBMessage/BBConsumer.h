//
//  BBConsumer.h
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

/**
 Class represents consumer (application or internet resource in general)
 that uses OAuth to access the Service Provider on behalf of the User.
 */

@interface BBConsumer : NSObject <NSCopying>

/**
 A string used by the Consumer to identify itself to the Service Provider. 
 */
@property (copy, nonatomic, readonly) NSString *key;

/**
 A string used by the Consumer to establish ownership of the Consumer Key. 
 */
@property (copy, nonatomic, readonly) NSString *secret;


/**
 Creates and returns a consumer object using the specified key and secret. 
 
 @param		key			The key string.
 @param		secret		The secret string.
 @return				A consumer object.
 */
+ (id)consumerWithKey:(NSString *)key secret:(NSString *)secret;

/**
 Initializes and returns a consumer object using the specified key and secret. 
 
 @param		key			The key string.
 @param		secret		The secret string.
 @return				An initialized consumer object.
 */
- (id)initWithKey:(NSString *)key secret:(NSString *)secret;

/**
 Returns a BOOL value that indicates whether the receiver and a given
 consumer object are equal.
 
 @param		consumer	The consumer object with which to compare the receiver.
 @return				YES if consumer is equivalent to the 
						receiver (if they have the same key and secret),
						otherwise NO.
 */
- (BOOL)isEqualToConsumer:(BBConsumer *)consumer;

@end
