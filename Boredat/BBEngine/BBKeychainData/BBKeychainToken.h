//
//  BBKeychainToken.h
//  Boredat
//
//  Created by Dmitry Letko on 3/18/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@class BBToken;


@interface BBKeychainToken : NSObject
@property (copy, nonatomic, readonly) NSString *label;
@property (copy, nonatomic, readwrite) BBToken *token;

- (id)initWithLabel:(NSString *)label;

@end
