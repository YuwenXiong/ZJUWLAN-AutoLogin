//
//  AppController.m
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

- (IBAction)showPreferencePanel:(id)sender
{
    preferenceController = [[PreferenceController alloc] init];
    NSLog(@"showing %@", preferenceController);
    [preferenceController showWindow:self];
}

@end
