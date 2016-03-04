//
//  BBUUID.m
//  Boredat
//
//  Created by Dmitry Letko on 5/10/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUUID.h"

#import "CFUtils.h"


static NSString *const kStrSeparator = @"-";
static NSString *const kStrEmpty = @"";


@interface BBUUID ()
{
@private
    CFUUIDRef _UUID;
}

@end


@implementation BBUUID

+ (id)uuid
{
	return [self new];
}

+ (id)uuidWithString:(NSString *)string
{
	return [[self alloc] initWithString:string];
}

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{		
		_UUID = CFUUIDCreate(nil);
	}
	
	return self;
}

- (id)initWithString:(NSString *)string
{
	self = [super init];
	
	if (self != nil)
	{
		_UUID = CFUUIDCreateFromString(nil, (CFStringRef)string);
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

//- (void)dealloc
//{
//    if (_UUID != NULL)
//    {
//        CFRelease(_UUID);
//        _UUID = NULL;
//    }
//	
//}


#pragma mark -
#pragma mark public

- (NSString *)string
{	
	return (__bridge_transfer NSString *)CFUUIDCreateString(nil, _UUID);
}

- (NSString *)HEXString
{
	return [self.string stringByReplacingOccurrencesOfString:kStrSeparator withString:kStrEmpty];
}


#pragma mark -
#pragma mark equality

- (BOOL)isEqual:(id)object
{
	if ([object isKindOfClass:[BBUUID class]] == YES)
	{
		return [self isEqualToUUID:(BBUUID *)object];
	}
	
	return NO;
}

- (NSUInteger)hash
{
	return (NSUInteger)CFHash(_UUID);
}

- (BOOL)isEqualToUUID:(BBUUID *)uuid
{	
	if (self == uuid)
	{
		return YES;
	}
	else
	{
		return (BOOL)CFEqual(_UUID, uuid->_UUID);
	}
}

@end
