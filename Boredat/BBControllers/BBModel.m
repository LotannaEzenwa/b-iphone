//
//  BBModel.m
//  Boredat
//
//  Created by David Pickart on 12/11/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBModel.h"

@implementation BBModel


- (BOOL)hasData
{
    return [self numberOfObjects] > 0;
}

- (void)completeAction:(BBPostAction)action forObjectAtIndex:(NSInteger)index
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

- (NSInteger)numberOfObjects
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

- (id)objectAtIndex:(NSInteger)index
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

- (void)updateDataForced:(BOOL)forced
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

- (void)updateDataWithCompletion:(void (^)())block forced:(BOOL)forced
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

- (void)clearData
{
    @throw [NSException exceptionWithName:@"MethodOverrideException"
                                   reason:@"BBModel method needs to be overridden"
                                 userInfo:nil];
}

@end