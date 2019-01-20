/*
 * CLTokenizer.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLTokenizer.h"

#import "CLError.h"
#import "CLConstant.h"
#import "CLOperation.h"
#import "CLPrefixFunction.h"
#import "CLPostfixFunction.h"

@implementation CLTokenizer

#pragma mark - Class Methods

// Stores the delegate class.
static Class<CLTokenizerProtocol> _protocolClass;

+ (void)registerProtocolClass:(Class<CLTokenizerProtocol>)protocolClass {
	// Saves the class of the delegate.
	_protocolClass = protocolClass;
}

+ (void)unregisterProtocolClass {
	// Clears the variable that holds the delegate class, thereby deleting it.
	_protocolClass = nil;
}

#pragma mark - Processing

- (instancetype)initWithExpression:(CLExpression *)expression error:(NSError **)error {
	// Calls the designated constructor.
	return [self initWithString:expression.stringValue error:error];
}

+ (instancetype)tokenizerWithExpression:(CLExpression *)expression error:(NSError **)error {
	// Calls the designated constructor.
	return [[self alloc] initWithString:expression.stringValue error:error];
}

+ (instancetype)tokenizerWithString:(NSString *)aString error:(NSError **)error {
	// Calls the designated constructor.
	return [[self alloc] initWithString:aString error:error];
}

- (instancetype)initWithString:(NSString *)aString error:(NSError **)error {
	self = [super init];
	
	if (self = [super init]) {
		// Delete the space as unnecessary characters in the string.
		NSString *cleanedString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		// Create a delegate if it has been registered.
		id<CLTokenizerProtocol> delegate = nil;
		if (_protocolClass)
			delegate = [[(id)_protocolClass alloc] init];
		
		// Ordered the buffer with the processed tokens.
		CLMutableTokenizedExpression *tokenizedExpression = [[CLMutableTokenizedExpression alloc] init];
		
		// Main process loop.
		NSUInteger index = 0;
		while (index < cleanedString.length) {
			// Get the next type of token.
			CLTokenType nextType = [self nextTokenTypeInString:cleanedString
												 startingIndex:index
														buffer:tokenizedExpression.array];
			
			// Query the delegate about the correctness of the selected token type.
			if ([delegate respondsToSelector:@selector(tokenizer:correctlyTokenType:forString:)]) {
				NSString *substring = [cleanedString substringFromIndex:index];
				BOOL isWrong = [delegate tokenizer:self correctlyTokenType:nextType forString:substring];
				
				// If the type is not defined correctly.
				if (isWrong) {
					// The request to delegate to the correct type of token.
					nextType = [delegate tokenizer:self tokenTypeForString:substring];
					
					// If the delegate was able to determine the type.
					if (nextType != CLTokenTypeUnknown) {
						CLToken *token = [delegate tokenizer:self
												tokenForType:nextType
													inString:substring
														name:@""];
						
						if (token) {
							index += token.stringValue.length;
							[tokenizedExpression addObject:token];
							continue;
						}
						
						// If the delegate was unable to generate the token.
						nextType = CLTokenTypeUnknown;
					}
				}
			}
			
			NSString *stringValue = nil;
			NSError *tokenizerError = nil;
			switch (nextType) {
				// Processing of the numeric token.
				case CLTokenTypeDecimal:
					stringValue = [self stringValueForDecimalToken:cleanedString
															 index:&index
															 error:&tokenizerError];
					break;
					
				case CLTokenTypeConstant:
					stringValue = [self stringValueForConstantToken:cleanedString
															  index:&index
															  error:&tokenizerError];
					break;
				
				// Variable handling.
				case CLTokenTypeVariable:
					break;
					
				// Processing actions.
				case CLTokenTypeOperation:
				case CLTokenTypePrefixFunction:
				case CLTokenTypePostfixFunction:
					stringValue = [self stringValueForAction:cleanedString
												   tokenType:nextType
													   index:&index];
					break;
					
				// Processing of service token types.
				case CLTokenTypeOpeningBrace:
				case CLTokenTypeClosingBrace:
				case CLTokenTypeSeparator:
					stringValue = [NSString stringWithFormat:@"%c", [cleanedString characterAtIndex:index]];
					++index;
					break;
				
				// An attempt to process a token whose type has not been recognized.
				case CLTokenTypeUnknown:
					if (delegate) {
						// The request to delegate to the correct type of token.
						NSString *substring = [cleanedString substringFromIndex:index];
						nextType = [delegate tokenizer:self tokenTypeForString:substring];
						
						// If the delegate was able to determine the type.
						if (nextType != CLTokenTypeUnknown) {
							CLToken *token = [delegate tokenizer:self
													tokenForType:nextType
														inString:substring
															name:@""];
							
							if (token) {
								index += token.stringValue.length;
								[tokenizedExpression addObject:token];
								continue;
							}
						}
					}
					
					// Generate an error if the delegate is not assigned or it is also unable to allocate a token.
					tokenizerError = [NSError errorWithDomain:CLTokenizerErrorDomain
														 code:CLUnknownToken
													 userInfo:nil];
					break;
			}
			
			// Error handling.
			if (tokenizerError) {
				if (error)
					*error = tokenizerError;
				
				return nil;
			}
			
			// Generation of the token.
			CLToken *token = [[CLToken alloc] initWithName:@"" type:nextType stringValue:stringValue];
			[tokenizedExpression addObject:token];
			
			// Makes a request to the delegate, whether to continue treatment.
			if ([delegate respondsToSelector:@selector(tokenizer:shouldContinueProcessingString:originalString:)]) {
				NSString *substring = [cleanedString substringFromIndex:index];
				BOOL isExit = ![delegate tokenizer:self shouldContinueProcessingString:substring originalString:cleanedString];
				
				// Terminates, if the delegate has decided.
				if (isExit)
					break;
			}
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
		return CLTokenTypeDecimal;
	
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
	
	// Search constants for entry.
	if ([CLConstant hasConstant:substring]) {
		return CLTokenTypeConstant;
	}
	
	// Search operations for entry.
	if ([CLOperation containsAction:substring]) {
		// Check for unary minus or plus.
		if ([substring hasPrefix:@"+"] || [substring hasPrefix:@"-"]) {
			// If this plus or minus sign is the first character of the expression, then it is unary.
			if (!index)
				return CLTokenTypeConstant;
			
			CLToken *token = [buffer lastObject];
			if (token.type == CLTokenTypeOpeningBrace || (token.type == CLTokenTypeOperation &&
				([token.stringValue isEqualToString:@"+"] || [token.stringValue isEqualToString:@"-"]))) {
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

- (NSString *)stringValueForDecimalToken:(NSString *)string
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
		
		// Treatment of unary plus or minus.
		if ((symbol == '-' || symbol == '+') && currentIndex == *index + 1) {
			int prevSymbol = [string characterAtIndex:currentIndex - 1];
			if (prevSymbol == '-' || prevSymbol == '+') {
				++currentIndex;
				continue;
			}
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

- (NSString *)stringValueForConstantToken:(NSString *)string
									index:(NSUInteger *)index
									error:(NSError **)error {
	
	// Substring from the index of the beginning of the search.
	NSString *substring = [string substringFromIndex:*index];
	
	// Retrieves the length of the action.
	NSUInteger lenght = [CLConstant hasConstant:substring];
	
	// The symbol by which the type of token will be determined.
	NSString *token = [string substringWithRange:NSMakeRange(*index, lenght)];
	
	// Update index of the start of processing.
	*index += lenght;
	
	return token;
}

- (NSString *)stringValueForAction:(NSString *)string
						 tokenType:(CLTokenType)tokenType
							 index:(NSUInteger *)index {
	
	// Define a class that has information about the token of the current type.
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
