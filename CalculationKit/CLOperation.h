//
//  CLOperation.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLAction.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat (^CLOperationBlock)(NSString *operation, CGFloat leftOperand, CGFloat rightOperand);

@interface CLOperation : NSObject <CLAction>

- (nullable instancetype)initWithSignature:(NSString *)signature;
+ (nullable instancetype)operationWithSignature:(NSString *)signature;

- (CGFloat)calcWithLeftOperand:(CGFloat)left rightOperand:(CGFloat)right;
+ (CGFloat)calcOperation:(NSString *)operation leftOperand:(CGFloat)left rightOperand:(CGFloat)right;

+ (void)registerOperation:(NSString *)operation calcBlock:(CLOperationBlock)block;

@end

NS_ASSUME_NONNULL_END
