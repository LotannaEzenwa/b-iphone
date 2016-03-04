//
//  BBRequestProtocol.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

/**
 Set of methods and properties to be implemented to act as a Server request.
 */

@protocol BBRequestProtocol <NSObject>
@required

/**
 The original URLRequest.
 */
@property (copy, nonatomic, readonly) NSURLRequest *URLRequest;

/**
 Create new Boredat request object with specified URLRequest.
 
 @property URLRequest	The base URLReqest. 
 @return				A newly created object.
 */
+ (id)requestWithURLRequest:(NSURLRequest *)URLRequest;

/**
 Initialize new Boredat request object with specified URLRequest.
 
 @property URLRequest	The base URLReqest. 
 @return				A newly initialized object.
 */
- (id)initWithURLRequest:(NSURLRequest *)URLRequest;

@end
