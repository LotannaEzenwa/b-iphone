//
//  BBNewsworthyMessage.m
//  Boredat
//
//  Created by Dmitry Letko on 1/31/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBNewsworthyMessage.h"


@implementation BBNewsworthyMessage

#pragma mark -
#pragma mark BBMessage overload

- (NSString *)pathComponent
{
    return @"/post/newsworthy";
}

@end
