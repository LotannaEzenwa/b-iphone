//
//  BBViewController.h
//  Boredat
//
//  Created by David Pickart on 29/10/2015.
//  Copyright © 2015 BoredAt LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPost;
@class BBPersonality;

@interface BBViewController : UIViewController

- (void)presentPersonalityControllerWithPersonality:(BBPersonality *)personality;

- (void)presentReplyControllerWithPost:(BBPost *)post;
- (void)presentReplyControllerWithPostAtURL:(NSURL *)url;

@end
