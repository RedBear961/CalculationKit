# CalculationKit
Uses a string representing the expression to perform calculations.

## Usage

### Calculation

The simplest way to perform calculations:
```
// Input string.
NSString *aString = @"2+2";

// Create an instance of an expression.
NSError *error = nil;
CLExpression *expression = [[CLExpression alloc] initWithString:aString error:&error];

if (error) {
   // Error handling...
}

// Getting the result of the calculation.
CGFloat result = [expression calc:&error];

if (error) {
   // Error handling...
}
```
### Registration of user-defined functions

CalculationKit also allows you to register user-defined prefix, postfix functions, and operations. Any function has a signature, and a prefix function also has a number of arguments. The following shows how to install a custom function.

```
// The signature of the function.
NSString *signature = @"sum";

// The number of arguments that the function takes.
NSUInteger argumentCount = 2;

// The calculation block that will be called if the calculator
// finds the function signature in the expression.

CLPrefixFunctionBlock calcBlock =
	^CGFloat(NSString *prefixFunction, NSUInteger argumentCount, NSArray<NSNumber *> *arguments) {
		return arguments[0].doubleValue + arguments[1].doubleValue;
	};
   
// Function registration.
[CLPrefixFunction registerPrefixFunction:signature argumentCount:argumentCount calcBlock:calcBlock];

// Using the new function.
CLExpression *expression = [[CLExpression alloc] initWithString:@"sum(2, 2)" error:nil];
CGFloat result = [expression calc:nil]; // sum(2, 2) = 2
```
