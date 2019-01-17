//
//  CLExpression.m
//  CalculationKit
//
//  Created by God on 09.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLExpression.h"
#import "CLTokenizer.h"
#import "CLReversePolishNotation.h"

@interface CLExpression ()

@end

@implementation CLExpression

- (instancetype)initWithString:(NSString *)aString error:(NSError * _Nullable __autoreleasing *)error {
	self = [super init];
	
	if (self) {
		// Saves the original string.
		_stringValue = aString;
		
		NSError *tokenizerError = nil;
		CLTokenizer *tokenizer = [[CLTokenizer alloc] initWithExpression:self error:&tokenizerError];
		
		if (tokenizerError) {
			if (error)
				*error = tokenizerError;
			
			return nil;
		}
		
		NSError *rpnError = nil;
		_tokenizedExpression = [tokenizer tokenizedExpression];
		CLReversePolishNotation *reversePolishNotation = [[CLReversePolishNotation alloc] initWithTokenizedExpression:_tokenizedExpression error:&rpnError];
		
		if (rpnError) {
			if (error)
				*error = rpnError;
			
			return nil;
		}
		
		_reversePolishNotation = [reversePolishNotation reverseExpression];
	}
	
	return self;
}

@end
