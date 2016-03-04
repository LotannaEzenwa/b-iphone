//
//  BBLoginMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 1/30/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBAuthenticateMessage.h"


@interface BBLoginMessage : BBAuthenticateMessage
@property (copy, nonatomic, readwrite) NSString *userID;
@property (copy, nonatomic, readwrite) NSString *password;

- (BOOL)isEqualToLoginMessage:(BBLoginMessage *)message;

@end
