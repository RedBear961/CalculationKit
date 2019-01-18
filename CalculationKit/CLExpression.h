/**
 * CLExpression.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

@class CLTokenizedExpression;

/**
 * @abstract A wrapper representing an expression. Used to store and pass a processed expression.
 		It also uses a calculator to perform the calculation.
 * @see CLCalculator
 */
@interface CLExpression : NSObject

/**
 * @property stringValue
 * @abstract String value of the expression formed during class initialization. Does not change
 		during processing and retains the value that was passed to the designer.
 */
@property (readonly, nonatomic, copy) NSString *stringValue;

/**
 * @property tokenizedExpression
 * @abstract Tokenized expression, the result of the tokenizer. It is an ordered array of tokens.
 		Is passed to the translator in reverse polish notation.
 * @see CLTokenizer
 * @see CLReversePolishNotation
 */
@property (readonly, nonatomic) CLTokenizedExpression *tokenizedExpression;

/**
 * @property reversePolishNotation
 * @abstract Tokenized expression converted into reverse polish notation, the result of the translator's
 		work into reverse polish notation. Passed to the calculator to perform calculations.
 * @see CLReversePolishNotation
 * @see CLCalculator
 */
@property (readonly, nonatomic) CLTokenizedExpression *reversePolishNotation;

/**
 * @abstract The main constructor of the class. It automatically performs string processing operations by
 		passing the string to the tokenizer and translator in reverse polish notation.
 * @param aString The input string that you want to convert to an expression and calculate.
 * @param error Pointer to a pointer to an error that may occur during processing of the input string.
 * @return An instance of an expression that is ready for evaluation.
 */
- (instancetype)initWithString:(NSString *)aString error:(NSError **)error NS_DESIGNATED_INITIALIZER;
+ (instancetype)expressionWithString:(NSString *)aString error:(NSError **)error;

- (instancetype)init NS_UNAVAILABLE; // Not support.

@end

NS_ASSUME_NONNULL_END
