/**
 * CLAction.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @protocol CLAction
 * @abstract It contains methods that characterize the action, operation. Classes CLOperation, CLPrefixFunction,
 		CLPostfixFunction implement the protocol.
 * @discussion This protocol combines action and contains declaration of methods that are required to contain any
 		classes. If you want to implement your own action format and inherit from an action class, you must override
 		these methods.
 */
@protocol CLAction <NSObject>

/**
 * @property stringValue
 * @abstract The string value of the action or operation signature. It allows you to uniquely identify the object.
 		For example, for the addition operation, its signature is the string "+".
 */
@property (readonly, nonatomic) NSString *stringValue;

/**
 * @abstract Checks the signature to be included in the operations of this class. Override the method to support
 		your own signature format.
 * @param signature Line, the beginning of which is a function. For example, from the string "sin(45) + 2" it will
 		select the function sin and return its length.
 * @return The length of the action containing the signature, or zero if no action with the signature is found.
 */
+ (NSUInteger)containsAction:(NSString *)signature;

/**
 * @abstract Checks the signature for belonging to user operations. If the function was not registered it will
 		return NO. Override to support your own signature format.
 * @param signature Line, the beginning of which is the signature of the function. If a function with this signature
 		exists, return YES.
 */
+ (BOOL)isUserAction:(NSString *)signature;

@end

NS_ASSUME_NONNULL_END
