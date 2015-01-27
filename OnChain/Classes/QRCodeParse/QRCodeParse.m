//
//  QRCodeParse.m
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "QRCodeParse.h"

@implementation QRCodeParse
+ (NSString *) parseQRCodeWithString:(NSString *) strQRCode
{
    NSArray * array = [strQRCode componentsSeparatedByString:@"://"];
    if (array.count > 1) {
        if ([array[0] isEqualToString:@"bitid"]) {
            return [self getAuthontificateKeyWithString:array[1]];
        }
    }
    return nil;
}
+ (NSString *) getAuthontificateKeyWithString:(NSString *) string
{
    NSArray * array = [string componentsSeparatedByString:@"?"];
    if (array.count > 1) {
        NSArray * tmpArray = [array[1] componentsSeparatedByString:@"="];
        if (tmpArray.count>1) {
            if ([tmpArray[0] isEqualToString:@"x"]) {
                return tmpArray[1];
            }
        }
    }
    return nil;
}
@end
