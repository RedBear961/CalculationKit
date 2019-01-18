/**
 * CLTokenizer.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLExpression.h>
#import <CalculationKit/CLTokenizedExpression.h>

NS_ASSUME_NONNULL_BEGIN

@class CLTokenizer;

/**
 * @protocol CLTokenizerProtocol
 * @abstract Contains methods to control tokenization of the string, and the manual tokenization of the string.
		This Protocol must be implemented by the class, which in turn must register itself with the tokenizer
 		by calling the registration method.
 */
@protocol CLTokenizerProtocol <NSObject>
@required
/**
 * @abstract Called if the tokenizer was unable to determine the type of token, or if it was determined that the
 		type of token was not correctly determined by the tokenizer.
 * @discussion Before you begin to allocate a token from a string, the tokenizer determines its type. If the tokenizer
 		has gone through all the possible options and assigned the token type CLTokenTypeUnknown (did not determine
 		the type of token), it will try to shift the responsibility for the type definition to its delegate.
 
 * @param aString A string in which the tokenizer attempts to allocate a token type. It is a substring of the original
 		string and the new token must start from the beginning of that string.
 * @return The correct token type or CLTokenTypeUnknown if the delegate was also unable to determine the token type.
 		If the token type has not been defined, the tokenizer will generate an error and interrupt the operation.
 */
- (CLTokenType)tokenizer:(CLTokenizer *)tokenizer tokenTypeForString:(NSString *)aString;

/**
 * @abstract Called after the [CLTokenizerProtocol tokenizer:tokenTypeForString:] method. The tokenizer was unable
 		to allocate the token from the string on its own and transfers responsibility for this to its delegate.
 * @discussion The tokenizer attempts to allocate a token type, and after the type is allocated, it calls the
 		appropriate handler, which should allocate the token. If the handler for some reason could not determine
		the type of token, the tokenizer will call this method.
 
 * @param type The type of token that the tokenizer identified but was unable to allocate the token itself.
 * @param aString The string from which you want to allocate the token.
 * @param name The unique name of the token generated by the token generator. Must be used in the token constructor.
 * @return A dedicated token, with a unique name from the name parameter. If the method returns nil, the tokenizer
 		generates an error and aborts.
 */
- (CLToken *)tokenizer:(CLTokenizer *)tokenizer tokenForType:(CLTokenType)type inString:(NSString *)aString name:(NSString *)name;

@optional
/**
 * @abstract Is called each time after a successful allocation of a token. By calling this method, the tokenizer
 		tries to find out if it needs to continue working or if the allocated amount of tokens is enough and it
 		can complete its work.
 * @param aString The raw part of the string.
 * @param origin The original input string passed to the tokenizer for processing.
 * @return YES, if the tokenizer should continue processing the string, NO, if the tokenizer should stop processing.
 		If NO is returned, the tokenizer stops processing the string and completes successfully. This method does
 		not generate an error.
 */
- (BOOL)tokenizer:(CLTokenizer *)tokenizer shouldContinueProcessingString:(NSString *)aString originalString:(NSString *)origin;

/**
 * @abstract Calls this method each time the next token type is determined. Asks the delegate if the allocated token
 		type is correct.
 * @param tokenType Token type defined by the tokenizer.
 * @param aString The part of the string for which the token has defined the type.
 * @return YES, if the tokenizer has correctly determined the token type, NO, if the token type is incorrect.
 		If the token type is incorrect, the tokenizer will make a request to its delegate, so he tried to identify
 		the token type.
 */
- (BOOL)tokenizer:(CLTokenizer *)tokenizer correctlyTokenType:(CLTokenType)tokenType forString:(NSString *)aString;

@end

/**
 * @abstract Tokenizes the input string. Performs the initial processing of the string, breaking it
 		into discrete parts - tokens. Subsequently, the tokenized string formed by the tokenizer is
 		used by the tracer in the reverse Polish record and the calculator.
 
 * @discussion When splitting a string into tokens, the tokenizer focuses on the information received
 		from the CLPrefixFunction, CLPostfixFunction, and CLOperation classes. By itself, the tokenizer
 		does not have information about what type of token this or that part of the string represents.
 		The aforementioned classes provide the interfaces and enable the tokenizer to be clear about the
 		token in the string.
 
 		By default, the tokenizer will not process tokens of the CLTokeTypeUnknown type, but you can
 		assign a class to the tokenizer that supports the CLTokenizerProtocol Protocol to handle situations
 		that are disputed by the tokenizer.
 
 * @see CLPrefixFunction, CLPostfixFunction, CLOperation
 * @see CLToken, CLTokenType, CLTokenTypeUnknown
 * @see CLTokenizerProtocol
 */
@interface CLTokenizer : NSObject

/**
 * @property tokenizedExpression
 * @abstract Tokenized expression, the result of the tokenizer. Later it can be used in the translator in
 		reverse rolish notation.
 * @discussion This tokenized expression is the initial processing of the string. To use it in a calculator,
 		it must be algorithmically converted to reverse polish notation.
 */
@property (readonly, nonatomic) CLTokenizedExpression *tokenizedExpression;

/**
 * @abstract Class constructor. Using an expression, selects the input string and begins its tokenization.
 		After successful tokenization, returns an instance of the class or generates an error and returns
 		nil if the tokenization fails.
 */
- (nullable instancetype)initWithExpression:(CLExpression *)expression error:(NSError **)error;
+ (nullable instancetype)tokenizerWithExpression:(CLExpression *)expression error:(NSError **)error;

/**
 * @abstract Designated to the class constructor. Using the input string, it performs its tokenization and
 		returns its instance, if successful. If the tokenization fails, generates an error and returns nil.
 */
- (nullable instancetype)initWithString:(NSString *)aString error:(NSError **)error NS_DESIGNATED_INITIALIZER;
+ (nullable instancetype)tokenizerWithString:(NSString *)aString error:(NSError **)error;

/**
 * @abstract Registers the class that implemented the CLTokenizerProtocol Protocol as its delegate for processing.
 * @discussion The tokenizer is designed so that a delegate is assigned to control processing. Please do not attempt
 		to inherit from this class, use a delegate for any action. Note that the delegate will be created each time
 		the constructor of this class is called.
 * @see CLTokenizerProtocol
 */
+ (void)registerProtocolClass:(Class<CLTokenizerProtocol>)protocolClass;

/**
 * @abstract Removes a registered class of the delegate. Note that calling this method while the tokenizer is
 		running can cause unpredictable behavior.
 * @see CLTokenizerProtocol
 */
+ (void)unregisterProtocolClass;

- (instancetype)init NS_UNAVAILABLE; // Not support.

@end

NS_ASSUME_NONNULL_END
