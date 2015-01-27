//
//  Define_Gloabal.h
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)

#define SCREEN_WIDTH			[[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT			[[UIScreen mainScreen] bounds].size.height

#define MULTIPLY_VALUE          (IS_IPAD ? 2.0 : 1.0)
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

//#define SERVER_API                                @"https://api.chain.com/v2/"
#define SERVER_API                                @"https://carbonwallet.com/"
#define AUTHONTIFICATE_QR                           @"bitid_callback?x=%@"

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#define BIT_ID_PARAM_ADDRESS                        @"address"
#define BIT_ID_PARAM_SIGNATURE                      @"signature"
#define BIT_ID_PARAM_URI                            @"uri"

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#define TAG_WAIT_SCREEN_VIEW            1025
#define TAG_WAIT_SCREEN_INDICATOR       1026
#define TAG_WAIT_SCREEN_LABEL           1027

@interface Define_Gloabal : NSObject

@end
