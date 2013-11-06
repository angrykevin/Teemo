//
//  TMTagHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMTagHandler__
#define __TMTagHandler__

#include <iostream>

#include <gloox/taghandler.h>

using namespace gloox;


class TMTagHandler : public TagHandler {
  
public:
  /**
   * This function is called when a registered XML element arrives.
   * As with every handler in gloox, the Tag is going to be deleted after this function returned.
   * If you need a copy afterwards, create it using Tag::clone().
   * @param tag The complete Tag.
   */
  void handleTag( Tag* tag );
  
};

#endif
