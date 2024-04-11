#  OMDBMovies

This is a simple project that uses the OMDB API to search for movies and display the results. <br>

<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/b5d0a679-dcee-4b5a-aa61-9eea1e4750f8" width="200">


<hr>

A couple things of note:<br>
- The UI is built in UIKit programatically. And the app is following a basic MVVM architecture and uses Combine for binding data/state. 
- No external dependencies are used.
- The app supports horizontal and vertical layouts, varying screen sizes (iPhone/iPad), light/dark mode and scaling font sizes. 
- A number of unit tests are found in the OMDBMoviesTests folder. And a simple UI test is added as an example.

A couple areas for improvement:
- Image caching/management could be improved from an UIImageView extension to either be it's own service/manager or possibly a third party image library could be used.
- Strings could be localized and abstracted into their own file.
- The OMDB API key could be stored in a more secure way. Possible approaches are through a configuration file (ie. .plist or at build), a secure keychain wrapper or ideally through an authenticated backend service. 
- Storing URLs/domains and other important strings in a Constants file or in build settings/.plist. 

<hr>

Screenshots:<br>

<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/2a8ae0dc-7bad-42af-9606-97697fd2a596" width="200">
<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/d1db6691-2813-4bd5-b24a-10ab231bf697" width="200">
<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/cd4d0a6e-f8ec-43a1-a3c6-887045569b90" width="200">
<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/47236fb3-cf4b-47c7-af30-a9c5a8732e70" width="200">
<br>

Large Font:<br>
<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/4942bdaf-ae44-47e5-8cf8-d65d955fd458" width="200">
<br>
iPad: <br>
<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/625b1c7e-d55f-40ab-9392-2768297d26bf" width="400">
<img src="https://github.com/dayvauld/OMDBMovies/assets/18684910/01941bf9-39bf-4cb6-a5f5-8715b46f468c" width="800">
