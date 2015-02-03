//
//  BitIDCommands.h
//  OnChain
//
//  Created by Cool on 1/29/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingClass.h"
#import <UIKit/UIKit.h>

@class BTCKey;

@interface BitIDCommands : UIView<NetworkingClassDelegate, UIAlertViewDelegate>
{
    BTCKey * _dataKey;
    NSString * _data;

}
+ (void) excuteBit:(NSString *) data withKey:(BTCKey *) dataKey;
- (void) excuteBit:(NSString *) data withKey:(BTCKey *) dataKey;

@end
