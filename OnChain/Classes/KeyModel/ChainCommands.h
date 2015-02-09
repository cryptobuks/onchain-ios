//
//  ChainCommands.h
//  OnChain
//
//  Created by Cool on 2/7/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTCKey;

@protocol ChainCommandsDelegate <NSObject>

@optional

@end
@interface ChainCommands : NSObject

@property (nonatomic, weak) id <ChainCommandsDelegate> delegate;


- (void) processMPKRequestWithParams:(NSArray *) params withPostBack:(NSString *)postBack withKey:(BTCKey *) key;
- (void) processSignRequestWithParams:(NSArray *) params withPostBack:(NSString *)postBack withKey:(BTCKey *) key;
- (void) processPubKeyRequestWithParams:(NSArray *) params withPostBack:(NSString *)postBack withKey:(BTCKey *) key;

@end
