//
//  BBJSONSerialization.h
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

@interface BBJSONSerialization : NSObject

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error;

@end
