//
//  main.m
//  AuthorizationService
//
//  Created by gzonelee on 2021/11/01.
//

#import <Cocoa/Cocoa.h>
@import SecurityFoundation;


void runApp();

int main(int argc, const char * argv[]) {
    NSString* str = NSProcessInfo.processInfo.userName;
    runApp();
    return 0;
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//    }
//    return NSApplicationMain(argc, argv);
}

void runApp() {
    AuthorizationRef myAuthorizationRef;
    OSStatus myStatus;
    
    AuthorizationItem myItems[1];
     
    char* path = "/Applications/AhnReport.app/Contents/MacOS/ahnrpt";
    myItems[0].name = kAuthorizationRightExecute;
    myItems[0].valueLength = strlen(path);
    myItems[0].value = &path;
    myItems[0].flags = 0;
    
    AuthorizationEnvironment myAuthorizationEnvironment;
        AuthorizationItem kAuthEnv[1];
        myAuthorizationEnvironment.items = kAuthEnv;

        const char *prompt = "hello";
        kAuthEnv[0].name = kAuthorizationEnvironmentPrompt;
        kAuthEnv[0].valueLength = strlen(prompt);
        kAuthEnv[0].value = prompt;
        kAuthEnv[0].flags = 0;

        myAuthorizationEnvironment.count = 1;

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
    myStatus = AuthorizationCreate (NULL, &myAuthorizationEnvironment,
                                    kAuthorizationFlagDefaults, &myAuthorizationRef);
    NSLog(@"myStatus : %d", myStatus);

//    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
//            kAuthorizationEmptyEnvironment, myFlags, NULL);
    
    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
                &myAuthorizationEnvironment, myFlags,
                NULL);
    NSLog(@"myStatus : %d", myStatus);
    if (myStatus != 0) {
        return;
    }

    char* args[] = { NULL };
    FILE *outputFile;
    OSStatus s = AuthorizationExecuteWithPrivileges(myAuthorizationRef, path, kAuthorizationFlagDefaults, (char**)args, &outputFile);
    NSLog(@"%d", s);
    AuthorizationFree(myAuthorizationRef, myFlags);
}
