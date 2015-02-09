//
//  ChainCommands.m
//  OnChain
//
//  Created by Cool on 2/7/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "ChainCommands.h"
#import <CoreBitcoin/CoreBitcoin.h>

#import "NetworkingClass.h"
#import "MultiUtils.h"

@interface ChainCommands()<NetworkingClassDelegate>

@end

@implementation ChainCommands
- (void) processMPKRequestWithParams:(NSArray *) params withPostBack:(NSString *)postBack withKey:(BTCKey *) key
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 3; i + 1 < params.count; i += 2) {
        dic[params[i]] = params[i + 1];
    }
    dic[@"mpk"] = [key.publicKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NetworkingClass * req = [[NetworkingClass alloc] init];
    req.delegate = self;
    [req processMPKRequestWithDictionary:dic withPostBack:postBack];
    
}
- (void) processSignRequestWithParams:(NSArray *) params withPostBack:(NSString *)postBack withKey:(BTCKey *) key
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 3; i + 1 < params.count; i += 2) {
        dic[params[i]] = params[i + 1];
    }
    
    NetworkingClass * req = [[NetworkingClass alloc] init];
    req.delegate = self;
    [req processSignRequestWithDictionary:dic withPostBack:postBack];
    
}
- (void) processPubKeyRequestWithParams:(NSArray *) params withPostBack:(NSString *)postBack withKey:(BTCKey *) key
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"pubkey"] = [MultiUtils bytesToHex:key.publicKey];
    
    for (NSInteger i = 3; i + 1 < params.count; i += 2) {
        dic[params[i]] = params[i + 1];
    }
    
    NetworkingClass * req = [[NetworkingClass alloc] init];
    req.delegate = self;
    [req processSignRequestWithDictionary:dic withPostBack:postBack];
    
}
#pragma mark - NetworkingClassDelegate

- (void) successSignRequestWithResponse:(NSString *) strResponse
{
    NSString * transactionHex = strResponse;
    NSString * metaData = nil;
    if ([strResponse rangeOfString:@":"].length == 1 && [strResponse rangeOfString:@":"].location != NSNotFound) {
        transactionHex = [strResponse componentsSeparatedByString:@":"][0];
        metaData = [strResponse substringFromIndex:[strResponse rangeOfString:@":"].location + 1];
    }
    BTCTransaction * tx = [[BTCTransaction alloc] initWithHex:transactionHex];
    if (!tx.outputs.count) {
        NSString * txShort = [strResponse substringWithRange:NSMakeRange(0, 40)];
        NSLog(@"Invalid TX (%@)", txShort);
        return;
        
    }
    
    if (!metaData) {
        tx = [MultiUtils signMultiSignatureWithTransaction:tx withKey:nil];
    } else {
        
    }
}

@end
