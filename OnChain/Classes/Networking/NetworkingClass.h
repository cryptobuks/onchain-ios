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
- (void) successLoginToServer:(NSString *) strToken;

- (void) failedConnectToServer:(NSString *) strErrorMessage;

@end


@interface NetworkingClass : NSObject
@property (nonatomic, weak) id <NetworkingClassDelegate> delegate;

- (void) authontificateWithKey:(NSString *) strKey;

@end
