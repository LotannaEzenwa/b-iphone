//
//  BBUserImage.m
//  Boredat
//
//  Created by Dmitry Letko on 3/19/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBUserImage.h"

#import "MgmtUtils.h"


static NSString *const kFilepath = @"filepath";


@interface BBUserImage ()

@property (nonatomic, readwrite) BOOL loading;

@end


@implementation BBUserImage

+ (BOOL)automaticallyNotifiesObserversOfFilepath
{
    return NO;
}


#pragma mark -
#pragma mark NScopying callbacks

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark -
#pragma mark public

- (void)setFilepath:(NSString *)filepath
{
    if ([_filepath isEqualToString:filepath] == NO && _filepath != filepath)
    {
        [self willChangeValueForKey:kFilepath];
        
        if (filepath != nil)
        {
            _filepath = [filepath copy];
        }            
            
        [self didChangeValueForKey:kFilepath];
    }
}

@end
