//
//  AppController.h
//  Menubar
//
//  Created by Orpine on 3/22/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreferenceController;

@interface AppController : NSObject
{
    PreferenceController *preferenceController;
}

- (IBAction)showPreferencePanel:(id)sender;

@end
