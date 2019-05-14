//
//  NSArray+PEYCollectionOperation.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (PEYCollectionOperation)

- (void)pey_each:(void (^)(id, NSUInteger))block;

- (void)pey_apply:(void (^)(id, NSUInteger))block;

- (NSArray *)pey_map:(id (^)(id, NSUInteger))block;

- (id)pey_reduce:(id (^)(id, id))block;

- (id)pey_match:(BOOL (^)(id, NSUInteger))block;

- (id)pey_find:(BOOL (^)(id obj))block;

- (NSArray *)pey_filter:(BOOL (^)(id, NSUInteger))block;

- (NSArray *)pey_select:(BOOL (^)(id, NSUInteger))block;

- (NSArray *)pey_reject:(BOOL (^)(id, NSUInteger))block;

- (BOOL)pey_every:(BOOL (^)(id, NSUInteger))block;

- (BOOL)pey_some:(BOOL (^)(id, NSUInteger))block;

- (BOOL)pey_notAny:(BOOL (^)(id, NSUInteger))block;

- (BOOL)pey_notEvery:(BOOL (^)(id, NSUInteger))block;

- (instancetype)pey_evenIndexObjects;

- (instancetype)pey_oddIndexObjects;

- (BOOL)pey_allObjectsMatched:(BOOL (^)(id obj))block;

- (NSString *)pey_join:(NSString *)seperator;

- (BOOL)pey_existObjectMatch:(BOOL (^)(id obj, NSUInteger index))block;

- (NSArray *)pey_groupBy:(id (^)(id obj))block;

- (NSArray *)pey_zip:(NSArray *)array;

- (NSString *)pey_insertIntoPlaceHolderString:(NSString *)placeHolder;

- (id)pey_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block;

- (instancetype)pey_take:(NSInteger)n;

- (instancetype)pey_withoutFirst:(NSInteger)n;

- (instancetype)pey_last:(NSInteger)n;

- (instancetype)pey_withoutLast:(NSInteger)n;

- (instancetype)pey_seprate:(NSInteger)length;

- (instancetype)pey_flatten;

@end

NS_ASSUME_NONNULL_END
