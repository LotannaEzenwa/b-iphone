//
//  BBInlineWebViewController.h
//  Boredat
//
//  Created by Anton Kolosov on 9/23/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBInlineWebViewController : UIViewController

@property (strong, nonatomic, readwrite) NSURL *linkUrl;

- (id)initWithUrl:(NSURL *)url;

@end
