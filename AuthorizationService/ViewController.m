//
//  ViewController.m
//  AuthorizationService
//
//  Created by gzonelee on 2021/11/01.
//

#import "ViewController.h"
@import SecurityFoundation;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(IBAction)pressClicked:(id)sender {
    AuthorizationRef myAuthorizationRef;
    OSStatus myStatus;
    myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment,
                kAuthorizationFlagDefaults, &myAuthorizationRef);
    
    AuthorizationItem myItems[2];
     
    myItems[0].name = "com.myOrganization.myProduct.myRight1";
    myItems[0].valueLength = 0;
    myItems[0].value = NULL;
    myItems[0].flags = 0;
     
    myItems[1].name = "com.myOrganization.myProduct.myRight2";
    myItems[1].valueLength = 0;
    myItems[1].value = NULL;
    myItems[1].flags = 0;
    
    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;

    AuthorizationFlags myFlags;
    myFlags = kAuthorizationFlagDefaults |
                kAuthorizationFlagInteractionAllowed |
                kAuthorizationFlagExtendRights;
    
//    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
//            kAuthorizationEmptyEnvironment, myFlags, NULL);
    
    AuthorizationRights *myAuthorizedRights;
    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
                kAuthorizationEmptyEnvironment, myFlags,
                &myAuthorizedRights);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/tmp/gzonelee/hello.txt"] == NO) {
        NSLog(@"error - fileExists");
    }
    NSData* data = [NSData dataWithContentsOfFile:@"/tmp/gzonelee/hello.txt" options:0 error:nil];
    NSLog(@"%@", data);
}

@end
