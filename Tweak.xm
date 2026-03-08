#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static void (*orig_dataTask)(id, SEL, NSURLRequest *, id);
static void hooked_dataTask(id self, SEL _cmd, NSURLRequest *request, id completion) {
    NSString *url = request.URL.absoluteString;
    if ([url containsString:@"keygen.henghack.store"] && [url containsString:@"validate"]) {
        NSLog(@"[BYPASS] Validate request caught: %@", url);

        NSDictionary *fake = @{
            @"valid": @YES,
            @"status": @"active",
            @"key": @"MARINA-BYPASS-999999",
            @"durationDays": @9999,
            @"expiresAt": @"2099-12-31T23:59:59Z",
            @"visitorid": @"fake-marina",
            @"deviceId": @"bypass-id"
        };

        NSData *data = [NSJSONSerialization dataWithJSONObject:fake options:0 error:nil];
        NSHTTPURLResponse *resp = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"application/json"}];

        void (^block)(NSData *, NSURLResponse *, NSError *) = completion;
        block(data, resp, nil);
        return;
    }
    orig_dataTask(self, _cmd, request, completion);
}

%ctor {
    Class cls = NSClassFromString(@"NSURLSession");
    SEL sel = @selector(dataTaskWithRequest:completionHandler:);
    MSHookMessageEx(cls, sel, (IMP)hooked_dataTask, (IMP *)&orig_dataTask);
    NSLog(@"[AsuraBypass] Hook installed");
}
