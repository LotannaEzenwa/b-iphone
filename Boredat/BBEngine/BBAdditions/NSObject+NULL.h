//
//  NSObject+NULL.h
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

id NSObjectOfClass(id object, Class ObjClass);

NSString *NSStringObject(id object);
NSNumber *NSNumberObject(id object);
NSDate *NSDateObject(id object);
NSDictionary *NSDictionaryObject(id object);
NSArray *NSArrayObject(id object);

NSString *NSStringNotNIL(NSString *string);