//
//  CATransitionAdditions.h
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATransition (Initialization)

+ (CATransition *)pushTransition;

+ (CATransition *)popTransition;

@end
