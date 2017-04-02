# flicks

This is an iOS demo application for displaying the latest box office movies using the [themoviedb API](https://developers.themoviedb.org/3/getting-started).

Time spent: 14 hours spent in total

Completed user stories:

 * [x] Required: User can view a list of movies currently playing in theaters from The Movie Database. Poster are loaded asynchronously.
 * [x] Required: User can view movie details by tapping on a cell.
 * [x] Required: User sees loading state while waiting for movies API.
 * [x] Required: User sees an error message when there's a networking error.
 * [x] Required: User can pull to refresh the movie list.
 * [x] Optional: Add a tab bar for Now Playing or Top Rated movies.
 * [x] Optional: Implement a UISegmentedControl to switch between a list view and a grid view.
 * [x] Optional: Add a search bar.
 * [x] Optional: All images fade in as they are loading.
 * [x] Optional: For the large poster, load the low-res image first and switch to high-res when complete.
 * [x] Optional: Customize the highlight and selection effect of the cell. (Done in personal options with different approach)
 * [x] Optional: Customize the navigation bar.(embedded search bar and changed tint color)
  
Personal:
 * [x] Optional: Custom ticket style cell, with tare to show which movies have been selected.
 * [x] Optional: Clear ticket tare by swiping left on cell.
 * [x] Optional: Embedded serch bar in Navigation Controller.

How to use:

Click on a ticket to see the poster and description. When coming back there will be a tear on the ticker to show you have looked at it. Swipe left on the cell to remove the tear. Search for a movie in the top. Switch from cells to grids on the bottom, and switch between now playing and top rated movies on the bottom tabs.
 
Notes/Problems:

Had a lot of layout issues. Enjoyed adding my movie ticket tear feature/ cookie trail.

Walkthrough of all user stories:

[![flicks.gif](https://s26.postimg.org/5zri28ho9/flicks.gif)](https://postimg.org/image/5a8ppvh4l/)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

Credits: 

Icons provided by https://icons8.com

Movies from TheMovieDB

Frameworks used include
  1. AFNetworking
  2. KRProgressHUD


