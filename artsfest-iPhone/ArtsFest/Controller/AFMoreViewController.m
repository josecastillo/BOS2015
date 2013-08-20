//
//  AFMoreViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFMoreViewController.h"
#import "AFWebViewController.h"

@interface AFMoreViewController ()

@end

@implementation AFMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																			 style:UIBarButtonItemStyleBordered
																			target:nil
																			action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"CommunityMessageSegue"]) {
		AFWebViewController *destinationViewController = (AFWebViewController *)segue.destinationViewController;
		NSURL *message = [NSURL URLWithString:@"data:text/html;base64,PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDx0aXRsZT5Db21tdW5pdHkgTWVzc2FnZTwvdGl0bGU+CiAgPHN0eWxlPgogIGJvZHkge2ZvbnQtZmFtaWx5OiAiSGVsdmV0aWNhIE5ldWUiLCBIZWx2ZXRpY2EsIEFyaWFsLCBzYW5zLXNlcmlmO30gaDEge21hcmdpbi10b3A6IDB9CiAgPC9zdHlsZT4KPC9oZWFkPgo8Ym9keT4KPGgxPkEgTWVzc2FnZSB0byBPdXIgQ29tbXVuaXR5PC9oMT4KPHA+T3ZlciB0aGUgcGFzdCB0d28geWVhcnMsIEFydHMgaW4gQnVzaHdpY2sgaGFzIGV4cGVyaWVuY2VkIHVucHJlY2VkZW50ZWQgZ3Jvd3RoLCBleHBhbmRpbmcgb3VyIGNvbW11bml0eSBvdXRyZWFjaCBhbmQgcHJvZ3JhbW1pbmcsIGZlc3RpdmFsIHBhcnRpY2lwYXRpb24gYW5kIHZvbHVudGVlciBuZXR3b3JrLiBPdXIgY3VycmVudCBncm91cCBvZiBsZWFkIG9yZ2FuaXplcnMgaGFzIGNvbWUgdG9nZXRoZXIgdGhpcyB5ZWFyIHRvIHByb3ZpZGUgYW4gb3BlbiBzdHVkaW9zIGFuZCBhcnRzIGZlc3RpdmFsIHdoaWNoLCByZWdhcmRsZXNzIG9mIHRoZSBzdXJnZSBpbiBzaXplIGFuZCBzY29wZSwgZnVuY3Rpb25zIGFzIGFuIG9wZW4gZm9ydW0gZm9yIHRoZSBjcmVhdGlvbiwgZXhoaWJpdGlvbiBhbmQgY2VsZWJyYXRpb24gb2YgYXJ0IGluIHRoZSBCdXNod2ljayBjb21tdW5pdHkuPC9wPgo8cD5UaHJvdWdob3V0IDIwMTItMjAxMywgd2l0aCB0aGUgY29tYmluZWQgZWZmb3J0cyBvZiBpdHMgdm9sdW50ZWVycywgQWlCIGluY3JlYXNlZCB0aGUgcmVhY2ggb2Ygb3VyIGNvbW11bml0eSBwcm9ncmFtbWluZyBieSBwYXJ0bmVyaW5nIHdpdGggbG9jYWwgb3JnYW5pemF0aW9ucywgaW5kaXZpZHVhbHMgYW5kIHNjaG9vbHMgdG8gb2ZmZXIgZnJlZSBldmVudHMgYW5kIHdvcmtzaG9wcyBmb3IgcmVzaWRlbnRzLCB3aXRoIGEgc3BlY2lhbCBmb2N1cyBvbiB0aGUgeW91dGggcG9wdWxhdGlvbi4gSW4gdGhpcyB2ZWluLCB3ZSBhcmUgdGhyaWxsZWQgdG8gZGVidXQgPHN0cm9uZz5CT1MgJzEzIENvbW11bml0eSBEYXk8L3N0cm9uZz4gaW4gTWFyaWEgSGVybmFuZGV6IFBhcmssIGEgbmV3IEJPUyBldmVudCBmZWF0dXJpbmcgbXVzaWMgYW5kIGZhbWlseS1mcmllbmRseSBhY3Rpdml0aWVzLiBXZSBhcmUgZXF1YWxseSBleGNpdGVkIHRvIHVudmVpbCBhIG5ldyBwdWJsaWMgbXVyYWwgaW4gdGhlIG91dGRvb3IgYXF1YXBvbmljIGZhcm0gc3BhY2UKYXQgTGEgTWFycXVldGEgZGUgV2lsbGlhbXNidXJnLCBkZXZlbG9wZWQgYnkgYXJ0aXN0IGFuZCBCdXNod2ljayByZXNpZGVudCBNaXJpYW0gQ2FzdGlsbG8gaW4gY29sbGFib3JhdGlvbiB3aXRoIHN0dWRlbnRzIGZyb20gdGhlIEJlYWNvbiBDZW50ZXIgZm9yIEFydHMgYW5kIExlYWRlcnNoaXAgYW5kIG1hZGUgcG9zc2libGUgYnkgYSBwYXJ0bmVyc2hpcCBiZXR3ZWVuIFRoZSBNb29yZSBTdHJlZXQgUmV0YWlsIE1hcmtldCwgT0tPIEZhcm1zLCB0aGUgQmVhY29uIENlbnRlciwgYW5kIHRoZSBBaUIgQ29tbXVuaXR5IFRlYW0uPC9wPgo8cD5PdGhlciBuZXcgaGlnaGxpZ2h0cyB0byB0aGlzIHllYXLigJlzIGZlc3RpdmFsIGluY2x1ZGUgPHN0cm9uZz5DaW5lbWFTdW5kYXk8L3N0cm9uZz4sIHdoaWNoIHByb3ZpZGVzIGZpbG0gYW5kIHZpZGVvIGFydGlzdHMgYSBjaGFuY2UgdG8gcmVhbGl6ZSB0aGVpciB3b3JrIG9uIHRoZSBiaWcgc2NyZWVuIGR1cmluZyBCT1MgJzEzOyA8c3Ryb25nPkFpQiBCbG9nPC9zdHJvbmc+LCBuZXdseSByZS1sYXVuY2hlZCBpbiAyMDEzIHRvIHByb3ZpZGUgdW5pcXVlIGNvbnRlbnQgaW4gYW4gZXhwYW5kZWQgc2NvcGUsIGluY2x1ZGluZyA8c3Ryb25nPkFpQiBSYWRpbzwvc3Ryb25nPiwgYSBzZXJpZXMgb2YgcG9kY2FzdHMgaGlnaGxpZ2h0aW5nIG11c2ljaWFucyBhbmQgb3JpZ2luYWwgYXVkaW8gaW50ZXJ2aWV3czsgYW5kIGFuIDxzdHJvbmc+RWxlY3Ryb25pYyBNdXNpYyBTaG93Y2FzZTwvc3Ryb25nPiwgd2hpY2ggb2ZmZXJzIGV4cG9zdXJlIHRvIG11c2ljaWFucyBhbmQgc291bmQgYXJ0aXN0cyBleHBlcmltZW50aW5nIGluIHRoaXMgaHlicmlkIG1lZGl1bS4gVGhlc2UgZXhjaXRpbmcgYWRkaXRpb25zIHRvIG91ciBvZmZpY2lhbCBwcm9ncmFtbWluZyByb3N0ZXIgd291bGQgbm90IGJlIG1hZGUgcG9zc2libGUgd2l0aG91dCB0aGUgZXh0cmFvcmRpbmFyeSB0YWxlbnRzIGFuZCBoYXJkIHdvcmsgb2Ygb3VyIHBhc3Npb25hdGUgdGVhbSBvZiB2b2x1bnRlZXJzLiBXZSB3b3VsZCBzcGVjaWZpY2FsbHkgbGlrZSB0byB0aGFuayBvdXIgY29yZSBncm91cCBvZiBsZWFkIG9yZ2FuaXplcnMgYW5kIGNvb3JkaW5hdG9ycyBvZiBCT1MgJzEzIHdobyBoYXZlIHdvcmtlZCB0aXJlbGVzc2x5IHllYXItcm91bmQgdG8gbWFrZSBBaUIgYW5kIEJPUyAnMTMgYSBzdWNjZXNzOiA8c3Ryb25nPkx1Y2lhIFJvbGxvdywgSnVsaWEgU2luZWxuaWtvdmEsIEhvbGx5IFNoZW4gQ2hhdmVzLCBTYW1hbnRoYSBLYXR6LCBIYW5sZXkgTWEsIEppbGxpYW4gU2FsaWssIExhdXJlbiBELiBTbWl0aCwgTWVnYW4gVHJldmlubywgVGFyYSBGZXJyaSwgQW5keSBHaWxsZXR0ZSwgTWlrYWVsIEhlbmFmZiwgSm9leSBDYXN0aWxsbywgQnJpYW4gRG9ub2h1ZSwgQWxleGFuZHJhIFNwaW5rcywgTWFyeSBHb3JkYW5pZXIsIE1hbmR5IE1hbmRlbHN0ZWluLCBUcmFjeSBGcmFuY2lzLCBhbmQgSWFuIENvbGxldHRpPC9zdHJvbmc+LjwvcD4KPHA+QWlCIHdvdWxkIGFsc28gbGlrZSB0byB0aGFuayBvdXIgbG9jYWwgY29tbXVuaXR5LCBhcnRpc3QsIGdhbGxlcnkgYW5kIHN0dWRpbyBwYXJ0aWNpcGFudHMgYW5kIHNwb25zb3JzIGZvciBicmluZ2luZyB0aGlzIHRydWx5IG9uZS1vZi1hLWtpbmQgY29tbXVuaXR5IGFydCBmZXN0aXZhbCB0byBmcnVpdGlvbi4gRW5qb3kgQk9TICcxMyE8L3A+CjxwPjxzdHJvbmc+Jm5ic3A7Jm1kYXNoOyZuYnNwO1RoZSBBSUIgVGVhbTwvc3Ryb25nPjwvcD4KPC9ib2R5Pgo8L2h0bWw+Cgo="];
		destinationViewController.request = [NSURLRequest requestWithURL:message];
	}
	if ([segue.identifier isEqualToString:@"AboutAIBSegue"]) {
		AFWebViewController *destinationViewController = (AFWebViewController *)segue.destinationViewController;
		NSURL *message = [NSURL URLWithString:@"data:text/html;base64,PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmLTgiPgogIDx0aXRsZT5BYm91dCBBSUI8L3RpdGxlPgogIDxzdHlsZT4KICBib2R5IHtmb250LWZhbWlseTogIkhlbHZldGljYSBOZXVlIiwgSGVsdmV0aWNhLCBBcmlhbCwgc2Fucy1zZXJpZjt9IGgxIHttYXJnaW4tdG9wOiAwfQogIDwvc3R5bGU+CjwvaGVhZD4KPGJvZHk+CjxoMT5BYm91dCBBcnRzIGluIEJ1c2h3aWNrPC9oMT4KPGgyPldobyBXZSBBcmU8L2gyPgo8cD5BcnRzIEluIEJ1c2h3aWNrIGlzIGEgdm9sdW50ZWVyLCBub24tcHJvZml0IG9yZ2FuaXphdGlvbiB0aGF0IGVuY291cmFnZXMgYXJ0aXN0cywgcmVzaWRlbnRzLCBmYW1pbGllcywgYW5kIHlvdXRocyB0byBwYXJ0YWtlIGluIEJ1c2h3aWNr4oCZcyBjcmVhdGl2ZSBjb21tdW5pdHkgYnkgY29udHJpYnV0aW5nIHRoZWlyIGxlYWRlcnNoaXAsIHRpbWUsIGFuZCB0YWxlbnQgdG8gb3VyIGRpdmVyc2UgZ3JvdXAgb2Ygb3JnYW5pemVycy4gRG96ZW5zIG9mIHZvbHVudGVlcnMsIHdpdGggc3VwcG9ydCBmcm9tIGxvY2FsIGJ1c2luZXNzZXMgYW5kIG90aGVyIG5laWdoYm9yaG9vZCBhc3NvY2lhdGlvbnMgYmFzZWQgaW4gdGhlIEJ1c2h3aWNrIGFuZCBzdXJyb3VuZGluZyBhcmVhLCB3b3JrIHRvZ2V0aGVyIHRvIHByb2R1Y2Ugb3VyIGFubnVhbCBmZXN0aXZhbHMgYW5kIHllYXItcm91bmQgcHJvZ3JhbXMuPC9wPgo8aDI+T3VyIE1pc3Npb248L2gyPgo8cD5BcnRzIGluIEJ1c2h3aWNrIHByb3ZpZGVzIGNyaXRpY2FsIHJlc291cmNlcyB0byBhcnRpc3RzIGFuZCByZXNpZGVudHMgYnkgb2ZmZXJpbmcgYW4gYWNjZXNzaWJsZSBwbGF0Zm9ybSB0byBvcmdhbml6ZSBhcnRzLXJlbGF0ZWQgZXZlbnRzLCBmZXN0aXZhbHMsIGFuZCBlZHVjYXRpb25hbCBhbmQgcHJvZmVzc2lvbmFsIGRldmVsb3BtZW50IG9wcG9ydHVuaXRpZXMuIFRoZSBnb2FsIGlzIHRvIGZvc3RlciBwb3NpdGl2ZSBhbmQgY29vcGVyYXRpdmUgbmVpZ2hib3Job29kIGdyb3d0aCB0aHJvdWdoIHVuaXF1ZSBhcnRzIHByb2dyYW1taW5nIHRoYXQgaW50ZWdyYXRlcyBCdXNod2ljayByZXNpZGVudHMgd2l0aCB0aGUgbG9jYWwgcG9wdWxhdGlvbiBvZiBhcnRpc3RzIGFuZCBjcmVhdGl2ZSBpbmRpdmlkdWFscy48L3A+CjxoMj5PdXIgSGlzdG9yeTwvaDI+CjxwPkFydHMgSW4gQnVzaHdpY2sgd2FzIGZvdW5kZWQgaW4gdGhlIGZhbGwgb2YgMjAwNywgYnkgYSBncm91cCBvZiByb3VnaGx5IGZpZnRlZW4gbG9jYWwgYXJ0aXN0cyBhbmQgY29tbXVuaXR5IG9yZ2FuaXplcnMsIGFzIHBhcnQgb2YgYSBncmFzc3Jvb3RzIGVmZm9ydCB0byBwcm9kdWNlIHRoZSAyMDA3IEJ1c2h3aWNrIE9wZW4gU3R1ZGlvcyBmZXN0aXZhbC4gV2hpbGUgb3VyIHByb2dyYW1taW5nIGFuZCB0ZWFtIG9mIHZvbHVudGVlciBvcmdhbml6ZXJzIGhhcyBncm93biBjb25zaWRlcmFibHksIHRoZSBoZWFydCBvZiBBcnRzIGluIEJ1c2h3aWNrIHJlbWFpbnMgYW5jaG9yZWQgaW4gdGhlIGFubnVhbCBCdXNod2ljayBPcGVuIFN0dWRpb3MgRmVzdGl2YWwgdGhhdCB0YWtlcyBwbGFjZSBhbm51YWxseSBkdXJpbmcgdGhlIGZpcnN0IHdlZWtlbmQgb2YgSnVuZS48L3A+CjxoMj5PdXIgUHJvamVjdHM8L2gyPgo8cD5BcnRzIGluIEJ1c2h3aWNrIGhhcyB0d28gY29yZSBmdW5jdGlvbnMgJm1kYXNoOyBwcm9kdWNpbmcgbmVpZ2hib3Job29kIGFydHMgZmVzdGl2YWxzLCBhbmQgZmFjaWxpdGF0aW5nIGNvbW11bml0eSBwcm9qZWN0cyBvbiBhbiBvbmdvaW5nIGJhc2lzLiBUaGlzIHllYXIsIHdlIGFyZSB0aHJpbGxlZCB0byBob3N0IGVpZ2h0IG9mZmljaWFsIEFpQi1zcG9uc29yZWQgZXZlbnRzIGR1cmluZyBCT1MgJzEzLCBhbmQgaGF2ZSBleHBhbmRlZCB0aGUgc2NvcGUgb2YgdGhlIEZlc3RpdmFsIHRvIGZlYXR1cmUgYSBmaWxtIGNvbXBvbmVudCwgYSBtdXJhbCBsYXVuY2gsIGFuIGludGVncmF0aXZlIENvbW11bml0eSBEYXkgaW4gTWFyaWEgSGVybmFuZGV6IFBhcms7IGFuZCBhIHBvZGNhc3QsIFR1bWJsciBibG9nLCBhbmQgc29jaWFsIG1lZGlhIGFjY291bnRzIHRvIGNhcHR1cmUgdGhlIHdlZWtlbmQncyBnb2luZ3Mtb24uPC9wPgo8L2JvZHk+CjwvaHRtbD4KCg=="];
		destinationViewController.request = [NSURLRequest requestWithURL:message];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	view.opaque = NO;
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1;
}

@end
