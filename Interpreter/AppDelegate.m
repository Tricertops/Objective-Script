//
//  AppDelegate.m
//  Objective-Script
//
//  Created by Martin Kiss on 6.2.16.
//  Copyright © 2016 Tricertops. All rights reserved.
//

@import Cocoa;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;

@end

int main(int argc, const char * argv[]) {
    return NSApplicationMain(argc, argv);
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

@end
