//
//  CSJSONPrettyPrint.m
//  json-pp
//
//  Created by griffin_stewie on 2012/12/08.
//  Copyright (c) 2012年 griffin-stewie. All rights reserved.
//

#import "CSJSONPrettyPrint.h"
#import "SBJson.h"

#define VERSION @"1.0.0"

#define CS_STRING_FROM_BOOL(flag) ((flag) ? @"YES" : @"NO")


@interface CSJSONPrettyPrint ( )
@property (nonatomic, strong) SBJsonParser *parser;
@property (nonatomic, strong) SBJsonWriter *writer;
@property (nonatomic, assign) BOOL version;
@property (nonatomic, assign) BOOL help;
@property (nonatomic, assign) BOOL sort;
@property (nonatomic, assign) BOOL sortNumeric;
@property (nonatomic, assign) BOOL orz;
@property (nonatomic, strong) NSString *filterKey;
@property (nonatomic, strong) NSString *output;
//@property (nonatomic, assign) BOOL verbose;
@end


@implementation CSJSONPrettyPrint

- (id)init
{
    self = [super init];
    if (self) {
        _parser = [[SBJsonParser alloc] init];
        _writer = [[SBJsonWriter alloc] init];
        _writer.humanReadable = YES;
//        _writer.sortKeys = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Internal

- (NSError *)errorWithLocalizedDescription:(NSString *)description
{
    return [NSError errorWithDomain:@"" code:1 userInfo:[NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey]];
}

#pragma mark -
#pragma mark Output

- (int)printVersion
{
    ddprintf(@"Version %@\n", VERSION);
    return EXIT_SUCCESS;
}

- (int)printHelp
{
    ddprintf(@"%@ - pretty-print json\n"
             @"\n"
             @"Basic Usage\n"
             @"  %@ [OPTIONS] [JSON Input]\n"
             @"\n"
             @"Options:\n"
             @"\t\t-v, --version\n"
             @"\t\t   Print version.\n"
             @"\t\t\n"
             @"\t\t-h, --help\n"
             @"\t\t   Print help.\n"
             @"\t\t\n"
             @"\t\t--sort,\n"
             @"\t\t   Sort keys (use compare)\n"
             @"\t\t\n"
             @"\t\t--sort-numeric\n"
             @"\t\t   Sort keys (NSNumericSearch)\n"
             @"\t\t\n"
             @"\t\t-o *FILE*, --output *FILE*\n"
             @"\t\t   Write output to *FILE* instead of *stdout*.\n"
             , DDCliApp
             , DDCliApp);
    return EXIT_SUCCESS;
}

- (void)printUsage: (FILE *) stream;
{
    ddfprintf(stream, @"%@: Usage [OPTIONS] <argument> [...]\n", DDCliApp);
}

- (int)printError:(NSError *)error
{
    ddprintf(@"Error: %@\n", error);
    return EXIT_FAILURE;
}

- (id)JSONFromData:(id)jsonData error:(NSError *__autoreleasing *)error
{
    id object = nil;
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)jsonData;
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *e = nil;
        object = [self.parser objectWithString:jsonString error:&e];
        if (object == nil) {
            if (error) {
                *error = e;
            }
            return nil;
        }
    } else if ([jsonData isKindOfClass:[NSString class]]) {
        NSError *e = nil;
        object = [self.parser objectWithString:jsonData error:&e];
        if (object == nil) {
            if (error) {
                *error = e;
            }
            return nil;
        }
    }
    
    if (object) {
        return object;
    } else {
        if (error) {
            *error = [self errorWithLocalizedDescription:@"Unknown"];
        }
    }
    return nil;
}

- (int)writeWithString:(NSString *)JSONString
{
    NSError *error = nil;
    BOOL result = [JSONString writeToFile:[self.output stringByStandardizingPath]
                               atomically:YES
                                 encoding:NSUTF8StringEncoding
                                    error:&error];
    if (error && result == NO) {
        return [self printError:error];
    }
    return EXIT_SUCCESS;
}

- (int)prettyPrintJSON:(id)json
{
    NSError *error = nil;
    id object = [self JSONFromData:json error:&error];
    
    if (object == nil || error) {
        ddprintf(@"Error: %@\n", error);
        return EXIT_FAILURE;
    }
    
    if (self.filterKey) {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, self.filterKey);
//        id temp = object;
//        id tempFilterd = [temp valueForKeyPath:self.filterKey];
//        object = tempFilterd;
    }
    
    if (self.output) {
        return [self writeWithString:[_writer stringWithObject:object]];
    } else {
        ddprintf(@"%@\n", [_writer stringWithObject:object]);
        return EXIT_SUCCESS;
    }
}

#pragma mark -
#pragma mark Delegate

- (void)application:(DDCliApplication *)app
    willParseOptions:(DDGetoptLongParser *)optionsParser;
{
    DDGetoptOption optionTable[] =
    {
        // Long                Short   Argument options
        {@"version",           'v',    DDGetoptNoArgument},
        {@"help",              'h',    DDGetoptNoArgument},
        {@"sort",               0,     DDGetoptNoArgument},
        {@"sort-numeric",       0,     DDGetoptNoArgument},
        {@"output",            'o',    DDGetoptRequiredArgument},
        {@"filter-key",        'k',    DDGetoptRequiredArgument},
        {@"orz",                0,     DDGetoptNoArgument},
        {nil,                   0,     0},
    };
    [optionsParser addOptionsFromTable: optionTable];
}

- (int)application:(DDCliApplication *)app
   runWithArguments:(NSArray *)arguments;
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, app);
    NSLog(@"%s %@", __PRETTY_FUNCTION__, arguments);

    NSLog(@"%s version: %@", __PRETTY_FUNCTION__, CS_STRING_FROM_BOOL(self.version));
    NSLog(@"%s help: %@", __PRETTY_FUNCTION__, CS_STRING_FROM_BOOL(self.help));
    NSLog(@"%s sort: %@", __PRETTY_FUNCTION__, CS_STRING_FROM_BOOL(self.sort));
    NSLog(@"%s sortNumeric: %@", __PRETTY_FUNCTION__, CS_STRING_FROM_BOOL(self.sortNumeric));
    NSLog(@"%s filterKey: %@", __PRETTY_FUNCTION__, self.filterKey);
    NSLog(@"%s output: %@", __PRETTY_FUNCTION__, self.output);
    
    if (self.version) {
        return [self printVersion];
    }
    
    if (self.help) {
        return [self printHelp];
    }
    
    if (self.orz) {
        ddprintf(@"%@\n", @"乙");
        return EXIT_SUCCESS;
    }
    
    if (self.sort) {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, @"ソート");
        self.writer.sortKeys = YES;
    } else if (self.sortNumeric) {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, @"ソート Numeric");
        self.writer.sortKeysComparator = ^(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        };
        self.writer.sortKeys = YES;
    }
    
//    if ([arguments count] < 1)
//    {
//        ddfprintf(stderr, @"%@: At least one argument is required\n", DDCliApp);
//        [self printUsage: stderr];
//        ddfprintf(stderr, @"Try `%@ --help' for more information.\n",
//                  DDCliApp);
//        return EX_USAGE;
//    }
    
    /// JSONファイルの入力確認
    
    if ([arguments count] == 1) {
        NSString *path = [arguments lastObject];
        NSURL *URL = [NSURL URLWithString:[path stringByStandardizingPath]];
        if ([URL isFileReferenceURL]) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, @"URL は FileReferenceURL");
        } else if ([URL isFileURL]) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, @"URL は FileURL");
        } else if ([[URL scheme] hasSuffix:@"http"]) {
            /// サーバ URL
            NSLog(@"%s %@", __PRETTY_FUNCTION__, @"URL はサーバ URL");
            
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:URL];
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&response
                                                             error:&error];
            if (error) {
                return [self printError:error];
            } else if ([data length]) {
                return [self prettyPrintJSON:data];
            } else {
                return [self printError:[self errorWithLocalizedDescription:@"Something wrong"]];
            }

        } else {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, @"URL は File の URL");
            NSError *error = nil;
            NSData *data = [[NSData alloc] initWithContentsOfFile:[URL absoluteString] options:0 error:&error];
            if (error) {
                return [self printError:error];
            }
            NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
            return [self prettyPrintJSON:data];
        }
    } else {
        NSFileHandle *fh = [NSFileHandle fileHandleWithStandardInput];
        NSLog(@"%s NSFileHandle: %@", __PRETTY_FUNCTION__, fh);
        NSData *data = nil;
        @try {
            data = [fh readDataToEndOfFile];
        }
        @catch (NSException *exception) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, exception);
            return EXIT_FAILURE;
        }
        @finally {
            [fh closeFile];
            if ([data length]) {
                return [self prettyPrintJSON:data];
            } else {
                /// 引数
            }
        }    
    }

    return EXIT_SUCCESS;
}
@end
