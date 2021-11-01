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
    
    AuthorizationItem myItems[1];
     
    char* path = "/usr/bin/log";
    myItems[0].name = kAuthorizationRightExecute;
    myItems[0].valueLength = strlen(path);
    myItems[0].value = &path;
    myItems[0].flags = 0;
     
//    myItems[1].name = kAuthorizationRightExecute;
//    myItems[1].valueLength = 0;
//    myItems[1].value = NULL;
//    myItems[1].flags = 0;

//    myItems[2].name = "admin";
//    myItems[2].valueLength = 0;
//    myItems[2].value = NULL;
//    myItems[2].flags = 0;

    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;

    AuthorizationFlags myFlags;
    myFlags = kAuthorizationFlagDefaults |
                kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize |
                kAuthorizationFlagExtendRights;

    AuthorizationRights *myAuthorizedRights = NULL;
    myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment,
                                    kAuthorizationFlagDefaults, &myAuthorizationRef);
    NSLog(@"myStatus : %d", myStatus);

//    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
//            kAuthorizationEmptyEnvironment, myFlags, NULL);
    
    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
                kAuthorizationEmptyEnvironment, myFlags,
                NULL);
    NSLog(@"myStatus : %d", myStatus);

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/tmp/gzonelee/hello.txt"] == NO) {
        NSLog(@"error - fileExists");
    }
    NSData* data = [NSData dataWithContentsOfFile:@"/tmp/gzonelee/hello.txt" options:0 error:nil];
    NSLog(@"%@", data);
    char* args[] = { "show", "--last", "1m", NULL };
    FILE *outputFile;
    OSStatus s = AuthorizationExecuteWithPrivileges(myAuthorizationRef, path, kAuthorizationFlagDefaults, (char**)args, &outputFile);
    if (outputFile) {
        char sss[1024];
        while(fgets(sss, 512, outputFile)) {
            NSLog(@"%s", sss);
        }
    }
    NSLog(@"%d", s);

    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/log"];
    [task setArguments:@[ @"show", @"--last",  @"1m" ]];
    [task launch];
    
    
}

@end
