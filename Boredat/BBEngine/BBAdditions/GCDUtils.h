//
//  GCDUtils.h
//  Boredat
//
//  Created by Dmitry Letko on 7/24/12.
//  Copyright (c) 2014 Boredat LLC. All rights reserved.
//

#define		crelease_dispatch(dispatch_obj)			{if (dispatch_obj != NULL) {dispatch_release(dispatch_obj);}}
#define		cclear_dispatch(dispatch_obj)			{if (dispatch_obj != NULL) {dispatch_release(dispatch_obj), dispatch_obj = NULL;}}
#define		crelease_dispatch_source(dispatch_src)	{if (dispatch_src != NULL) {dispatch_source_cancel(dispatch_src), dispatch_release(dispatch_src);}}
#define		cclear_dispatch_source(dispatch_src)	{if (dispatch_src != NULL) {dispatch_source_cancel(dispatch_src), dispatch_release(dispatch_src), dispatch_src = NULL;}}


static inline void dispatch_sync_main_queue(dispatch_block_t block);
static inline void dispatch_background_queue(dispatch_block_t block);


static inline void dispatch_sync_main_queue(dispatch_block_t block)
{
    if ([NSThread isMainThread] == NO)
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    else
    {
        block();
    }
}

static inline void dispatch_background_queue(dispatch_block_t block)
{
    if ([NSThread isMainThread] == YES)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, block);
    }
    else
    {
        block();
    }
}
