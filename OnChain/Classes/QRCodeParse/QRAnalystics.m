//
//  QRAnalystics.m
//  OnChain
//
//  Created by Cool on 1/27/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "QRAnalystics.h"

@implementation QRAnalystics

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.mode = @"";
        self.serverURL = @"";
        self.arrayExtraParams = [[NSMutableArray alloc] init];
        
    }
    return  self;
    
}
@end
