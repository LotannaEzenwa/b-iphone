//
//  BBApplicationSettings.m
//  Boredat
//
//  Created by Dmitry Letko on 5/26/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBApplicationSettings.h"

#import "NSObject+NULL.h"
#import "UIKit+Extensions.h"

#define UserDefaults()  ([NSUserDefaults standardUserDefaults])

NSString *const kOptionsServer = @"kOptionsServer";
NSString *const kOptionsUseWebLogin = @"kOptionsUseWebLogin";

NSString *const kServerValueProduction = @"kServerValueProduction";
NSString *const kServerValueStaging = @"kServerValueStaging";


@implementation BBApplicationSettings

#pragma mark -
#pragma mark public

+ (NSString *)localServer
{
    return @"https://boredat.com/api/v1";
}

+ (NSString *)globalServer
{
    return @"https://boredat.com/global/api/v1";
}

+ (NSString *)serverValue
{
    NSString *string = [UserDefaults() stringForKey:kOptionsServer];
    
    if ([string isKindOfClass:[NSString class]] == YES)
    {
        return string;
    }
    
    return kServerValueProduction;
}

#pragma mark -
#pragma mark fonts and colors

+ (UIFont *)fontForKey:(BBFont)font
{
    switch (font) {
        case kFontPost:
            return [UIFont fontWithName:@"Helvetica" size:14.0f];
            
        case kFontLoginField:
            return [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
            
        case kFontLoginButton:
            return [UIFont fontWithName:@"Helvetica" size:18.0f];
            
        case kFontRegisterButton:
            return [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
            
        case kFontRegisterBackButton:
            return [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
            
        case kFontRegistrationTitle:
            return [UIFont fontWithName:@"Helvetica" size:24.0f];
            
        case kFontRegistrationInfoText:
            return [UIFont fontWithName:@"Helvetica" size:14.0f];

        case kFontVote:
            return [UIFont fontWithName:@"Helvetica-Light" size:14.0f];

        case kFontReply:
            return [UIFont fontWithName:@"Helvetica-Light" size:12.0f];

        case kFontTitle:
            return [UIFont fontWithName:@"Helvetica" size:18.0f];

        case kFontLoading:
            return [UIFont fontWithName:@"Helvetica" size:18.0f];

        case kFontLink:
            return [UIFont fontWithName:@"Helvetica-Light" size:14.0f];

        case kFontOriginalPoster:
            return [UIFont boldSystemFontOfSize:14.0f];

        case kFontNotification:
            return [UIFont fontWithName:@"Helvetica" size:14.0f];

        case kFontPageUnselected:
            return [UIFont fontWithName:@"Helvetica-Light" size:14.0f];

        case kFontPageSelected:
            return [UIFont fontWithName:@"Helvetica" size:14.0f];
            
        case kFontDetailsLarge:
            return [UIFont fontWithName:@"Helvetica" size:14.0f];

        case kFontDetailsSmall:
            return [UIFont fontWithName:@"Helvetica-Light" size:11.0f];
            
        case kFontPersonalityName:
            return [UIFont fontWithName:@"Helvetica" size:16.0f];

        case kFontSettingsButton:
            return [UIFont fontWithName:@"Helvetica" size:16.0f];
            
        case kFontScreennameSwitcher:
            return [UIFont fontWithName:@"Helvetica" size:14.0f];

        default:
            return [UIFont fontWithName:@"Helvetica" size:12.0f];
    }
}

+ (UIColor *)colorForKey:(BBColor)color
{
    switch (color) {
        case kColorGlobalDark:
            return [UIColor colorWithHexString:@"#0c3b5f"];
            
        case kColorGlobalLight:
            return [UIColor colorWithHexString:@"#5e9cd2"];
            
        case kColorGlobalGrayDark:
            return [UIColor colorWithWhite:0 alpha:.75];
            
        case kColorGlobalGrayLight:
            return [UIColor colorWithHexString:@"#c3c1be"];
            
        case kColorLoginBackground:
            return [UIColor colorWithHexString:@"#EEF5FA"];
            
        default:
            return [UIColor clearColor];
    }
}

#pragma mark -
#pragma mark info text

+ (NSString *)infoTextAbout
{
    return @"Boredat (b@ for short) is a private anonymous network for schools. \n \n B@ does not track any personally identifiable information about you. No GPS tracking, no email addresses and no identifiers that tie you to your physical device. b@ protects you by never storing this information.- what you say with your fellow students is no one's business but your own. \n All posts to b@ will have an equal opportunity to be heard.";
}

+ (NSString *)infoTextPIN
{
    return @"Since we will not keep a record of your email address, in the event that you forget your password, you're going to need some way to reset it! A secret 4-digit PIN is used instead. \n \nUse any 4 digits that you can remember easily.";
}

+ (NSString *)infoTextCompletion
{
    return @"Congratulations, you just created an account!\n \nPlease check your inbox for a verification email.";
}

#pragma mark -

+ (NSString *)consumerKey
{
    return @"d81a0dc62eaa717532d134db065270cb04fab84c1";
}

+ (NSString *)consumerSecret
{
    return @"f7a543570d6a6efdd38d7a9e3a51a2bd";
}

+ (NSString *)picturesPath
{    
    NSString *serverValue = [self serverValue];
    
    if ([serverValue isEqualToString:kServerValueProduction] == YES)
    {
        return @"https://boredatbaker.com/images/profile_pictures";
    }
    else
        if ([serverValue isEqualToString:kServerValueStaging] == YES)
        {
            return @"http://boredattest.com/images/profile_pictures";
        }
    
    return nil;
}

+ (NSString *)picturesLogin
{
    NSString *serverValue = [self serverValue];
    
    if ([serverValue isEqualToString:kServerValueStaging] == YES)
    {
        return @"root";
    }
    
    return nil;
}

+ (NSString *)picturesPassword
{
    NSString *serverValue = [self serverValue];
    
    if ([serverValue isEqualToString:kServerValueStaging] == YES)
    {
        return @"D!3v0rd137ry1n6";
    }
    
    return nil;
}

+ (NSString *)picturesFolder
{
    NSString *serverValue = [self serverValue];
    
    if ([serverValue isEqualToString:kServerValueProduction] == YES)
    {
        return @"production/images";
    }
    else
        if ([serverValue isEqualToString:kServerValueStaging] == YES)
        {
            return @"staging/images";
        }
    
    return nil;
}

@end
