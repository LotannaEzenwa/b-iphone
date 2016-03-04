//
//  BBTableSection.m
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

#import "BBTableSection.h"


@interface BBTableSection ()
@property (assign, nonatomic, readonly) BOOL isManual;

@end;


@implementation BBTableSection
@synthesize title = _title;
@synthesize cells = _cells;
@synthesize manualRows = _manualRows;


+ (id)section
{
	return [[self new] autorelease];
}

+ (id)sectionWithTitle:(NSString *)title
{
	return [[[self alloc] initWithTitle:title] autorelease];
}

- (id)init
{
	return [self initWithTitle:nil];
}

- (id)initWithTitle:(NSString *)title
{
	self = [super init];
	
	if (self != nil)
	{
		self.title = title;
		self.cells = nil;
		self.manualRows = nil;
	}
	
	return self;
}

- (void)dealloc
{
	self.title = nil;
	self.cells = nil;
	self.manualRows = nil;
	
	[super dealloc];
}


#pragma mark -
#pragma mark public

- (NSUInteger)cellsCount
{
	return self.cells.count;
}

- (NSArray*)rows
{
	if (self.isManual == YES) 
	{
		return [self.cells objectsAtIndexes:self.manualRows];
	}
	
	return self.cells;
}

- (NSUInteger)rowsCount
{	
	if (self.isManual == YES)
	{
		return self.manualRows.count;		
	}
	
	return self.cellsCount;	
}

- (BOOL)isManual
{
	return (self.manualRows != nil);
}

- (UITableViewCell*)cellWithIndex:(NSUInteger)index
{
	return [self.cells objectAtIndex:index];
}

- (UITableViewCell*)cellForRow:(NSUInteger)row
{
	return [self.rows objectAtIndex:row];
}

@end
