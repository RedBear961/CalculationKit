/**
 * CLReversePolishNotation.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLExpression.h>
#import <CalculationKit/CLTokenizedExpression.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract Algorithmically converts a tokenized expression into reverse polish notation.
 * @discussion The algorithm uses a sorting station and converts the expression from infix to Postfix entries.
 		It is assumed that the class already has sufficient information about all tokens. Do not attempt to
 		inherit from it, a given class is able to translate any correctly tokenized expression into a reverse
 		polish notation.
 
 		There are three types of mathematical expression notation: prefix, infix, and postfix or reverse polish notation.
 		The infix method of recording, when the operation is written between operands (2 + 2), we use in the household
 		account. The reverse Polish notation assumes that the operation is written after operands (2 2 +). The key advantage
 		of postfix notation is the lack of priorities. In expression 2 2 2 + * operations are performed in the order they
 		are written, so addition will be the first action.
 
 		See sorting station algorithm here: https://en.wikipedia.org/wiki/Shunting-yard_algorithm
 * @see CLTokenizedExpression
 */
@interface CLReversePolishNotation : NSObject

/**
 * @property reverseExpression
 * @abstract The result of the work of the translator, the expression in reverse Polish notation, ready for the use
 		of a calculator.
 */
@property (readonly, nonatomic) CLTokenizedExpression *reverseExpression;

/**
 * @abstract Takes an expression from which it takes a tokenized expression and converts it to a reverse polish notation.
 		May generate an error if it detects inconsistency of brackets.
 */
- (instancetype)initWithExpression:(CLExpression *)expression error:(NSError **)error;
+ (instancetype)postfixNotationWithExpression:(CLExpression *)expression error:(NSError **)error;

/**
 * @abstract Designated to the class constructor. Takes a tokenized expression and converts it to a reverse polish
 		notation. May generate an error if it detects inconsistency of brackets.
 */
- (instancetype)initWithTokenizedExpression:(CLTokenizedExpression *)expression error:(NSError **)error NS_DESIGNATED_INITIALIZER;
+ (instancetype)postfixNotationWithTokenizedExpression:(CLTokenizedExpression *)expression error:(NSError **)error;

- (instancetype)init NS_UNAVAILABLE; // Not support.

@end

NS_ASSUME_NONNULL_END
