/**
 * CLOperation.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLAction.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @enum CLOperationPriority
 * @abstract Declares the possible priorities of the operations. The work of the translator in reverse Polish
 		recording depends on these priorities. Registering the custom functions require the installation of
 		their priority.
 */
typedef NS_ENUM(NSInteger, CLOperationPriority) {
	CLOperationPriorityLower = 0, // + -
	CLOperationPriorityMedium, // * /
	CLOperationPriorityHigh, // ^
	CLOperationPriorityUnknown = -1,
};

/**
 * @typedef CLOperationBlock
 * @abstract A computation of the binary operation. Called by the calculator when an operation needs to be calculated.
 * @param operation The signature of the calculated operation.
 * @param leftOperand The left operand of the operation.
 * @param rightOperand The right operand of the operation.
 * @return The result of the calculations.
 */
typedef CGFloat (^CLOperationBlock)(NSString *operation, CGFloat leftOperand, CGFloat rightOperand);

/**
 * @abstract Provides calculation of binary operations. A binary operation is an operation that has two operands,
 		in the infix notation, written to the left and right of the operation. Examples of such operations are
 		addition and multiplication. The binary operation provides support for custom operations.
 */
@interface CLOperation : NSObject <CLAction>

/**
 * @abstract Returns a binary operation by its signature. If the operation with such a signature does not exist,
 		returns nil.
 * @param signature The signature of the operation. For example, "+".
 */
+ (nullable CLOperation *)operationWithSignature:(NSString *)signature;

/**
 * @abstract Returns the priority of the operation by its signature. If the operation with such a signature does not
 		exist, returns CLOperationPriorityUnknown.
 * @param signature The signature of the operation. For example, "+".
 * @see CLOperationPriority
 */
+ (CLOperationPriority)priorityForOperation:(NSString *)signature;

/**
 * @abstract Performs calculations using the passed operands. Calls the calculation block.
 * @see CLOperationBlock
 */
- (CGFloat)calcWithLeftOperand:(CGFloat)left rightOperand:(CGFloat)right;

/**
 * @abstract Searches for an operation by the supplied signature, and then performs its calculation by calling
 		the calculation block. Throws an exception if an operation with such a signature does not exist or has
 		not been registered.
 * @see CLOperationBlock
 */
+ (CGFloat)calcOperation:(NSString *)signature leftOperand:(CGFloat)left rightOperand:(CGFloat)right;

/**
 * @abstract Registers a user operation with two numeric operands. Does nothing if the transaction has already been
 		registered.
 * @param signature The signature of the operation to be used by the token generator and the calculator to perform the
 		calculation.
 * @param block Operation calculation block.
 * @param priority The operation priority used by the translator in reverse Polish notation to translate the tokenized
 		expression from the infix notation to the Postfix notation.
 * @see CLOperationBlock
 * @see CLOperationPriority
 */
+ (void)registerOperation:(NSString *)signature calcBlock:(CLOperationBlock)block priority:(CLOperationPriority)priority;

/**
 * @abstract Unregisters the user-defined function. If such a function has not been registered, does nothing.
 * @see CLOperation.isUserAction:
 */
+ (void)removeOperation:(NSString *)signature;

@end

NS_ASSUME_NONNULL_END
