//
//  NSURLResponse+HTTPFields.m
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSURLResponse+HTTPFields.h"


const NSInteger cHTTPStatusOK = 200;
const NSInteger cHTTPStatusForbidden = 403;


@implementation NSURLResponse (HTTPFields)

- (BOOL)isHTTPResponse
{
	return [self isKindOfClass:[NSHTTPURLResponse class]];
}

- (NSHTTPURLResponse *)HTTPResponse
{
	if (self.isHTTPResponse == YES)
	{
		return  (NSHTTPURLResponse *)[self copy];
	}
	
	return nil;
}

- (NSInteger)status
{
	return self.HTTPResponse.statusCode;
}

- (BOOL)isSuccess
{
	return (self.status == cHTTPStatusOK);
}

- (BOOL)isForbidden
{
	return (self.status == cHTTPStatusForbidden);
}

- (NSUInteger)capacityToReserve
{
	return (self.expectedContentLength != NSURLResponseUnknownLength ? (int)self.expectedContentLength : 0.0f);
}

- (NSString *)statusMeessage
{
	return [NSHTTPURLResponse localizedStringForStatusCode:self.status];
}

- (NSDate *)lastModified
{
	if ([self respondsToSelector:@selector(allHeaderFields)] == YES) 
	{
		static NSString *const cStrLastModified = @"Last-Modified";
		static NSString *const cStrDateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
		
		NSDictionary *allHeaderFields = [self performSelector:@selector(allHeaderFields)];
		NSString *lastModifiedStr = [allHeaderFields objectForKey:cStrLastModified];
		
		if (lastModifiedStr.length > 0)
		{			
			NSDateFormatter *dateFormatter = [NSDateFormatter new];			
			[dateFormatter setDateFormat:cStrDateFormat];
			
			return [dateFormatter dateFromString:lastModifiedStr];
		}
	}
	
	return nil;
}

@end
