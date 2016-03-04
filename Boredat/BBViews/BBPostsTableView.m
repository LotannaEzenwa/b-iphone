//
//  BBPostsTableView.m
//  Boredat
//
//  Created by Dmitry Letko on 5/22/12.
//  Copyright (c) 2012 Scand Ltd. All rights reserved.
//

#import "BBPostsTableView.h"
#import "BBPostCell.h"
#import "BBPostsTableViewDelegate.h"
#import "BBPost.h"


@interface BBPostsTableView ()

- (BBPostCell *)dequeueReusableCell;
- (void)reloadPosts;

@end


@implementation BBPostsTableView
@synthesize bbDelegate = _bbDelegate;
@synthesize posts = _posts;


static NSString *const cCellIdentifier = @"cCellIdentifier";

static NSString *const kPathPosts = @"posts";


- (id)init
{
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame style:UITableViewStylePlain];
	
	if (self != nil)
	{
		self.dataSource = self;
		self.delegate = self;
			
		self.bbDelegate = nil;
		self.posts = nil;
		
		[self addObserver:self forKeyPath:kPathPosts options:0 context:@selector(reloadPosts)];
	}
	
	return self;
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:kPathPosts];
	
	self.bbDelegate = nil;
	self.posts = nil;
	
	[super dealloc];
}


#pragma mark -
#pragma mark UITableViewDataSource protocol callbacks

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	BBPost *post = [self.posts objectAtIndex:indexPath.row];
	BBPostCell *cell = [self dequeueReusableCell];		
	cell.post = post;
		
	return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate protocol callbacks

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([self.bbDelegate respondsToSelector:@selector(tableView:didSelectPost:)] == YES)
	{
		BBPost *post = [self.posts objectAtIndex:indexPath.row];
		
		[self.bbDelegate performSelector:@selector(tableView:didSelectPost:) withObject:self withObject:post];
	}
}


#pragma mark -
#pragma mark NSKeyValueObserving protocol callbacks

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{			
	const SEL selector = (SEL)context;
	
	if ([self respondsToSelector:selector] == YES)
	{		
		[self performSelectorOnMainThread: selector 
							   withObject: nil 
							waitUntilDone: YES];
	}
}


#pragma mark -
#pragma mark private

- (BBPostCell *)dequeueReusableCell
{
	BBPostCell *cell = [self dequeueReusableCellWithIdentifier:cCellIdentifier];	
	
	if (cell == nil)
	{
		cell = [BBPostCell cellWithReuseIdentifier:cCellIdentifier];
	}	
	
	return cell;
}

- (void)reloadPosts
{
	[self reloadData];
	[self reloadRowsAtIndexPaths:self.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationMiddle];
}

@end
