//
//  ViewController.m
//  XMPP
//
//  Created by Nguyen Kim Ngoc on 5/31/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#import "ViewController.h"
#import "DBService.h"
#import "RHAddressBook/AddressBook.h"
#import "ReachibilitySample.h"

//@import RHAddressBook;
@import libPhoneNumberiOS;

@class RHPerson;

static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN | XMPP_LOG_FLAG_TRACE;

@interface ViewController () <XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTextDemo;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (!self.xmppStream) {
        self.xmppStream = [[XMPPStream alloc] init];
    }
//    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//        // keep in mind this is called on a background thread
//        // and if you are updating the UI it needs to happen
//        // on the main thread, like this:
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"REACHABLE!");
//        });
//    };
//    
//    reach.unreachableBlock = ^(Reachability*reach)
//    {
//        NSLog(@"UNREACHABLE!");
//    };
//    
//    [reach startNotifier];
    
    self.xmppStream.myJID = [XMPPJID jidWithString:@"0988084022@reeng/reeng"];
    self.xmppStream.hostName = @"171.255.193.155";
    self.xmppStream.hostPort = 5225;
    
    
//    self.xmppStream.myJID = [XMPPJID jidWithString:@"user01@localhost/abc"];
//    self.xmppStream.hostName = @"125.235.13.148";
//    self.xmppStream.hostPort = 5222;
    
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    self.xmppPing = [[XMPPPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
//    self.xmppPing.respondsToQueries = NO;
//    [self.xmppPing activate: self.xmppStream];
    
    //dispatch_get_current_queue();
    self.xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    
    [self.xmppAutoPing setPingTimeout: 10];
    [self.xmppAutoPing setPingInterval:12];
    [self.xmppAutoPing activate:self.xmppStream];
    
//    self.xmppAutoPing
    self.xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [self.xmppReconnect setReconnectDelay:5];
    [self.xmppReconnect setReconnectTimerInterval:5];
    [self.xmppReconnect setAutoReconnect:TRUE];
    [self.xmppReconnect activate:self.xmppStream];
    
//    ReachibilitySample *s = [[ReachibilitySample alloc] init];
//    
//    [s sayHello:@"NGOCNK1"];
#if NGOCNK_DEBUG == 1
    NSLog(@"finish view did load");
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtnDisconnect:(id)sender {
    if (self.xmppStream) {
        [self.xmppStream disconnect];
    }
}

- (IBAction)clickButton:(id)sender {
    
    NSError *error;

    [self.xmppStream connectWithTimeout:50 error: &error];
    
    if(error) {
        NSLog(@"1. %@", error.description);
    }
}
- (IBAction)clickBtnCheckStatus:(id)sender {
    NSString *message = @"Some message..." ;
    [self.xmppStream state];
    
    NSString *txtValue = [_inputTextDemo text];
    
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    
    [[DBService sharedInstance] testQuery];
    
    if (txtValue != nil) {
        NBPhoneNumber *myNumber = [phoneUtil parse:txtValue defaultRegion:@"VN" error:&anError];
        NSLog(@"%d", [phoneUtil isValidNumber:myNumber]);
    }
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}
- (IBAction)clickbtnContactDemo:(id)sender {
    RHAddressBook *ab = [[RHAddressBook alloc] init] ;
    
    NSArray *peopel = [ab peopleWithName:@"113"];
    
    for (id p in peopel) {
        RHPerson *rp = (RHPerson*) p;
        if ([[rp name] containsString:@"113 VY"]) {
            //[rp phoneNumbers]
            //NSLog(@"RecordID: %d, Name: %@, Number Phones: %tu", [rp recordID], [rp modified], [[rp phoneNumbers] count]);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

            NSString *message = [formatter stringFromDate:[rp modified]];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            [self presentViewController:alert animated:YES completion:nil];

            int duration = 1; // duration in seconds

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }
}

-(void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"2. DID CONNECT ");
    NSError *error;
    [self.xmppStream authenticateWithPassword:@"22872172152888958234602" error:&error];
//    [self.xmppStream authenticateWithPassword:@"user01" error:&error];
    if(error) {
        NSLog(@"3. %@", error.description);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@" %@", [message prettyXMLString]);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"3. DID AUTHENTICATE");
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq {
    NSLog(@"4. IQ: %@", [iq elementID]);
}
@end
