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

The configuration we created previously will be utilized within our NSURLSession.  The delegate is set to self so we if we wanted we could utilize certain delegate methods to track job statuses.  The delegateQueue parameter allows us to utilize NSOperationQueues to support our data download activities, we don't need it for this simple example though.

#NSURLSessionDataTask

In order to use our newly created NSURLSession to download the required data we must instantiate an NSURLSessionDataTask.  By instantiating this object we will be able to tell the session to being download data from the specified api.  THere are three very important parts to this.  The first part is setting up the NSURLSession object to begin the download:

`NSSting *myApiUrlString = @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"`

`NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:myApiUrlString`
`completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {`

We have to create an NSURLSessionDataTask since we are downloading JSON data from our api.  The part after the equals sign tells our NSURLSession where we want it to download data from (NSURL portion) and what we want it to do when it compeletes (completion block).  Inside the completion block we will be able to manipulate the json data that is returned.

Inside our completion handler's parameters we can see three objects NSData, NSURLResponse and NSError.  These all tell us important information about our operation.  The NSData will return the information we want to download.  So in the case of this example the fundraising data.  The NSURLResponse will tell us the status of our operation if its 200 that means we have succeeded.  The NSError as you may have guessed will tell us what happened if the operation fails for some reason.  Inside the completion block we want to parse our data and handle any errors.  We want to nest this code inside an `if(!error){` so only move forward with the parse operation if the data was returned correctly.  Then we want another check to see if the NSURLResponse is 200, to make sure our service properly interfaced with our application:

`NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;`<br>
`if(urlResponse.statusCode == 200){`

Inside this block we want to take our NSData object and start to pull it apart and record any relevant data we may want to store.  We can do this by utilizing the NSJSONSerialization class to parse the NSData into an NSDictionary, from there we can acess different pieces of data through key value notation.  Parsing the NSData if the urlResponse status code is 200:

`NSError *jsonError;`<br>
`NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];`

This will convert our NSData in the completion block parameters (data) to an NSDictionary.  The NSJSONSerialization class handles all the work by taking our properly formed JSON and automatically converting it.  There are some parameters we need to set in the JSONObjectWithData method.  First of all we need to specify the NSData that we will be parsing, in this case it is the NSData (data) provided in the completion block parameters.  The options which will specify any special handling we may need.  NSJSONReadingALlowFragments will allow top level JSON objects that are not arrays.  The error which will just take our generic NSError *jsonError and make it the NSError object returned if something goes wrong in our JSON parse operation.

Next we need to setup an array to hold the elements we wish to extract from our responseObject:

`NSMutableArray *fundraisingObjectsCollected = [[NSMutableArray alloc] init];`

If there is not jsonError `if(!jsonError){` then we should begin to open up our responseObject dictionary and take out what we need.  The first thing we need to do is target the key value that holds the "loans" array so we can get access to this information:

`NSArray *loansArrayContents = responseObject[@"loans"];`

This just tells sets the NSArray loansArrayContents to the value of the object at with key @"loans".  Next we want to extract the required information.  Inside the array is a dictionary for each loan record.  These dictionaries can essentially be thought of as "FundraisingObjects".  Since each one is contains specific info about the person being lended the funds (amount, what it is for, location, etc...).  In the "Models" section of the project I created a PWFundraisingObject to hold some of the important data within these dictionaries.  Now we can extract these dictionaries and use them to create PWFundraisingObjects:

`for(NSDictionary *dictionary in loansArrayContents){`

So for each dictionary object inside the loansArrayContents array we wish to do something:

`PWFundraisingObject *fundraisingObject = [[PWFundraisingObject alloc] initWithFundraiserName: dictionary[@"name"] fundraisingStatus:dictionary[@"status"] fundedAmount:dictionary[@"funded_amount"] numberOfLenders:dictionary[@"lender_count"]];`

Inside the for loop we are taking each dictionary and using it to intialize our custom PWFundraisingObject.  This gives the raw data a proper model.  We can use these objects to present data to the user and keep track of each record in a more organized fashion.  For each object we create we add it to the fundraisingObjectsCollected array:

`[fundraisingObjectsCollected addObject:fundraisingObject];`

So once the for loop is complete we should have an array full of PWFundraisingObjects.  In the example project I used this array to populate a non-mutable array that is used to populate the UITableView (this array is a property):

`self.fundraisingList = fundraisingObjectsCollected;`

#UI Updates

After that we can use dispatch_asych to perform some asychronous UI Updates:

`dispatch_async(dispatch_get_main_queue(), ^{`

Here we can do a few things, one of the most important is setting the networkActivityIndicator to hidden:

`[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;`

Finally we can stop any UIActivityIndicators or UIRefreshControls that may be working (depends on implementation, feel free to reference mine) and reload the UITableView data.  Now one thing to note.  Is that outside of our completion block and at the end of the fecthFundraisingData function we want to add:

`[dataTask resume];`

This is what kicks off the dataTask.  It seems kind of confusing, but this is actually called right after we instantiate the data task.  The lengthy stuff inside the completion block is only called when all of this finishes.

#Closing Comments

The example presented in this project should give a basic understanding of how to use NSURLSession and NSURLSessionDataTask to download information from an api and process it.  The rest of the project (not covered in this write up) serves as an example of how to use the data that we processed and collected inside our completion block.

Thanks for reading!
