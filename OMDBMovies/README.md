#  OMDBMovies

This is a simple project that uses the OMDB API to search for movies and display the results. 

A couple things of note:
• The UI is built in UIKit programatically. And the app is following a basic MVVM architecture and uses Combine for binding data/state. 
• No external dependencies are used.
• The app supports horizontal and vertical layouts, varying screen sizes (iPhone/iPad), light/dark mode and scaling font sizes. 
• A number of unit tests are found in the OMDBMoviesTests folder. And a simple UI test is added as an example.

A couple areas for improvement:
• Image caching/management could be improved from an UIImageView extension to either be it's own service/manager or possibly a third party image library could be used.
• Strings could be localized and abstracted into their own file.
• The OMDB API key could be stored in a more secure way. Possible approaches are through a configuration file (ie. .plist or at build), a secure keychain wrapper or ideally through an authenticated backend service. 
• Storing URLs/domains and other important strings in a Constants file or in build settings/.plist. 


Screenshots:
