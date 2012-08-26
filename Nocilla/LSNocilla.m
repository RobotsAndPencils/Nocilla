//
//  LSNocilla.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LSNocilla.h"
#import "LSNSURLHook.h"

NSString * const LSUnexpectedRequest = @"Unexpected Request";

@interface LSNocilla ()
@property (nonatomic, strong) NSMutableArray *mutableRequests;
@property (nonatomic, strong) NSMutableArray *hooks;
@property (nonatomic, assign, getter = isStarted) BOOL started;

-(void) loadHooks;
-(void) unloadHooks;
-(void) loadNSURLConnectionHook;
-(void) unloadNSURLConnectionHook;

@end
static LSNocilla *sharedInstace = nil;
@implementation LSNocilla


+(LSNocilla *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

-(id) init {
    self = [super init];
    if (self) {
        _mutableRequests = [NSMutableArray array];
        _hooks = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)stubbedRequests {
    return [NSArray arrayWithArray:self.mutableRequests];
}

- (void) start {
    [self loadHooks];
}

-(void) stop {
    [self unloadHooks];
    [self clearStubs];
}

-(void) addStubbedRequest:(LSStubRequest *)request {
    [self.mutableRequests addObject:request];
}

-(void) clearStubs {
    [self.mutableRequests removeAllObjects];
}

#pragma mark - Private
-(void) loadHooks {
    [self loadNSURLConnectionHook];
}

-(void) unloadHooks {
    for (LSHTTPClientHook *hook in self.hooks) {
        [hook unload];
    }
}

-(void) loadNSURLConnectionHook {
    LSHTTPClientHook *hook = [[LSNSURLHook alloc] init];
    [self.hooks addObject:hook];
    [hook load];
}

@end
