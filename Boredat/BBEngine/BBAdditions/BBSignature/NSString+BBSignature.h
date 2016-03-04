//
//  NSString+BBSignature.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface NSString (BBSignature)

- (NSData *)HMAC_SHA1_DataWithKey:(NSString *)key;

@end
