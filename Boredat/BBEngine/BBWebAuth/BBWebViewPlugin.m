//
//  BBWebViewDelegate.m
//  Boredat
//
//  Created by Dmitry Letko on 5/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBWebViewPlugin.h"
#import "BBMessageProtocol.h"
#import "BBRequestBuilder.h"
#import "BBRequestProtocol.h"
#import "BBResponseData.h"
#import "BBResponseProtocol.h"
#import "BBCompletionQueue.h"

#import "LogUtils.h"


@interface BBWebViewPlugin ()
@property (strong, nonatomic, readwrite) id<BBMessageProtocol> message;
@property (strong, nonatomic, readonly) BBCompletionQueue *completionQueue;

- (void)callCompletionWithResponse:(id<BBResponseProtocol>)response error:(NSError *)error;

@end


@implementation BBWebViewPlugin

@synthesize result = _result;


static const NSRange cEmptyRange = {NSNotFound, 0};


#pragma mark -

+ (id)plugin
{
	return [self new];
}

+ (id)pluginWithMessage:(id<BBMessageProtocol>)message
{
	return [[self alloc] initWithMessage:message];
}

- (id)initWithMessage:(id<BBMessageProtocol>)message
{
	self = [super init];
	
	if (self != nil)
	{
		self.message = message.clone;
	}
	
	return self;
}



#pragma mark -
#pragma mark public

- (NSURLRequest *)URLRequest
{
	id<BBRequestProtocol> request = [BBRequestBuilder requestWithMessage:_message];
	NSURLRequest *URLRequest = request.URLRequest;
	
	return URLRequest;
}

- (NSString *)callback
{
	return _message.callback;
}


#pragma mark -
#pragma mark UIWebViewDelegate protocol callbacks

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
	DLogFunction();
	DLog(@"\t request :%@", request);
	*/
	
	//	delete me
	//	HTTPS workaround
	{
		NSMutableURLRequest *URLRequest = (NSMutableURLRequest *)request;
		
		NSURL *URL = URLRequest.URL;
		NSString *URLString = URL.absoluteString;
		
		NSString *URLStringFixed = [URLString stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
		NSURL *URLFixed = [NSURL URLWithString:URLStringFixed];
		
		URLRequest.URL = URLFixed;
	}	
	//
		
	
	if (self.callback.length > 0)
	{
		NSURL *URL = request.URL;
		NSString *URLString = URL.absoluteString;
		
		const NSRange range = [URLString rangeOfString:self.callback];
		const BOOL isEmpty = NSEqualRanges(range, cEmptyRange);
				
		if (isEmpty == NO)
		{
			BBResponseData *data = [BBResponseData data];
			data.URLRedirection = request;
			data.URLResponse = nil;
			data.JSONObject = nil;
			
			Class<BBResponseProtocol> BBResponseClass = self.message.BBResponseClass;
			id<BBResponseProtocol> response = [BBResponseClass responseWithData:data];
			
			
			[self callCompletionWithResponse:response error:nil];
			
			
			return NO;
		}
	}
		
	return YES;
}


#pragma mark -
#pragma mark private

- (BBCompletionQueue *)completionQueue
{
	return [BBCompletionQueue mainCompletionQueue];
}

- (void)callCompletionWithResponse:(id<BBResponseProtocol>)response error:(NSError *)error
{
	[self.completionQueue callBlock:self.completion response:response error:error];
}

@end
