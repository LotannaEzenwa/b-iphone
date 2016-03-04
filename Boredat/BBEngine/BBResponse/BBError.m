//
//  BBError.m
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBError.h"

#import "MgmtUtils.h"

#import "NSObject+NULL.h"


NSString *const kBBErrorDomain = @"app.Boredat.error";

static NSString *const kError = @"error";
static NSString *const kMessage = @"message";
static NSString *const kNumber = @"errorNo";
static NSString *const kDetails = @"moreInfo";


@interface BBError ()
@property (copy, nonatomic, readwrite) NSString *message;
@property (copy, nonatomic, readwrite) NSNumber *number;
@property (copy, nonatomic, readwrite) NSString *details;

@end


@implementation BBError

+ (id)errorWithJSONObject:(id)JSONObject
{
	NSDictionary *JSONDictionary = NSDictionaryObject(JSONObject);
	NSDictionary *dictionary = NSDictionaryObject([JSONDictionary objectForKey:kError]);
	
	if (dictionary.count > 0)
	{
		return [self errorWithDictionary:dictionary];
	}
	
	return nil;
}

+ (id)error
{
	return [self new];
}

+ (id)errorWithDictionary:(NSDictionary *)dictionary
{
	return [(BBError *)[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
	if (self != nil)
	{        
		_message = [[dictionary objectForKey:kMessage] copy];
		_number = [[dictionary objectForKey:kNumber] copy];
		_details = [[dictionary objectForKey:kDetails] copy];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


#pragma mark -
#pragma mark public

- (NSInteger)code
{
	return _number.integerValue;
}

@end


@implementation BBError (NSError)

- (NSError *)NSErrorRepresentation
{
	NSDictionary *userInfo = [NSMutableDictionary dictionary];
	[userInfo setValue:_message forKey:NSLocalizedDescriptionKey];
	
	NSError *error = [NSError errorWithDomain: kBBErrorDomain
                                         code: self.code
                                     userInfo: userInfo];
	
	
	return error;
}

@end
