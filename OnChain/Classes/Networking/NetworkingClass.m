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
#import "JSON.h"

#import "AppDelegate.h"
#import "Define_Gloabal.h"

@implementation NetworkingClass
- (void) doBitIDWithSigned:(NSString *) strSigned withPostBack:(NSString *) postBack withAddress:(NSString *)address withData:(NSString *) data
{
    [[AppDelegate sharedAppDelegate] showWaitingScreen:NSLocalizedString(@"Connecting...", @"Connecting...") bShowText:YES withSize:CGSizeMake(150 * MULTIPLY_VALUE, 100 * MULTIPLY_VALUE)];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[BIT_ID_PARAM_ADDRESS] = address;
    dic[BIT_ID_PARAM_SIGNATURE] = strSigned;
    dic[BIT_ID_PARAM_URI] = data;
    

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
        //        NSArray * array = [strResponse componentsSeparatedByString:[NSString stringWithFormat:@"\%c", '"']];
        //        if (array.count > 5) {
        //            [self.delegate successLoginToServer:array[3]];
        //        }
        NSDictionary * dicData = [strResponse JSONValue];
        if (dicData.count) {
            if (!dicData[@"error"]) {
                [self.delegate successAuthentification];
            }
            else
                [self.delegate failedConnectToServer:@"Connection error!"];
            
        }
        else
            [self.delegate failedConnectToServer:@"Connection error!"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
        
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Failed to send request into web server", @"Failed to send request into web server")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
//        [self.delegate failedConnectToServer:error.description];
    }];
    [[[NSOperationQueue alloc] init] addOperation:myOperation];

}

- (void) authontificateWithKey:(NSString *) strKey
{
    [[AppDelegate sharedAppDelegate] showWaitingScreen:NSLocalizedString(@"Logging in...", @"Logging in...") bShowText:YES withSize:CGSizeMake(150 * MULTIPLY_VALUE, 100 * MULTIPLY_VALUE)];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"x"] = strKey;
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:SERVER_API]];
    
    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:AUTHONTIFICATE_QR, strKey] parameters:nil];
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
        //        NSArray * array = [strResponse componentsSeparatedByString:[NSString stringWithFormat:@"\%c", '"']];
        //        if (array.count > 5) {
        //            [self.delegate successLoginToServer:array[3]];
        //        }
        NSDictionary * dicData = [strResponse JSONValue];
        if (dicData.count) {
            if (!dicData[@"error"]) {
                [self.delegate successAuthentification];
            }
            else
                [self.delegate failedConnectToServer:@"Connection error!"];
            
        }
        else
            [self.delegate failedConnectToServer:@"Connection error!"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
        
        [[AppDelegate sharedAppDelegate] hideWaitingScreen];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Failed to send request into web server", @"Failed to send request into web server")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
        [self.delegate failedConnectToServer:error.description];
    }];
    [[[NSOperationQueue alloc] init] addOperation:myOperation];
}
@end
