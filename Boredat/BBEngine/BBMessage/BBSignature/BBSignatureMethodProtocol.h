//
//  BBSignatureMethodProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

/**
 Set of properties and methods to be implemented to act as a signature method.
 */

@protocol BBSignatureMethodProtocol <NSObject, NSCopying>
@required

/**
 The name of the signature method.
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 Create new signature method object.
 
 @return	A newly created object.
 */
+ (id)method;

/**
 Makes data which is signature of specified string with secret.
 
 @property	text	The string to be signed;
 @property	secret	The secret key that determines the functional output 
					of a cryptographic algorithm.
 @return			
 */
- (NSData *)signText:(NSString *)text secret:(NSString *)secret;

/**
 Returns a BOOL value that indicates whether the receiver and a given
 signature method object are equal.
 
 @param		signature	The signature method object with which to compare the receiver.
 @return				YES if object is equivalent to the 
						receiver, otherwise NO.
 */
- (BOOL)isEqualToSignature:(id<BBSignatureMethodProtocol>)signature;

@end
