//
//  BBWebView.m
//  Boredat
//
//  Created by Dmitry Letko on 5/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBWebView.h"
#import "BBWebViewPlugin.h"
#import "BBWebViewDelegate.h"


@interface BBWebView ()
@property (weak, nonatomic, readwrite) id<UIWebViewDelegate> internalDelegate;
@property (weak, nonatomic, readwrite) id<UIWebViewDelegate, BBWebViewDelegate> externalDelegate;
@property (copy, nonatomic, readwrite) NSURLRequest *URLRequest;

@end


@implementation BBWebView

- (id)init
{
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self != nil)
	{
		self.internalDelegate = self;
	}
	
	return self;
}

//- (void)dealloc
//{
//	self.internalDelegate = nil;
//	self.externalDelegate = nil;
//	
//}


#pragma mark -
#pragma mark public

- (void)loadRequest:(NSURLRequest *)request
{
	[super loadRequest:request];
	
	self.URLRequest = request;
}

- (void)loadPlugin
{
	[self loadRequest:self.plugin.URLRequest];
}

- (void)retry
{
	[self loadRequest:self.URLRequest];
}


#pragma mark -
#pragma mark private

- (void)setDelegate:(id<UIWebViewDelegate, BBWebViewDelegate>)delegate
{
	self.externalDelegate = delegate;
}

- (id<UIWebViewDelegate, BBWebViewDelegate>)delegate
{
	return self.externalDelegate;
}

- (void)setInternalDelegate:(id<UIWebViewDelegate>)internalDelegate
{
	[super setDelegate:internalDelegate];
}

- (id<UIWebViewDelegate>)internalDelegate
{
	return [super delegate];
}


#pragma mark -
#pragma mark UIWebViewDelegate protocol callbacks

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	//if ([self isEqual:webView] == YES)
	{
		if ([self.plugin respondsToSelector:@selector(webView:didFailLoadWithError:)] == YES)
		{
			[self.plugin webView:webView didFailLoadWithError:error];
		}
		
		if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)] == YES)
		{
			[self.delegate webView:webView didFailLoadWithError:error];
		}
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//if ([self isEqual:webView] == YES)
	{
		if ([self.plugin respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)] == YES)
		{
			if ([self.plugin webView:webView shouldStartLoadWithRequest:request navigationType:navigationType] == NO)
			{
				if ([self.delegate respondsToSelector:@selector(webViewDidFindCallback:)] == YES)
				{
					[self.delegate performSelector:@selector(webViewDidFindCallback:) withObject:self];
				}
				
				return NO;
			}
		}
		else
		{
			if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)] == YES)
			{
				return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
			}	
		}
	}
	
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	//if ([self isEqual:webView] == YES)
	{
		if ([self.plugin respondsToSelector:@selector(webViewDidFinishLoad:)] == YES)
		{
			[self.plugin webViewDidFinishLoad:webView];
		}
		
		if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)] == YES)
		{
			[self.delegate webViewDidFinishLoad:webView];
		}
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	//if ([self isEqual:webView] == YES)
	{
		if ([self.plugin respondsToSelector:@selector(webViewDidStartLoad:)] == YES)
		{
			[self.plugin webViewDidStartLoad:webView];
		}
		
		if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)] == YES)
		{
			[self.delegate webViewDidStartLoad:webView];
		}
	}
}

@end
