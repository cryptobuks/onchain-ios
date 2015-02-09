//
//  NetworkingClass.h
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NetworkingClassDelegate <NSObject>

@optional
- (void) successSignRequestWithResponse:(NSString *) strResponse;

- (void) successAuthentification;
- (void) failedConnectToServer:(NSString *) strErrorMessage;

@end


@interface NetworkingClass : NSObject
@property (nonatomic, weak) id <NetworkingClassDelegate> delegate;

- (void) doBitIDWithSigned:(NSString *) strSigned withPostBack:(NSString *) postBack withAddress:(NSString *)address withData:(NSString *) data;
- (void) processMPKRequestWithDictionary:(NSMutableDictionary *) dic withPostBack:(NSString *)postBack;
- (void) processSignRequestWithDictionary:(NSMutableDictionary *) dic withPostBack:(NSString *)postBack;
- (void) processPubKeyRequestWithDictionary:(NSMutableDictionary *) dic withPostBack:(NSString *)postBack;

@end
