//
//  NSDictionary+PEYCollectionOperation.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (PEYCollectionOperation)

- (void)pey_each:(void (^)(id, id))block;

- (void)pey_apply:(void (^)(id, id))block;

- (NSDictionary *)pey_map:(id (^)(id, id))block;

- (id)pey_reduce:(id (^)(id, id, id))block;

- (id)pey_match:(BOOL (^)(id, id))block;

- (NSDictionary *)pey_filter:(BOOL (^)(id, id))block;

- (NSDictionary *)pey_select:(BOOL (^)(id, id))block;

- (NSDictionary *)pey_reject:(BOOL (^)(id, id))block;

- (BOOL)pey_every:(BOOL (^)(id, id))block;

- (BOOL)pey_some:(BOOL (^)(id, id))block;

- (BOOL)pey_notAny:(BOOL (^)(id, id))block;

- (BOOL)pey_notEvery:(BOOL (^)(id, id))block;

- (void)pey_mergeToDestinationDic:(NSMutableDictionary *)mergedDic withAnotherDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
