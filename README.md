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
