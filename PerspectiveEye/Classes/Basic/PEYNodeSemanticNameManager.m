//
//  PEYNodeSemanticNameManager.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/16.
//

#import "PEYNodeSemanticNameManager.h"

@interface PEYNodeSemanticNameManager()

@property (nonatomic, strong) NSMutableDictionary *semanticNameCache;

@end

@implementation PEYNodeSemanticNameManager

- (instancetype)init
{
    self = [super init];
    if (self){
        self.semanticNameCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)nameForViewElement:(PEYViewElement *)viewElement
{
    if (!viewElement || viewElement.elementIdentifier.length == 0) {
        return @"";
    }
    NSString *elementIdentifier = viewElement.elementIdentifier;
    return [self nameForElementIdentifier:elementIdentifier];
}

- (NSString *)nameForElementIdentifier:(NSString *)elementIdentifier
{
    if (elementIdentifier.length == 0) {
        return @"";
    }
    if (![self.semanticNameCache.allKeys containsObject:elementIdentifier]) {
        [self.semanticNameCache setObject:[self generateUniqueName] forKey:elementIdentifier];
    }
    return [self.semanticNameCache objectForKey:elementIdentifier];
}

- (NSString *)generateUniqueName
{
    NSUInteger totalCount = self.semanticNameCache.count;
    return [NSString stringWithFormat:@"%lx", (unsigned long)totalCount];
}

@end
