# PWNetworkingExample
Example of NSURLSession Utilizing public api http://api.kivaws.org/v1/loans/search.json?status=fundraising

#General
This project illustrates how to utilize NSURLSession to pull data from a free and publicly available api.  The resulting data is then populated into a basic UITableView.  A drill down is available if a table row is tapped.  It is always valuable to understand how to do operations without the help of a framework.

#NSURLSession
NSURLSession is an api we can use to support various types of data transfer tasks.  This example only illustrates a data task that is downloading a set of information.  The first thing we have to determine when setting up our NSURLSession is the configuration.  We can do this by creating an NSURLSessionConfiguration:

`NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];`

In this example I specified that the configuration only accept JSON format:

`[config setHTTPAdditionalHeaders:@{@"Accept":@"application/json}];`

I also specified the timeout interval for request, which determines how long without recieving any data before the job will time out:

`config.timeoutIntervalForRequest = 30.0f;`

After that we can being to fetch out data by instantiating out NSURLSession:

`NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];`

The configuration we created previously will be utilized within our NSURLSession.  The delegate is set to self so we if we wanted we could utilize certain delegate methods to track job statuses.

