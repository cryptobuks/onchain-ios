//
//  MultiUtils.m
//  OnChain
//
//  Created by Cool on 2/7/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "MultiUtils.h"
#import <CoreBitcoin/CoreBitcoin.h>

@implementation MultiUtils

+ (NSInteger) crc16:(NSString *) serviceName
{
    NSInteger crc = 0xFFFF;
    NSInteger polynomial = 0x1021;
    
    const Byte * bytes = [serviceName dataUsingEncoding:NSUTF8StringEncoding].bytes;

    for (NSInteger k = 0; k < [serviceName dataUsingEncoding:NSUTF8StringEncoding].length; k ++) {
        for (NSInteger i = 0; i < 8; i ++) {
            BOOL bit = ((bytes[k] >> (7 - i) & 1) == 1);
            BOOL c15 = ((crc >> 15 & 1) == 1);
            crc <<= 1;
            if (c15 ^ bit) {
                crc ^= polynomial;
            }
        }
    }
    
    crc &= 0xFFFF;
    return crc;
    
}
+ (NSString *) bytesToHex:(NSData *) data
{
    NSArray * hexArray = [NSArray arrayWithObjects:@"0", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F", nil];
    const Byte * bytes = data.bytes;
    char * hex;
    for (NSInteger j = 0; j < data.length; j ++) {
        NSInteger v = bytes[j] & 0xFF;
        hex[j * 2] = ((char)hexArray[v >> 4]);
        hex[j * 2 + 1] = ((char)hexArray[v & 0x0F]);
    }
    return [NSString stringWithUTF8String:hex];
}
+ (BTCTransaction *) signMultiSignatureWithTransaction:(BTCTransaction *) tx withKey:(BTCKey *) key
{
    for (NSInteger index = 0; index < tx.inputs.count; index ++) {
        BTCTransactionInput * txIn = tx.inputs[index];
        NSArray * chunks = [txIn.signatureScript scriptChunks];
        BTCScript * redeemScript = (((BTCScriptChunk *)chunks.lastObject).isOpcode) ? txIn.signatureScript : [[BTCScript alloc] initWithData:((BTCScriptChunk *)chunks.lastObject).pushdata];
        
    }
    return nil;
}
@end
