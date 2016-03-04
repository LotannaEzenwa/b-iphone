//
//  NSData+BBSignature.h
//  Boredat
//
//  Created by Dmitry Letko on 5/16/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface NSData (BBSignature)

- (NSData *)HMAC_SHA1_DataWithKey:(NSString *)key;

@end
