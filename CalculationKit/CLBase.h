//
//  CLBase.h
//  CalculationKit
//
//  Created by God on 09.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#ifndef __CALCULATION_KIT_BASE__
#define __CALCULATION_KIT_BASE__

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
#define CL_EXPORT extern "C"
#else
#define CL_EXPORT extern
#endif

CL_EXPORT
BOOL CalculationKitUsesRadians(void);

CL_EXPORT
void CalculationKitSetUseRadians(BOOL flag);

#endif /* __CALCULATION_KIT_BASE__ */
