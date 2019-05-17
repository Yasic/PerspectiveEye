//
//  PEYNodeSemanticNameManager.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/16.
//

#import <Foundation/Foundation.h>
#import "PEYViewElement.h"

NS_ASSUME_NONNULL_BEGIN

@interface PEYNodeSemanticNameManager : NSObject

/**
 根据 viewElement 生成唯一的语义化名称

 @param viewElement 对应的 viewElement 对象
 @return 语义化名称
 */
- (NSString *)nameForViewElement:(PEYViewElement *)viewElement;

/**
 根据 identifier 生成唯一的语义化名称

 @param elementIdentifier 唯一标识
 @return 语义化名称
 */
- (NSString *)nameForElementIdentifier:(NSString *)elementIdentifier;

@end

NS_ASSUME_NONNULL_END
