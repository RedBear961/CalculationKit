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

- (nullable instancetype)initWithSignature:(NSString *)signature;
+ (nullable instancetype)prefixFunctionWithSignature:(NSString *)signature;

- (CGFloat)calcWithArguments:(NSArray<NSNumber *> *)arguments;

+ (void)registerPrefixFunction:(NSString *)function calcBlock:(CLPrefixFunctionBlock)block;

@end

NS_ASSUME_NONNULL_END
