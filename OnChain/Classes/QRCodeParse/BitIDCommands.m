//
//  BitIDCommands.m
//  OnChain
//
//  Created by Cool on 1/29/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "BitIDCommands.h"

#import <Chain/Chain.h>
#import <CoreBitcoin/CoreBitcoin.h>

#import "BitID.h"


@implementation BitIDCommands
+ (void) excuteBit:(NSString *) data withKey:(BTCKey *) dataKey
{
    
    BitIDCommands * idCommands = [[BitIDCommands alloc] init];
    [idCommands excuteBit:data withKey:dataKey];
    
}
- (void) excuteBit:(NSString *) data withKey:(BTCKey *) dataKey
{
    if (![BitID checkBitIDValidatyWithQR:[NSURL URLWithString:data]]) {
        return;
    }
    _data = data;
    _dataKey = dataKey;
    
    NSURL * callback = [BitID buildCallbackUrlFromBitUrl:[NSURL URLWithString:data]];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ is requesting that you identify yourself.\nDo you want to proceed?", callback] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        NSURL * callback = [BitID buildCallbackUrlFromBitUrl:[NSURL URLWithString:_data]];
        NSString * strSigned;// = dataKey.
        NSString * address = _dataKey.privateKeyAddress.string;
       
        NetworkingClass * serverReq = [[NetworkingClass alloc] init];
        serverReq.delegate = self;
        [serverReq doBitIDWithSigned:strSigned withPostBack:[callback absoluteString]  withAddress:address withData:_data];
    }
}
@end
