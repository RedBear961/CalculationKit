//
//  CLPostfixFunction.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLAction.h>
#import <CalculationKit/CLCalculator.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat (^CLPostfixFunctionBlock)(NSString *postfixFunction, CGFloat operand);

@interface CLPostfixFunction : NSObject <CLAction>

+ (nullable CLPostfixFunction *)postfixFunctionWithSignature:(NSString *)signature;

- (CGFloat)calcWithOperand:(CGFloat)operand;
+ (CGFloat)calcPostfixFunction:(NSString *)function withOperand:(CGFloat)operand;

+ (void)registerPostfixFunction:(NSString *)function calcBlock:(CLPostfixFunctionBlock)block;
+ (void)removePostfixFunction:(NSString *)signature;

@end

@interface CLCalculator (CLPostfixFunction)

+ (NSUInteger)factorial:(NSUInteger)number;
+ (NSUInteger)doubleFactorial:(NSUInteger)number;

@end

NS_ASSUME_NONNULL_END
