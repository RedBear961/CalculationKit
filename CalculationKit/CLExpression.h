//
//  CLExpression.h
//  CalculationKit
//
//  Created by God on 09.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

@class CLTokenizedExpression;

@interface CLExpression : NSObject

@property (readonly, nonatomic) NSString *stringValue;
@property (readonly, nonatomic) CLTokenizedExpression *tokenizedExpression;
@property (readonly, nonatomic) CLTokenizedExpression *reversePolishNotation;

- (instancetype)initWithString:(NSString *)aString error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
