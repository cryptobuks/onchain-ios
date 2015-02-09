//
//  NetworkingClass.m
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "NetworkingClass.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "JSON.h"

#import "AppDelegate.h"
#import "Define_Gloabal.h"

@implementation NetworkingClass
- (void) doBitIDWithSigned:(NSString *) strSigned withPostBack:(NSString *) postBack withAddress:(NSString *)address withData:(NSString *) data
{
    
    [[AppDelegate sharedAppDelegate] showWaitingScreen:NSLocalizedString(@"Connecting...", @"Connecting...") bShowText:YES withSize:CGSizeMake(150 * MULTIPLY_VALUE, 100 * MULTIPLY_VALUE)];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[BIT_ID_PARAM_URI] = data;
    dic[BIT_ID_PARAM_ADDRESS] = address;
    dic[BIT_ID_PARAM_SIGNATURE] = strSigned;
    
    
    NSMutableString* jsonData=[[NSMutableString alloc] init];
//    [jsonData appendFormat:@"\"version\":%@,\"id\":%@",info.version, info.contactid];
    for(NSString* fld in [dic allKeys])
    {
        if ([jsonData length] > 0 ) {
            [jsonData appendString:@","];
        }
        [jsonData appendFormat:@"\"%@\":\"%@\"",fld,[dic objectForKey:fld]];
    }
    
    [jsonData insertString:@"{" atIndex:0];
    [jsonData appendString:@"}"];
    NSLog(@"%@", jsonData);

    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    dic1[@"data"] = jsonData;

//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://carbonwallet.com"]];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:postBack]];
    
    
    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:@"" parameters:dic];
//    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/bitid_callback"] parameters:dic1];
//    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/bitid_callback?data=%@", jsonData] parameters:nil];
    
    NSLog(@"%@", urlRequest.URL);
    
    AFHTTPRequestOperation *myOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [myOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = operation.responseString;
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
         
        if ([strResponse isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"No response data", @"No response data")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                   otherButtonTitles:nil];
            [alert show];
            [self.delegate failedConnectToServer:@"Connection error!"];
            
             
            return;
        }
        NSDictionary * dicData = [strResponse JSONValue];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
        
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Failed to send request into web server", @"Failed to send request into web server")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [[[NSOperationQueue alloc] init] addOperation:myOperation];

}
- (void) processMPKRequestWithDictionary:(NSMutableDictionary *) dic withPostBack:(NSString *)postBack
{
    
    [[AppDelegate sharedAppDelegate] showWaitingScreen:NSLocalizedString(@"Connecting...", @"Connecting...") bShowText:YES withSize:CGSizeMake(150 * MULTIPLY_VALUE, 100 * MULTIPLY_VALUE)];
 
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:postBack]];
    
    
    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:@"" parameters:dic];
    
    NSLog(@"%@", urlRequest.URL);
    
    AFHTTPRequestOperation *myOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [myOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = operation.responseString;
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        
        if ([strResponse isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"No response data", @"No response data")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            [self.delegate failedConnectToServer:@"Connection error!"];
            
            
            return;
        }
        NSDictionary * dicData = [strResponse JSONValue];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
        
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Failed to send request into web server", @"Failed to send request into web server")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [[[NSOperationQueue alloc] init] addOperation:myOperation];

}
- (void) processSignRequestWithDictionary:(NSMutableDictionary *) dic withPostBack:(NSString *)postBack
{
    
    [[AppDelegate sharedAppDelegate] showWaitingScreen:NSLocalizedString(@"Connecting...", @"Connecting...") bShowText:YES withSize:CGSizeMake(150 * MULTIPLY_VALUE, 100 * MULTIPLY_VALUE)];
 
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:postBack]];
    
    
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET" path:@"" parameters:dic];
    
    NSLog(@"%@", urlRequest.URL);
    
    AFHTTPRequestOperation *myOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [myOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = operation.responseString;
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        
        if ([strResponse isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"No response data", @"No response data")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            [self.delegate failedConnectToServer:@"Connection error!"];
            
            
            return;
        }
        [self.delegate successSignRequestWithResponse:strResponse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
        
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Failed to send request into web server", @"Failed to send request into web server")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [[[NSOperationQueue alloc] init] addOperation:myOperation];

}
- (void) processPubKeyRequestWithDictionary:(NSMutableDictionary *) dic withPostBack:(NSString *)postBack
{
    
    [[AppDelegate sharedAppDelegate] showWaitingScreen:NSLocalizedString(@"Connecting...", @"Connecting...") bShowText:YES withSize:CGSizeMake(150 * MULTIPLY_VALUE, 100 * MULTIPLY_VALUE)];
 
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:postBack]];
    
    
    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:@"" parameters:dic];
    
    NSLog(@"%@", urlRequest.URL);
    
    AFHTTPRequestOperation *myOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [myOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = operation.responseString;
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        
        if ([strResponse isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"No response data", @"No response data")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            [self.delegate failedConnectToServer:@"Connection error!"];
            
            
            return;
        }
        NSDictionary * dicData = [strResponse JSONValue];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
        
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Failed to send request into web server", @"Failed to send request into web server")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [[[NSOperationQueue alloc] init] addOperation:myOperation];

}

@end
