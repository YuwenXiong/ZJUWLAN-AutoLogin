//
//  MenubarAppDelegate.h
//  Menubar
//
//  Created by Orpine on 3/21/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "Sparkle/Sparkle.h"
#import "Reachability.h"

@interface MenubarAppDelegate : NSObject <NSApplicationDelegate>
{
    NSDictionary *userDefaults;
    Reachability  *hostReach;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (weak) IBOutlet NSView *preferencePane;
@property (nonatomic, retain) NSDictionary *userDefaults;
- (IBAction)ConnectZJUWLAN:(id)sender;
- (NSString *)setupConnection;
- (void)connecting:(BOOL)isClick;
@end
