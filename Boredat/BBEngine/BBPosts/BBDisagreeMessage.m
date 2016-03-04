//
//  BBDisagreeMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 5/23/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBDisagreeMessage.h"


@implementation BBDisagreeMessage

#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/post/disagree";
}


@end
