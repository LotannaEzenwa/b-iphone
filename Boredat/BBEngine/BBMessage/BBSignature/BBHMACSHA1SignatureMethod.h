//
//  BBHMACSHA1SignatureMethod.h
//  Boredat
//
//  Created by Dmitry Letko on 5/14/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#import "BBSignatureMethodProtocol.h"


/**
 Class provides functionality to compute a Hash-based Message Authentication Code (HMAC) 
 using the SHA1 hash function in accordance with the BBSignatureMethodProtocol.
 
 @see	BBSignatureMethodProtocol
 */

@interface BBHMACSHA1SignatureMethod : NSObject <BBSignatureMethodProtocol>

@end
