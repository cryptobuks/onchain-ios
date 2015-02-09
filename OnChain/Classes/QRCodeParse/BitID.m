//
//  BitID.m
//  OnChain
//
//  Created by Cool on 1/27/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "BitID.h"

@implementation BitID
+ (BOOL) checkBitIDValidatyWithQR:(NSURL *) urlQR
{
    if (![urlQR.scheme isEqualToString:@"bitid"]) {
        return NO;
    }
    if (!urlQR.host || !urlQR.path) {
        return NO;
    }
    if (!urlQR.path.length || [urlQR.path isEqualToString:@"/"]) {
        return NO;
    }
    if (![self extractNonceFromBitidUrl:urlQR]) {
        return NO;
    }
    return YES;
}
+ (NSURL *) buildCallbackUrlFromBitUrl:(NSURL *) urlQR
{
    NSString * strScheme = @"https";
    NSDictionary * dic = [self getParametersFromURL:urlQR];
    if (dic[@"u"]) {
        if (((NSString *)dic[@"u"]).length == 1) {
            strScheme = @"http";
        }
        
    }
    NSURL * result = [[NSURL alloc] initWithScheme:strScheme host:urlQR.host path:urlQR.path];
//    result.port = urlQR.port;
    
     
    return result;
}
+ (NSDictionary *) getParametersFromURL:(NSURL *) urlQR
{
    NSArray * array = [urlQR.absoluteString componentsSeparatedByString:@"?"];
    if (array.count > 1)
    {
        array = [array[1] componentsSeparatedByString:@"&"];
        if (array.count)
        {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            for (NSString * str in array)
            {
                NSArray * tmpArr = [str componentsSeparatedByString:@"="];
                if (tmpArr.count > 1) {
                    dic[tmpArr[0]] = tmpArr[1];
                }
                
            }
            return dic;
            
        }
    }
    return nil;
}
+ (NSString *) extractNonceFromBitidUrl:(NSURL *) urlQR
{
    NSArray * array = [urlQR.absoluteString componentsSeparatedByString:@"?"];
    if (array.count > 1)
    { 
        array = [array[1] componentsSeparatedByString:@"&"];
        if (array.count)
        {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            for (NSString * str in array)
            {
                NSArray * tmpArr = [str componentsSeparatedByString:@"="];
                if (tmpArr.count > 1) {
                    dic[tmpArr[0]] = tmpArr[1];
                    if ([tmpArr[0] isEqualToString:@"x"]) {
                        return tmpArr[1];
                    }
                }
                
            }

        }
    }
    
    return nil;
    
}
@end
