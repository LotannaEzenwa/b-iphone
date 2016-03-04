//
//  BBSilentAuthenticateMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 5/15/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBSilentAuthenticateMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *login;
@property (copy, nonatomic, readwrite) NSString *password;

@end
