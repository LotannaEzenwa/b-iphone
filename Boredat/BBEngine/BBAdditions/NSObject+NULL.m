//
//  NSObject+NULL.m
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSObject+NULL.h"


id NSObjectOfClass(id object, Class ObjClass)
{
	if ([object isKindOfClass:ObjClass] == YES)
	{
		return object;
	}
	
	return nil;
}


#pragma mark -

NSString *NSStringObject(id object)
{
	return NSObjectOfClass(object, [NSString class]);
}

NSNumber *NSNumberObject(id object)
{
	return NSObjectOfClass(object, [NSNumber class]);
}

NSDate *NSDateObject(id object)
{
	return NSObjectOfClass(object, [NSDate class]);
}

NSDictionary *NSDictionaryObject(id object)
{
	return NSObjectOfClass(object, [NSDictionary class]);
}

NSArray *NSArrayObject(id object)
{
	return NSObjectOfClass(object, [NSArray class]);
}


#pragma mark -

static NSString *const cStrEmpty = @"";


NSString *NSStringNotNIL(NSString *string)
{
	if (string != nil)
	{
		return string;
	}
	
	return cStrEmpty;
}