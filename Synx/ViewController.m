//
//  ViewController.m
//  Synx
//
//  Created by Scott on 4/10/18.
//  Copyright © 2018 CrankySoft. All rights reserved.
//

#import "ViewController.h"
#import <AppKit/AppKit.h>

@implementation ViewController
@synthesize url;
@synthesize pruneButton;
@synthesize noColorButton;
@synthesize noDefaultExclusionsButton;
@synthesize noSortByNameButton;
@synthesize exclusionButton;
@synthesize canSynx;
@synthesize output;
@synthesize textView;
@synthesize exclusionTextField;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
	self.canSynx = NO;
	self.output = [[NSMutableString alloc]init];
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

- (IBAction)openXCodeProject:(id)sender{
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	panel.allowedFileTypes = @[@"xcodeproj"];
	panel.message = @"Select an XCode Project";
	panel.allowsMultipleSelection = NO;
	panel.canChooseFiles = YES;
	panel.canChooseDirectories = NO;
	NSModalResponse returnCode = [panel runModal];
	
	if (returnCode == NSModalResponseOK) {
		self.url = panel.URL.copy;
		self.canSynx = YES;
	}
}

- (IBAction)onSynx:(id)sender {
	// Init variables
	NSTask* task = [[NSTask alloc]init];
	NSPipe* pipe = [[NSPipe alloc]init];
	task.standardOutput = pipe;
	NSFileHandle* fileHandle = pipe.fileHandleForReading;
	[self.output setString:@""];
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* pathToSynx = [bundle pathForResource:@"synx" ofType:@""];
	if (![pathToSynx isEqualToString:@""]) {
		
		// Set launch path
		task.launchPath = pathToSynx;
		
		// Prepare args
		NSMutableArray* array = [[NSMutableArray alloc]init];
		if (self.pruneButton.state == NSOnState) {
			[array addObject:@"--prune"];
		}
		if (self.noColorButton.state == NSOnState) {
			[array addObject:@"--no-color"];
		}
		if (self.noDefaultExclusionsButton.state == NSOnState) {
			[array addObject:@"--no-default-exclusions"];
		}
		if (self.noSortByNameButton.state == NSOnState) {
			[array addObject:@"--no-sort-by-name"];
		}
		if (self.exclusionButton.state == NSOnState) {
			[array addObject:@"--exclusion"];
			[array addObject:self.exclusionTextField.stringValue];
		}
		
		// Add the xcodeproj to args
		[array addObject:self.url.path];
		
		[task setArguments:array];
		NSString* cmd = pathToSynx;
		for (NSString* string in array) {
			cmd = [NSString stringWithFormat:@"%@ %@", cmd, string];
		}
		[output appendString:cmd];
		self.textView.string = output;
		
		[task launch];
		// Read the processed data
		NSData* data = [fileHandle availableData];
		NSString* text = [[NSString alloc] initWithData:data encoding:
						  NSASCIIStringEncoding];
		[output appendString:text];
		self.textView.string = output;
		
		[task waitUntilExit];
		
		
	}
}

- (IBAction)exclusionButtonChanged:(id)sender {
	self.exclusionTextField.enabled = self.exclusionButton.state;
	if (self.exclusionTextField.enabled) {
		[self.exclusionTextField becomeFirstResponder];
	}
}

@end
