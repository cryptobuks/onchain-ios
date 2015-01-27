/*
Copyright Kairos Community Directories 2014 all rights reserved.
 */

#import "NSString+SBJSON.h"
#import "SBJsonParser.h"

@implementation NSString (NSString_SBJSON)

- (id)JSONFragmentValue
{
    SBJsonParser *jsonParser = [SBJsonParser new];    
    id repr = [jsonParser fragmentWithString:self];    
    return repr;
}

- (id)JSONValue
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    id repr = [jsonParser objectWithString:self];
    return repr;
}

@end
