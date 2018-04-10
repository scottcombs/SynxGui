//
//  ViewController.h
//  Synx
//
//  Created by Scott on 4/10/18.
//  Copyright © 2018 CrankySoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (readwrite, retain)NSURL* url;
@property (strong) IBOutlet NSTextField *urlLabel;
@property (strong) IBOutlet NSButton *pruneButton;
@property (strong) IBOutlet NSButton *noColorButton;
@property (strong) IBOutlet NSButton *noDefaultExclusionsButton;
@property (strong) IBOutlet NSButton *noSortByNameButton;
@property (strong) IBOutlet NSButton *exclusionButton;
@property (readwrite)BOOL canSynx;
@property (readwrite, retain)NSMutableString* output;
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NSTextField *exclusionTextField;

- (IBAction)openXCodeProject:(id)sender;
- (IBAction)onSynx:(id)sender;

@end

