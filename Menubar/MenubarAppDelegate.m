//
//  MenubarAppDelegate.m
//  Menubar
//
//  Created by Orpine on 3/21/14.
//  Copyright (c) 2014 Orpine. All rights reserved.
//

#import "MenubarAppDelegate.h"
#import <netdb.h>

OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);
@implementation MenubarAppDelegate

@synthesize statusBar = _statusBar;
@synthesize userDefaults;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusBar setImage:[NSImage imageNamed:@"icon_16x16@2x.png"]];
    [_statusBar setMenu:self.statusMenu];
    [_statusBar setHighlightMode:YES];

    //注册事件
    EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec eventType;
    
    //注册对应的事件，如键盘按钮
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    //注册快捷键事件
    InstallApplicationEventHandler(&myHotKeyHandler,1,&eventType, (__bridge void *)self,NULL);
    
    myHotKeyID.signature='hk1';
    myHotKeyID.id=1;
    //注册EventHandler
    RegisterEventHotKey(kVK_ANSI_C, controlKey + cmdKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
//    NSLog(@"awake");
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"https://net.zju.edu.cn/srun_port1.php"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoLoginOptionChanged:)
                                                 name: autoLoginOptionChangedNotification
                                               object: nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL p = [defaults valueForKey:@"autoLogin"];
    if (p) {
        [hostReach startNotifier];
    }

}

OSStatus myHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void  *userData){
//    NSLog(@"call hot key %@", userData);
    [(MenubarAppDelegate *)[NSApp delegate] connecting:YES];
    return noErr;
}

- (NSString *)setupConnection
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *username = [defaults valueForKey:@"username"];
    NSString *password = [defaults valueForKey:@"password"];
    NSMutableURLRequest *url = [[NSMutableURLRequest alloc] init];
    NSString *post, *postLength;
    NSData *postData;
    
    post = [[NSString alloc] initWithFormat:@"action=login&username=%@&password=%@&ac_id=3&type=1&wbaredirect=&ac_id=3&type=1&wbaredirect=&ac_id=3&type=1&wbaredirect=&mac=&user_ip=&is_ldap=1&local_auth=1",username, password];
    postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [url setHTTPMethod:@"POST"];
    [url setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [url setURL:[NSURL URLWithString:@"https://net.zju.edu.cn/cgi-bin/srun_portal"]];
    [url setHTTPBody:postData];
    [url setTimeoutInterval:2.0];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:url returningResponse:nil error:nil];
    NSString *mess = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return mess;
}

- (NSString *)forceLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *username = [defaults valueForKey:@"username"];
    NSString *password = [defaults valueForKey:@"password"];
    NSMutableURLRequest *url = [[NSMutableURLRequest alloc] init];
    NSString *post, *postLength;
    NSData *postData;
    
    post = [[NSString alloc] initWithFormat:@"action=auto_dm&username=%@&password=%@", username, password];
    postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [url setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [url setHTTPMethod:@"POST"];
    [url setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [url setURL:[NSURL URLWithString:@"https://net.zju.edu.cn/rad_online.php"]];
    [url setHTTPBody:postData];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:url returningResponse:nil error:nil];
    NSString *mess = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return mess;
    
}

- (NSString *)dealMess: (NSString *)mess
{
    NSString *ok = @"<script language=\"javascript\">location=\"/srun_portal.html?action=login_ok\";</script> ";
    if ([mess isEqualToString:ok]) {
//        NSLog(@"ok");
        return @"成功登录";
    } else if ([mess isEqualToString:@"ok"]) {
        return @"成功远程注销";
    } else if ([mess isEqualToString:@""] || [mess isEqualToString:nil]) {
        return @"网络未就绪，请重试";
    }
    return mess;
}
- (void)connecting:(BOOL) isClick
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"ZJUWLAN";
    NSString *mess = [self setupConnection];
    if ([mess isEqualToString:nil]) {
        notification.informativeText = @"网络未就绪，请重试";
        return;
    }
    //    NSLog(@"%@", mess);
    
    
    //    NSLog(@"%@", mess);
    mess = [self dealMess:mess];
    if ([mess isEqualToString:@"您已在线，请注销后再登录。"] == YES) {
        notification.informativeText = @"您已在线，将远程注销。";
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        mess = [self forceLogout];
        //        NSLog(@"%@", mess);
        //        NSLog(@"%@", [self dealMess:mess]);
        mess = [self dealMess:mess];
        notification.informativeText = mess;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
        mess = [self setupConnection];
        //        NSLog(@"mess");
        //        NSLog(@"%@", [self dealMess:mess]);
        mess = [self dealMess:mess];
        notification.informativeText = mess;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    } else if(isClick == NO && [mess isEqualToString:@"您的ip异常，请断开wifi后重新连接"] == YES) {
        
    } else {
        notification.informativeText = mess;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        NSLog(@"%@", mess);

    }
}


- (IBAction)ConnectZJUWLAN:(id)sender {
    [self connecting:YES];
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == 0) {
        [self connecting:NO];
    }
}

- (void)autoLoginOptionChanged:(NSNotification *)note {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL p = [defaults valueForKey:@"autoLogin"];
    if (p) {
        [hostReach startNotifier];
    } else {
        [hostReach stopNotifier];
    }
}

@end
