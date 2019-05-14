//
//  NSDictionary+PEYCollectionOperation.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "NSDictionary+PEYCollectionOperation.h"

@implementation NSDictionary (PEYCollectionOperation)

- (void)pey_each:(void (^)(id, id))block
{
    NSParameterAssert(block);
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block) {
            block(obj, key);
        }
    }];
}

- (void)pey_apply:(void (^)(id, id))block
{
    NSParameterAssert(block);
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                  usingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop){
                                      if (block) {
                                          block(obj, key);
                                      }
                                  }];
}

- (NSDictionary *)pey_map:(id (^)(id, id))block
{
    NSParameterAssert(block);
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id key in self) {
        id value = self[key];
        id result = nil;
        if (block) {
            result = block(value, key);
        }
        if (!result) {
            result = [NSNull null];
        }
        resultDictionary[key] = result;
    }
    return [resultDictionary copy];
}

- (id)pey_reduce:(id (^)(id, id, id))block
{
    NSParameterAssert(block);
    id accumulated = nil;
    for (id key in self) {
        id value = self[key];
        if (!accumulated) {
            accumulated = value;
        } else {
            if (block) {
                accumulated = block(accumulated, value, key);
            }
        }
    }
    return accumulated;
}

- (id)pey_match:(BOOL (^)(id, id))block
{
    NSParameterAssert(block);
    id result = nil;
    for (id key in self) {
        id value = self[key];
        if (block) {
            if (block(value, key)) {
                result = value;
                break;
            }
        }
    }
    return result;
}

- (NSDictionary *)pey_filter:(BOOL (^)(id, id))block
{
    NSParameterAssert(block);
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    for (id key in self) {
        id value = self[key];
        if (block && block(value, key)) {
            resultDictionary[key] = value;
        }
    }
    return [resultDictionary copy];
}

- (NSDictionary *)pey_select:(BOOL (^)(id, id))block
{
    NSParameterAssert(block);
    return [self pey_filter:block];
}

- (NSDictionary *)pey_reject:(BOOL (^)(id, id))block
{
    NSParameterAssert(block);
    return [self pey_select:^BOOL(id object, id key) {
        if (block) {
            return !block(object, key);
        }
        return NO;
    }];
}

- (BOOL)pey_every:(BOOL (^)(id, id))block
{
    NSParameterAssert(block);
    BOOL result = YES;
    for (id key in self) {
        id value = self[key];
        if (block) {
            result = block(value, key);
        }
        if (!result) {
            break;
        }
    }
    return result;
}

- (BOOL)pey_some:(BOOL (^)(id, id))block
{
    NSParameterAssert(block);
    BOOL result = NO;
    for (id key in self) {
        id value = self[key];
        if (block) {
            result = block(value, key);
        }
        if (result) {
            break;
        }
    }
    return result;
}

- (BOOL)pey_notAny:(BOOL (^)(id, id))block
{
    return ![self pey_some:block];
}

- (BOOL)pey_notEvery:(BOOL (^)(id, id))block
{
    return ![self pey_every:block];
}

- (void)pey_mergeToDestinationDic:(NSMutableDictionary *)mergedDic withAnotherDic:(NSDictionary *)dic
{
    NSParameterAssert(mergedDic);
    NSParameterAssert(dic);
    
    [mergedDic addEntriesFromDictionary:self];
    [mergedDic addEntriesFromDictionary:dic];
}

@end
