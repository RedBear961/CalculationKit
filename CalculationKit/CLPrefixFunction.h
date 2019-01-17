//
//  CLPrefixFunction.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLAction.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat (^CLPrefixFunctionBlock)(NSString *prefixFunction, NSUInteger argumentCount, NSArray<NSNumber *> *arguments);

@interface CLPrefixFunction : NSObject <CLAction>

@property (readonly, nonatomic) NSUInteger argumentCount;
+ (NSUInteger)argumentCountForPrefixFunction:(NSString *)signature;

+ (nullable CLPrefixFunction *)prefixFunctionWithSignature:(NSString *)signature;

- (CGFloat)calcWithArguments:(NSArray<NSNumber *> *)arguments;
+ (CGFloat)calcFunction:(NSString *)function arguments:(NSArray<NSNumber *> *)arguments;

+ (void)registerPrefixFunction:(NSString *)function argumentCount:(NSUInteger)count calcBlock:(CLPrefixFunctionBlock)block;
+ (void)removePrefixFunction:(NSString *)signature;

@end

NS_ASSUME_NONNULL_END
