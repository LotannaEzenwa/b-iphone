//
//  BBRequest.m
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBRequest.h"

#import "MgmtUtils.h"


@interface BBRequest ()
@property (copy, nonatomic, readwrite) NSURLRequest *URLRequest;

@end


@implementation BBRequest

+ (id)requestWithURLRequest:(NSURLRequest *)URLRequest
{
	return [[self alloc] initWithURLRequest:URLRequest];
}

- (id)initWithURLRequest:(NSURLRequest *)URLRequest
{
	self = [super init];
	
	if (self != nil)
	{
		_URLRequest = [URLRequest copy];
	}
	
	return self;
}

@end
