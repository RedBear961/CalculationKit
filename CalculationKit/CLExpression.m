/*
 * CLExpression.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLExpression.h"
#import "CLTokenizer.h"
#import "CLReversePolishNotation.h"

@implementation CLExpression

- (instancetype)initWithString:(NSString *)aString error:(NSError * _Nullable __autoreleasing *)error {
	self = [super init];
	
	if (self) {
		// Saves the original string.
		_stringValue = aString;
		
		// Tokenization of the input string.
		NSError *tokenizerError = nil;
		CLTokenizer *tokenizer = [[CLTokenizer alloc] initWithExpression:self error:&tokenizerError];
		
		// Error checking.
		if (tokenizerError) {
			if (error)
				*error = tokenizerError;
			
			return nil;
		}
		
		// Convert a tokenized string from infix to reverse polish notation.
		NSError *rpnError = nil;
		_tokenizedExpression = [tokenizer tokenizedExpression];
		CLReversePolishNotation *reversePolishNotation = [[CLReversePolishNotation alloc] initWithTokenizedExpression:_tokenizedExpression error:&rpnError];
		
		// Error checking.
		if (rpnError) {
			if (error)
				*error = rpnError;
			
			return nil;
		}
		
		// Saving the processing result.
		_reversePolishNotation = [reversePolishNotation reverseExpression];
	}
	
	return self;
}

// Replacing the constructor with a minus.
+ (instancetype)expressionWithString:(NSString *)aString error:(NSError * _Nullable __autoreleasing *)error {
	return [[self alloc] initWithString:aString error:error];
}

@end
