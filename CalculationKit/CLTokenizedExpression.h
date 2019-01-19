/**
 * CLTokenizedExpression.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLToken.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract A wrapper over an array, simplifying the storage and processing of strings. It is the
 		result of the work of the tokenizer. An immutable class produced during tokenization.
 */
@interface CLTokenizedExpression<__covariant ObjectType : CLToken *> : NSObject

/**
 * @abstract The main constructor of the class. Generates an instance of the class from the token array.
 * @param aArray The array of tokens or kinds of class CLToken.
 */
- (instancetype)initWithArray:(NSArray<ObjectType> *)aArray NS_DESIGNATED_INITIALIZER;

/**
 * @abstract Returns an array of tokens that the class stores.
 */
- (NSArray<ObjectType> *)array;

/**
 * @property count
 * @abstract Number of tokens, which are stored by the class. Could be zero.
 */
@property (readonly, nonatomic) NSUInteger count;

/**
 * @abstract Resets the current movement of the expression and sets the current position to zero.
 * @discussion The class stores the sequence number of the position from which the work is performed.
 		Each time an item is received, it increments the sequence number. Calling this method resets
 		he current sequence number and returns the progress to the beginning.
 */
- (void)reset;

/**
 * @abstract Returns the first token in the string. If there are no tokens in the string, returns nil.
 		Calling this method also resets the current sequence number of the handler.
 */
- (nullable ObjectType)firstObject;

/**
 * @abstract Returns the next token in the string. If there are no more tokens left in the string, returns
		nil. Calling this method also increments the sequence number of the currently processed item.
 */
- (nullable ObjectType)nextObject;

@end

/**
 * @abstract A mutable version of the tokenized expression. Allows you to change the sequence number of
 		the currently processed item, add or remove items.
 */
@interface CLMutableTokenizedExpression<__covariant ObjectType : CLToken *> : CLTokenizedExpression

/**
 * @property currentIndex
 * @abstract The sequence number of the currently processed item. Methods that return elements of a
 		string depend on it.
 */
@property (nonatomic) NSInteger currentIndex;

/**
 * @abstract Adds a new token to the end of the string.
 */
- (void)addObject:(ObjectType)object;

/**
 * @abstract Removes the token from the string. If the sequence number points to this token, the
		sequence number is reset.
 */
- (void)removeObject:(ObjectType)object;

@end

NS_ASSUME_NONNULL_END
