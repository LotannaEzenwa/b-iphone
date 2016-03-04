//
//  MgmtUtils.h
//  Boredat
//
//  Created by Dmitry Letko on 7/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#define		cclear(var)             {if (var != nil) {[var release], var = nil;}}
#define		cclear_operation(obj)	{if (obj != nil) {[obj cancel], [obj release], obj = nil;}}