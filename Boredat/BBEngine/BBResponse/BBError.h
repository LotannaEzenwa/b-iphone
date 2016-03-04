//
//  BBError.h
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

/**
 This error domain is defined for Server errors.
 */
extern NSString *const kBBErrorDomain;


/**
 Class represents the error returned by Server and servers 
 to construct BBError object from returned JSON data.
 */
@interface BBError : NSObject <NSCopying>

/**
 A message of error.
 */
@property (copy, nonatomic, readonly) NSString *message;

/**
 A number of error.
 */
@property (copy, nonatomic, readonly) NSNumber *number;

/**
 Additional information about error.
 */
@property (copy, nonatomic, readonly) NSString *details;

/**
 Code of error (extracted from number).
 */
@property (nonatomic, readonly) NSInteger code;


/**
 Creates a BBError object initialized with a given JSON data.
 
 @param		JSONObject		The JSON data (NSArray or NSDictionary) is expected 
							to extract the info about error.
 @return					An BBError object.
 */
+ (id)errorWithJSONObject:(id)JSONObject;

/**
 Creates a BBError object initialized with a given dictionary.
 
 @param		dictionary		The dictionary with specified keys.
							The keys are hardcoded and well known to Server and developers.
 @return					A BBError object.
 */
+ (id)errorWithDictionary:(NSDictionary *)dictionary;

/**
 Returns a BBError object initialized with a given dictionary.  
 
 @param		dictionary		The dictionary with specified keys.
							The keys are hardcoded and well known to Server and developers.
 @return					An initialized BBError object.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


/**
 Adds some convenient methods to the BBString class.
 */

@interface BBError (NSError)

/**
 Creates and initializes an NSError object from the receiver.
 
 @return	An NSError object for kBBErrorDomain with the
			corresponded error code and the message.
 */
- (NSError *)NSErrorRepresentation;

@end