//
//  BitID.h
//  OnChain
//
//  Created by Cool on 1/27/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitID : NSObject
+ (BOOL) checkBitIDValidatyWithQR:(NSURL *) urlQR;
+ (NSURL *) buildCallbackUrlFromBitUrl:(NSURL *) urlQR;
+ (NSDictionary *) getParametersFromURL:(NSURL *) urlQR;
+ (NSString *) extractNonceFromBitidUrl:(NSURL *) urlQR;

@end
