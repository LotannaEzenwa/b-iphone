//
//  NSDictionary+Query.h
//  Boredat
//
//  Created by Dmitry Letko on 5/17/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface NSDictionary (Query)

+ (id)dictionaryWithQuery:(NSString *)query;

- (NSArray *)URLEncodedComponents;
- (NSArray *)URLEncodedComponentsWithFormat:(NSString *)format;

- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithSeparator:(NSString *)separator;
- (NSString *)URLEncodedStringWithFormat:(NSString *)format separator:(NSString *)separator;

@end
