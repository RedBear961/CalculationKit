//
//  CLTokenizer.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLTokenizer.h"

#import "CLError.h"
#import "CLOperation.h"
#import "CLPrefixFunction.h"
#import "CLPostfixFunction.h"

@implementation CLTokenizer

- (instancetype)initWithExpression:(CLExpression *)expression error:(NSError * _Nullable __autoreleasing *)error {
	return [self initWithString:expression.stringValue error:error];
}

- (instancetype)initWithString:(NSString *)aString error:(NSError * _Nullable __autoreleasing *)error {
	self = [super init];
	
	if (self = [super init]) {
		// Delete the space as unnecessary characters in the string.
		NSString *cleanedString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		// Ordered the buffer with the processed tokens.
		CLMutableTokenizedExpression *tokenizedExpression = [[CLMutableTokenizedExpression alloc] init];
		
		// Main process loop.
		NSUInteger index = 0;
		while (index < cleanedString.length) {
			CLTokenType nextType = [self nextTokenTypeInString:cleanedString
												 startingIndex:index
														buffer:tokenizedExpression.array];
			
			NSString *stringValue = nil;
			NSError *tokenizerError = nil;
			switch (nextType) {
				case CLTokenTypeConstant:
					stringValue = [self stringValueForConstantToken:cleanedString
															  index:&index
															  error:&tokenizerError];
					break;
					
				case CLTokenTypeVariable:
					break;
					
				case CLTokenTypeOperation:
				case CLTokenTypePrefixFunction:
				case CLTokenTypePostfixFunction:
					stringValue = [self stringValueForAction:cleanedString
												   tokenType:nextType
													   index:&index];
					break;
					
				case CLTokenTypeOpeningBrace:
				case CLTokenTypeClosingBrace:
				case CLTokenTypeSeparator:
					stringValue = [NSString stringWithFormat:@"%c", [cleanedString characterAtIndex:index]];
					++index;
					break;
					
				case CLTokenTypeUnknown:
					tokenizerError = [NSError errorWithDomain:CLTokenizerErrorDomain
														 code:CLUnknownToken
													 userInfo:nil];
					break;
			}
			
			if (tokenizerError) {
				if (error)
					*error = tokenizerError;
				
				return nil;
			}
			
			CLToken *token = [[CLToken alloc] initWithName:@"" type:nextType stringValue:stringValue];
			[tokenizedExpression addObject:token];
		}
		
		_tokenizedExpression = [tokenizedExpression copy];
	}
	
	return self;
}

- (CLTokenType)nextTokenTypeInString:(NSString *)aString
					   startingIndex:(NSUInteger)index
							  buffer:(NSArray<CLToken *> *)buffer {
	// Conversion to primitive type for calling C-functions.
	int symbol = [aString characterAtIndex:index];
	
	// If the character is a number, then the next token is obviously a number.
	if (isnumber(symbol))
		return CLTokenTypeConstant;
	
	// The inclusion of parentheses is necessary because in infix notation there is precedence of operations.
	if (symbol == '(')
		return CLTokenTypeOpeningBrace;
	
	if (symbol == ')')
		return CLTokenTypeClosingBrace;
	
	if (symbol == ',') {
		return CLTokenTypeSeparator;
	}
	
	// Substring from the index of the beginning of the search.
	NSString *substring = [aString substringFromIndex:index];
	
	// Search operations and functions for entry.
	if ([CLOperation containsAction:substring]) {
		// Check for unary minus or plus.
		if ([substring hasPrefix:@"+"] || [substring hasPrefix:@"-"]) {
			// If this plus or minus sign is the first character of the expression, then it is unary.
			if (!index)
				return CLTokenTypeConstant;
			
			CLToken *token = [buffer lastObject];
			if (token.type == CLTokenTypeOpeningBrace ||
				(token.type == CLTokenTypeOperation && [token.stringValue isEqualToString:@"+"]
				 && [token.stringValue isEqualToString:@"-"])) {
				return CLTokenTypeConstant;
			}
		}
		return CLTokenTypeOperation;
	}
	
	// Enumerate the prefix functions to search for an entry.
	if ([CLPrefixFunction containsAction:substring]) {
		return CLTokenTypePrefixFunction;
	}
	
	// Enumerate the postfix functions to search for an entry.
	if ([CLPostfixFunction containsAction:substring]) {
		return CLTokenTypePostfixFunction;
	}
	
	return CLTokenTypeUnknown;
}

- (NSString *)stringValueForConstantToken:(NSString *)string
									index:(NSUInteger *)index
									error:(NSError **)error {
	// Index parsing started.
	NSUInteger currentIndex = *index;
	
	// Manage the number of commas.
	BOOL isInsidePoint = NO;
	while (currentIndex < string.length) {
		int symbol = [string characterAtIndex:currentIndex];
		
		// Check for the existence of a number sign.
		if (currentIndex == *index && (symbol == '-' || symbol == '+')) {
			++currentIndex;
			continue;
		}
		
		// The reading takes place while the character is a number or a point. There can be only one point in the number.
		if (isnumber(symbol) || (symbol == '.' && !isInsidePoint)) {
			++currentIndex;
			continue;
		}
		
		// If a second point was detected, an error constructor will be called.
		if (symbol == '.' && isInsidePoint) {
			if (error)
				*error = [NSError errorWithDomain:CLTokenizerErrorDomain
											 code:CLDuplicatePointNumbers
										 userInfo:nil];
			return nil;
		}
		
		// If the symbol is not a number and not a dot, then you need to exit the loop.
		if (!isnumber(symbol) && symbol != '.')
			break;
	}
	
	// Constructor scanned string.
	NSRange numberRange = NSMakeRange(*index, currentIndex - *index);
	NSString *output = [string substringWithRange:numberRange];
	
	// Update index of the start of processing.
	*index = currentIndex;
	
	return output;
}

- (NSString *)stringValueForAction:(NSString *)string
						 tokenType:(CLTokenType)tokenType
							 index:(NSUInteger *)index {
	
	Class<CLAction> action = nil;
	switch (tokenType) {
		case CLTokenTypeOperation:
			action = [CLOperation class];
			break;
			
		case CLTokenTypePrefixFunction:
			action = [CLPrefixFunction class];
			break;
			
		case CLTokenTypePostfixFunction:
			action = [CLPostfixFunction class];
			break;
			
		default:
			return nil;
	}
	
	// Substring from the index of the beginning of the search.
	NSString *substring = [string substringFromIndex:*index];
	
	// Retrieves the length of the action.
	NSUInteger lenght = [action containsAction:substring];
	
	// The symbol by which the type of token will be determined.
	NSString *token = [string substringWithRange:NSMakeRange(*index, lenght)];
	
	// Update index of the start of processing.
	*index += lenght;
	
	return token;
}

@end
