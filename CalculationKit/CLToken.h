/**
 * @header CLToken
 * @framework CalculationKit
 *
 * @copyright 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @enum CLTokenType
 * @discussion Declares supported token types. The token types are defined by
 		the tokenizer and assign them on initialization.
 
 * @see CLToken.constant
 * @see CLToken.variable
 * @see CLTokenizer
 */
typedef NS_ENUM(NSInteger, CLTokenType) {
	CLTokenTypeConstant = 0, // A constant number, e.g. 10.2.
	CLTokenTypeVariable, // A variable, e.g. 'y'.
	CLTokenTypeOperation, // A binary operation, e.g. +.
	CLTokenTypePrefixFunction, // A prefix function, e.g. sin().
	CLTokenTypePostfixFunction, // Postfix function, e.g. factorial.
	CLTokenTypeOpeningBrace, // Opening bracket (.
	CLTokenTypeClosingBrace, // Closing bracket ).
	CLTokenTypeSeparator, // Function argument delimiter, comma.
	
	CLTokenTypeUnknown = -1, // Undefined token, not supported.
};

/**
 * @class CLToken
 * @abstract Expression token. Contains information about the token,
 		its string display, and numeric (if applicable).
 */
@interface CLToken : NSObject

/**
 * @property name
 * @brief The unique name of the token. It is not used by itself, but can
 		be useful when building an expression tree.
 */
@property (readonly, nonatomic, copy) NSString *name;

/**
 * @property stringValue
 * @brief String display of the token. Always non-zero. It is used by the
 		calculation class.
 */
@property (readonly, nonatomic, copy) NSString *stringValue;

/**
 * @property type
 * @brief Token type. All types are defined in the CLTokenType enumeration.
 		The token type is assigned by the tokenizer and is the main property of
		the class that is used in the calculation.
 * @see CLTokenType
 */
@property (readonly, nonatomic) CLTokenType type;

/**
 * @property constant
 * @brief Numerical value of the token. Used if the token type is numeric.
		In all other cases it is -1.
 * @see CLTokenType.CLTokenTypeConstant
 */
@property (readonly, nonatomic) CGFloat constant;

/**
 * @property variable
 * @brief String display of the variable. Used if the token type is a variable.
 		In all other cases, the value is nil.
 */
@property (readonly, nonatomic, nullable) NSString *variable;

/**
 * @abstract Assigned to the class constructor. Returns a ready-to-use instance of
		the class with property initialization.
 */
- (instancetype)initWithName:(NSString *)name type:(CLTokenType)type stringValue:(NSString *)aString NS_DESIGNATED_INITIALIZER;

/**
 * @abstract Assigned to the class constructor. Returns a ready-to-use instance of
 		the class with property initialization.
 */
+ (instancetype)tokenWithName:(NSString *)name type:(CLTokenType)type stringValue:(NSString *)aString;

- (instancetype)init NS_UNAVAILABLE; // Not support.

@end

NS_ASSUME_NONNULL_END
