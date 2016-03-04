//
//  NSFoundation+Extensions.m
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "NSFoundation+Extensions.h"

#include <xlocale.h>

#import <CommonCrypto/CommonDigest.h>

@implementation NSDate (Extensions)

+ (id)dateWithString:(NSString *)string
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (NSString *)relativeWeekdayName
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *todayTime = [NSDate date];
    
    NSDate *date = nil;
    NSDate *today = nil;
    
    if ([calendar rangeOfUnit:NSCalendarUnitDay startDate:&date interval:NULL forDate:self] == YES)
    {
        if ([calendar rangeOfUnit:NSCalendarUnitDay startDate:&today interval:NULL forDate:todayTime] == YES)
        {
            NSDateComponents *oddsComponents = [calendar components:NSCalendarUnitDay fromDate:date toDate:today options:0];
            
            switch (oddsComponents.day)
            {
                case 0:
                    return @"Today";
                    
                case 1:
                    return @"Yesterday";
                    
                case 2:
                    return @"2 Days Ago";
                    
                case 3:
                case 4:
                case 5:
                case 6:
                {
                    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
                    
                    static const NSUInteger daysInTheWeek = 7;
                    
                    const NSInteger weekdayIndex = (dateComponents.weekday - calendar.firstWeekday);
                    const NSInteger weekday = (weekdayIndex + daysInTheWeek) % daysInTheWeek;
                    
                    NSArray *days = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
                    
                    NSString *chosenDay = [days objectAtIndex:(weekday-1)%days.count];
                    
                    return [NSString stringWithFormat:@"Last %@", chosenDay];
                }
            }

        }
    }
            
    return nil;
}

@end


@implementation NSString (SHA)

- (NSData *)SHA512
{
    unsigned char *digest = malloc(CC_SHA512_DIGEST_LENGTH);
	
	if (digest != NULL)
	{
        const char *cstring = self.UTF8String;
        const unsigned char *result = CC_SHA512(cstring, (unsigned int)strlen(cstring), digest);
        
		if (result != nil)
		{
			return [NSData dataWithBytesNoCopy:digest length:CC_SHA512_DIGEST_LENGTH freeWhenDone:YES];
		}
        
        free(digest);
	}
    
    return nil;
}

@end
