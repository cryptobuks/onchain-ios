//
//  MultiUtils.h
//  OnChain
//
//  Created by Cool on 2/7/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTCTransaction, BTCKey;

@interface MultiUtils : NSObject
+ (NSInteger) crc16:(NSString *) serviceName;
+ (NSString *) bytesToHex:(NSData *) data;
+ (BTCTransaction *) signMultiSignatureWithTransaction:(BTCTransaction *) tx withKey:(BTCKey *) key;

@end
