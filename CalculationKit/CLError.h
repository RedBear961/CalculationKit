/**
 * CLError.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>

typedef NSString *CLErrorDomain;

NS_ASSUME_NONNULL_BEGIN

/**
 * @constant CLTokenizerErrorDomain
 * @abstract Domain of errors that occur during the operation of the tokenizer. The operation of the tokenizer
 		is the initial processing of the string. Errors related to the operation of the tokenizer occur due to
 		the spelling of an incorrectly constructed expression: incorrectly written fractional numbers, unknown
 		characters in the string.
 * @see CLTokenizerErrorCode
 */
FOUNDATION_EXPORT CLErrorDomain const CLTokenizerErrorDomain;

/**
 * @constant CLReversePolishNotationDomain
 * @abstract Domain of errors that occur when the translator works in reverse polish notation. It is assumed
 		that the translator receives a correctly tokenized expression and errors resulting from its operation
 		are associated with uncoordinated parentheses.
 * @see CLReversePolishNotationErrorCode
 */
FOUNDATION_EXPORT CLErrorDomain const CLReversePolishNotationDomain;

/**
 * @constant CLCalculatorDomain
 * @abstract Domain of errors that occur when the expression calculator is running. It is assumed that it receives
		the correct tokenized string translated into the reverse Polish record. The resulting errors are related to
 		the lack and overabundance of arguments and/or operands.
 * @see CLCalculatorErrorCode
 */
FOUNDATION_EXPORT CLErrorDomain const CLCalculatorDomain;


typedef NS_ENUM(NSInteger, CLTokenizerErrorCode) {
	CLDuplicatePointNumbers = -1000, // An incorrectly written fractional number. The number has several fractional parts.
	CLUnknownToken = -1001, // The token. The handler was unable to determine what type of token the string contains.
};

typedef NS_ENUM(NSInteger, CLReversePolishNotationErrorCode) {
	CLInconsistentBrackets = -1000, // Mismatched brackets. Missing opening or closing parenthesis.
};

typedef NS_ENUM(NSInteger, CLCalculatorErrorCode) {
	CLExtraArguments = -1000, // The number of arguments is greater than the number of operations on them.
	CLNotEnoughArguments = -1001, // Not enough arguments. More arguments are required to perform all operations.
};

NS_ASSUME_NONNULL_END
