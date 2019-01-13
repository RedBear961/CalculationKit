//
//  CLExpression.h
//  CalculationKit
//
//  Created by God on 09.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLExpression : NSObject

@property (readonly, nonatomic) NSString *stringValue;

- (instancetype)initWithString:(NSString *)aString error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
