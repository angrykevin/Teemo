//
//  TMMacro.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifdef DEBUG
#define TMPRINTMETHOD() printf("%s\n", __PRETTY_FUNCTION__)
#else
#define TMPRINTMETHOD() ((void)0)
#endif

#ifdef DEBUG
#define TMPRINT(__fmt, ...) printf(__fmt, ##__VA_ARGS__)
#else
#define TMPRINT(__fmt, ...) ((void)0)
#endif


#define OBJCSTR(__str) [NSString stringWithUTF8String:__str.c_str()]
#define CPPSTR(__str) string( [__str UTF8String] )

