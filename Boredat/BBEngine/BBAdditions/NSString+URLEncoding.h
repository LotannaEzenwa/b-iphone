//
//  NSString+URLEncoding.h
//  Boredat
//
//  Created by Dmitry Letko on 5/11/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface NSString (URLEncoding)
@property (copy, nonatomic, readonly) NSString *URLEncodedString;
@property (copy, nonatomic, readonly) NSString *URLDecodedString;

@end
