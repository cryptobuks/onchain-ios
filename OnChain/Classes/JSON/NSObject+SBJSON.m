/*
 Copyright Kairos Community Directories 2014 all rights reserved.
 */

#import "NSObject+SBJSON.h"
#import "SBJsonWriter.h"

@implementation NSObject (NSObject_SBJSON)

- (NSString *)JSONFragment {
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *json = [jsonWriter stringWithFragment:self];    
    return json;
}

- (NSString *)JSONRepresentation {
    SBJsonWriter *jsonWriter = [SBJsonWriter new];    
    NSString *json = [jsonWriter stringWithObject:self];
    return json;
}

@end
