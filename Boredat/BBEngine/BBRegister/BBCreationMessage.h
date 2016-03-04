//
//  BBCreationMessage.h
//  Boredat
//
//  Created by Dmitry Letko on 2/22/14.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBMessage.h"


@interface BBCreationMessage : BBMessage
@property (copy, nonatomic, readwrite) NSString *userID;
@property (copy, nonatomic, readwrite) NSString *password;

@end
