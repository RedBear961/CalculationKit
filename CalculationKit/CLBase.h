/**
 * CLBase.h
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * The base control class of the library, which is a singleton. Allows you to customize calculations,
 		such as specifying the number of decimal places as a result of calculations, or how the library
 		uses radians or degrees in trigonometric functions.
 */
@interface CLBase : NSObject

/**
 * @property useRadians
 * @abstract Specifies the library unit of angle measurement used in trigonometric, inverse trigonometric
 		and hyperbolic functions. By default, the library uses degrees.
 */
@property (nonatomic, getter=isUseRadians) BOOL useRadians;

/**
 * @property countOfDecimalPlaces
 * @abstract Specifies the library how many decimal places it should return the result of a computation.
 		Rounding is performed according to the standard rules of mathematical rounding. By default,
		the result is rounded to 5 characters after the dot.
 * @discussion Rounding is performed only for the final result of calculations, for all intermediate results,
 		rounding is not performed.
 */
@property (nonatomic) NSUInteger countOfDecimalPlaces;

/**
 * Returns the singleton variable of the class.
 */
+ (CLBase *)shared;

@end
