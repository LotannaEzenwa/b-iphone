//
//  NSFoundation+Extensions.h
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface NSDate (Extensions)

+ (id)dateWithString:(NSString *)string;

- (NSString *)relativeWeekdayName;

@end


@interface NSString (SHA)

- (NSData *)SHA512;

@end
