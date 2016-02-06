//
//  AppDelegate.m
//  Objective-Script
//
//  Created by Martin Kiss on 6.2.16.
//  Copyright © 2016 Tricertops. All rights reserved.
//

@import Cocoa;

@interface AppDelegate : NSObject <NSApplicationDelegate>

+ (int)interpret;

@end

int main(int argc, const char * argv[]) {
    if (argc > 1) {
        return [AppDelegate interpret];
    }
    else {
        return NSApplicationMain(argc, argv);
    }
}

@implementation AppDelegate

+ (int)interpret {
    printf("-- Objective-Script Interpreter --\n");
    NSArray<NSString *> *arguments = NSProcessInfo.processInfo.arguments;
    NSCParameterAssert(arguments.count >= 2);
    NSUInteger const executables = 2; //! First is this program, second is probably script.
    NSRange range = NSMakeRange(executables, arguments.count - executables);
    NSArray<NSString *> *scriptArguments = [arguments subarrayWithRange:range];
    
    NSURL *scriptURL = [NSURL fileURLWithPath:arguments[1]];
    NSMutableString *script = [NSMutableString stringWithContentsOfURL:scriptURL encoding:NSUTF8StringEncoding error:nil];
    if ([script hasPrefix:@"#!"]) {
        [script insertString:@"//" atIndex:0];
    }
    NSString *pid = [NSString stringWithFormat:@"%i", NSProcessInfo.processInfo.processIdentifier];
    NSURL *directoryURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:pid isDirectory:YES];
    [NSFileManager.defaultManager createDirectoryAtURL:directoryURL withIntermediateDirectories:NO attributes:nil error:nil];
    NSURL *sourceURL = [directoryURL URLByAppendingPathComponent:@"source.m" isDirectory:NO];
    [script writeToURL:sourceURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *executableURL = [directoryURL URLByAppendingPathComponent:@"executable" isDirectory:NO];
    NSTask *compilation = [NSTask new];
    compilation.launchPath = @"/usr/bin/cc";
    compilation.arguments = @[@"-o", executableURL.path, sourceURL.path];
    [compilation launch];
    [compilation waitUntilExit];
    if (compilation.terminationStatus != 0) {
        return compilation.terminationStatus;
    }
    
    NSTask *execution = [NSTask new];
    execution.launchPath = executableURL.path;
    execution.arguments = scriptArguments;
    [execution launch];
    [execution waitUntilExit];
    
    [NSFileManager.defaultManager removeItemAtURL:directoryURL error:nil];
    
    return execution.terminationStatus;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

@end
