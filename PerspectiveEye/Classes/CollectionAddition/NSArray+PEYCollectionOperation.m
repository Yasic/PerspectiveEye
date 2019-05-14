//
//  NSArray+PEYCollectionOperation.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "NSArray+PEYCollectionOperation.h"

@implementation NSArray (PEYCollectionOperation)

- (void)pey_each:(void (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block) {
            block(obj, idx);
        }
    }];
}

- (void)pey_apply:(void (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent
                           usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop){
                               if (block) {
                                   block(obj, idx);
                               }
                           }];
}

- (NSArray *)pey_map:(id (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count];
    NSUInteger index = 0;
    for (id object in self) {
        id result = nil;
        if (block) {
            result = block(object, index++);
        }
        if (!result) {
            result = [NSNull null];
        }
        [resultArray addObject:result];
    }
    return [resultArray copy];
}

- (id)pey_reduce:(id (^)(id, id))block
{
    NSParameterAssert(block);
    id accumulated = nil;
    for (id object in self) {
        if (!accumulated) {
            accumulated = object;
        } else {
            if (block) {
                accumulated = block(accumulated, object);
            }
        }
    }
    return accumulated;
}

- (id)pey_match:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    id result = nil;
    NSUInteger index = 0;
    for (id object in self) {
        if (block) {
            if (block(object, index++)) {
                result = object;
                break;
            }
        }
    }
    return result;
}

- (id)pey_find:(BOOL (^)(id obj))block {
    NSParameterAssert(block);
    for (id obj in self) {
        if (block && block(obj)) {
            return obj;
        }
    }
    return nil;
}

- (NSArray *)pey_filter:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger index = 0;
    for (id object in self) {
        if (block && block(object, index++)) {
            [resultArray addObject:object];
        }
    }
    return [resultArray copy];
}

- (NSArray *)pey_select:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    return [self pey_filter:block];
}

- (NSArray *)pey_reject:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    return [self pey_select:^BOOL(id object, NSUInteger index) {
        if (block) {
            return !block(object, index);
        }
        return NO;
    }];
}

- (BOOL)pey_every:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    BOOL result = YES;
    NSUInteger index = 0;
    for (id object in self) {
        if (block) {
            result = block(object, index++);
        }
        if (!result) {
            break;
        }
    }
    return result;
}

- (BOOL)pey_some:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    BOOL result = NO;
    NSUInteger index = 0;
    for (id object in self) {
        if (block) {
            result = block(object, index++);
        }
        if (result) {
            break;
        }
    }
    return result;
}

- (BOOL)pey_notAny:(BOOL (^)(id, NSUInteger))block
{
    return ![self pey_some:block];
}

- (BOOL)pey_notEvery:(BOOL (^)(id, NSUInteger))block
{
    return ![self pey_every:block];
}

- (instancetype)pey_evenIndexObjects {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger index = 0;
    for (id obj in self) {
        if (index % 2 == 0) {
            [array addObject:obj];
        }
        index += 1;
    }
    return array;
}

- (instancetype)pey_oddIndexObjects {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger index = 0;
    for (id obj in self) {
        if (index % 2 == 1) {
            [array addObject:obj];
        }
        index += 1;
    }
    return array;
}

- (BOOL)pey_allObjectsMatched:(BOOL (^)(id obj))block {
    for (id obj in self) {
        if (block) {
            if (!block(obj)) {
                return NO;
            }
        }
    }
    return YES;
}

- (NSString *)pey_join:(NSString *)seperator {
    NSMutableString *string = [NSMutableString string];
    [self pey_each:^(id obj, NSUInteger index) {
        if (index != 0) {
            [string appendString:seperator];
        }
        [string appendString:obj];
    }];
    return string;
}

- (BOOL)pey_existObjectMatch:(BOOL (^)(id obj, NSUInteger index))block {
    return [self pey_match:block] != nil;
}

- (NSArray *)pey_groupBy:(id (^)(id obj))block {
    NSParameterAssert(block);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id obj in self) {
        if (block) {
            NSString *key = block(obj);
            if (dic[key] == nil) {
                dic[key] = [NSMutableArray array];
            }
            [dic[key] addObject:obj];
        }
    }
    return [dic allValues];
}

- (NSArray *)pey_zip:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];
    [self pey_each:^(id obj, NSUInteger index) {
        [result addObject:obj];
        if (index >= array.count) return;
        [result addObject:array[index]];
    }];
    return result;
}

- (NSString *)pey_insertIntoPlaceHolderString:(NSString *)placeHolder {
    NSArray *components = [placeHolder componentsSeparatedByString:@"%%"];
    if ([components count] < 2) return placeHolder;
    return [[components pey_zip:self] pey_join:@""];
}

- (id)pey_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block {
    if (!block) {
        NSParameterAssert(block != nil);
        return initial;
    }
    id result = initial;
    
    for (id obj in self) {
        result = block(result, obj);
    }
    return result;
}

- (instancetype)pey_take:(NSInteger)n {
    if (n >= self.count) return self;
    return [self subarrayWithRange:NSMakeRange(0, n)];
}

- (instancetype)pey_withoutFirst:(NSInteger)n {
    if (n >= self.count) return @[];
    return [self subarrayWithRange:NSMakeRange(n, self.count - n)];
}

- (instancetype)pey_last:(NSInteger)n {
    if (n >= self.count) return self;
    return [self subarrayWithRange:NSMakeRange(self.count - n, n)];
}

- (instancetype)pey_withoutLast:(NSInteger)n {
    if (n >= self.count) return @[];
    return [self subarrayWithRange:NSMakeRange(0, self.count - n)];
}

- (instancetype)pey_seprate:(NSInteger)length
{
    NSMutableArray * array = [@[] mutableCopy];
    for (int i = 0; i < self.count; i += length) {
        if (i + length <= self.count) {
            [array addObject:[self subarrayWithRange:(NSRange){i, length}]];
        } else {
            [array addObject:[self pey_last:self.count - i]];
        }
    }
    return array;
}

- (instancetype)pey_flatten {
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *subArray in self) {
        if ([subArray isKindOfClass:[NSArray class]]) {
            for (id obj in subArray) {
                [array addObject:obj];
            }
        } else {
            id obj = subArray;
            [array addObject:obj];
        }
    }
    return array;
}

@end
