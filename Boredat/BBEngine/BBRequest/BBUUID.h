//
//  BBUUID.h
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//


/**
 Class for generating 'Universally Unique Identifiers'. 
 */

@interface BBUUID : NSObject <NSCopying>

/**
 String representation of UUID.
 The standard format for UUIDs represented in ASCII is a string punctuated by hyphens, 
 for example 68753A44-4D6F-1226-9C60-0050E4C00067.
 */
@property (copy, nonatomic, readonly) NSString *string;

/**
 HEX string representation of UUID, for example 68753A444D6F12269C600050E4C00067.
 */
@property (copy, nonatomic, readonly) NSString *HEXString;


/**
 Create new random UUID object.
 
 @return			A newly created random UUID object.
 */
+ (id)uuid;

/**
 Create new UUID object with string representation.
 
 @property string	A string containing a UUID. 
					The standard format for UUIDs represented in ASCII is a string punctuated by hyphens, 
					for example 68753A44-4D6F-1226-9C60-0050E4C00067.
 @return			A newly created object.
 */
+ (id)uuidWithString:(NSString *)string;

/**
 Initialize new UUID object with string representation.
 
 @property string	A string containing a UUID. 
					The standard format for UUIDs represented in ASCII is a string punctuated by hyphens, 
					for example 68753A44-4D6F-1226-9C60-0050E4C00067.
 @return			A newly initialized object.
 */
- (id)initWithString:(NSString *)string;

/**
 Returns a BOOL value that indicates whether a given uuid is equal to the receiver.
 
 @property uuid		The uuid with which to compare the receiver.
 @return			YES if uuid is equivalent to the receiver, otherwise NO.
 */
- (BOOL)isEqualToUUID:(BBUUID *)uuid;

@end
