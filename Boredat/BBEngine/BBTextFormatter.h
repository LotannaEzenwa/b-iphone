//
//  BBTextFormatter.h
//  Boredat
//
//  Created by David Pickart on 6/7/15.
//  Copyright (c) 2015 BoredAt LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTextFormatter : NSObject

+ (NSString *)serverTagWithNetworkName:(NSString *)name;

+ (NSMutableAttributedString *)addLinksToText:(NSString *)text;
+ (NSMutableAttributedString *)addOPTagToText:(NSMutableAttributedString *)text;
+ (NSMutableAttributedString *)addServerTagToText:(NSMutableAttributedString *)text withName:(NSString *)name;
+ (NSMutableAttributedString *)addParentLinkToText:(NSMutableAttributedString *)text withUID:(NSString *)UID;

+ (NSString *)stringWithDate:(NSDate *)date;

+ (NSString *)sanitizeText:(NSString *)text;
@end
