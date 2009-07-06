// NSObjectTests.m
// WOBezel
//
// Copyright 2006-2009 Wincent Colaiuta. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// class header
#import "NSObjectTests.h"

#pragma mark -
#pragma mark Helpers

static Class NSObjectTestClassSelf      = Nil;
static Class NSObjectTestSubclassSelf   = Nil;
static IMP   NSObjectTestClassIMP       = NULL;

@interface NSObjectTestClass : NSObject

+ (int)classMethod;

@end

@implementation NSObjectTestClass

// this method contains three assumptions that will be tested
+ (int)classMethod;
{
    // 1. Methods implementations are shared with subclasses
    // (that is, _cmd is the same regardless of whether a subclass or the superclass invoked the method)
    NSObjectTestClassIMP = (IMP)_cmd;

    // 2. Static locals should be shared with subclasses (because the method implementation is shared)
    static int foo = 0;
    foo++;

    // 3. But the value of "self" should be different when called by a subclass
    // (even though the method implementation is shared, the value of self is passed in as a parameter and is therefore dynamic)
    NSObjectTestClassSelf = self;
    return foo;
}

@end

@interface NSObjectTestSubclass : NSObjectTestClass
@end

@implementation NSObjectTestSubclass

+ (int)classMethod;
{
    NSObjectTestSubclassSelf = self;
    return [super classMethod];
}

@end

#pragma mark -

@implementation NSObjectTests

// the WONotificationBezelManager singleton pattern makes a number of assumptions; confirm them
- (void)testAssumptions
{
    // at start variables should be Nil/NULL
    WO_TEST_NIL(NSObjectTestClassSelf);
    WO_TEST_NIL(NSObjectTestSubclassSelf);
    WO_TEST_NIL(NSObjectTestClassIMP);

    // on first call to superclass, foo should be incremented to 1
    WO_TEST_EQ([NSObjectTestClass classMethod], 1);

    // and corresponding class variables should be non-Nil
    WO_TEST_NOT_NIL(NSObjectTestClassSelf);

    // although other class variable should still be Nil
    WO_TEST_NIL(NSObjectTestSubclassSelf);

    // and the IMP should have been set
    WO_TEST_NOT_NIL(NSObjectTestClassIMP);

    // keep a record of the initial value of "self" and "_cmd" in the superclass for later comparison
    Class NSObjectTestClassInitialSelf = NSObjectTestClassSelf;
    IMP NSObjectTestClassInitialIMP = NSObjectTestClassIMP;

    // on call to subclass foo should be incremented
    WO_TEST_EQ([NSObjectTestSubclass classMethod], 2);

    // subclass self should now be non-Nil
    WO_TEST_NOT_NIL(NSObjectTestSubclassSelf);

    // and superclass should have seen the same value
    WO_TEST_EQ(NSObjectTestClassSelf, NSObjectTestSubclassSelf);

    // but it should be different from the value it previously saw
    WO_TEST_NE(NSObjectTestClassSelf, NSObjectTestClassInitialSelf);

    // the IMP should be unchanged
    WO_TEST_EQ(NSObjectTestClassIMP, NSObjectTestClassInitialIMP);

    // if we call the superclass directly again, things should go back to how they were
    WO_TEST_EQ([NSObjectTestClass classMethod], 3);
    WO_TEST_NOT_NIL(NSObjectTestClassSelf);
    WO_TEST_EQ(NSObjectTestClassSelf, NSObjectTestClassInitialSelf);
    WO_TEST_EQ(NSObjectTestClassIMP, NSObjectTestClassInitialIMP);
}

@end
