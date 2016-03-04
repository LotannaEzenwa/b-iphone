//
//  BBTextFormatter.m
//  Boredat
//
//  Created by David Pickart on 6/7/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import "BBTextFormatter.h"
#import "BBApplicationSettings.h"
#import "BBFacade.h"
#import "NSFoundation+Extensions.h"

@implementation BBTextFormatter

# pragma mark Server tags

+ (NSString *)serverTagWithNetworkName:(NSString *)name
{
    if ([name class] == [NSNull class]) {
        return @"";
    }
    if ([name isEqualToString:@"New York University"]) {
        return @"NYU";
    }
    // First word of name
    return [[name componentsSeparatedByString:@" "][0] capitalizedString];
}

# pragma mark Post cells

+ (NSMutableAttributedString *)addLinksToText:(NSString *)text
{
    NSArray *links = [self resultsForLinksWithText:text];
    NSString *copyText = [self truncateStringFromString:text withResults:links];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:copyText];
    [mutableString addAttribute:NSFontAttributeName value:[BBApplicationSettings fontForKey:kFontPost] range:NSMakeRange(0, [copyText length])];

    NSArray *truncateLinks = [self resultsForLinksWithText:copyText];
    
    if ([truncateLinks count] > 0)
    {
        for (int i = 0; i < [links count]; i++) {
            NSTextCheckingResult *shortlink = [truncateLinks objectAtIndex:i];
            NSTextCheckingResult *link = [links objectAtIndex:i];
            
            // Additional formatting goes here
            [mutableString addAttribute:NSFontAttributeName value:[BBApplicationSettings fontForKey:kFontLink] range:shortlink.range];
            //    [string addAttribute:NSForegroundColorAttributeName value:[[BBFacade sharedInstance] currentBoardLightColor] range:range];
            [mutableString addAttribute:@"containsLink" value:link.URL range:shortlink.range];
        }
    }
    
    return mutableString;
}

+ (NSMutableAttributedString *)addOPTagToText:(NSMutableAttributedString *)text
{
    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] initWithString:@"Original Poster "];
    NSRange textRange = NSMakeRange(0, [newText length]);
    
    // Additional formatting goes here
    [newText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0f/255.0f green:124.0f/255.0f blue:153.0f/255.0f alpha:1.0f] range:textRange];
    [newText addAttribute:NSFontAttributeName value:[BBApplicationSettings fontForKey:kFontOriginalPoster] range:textRange];
    
    [newText appendAttributedString:text];
    return newText;
}

+ (NSMutableAttributedString *)addServerTagToText:(NSMutableAttributedString *)text withName:(NSString *)name
{
    NSString *serverTag = [NSString stringWithFormat:@"  (%@)", name];
    NSRange textRange = NSMakeRange(0, [serverTag length]);
    NSMutableAttributedString *attributedServerTag = [[NSMutableAttributedString alloc] initWithString:serverTag];
    
    // Additional formatting goes here
    [attributedServerTag addAttribute:NSFontAttributeName value:[BBApplicationSettings fontForKey:kFontPost] range:textRange];
    [attributedServerTag addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:textRange];
    
    [text appendAttributedString:attributedServerTag];
    return text;
}

+ (NSMutableAttributedString *)addParentLinkToText:(NSMutableAttributedString *)text withUID:(NSString *)UID
{
    NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"Reply to %@: ", UID]];
    NSRange textRange = NSMakeRange(0, [newText length]);
    [newText appendAttributedString:text];
    
    // Additional formatting goes here
    [newText addAttribute:NSFontAttributeName value:[BBApplicationSettings fontForKey:kFontLink] range:textRange];
    
    NSURL *newUrl = [NSURL URLWithString:[@"http://boredat.com/post/" stringByAppendingString:UID]];
    [newText addAttribute:@"containsLink" value:newUrl range:textRange];
    return newText;
}

# pragma mark Dates

+ (NSString *)stringWithDate:(NSDate *)date
{
    if (date == nil) {
        return @"";
    }

    // Format date
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateString = [date relativeWeekdayName];
    if (dateString == nil)
    {
        dateString = [dateFormatter stringFromDate:date];
    }
    
    // Format time
    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSString *timeString = [timeFormatter stringFromDate:date];

    // Put it together
    return [NSString stringWithFormat:@"%@ at %@", dateString, timeString];
}

# pragma mark Post text

// This is gross legacy code
// TODO: clean it up
+ (NSString *)sanitizeText:(NSString *)text
{
    NSString *firstText = [text stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    firstText = [firstText stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    firstText = [firstText stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    firstText = [firstText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (firstText != nil)
    {
        NSMutableString *ASCIIString = [[NSMutableString alloc] initWithString:firstText];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ASCII_HTML" withExtension:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
        NSString *expression = @"&(.*);";
        
        while (true)
        {
            NSRange range = [ASCIIString rangeOfString:expression options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
            if (range.location == NSNotFound) break;
            
            
            NSString *stringforReplace = [ASCIIString substringWithRange:(NSRange){range.location, range.length}];
            NSArray *strings = [stringforReplace componentsSeparatedByString:@"&"];
            
            [strings enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
                if ([str length] > 0)
                {
                    NSString *key = [[str componentsSeparatedByString:@";"] objectAtIndex:0];
                    
                    NSString *value = [dict objectForKey:key];
                    if ([value length] == 0)
                    {
                        value = @"";
                    }
                    key = [@"&" stringByAppendingFormat:@"%@%@",key,@";"];
                    
                    [ASCIIString replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0,[ASCIIString length])];
                }
            }];
            
        }
        
        return ASCIIString;
    }
    else
    {
        return nil;
    }
}

#pragma mark -
#pragma mark private

+ (NSArray *)resultsForLinksWithText:(NSString *)text
{
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *links = [detector matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    return ([links count] > 0) ? links : nil;
}

+ (NSString *)truncateStringFromString:(NSString *)text withResults:(NSArray *)results
{
    NSString *copyText = text;
    
    if ([results count] > 0)
    {
        for (NSTextCheckingResult *result in results)
        {
            NSString *urlString = [NSString stringWithFormat:@"%@", result.URL];
            if ([urlString length] > 25)
            {
                NSString *truncateUrlString = [urlString substringToIndex:25];
                truncateUrlString = [truncateUrlString stringByAppendingString:@"..."];
                copyText = [copyText stringByReplacingOccurrencesOfString:urlString withString:truncateUrlString];
            }
        }
    }
    return copyText;
}


@end
