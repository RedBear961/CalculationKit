/*
 * CLReversePolishNotation.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLReversePolishNotation.h"

#import "CLOperation.h"
#import "CLStack.h"
#import "CLError.h"

@interface CLReversePolishNotation ()

// Stack that provides the implementation of the sorting station algorithm.
@property (nonatomic) CLStack<CLToken *> *stack;

@end

@implementation CLReversePolishNotation

- (instancetype)initWithExpression:(CLExpression *)expression error:(NSError **)error {
	// Calls the designated constructor.
	return [self initWithTokenizedExpression:expression.tokenizedExpression error:error];
}

+ (instancetype)postfixNotationWithExpression:(CLExpression *)expression error:(NSError **)error {
	// Calls the designated constructor.
	return [[self alloc] initWithTokenizedExpression:expression.tokenizedExpression error:error];
}

+ (instancetype)postfixNotationWithTokenizedExpression:(CLTokenizedExpression *)expression error:(NSError **)error {
	// Calls the designated constructor.
	return [[self alloc] initWithTokenizedExpression:expression error:error];
}

- (instancetype)initWithTokenizedExpression:(CLTokenizedExpression *)expression
									  error:(NSError **)error {
	self = [super init];
	
	if (self) {
		_stack = [[CLStack alloc] init];
		CLMutableTokenizedExpression *reverseExpression = [[CLMutableTokenizedExpression alloc] init];
		
		// Error-watcher for handlers.
		NSError *postfixError = nil;
		
		// Counter of the current read character.
		NSUInteger index = 0;
		while (index < expression.count) {
			CLToken *token = [expression nextObject];
			
			switch (token.type) {
				// The actions for the postfix function and the numbers are identical.
				case CLTokenTypeDecimal:
				case CLTokenTypeConstant:
				case CLTokenTypePostfixFunction:
					[reverseExpression addObject:token];
					break;
					
				// Binary operation processing.
				case CLTokenTypeOperation:
					[self processOperation:token
							 outExpression:reverseExpression];
					break;
					
				// The actions for the prefix function and the open brace are identical.
				case CLTokenTypePrefixFunction:
				case CLTokenTypeOpeningBrace:
					[_stack push:token];
					break;
					
				// Processing stack while the closed brackets.
				case CLTokenTypeClosingBrace:
					[self processClosingBrace:token
								outExpression:reverseExpression
										error:&postfixError];
					break;
					
				// Processing stack when the separator of function arguments.
				case CLTokenTypeSeparator:
					[self processFunctionSeparator:token
									 outExpression:reverseExpression
											 error:&postfixError];
					break;
					
				case CLTokenTypeVariable:
				case CLTokenTypeUnknown:
					break;
			}
			
			if (postfixError) {
				if (error)
					*error = postfixError;
				
				return nil;
			}
			
			// The incrementing of the progress of the treatment.
			++index;
		}
		
		// Shift all tokens from the stack to the output string, provided that the stack is not empty.
		while (_stack.count) {
			CLToken *token = [_stack pop];
			[reverseExpression addObject:token];
		}
		
		_reverseExpression = [reverseExpression copy];
	}
	
	return self;
}

- (void)processOperation:(CLToken *)token
		   outExpression:(CLMutableTokenizedExpression *)expression {
	// Start processing the stack if it is not empty.
	if (_stack.count) {
		// Getting the top of the stack.
		CLToken *stackToken = [_stack pop];
		
		if (stackToken.type == CLTokenTypePrefixFunction) {
			[expression addObject:stackToken];
			
			// Add the input token to the stack.
			[_stack push:token];
			
			return;
		}
		
		// Operations priority variable.
		BOOL isPriority = NO;
		
		// So far on the stack binary operation.
		while (stackToken && stackToken.type == CLTokenTypeOperation) {
			
			isPriority = [CLOperation priorityForOperation:stackToken.stringValue];
			
			// If the stack has a lower priority operation, finish processing.
			if (!isPriority)
				break;
			
			[expression addObject:stackToken];
			
			stackToken = [_stack pop];
		}
		
		// Check for the existence of the last token taken.
		if (stackToken)
			[_stack push:stackToken];
	}
	
	// Add the input token to the stack.
	[_stack push:token];
}

- (NSUInteger)processClosingBrace:(CLToken *)token
			  outExpression:(CLMutableTokenizedExpression *)expression
					  error:(NSError * _Nonnull *)error {
	// Getting the top of the stack.
	CLToken *stackToken = [_stack pop];
	
	if (stackToken.type == CLTokenTypeOpeningBrace) return 0;
	
	// The creation of the observer error.
	// It is set to true, and when the opening of the bracket is found, it will be set to false.
	BOOL isError = YES;
	
	// Get objects from the stack and move them to the output string.
	while (stackToken.type != CLTokenTypeOpeningBrace && _stack.count) {
		[expression addObject:stackToken];
		
		stackToken = [_stack pop];
		
		// Open bracket found. No errors were found in the expression.
		if (stackToken.type == CLTokenTypeOpeningBrace) {
			isError = NO;
			break;
		}
	}
	
	// If an open bracket is not found, the brackets are not matched.
	if (isError && error) {
		*error = [NSError errorWithDomain:CLReversePolishNotationDomain
									 code:CLInconsistentBrackets
								 userInfo:nil];
	}
	
	return 0;
}

- (NSUInteger)processFunctionSeparator:(CLToken *)token
				   outExpression:(CLMutableTokenizedExpression *)expression
						   error:(NSError * _Nonnull *)error {
	// Getting the top of the stack.
	CLToken *stackToken = [_stack pop];
	
	//
	if (stackToken.type == CLTokenTypeOpeningBrace) {
		[_stack push:stackToken];
		return 0;
	}
	
	// The creation of the observer error.
	// It is set to true, and when the opening of the bracket is found, it will be set to false.
	BOOL isError = YES;
	
	while (stackToken.type != CLTokenTypeOpeningBrace && _stack.count) {
		[expression addObject:stackToken];
		
		stackToken = [_stack pop];
		
		// Open bracket found. No errors were found in the expression.
		if (stackToken.type == CLTokenTypeOpeningBrace) {
			// Moreover, the bracket is not removed from the stack.
			[_stack push:stackToken];
			
			isError = NO;
			
			break;
		}
	}
	
	// If an open bracket is not found, the brackets are not matched.
	if (isError && error) {
		*error = [NSError errorWithDomain:CLReversePolishNotationDomain
									 code:CLInconsistentBrackets
								 userInfo:nil];
	}
	
	return 0;
}

@end
