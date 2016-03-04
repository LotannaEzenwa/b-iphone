//
//  NSDictionary+Query.m
//  Boredat
//
//  Created by Dmitry Letko on 5/17/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSDictionary+Query.h"
#import "NSString+URLEncoding.h"


static NSString *const cStrObjFormat = @"%@";

static inline NSString *NSStringFromObject (id obj)
{	
	return [NSString stringWithFormat:cStrObjFormat, obj];
}



@implementation NSDictionary (NSString)


static NSString *const cStrQueryNameValueSeparator = @"=";
static NSString *const cStrQueryNameValueFormat = @"%@=%@";
static NSString *const cStrQuerySeparator = @"&";


+ (id)dictionaryWithQuery:(NSString *)query
{
	NSArray *queries = [query componentsSeparatedByString:cStrQuerySeparator];
		
	if (queries.count > 0)
	{
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:queries.count];
		
		[queries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSArray *nameValueArray = [obj componentsSeparatedByString:cStrQueryNameValueSeparator];
			
			if (nameValueArray.count == 2)
			{
				NSString *name = [nameValueArray objectAtIndex:0];
				NSString *value = [nameValueArray objectAtIndex:1];
				
				[dictionary setValue:value forKey:name];
			}
		}];
		
		return dictionary;
	}
	
	return nil;
}

- (NSArray *)URLEncodedComponents
{
	return [self URLEncodedComponentsWithFormat:cStrQueryNameValueFormat];
}

- (NSArray *)URLEncodedComponentsWithFormat:(NSString *)format
{
	NSMutableArray *components = [NSMutableArray arrayWithCapacity:self.count];
	
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSString *keyString = [NSStringFromObject(key) URLEncodedString];
		NSString *objString = [NSStringFromObject(obj) URLEncodedString];
		NSString *component = [NSString stringWithFormat:format, keyString, objString];
		
		if (component.length > 0)
		{
			[components addObject:component];
		}
	}];
	
	return components;
}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithSeparator:cStrQuerySeparator];
}

- (NSString *)URLEncodedStringWithSeparator:(NSString *)separator
{
	return [[self URLEncodedComponents] componentsJoinedByString:separator];
}

- (NSString *)URLEncodedStringWithFormat:(NSString *)format separator:(NSString *)separator
{
	return [[self URLEncodedComponentsWithFormat:format] componentsJoinedByString:separator];
}

@end
