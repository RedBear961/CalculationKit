//
//  CLReversePolishNotation.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLExpression.h>
#import <CalculationKit/CLTokenizedExpression.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLReversePolishNotation : NSObject

@property (readonly, nonatomic) CLTokenizedExpression *reverseExpression;

- (instancetype)initWithExpression:(CLExpression *)expression error:(NSError * __autoreleasing *)error;
- (instancetype)initWithTokenizedExpression:(CLTokenizedExpression *)expression error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
