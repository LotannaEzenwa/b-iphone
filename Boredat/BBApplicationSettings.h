//
//  BBApplicationSettings.h
//  Boredat
//
//  Created by Dmitry Letko on 5/26/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

extern NSString *const kOptionsServer;
extern NSString *const kOptionsUseWebLogin;

extern NSString *const kServerValueProduction;
extern NSString *const kServerValueStaging;

typedef enum {
    kFontPost = 0,
    kFontLoginField,
    kFontLoginButton,
    kFontRegisterButton,
    kFontRegisterBackButton,
    kFontRegistrationTitle,
    kFontRegistrationInfoText,
    kFontVote,
    kFontReply,
    kFontTitle,
    kFontLoading,
    kFontLink,
    kFontOriginalPoster,
    kFontNotification,
    kFontPageUnselected,
    kFontPageSelected,
    kFontDetailsLarge,
    kFontDetailsSmall,
    kFontPersonalityName,
    kFontSettingsButton,
    kFontScreennameSwitcher
} BBFont;

typedef enum {
    kColorGlobalDark = 0,
    kColorGlobalLight,
    kColorGlobalGrayDark,
    kColorGlobalGrayLight,
    kColorLoginBackground
} BBColor;

@interface BBApplicationSettings : NSObject

// Oauth stuff
+ (NSString *)consumerKey;
+ (NSString *)consumerSecret;

+ (NSString *)picturesPath;
+ (NSString *)picturesLogin;
+ (NSString *)picturesPassword;
+ (NSString *)picturesFolder;

// Server info
+ (NSString *)localServer;
+ (NSString *)globalServer;
+ (NSString *)serverValue;

// Fonts and colors
+ (UIFont *)fontForKey:(BBFont)font;
+ (UIColor *)colorForKey:(BBColor)color;

// Regsitration Info text
+ (NSString *)infoTextAbout;
+ (NSString *)infoTextPIN;
+ (NSString *)infoTextCompletion;

@end
