//
//  main.m
//  jsonpp
//
//  Created by griffin_stewie on 2012/12/09.
//  Copyright (c) 2012年 net.cyan-stivy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCommandLineInterface.h"
#import "CSJSONPrettyPrint.h"

int main(int argc, const char * argv[])
{
    int result = 0;
    @autoreleasepool {
        result = DDCliAppRunWithClass([CSJSONPrettyPrint class]);
    }
    return result;
}

