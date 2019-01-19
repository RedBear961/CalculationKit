/**
 * CLStack.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract The simplest implementation of a stack machine. Supports generics. It is not highly specialized,
 		it can be used anywhere.
 */
@interface CLStack<__covariant ObjectType> : NSObject

/**
 * @property count
 * @abstract The number of elements on the stack. Taking and placing an item on the stack changes
 		this number.
 */
@property (readonly, nonatomic) NSUInteger count;

/**
 * @abstract Adds an element to the top of the stack and increments the number of elements - the count.
 */
- (void)push:(ObjectType)object;

/**
 * @abstract Removes an element from the top of the stack and returns it, reducing the count - the number
 		of elements in the stack. If the stack is empty, returns nil.
 */
- (nullable ObjectType)pop;

/**
 * @abstract Clears the stack by removing all items and resetting count.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
