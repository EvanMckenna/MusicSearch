## MusicSearch

![d40ff6a9ee13326dd9021f7b110986de](https://cloud.githubusercontent.com/assets/22193702/26218109/ae6046d4-3c01-11e7-8b69-cfdcad371dbf.png)

Music Search is a Swift application which uses the Spotify API which will allow the user to search and view an artists songs. This will then allow the user to view the album art and play a preview of the song.

### Frameworks

* AlamoFire
* AvFoundation

### API's

* Spotify API

### Controllers

## Home Controller

The home controller is a simple page which displays what the app is about. It also displays the logo and the colour palette present within the application. The logo was designed by myself and created using Adobe Illustrator.

## Search

The search screen consists of a table view and a search bar. This table view is modified to give it a minimalist look and feel. The line beneath the navigation bar is also removed through code. Different details include:

* Images and name are stored in an array and will put the correct image and name within the cells in order.
* To create the round image, I used code cornerRadius and maskToBounds. This had to be hardcoded as it woulld not work through the interface builder
* The white border follows the above principle but uses a white UIImage and apply the same code
* The list is locked at 20 tracks to speed up the call.
* Alamofire is used to make the responses as well as parse the JSON to make it readable. This framework sped up the API process as I have found it difficult in the previous assignment to get the depricated code working. This is what the Spotify API brings up when searched for the band Muse:

![0800010994102c97abd626f2c60ede36](https://cloud.githubusercontent.com/assets/22193702/26219394/b77d71ba-3c06-11e7-9789-5f466b2573bf.png)

* I am only storing the name, cover and preview as the other information is not necessarily needed.

## Player

The player is a seperate view controller altered to make it look like a popup instead of navigating away from the table view. This player has a minimalist look and feel to it also.

* Instead of an usual seque, a modal popover is used. By creating a view in the middle of the controller and then turning the opacity of the main view, this allows the embedded view to have a popup effect.

![modal](https://cloud.githubusercontent.com/assets/22193702/26218870/81001306-3c04-11e7-97bf-02834e37bb03.png)

* The data is passed through the search view controller to the player view controller.
* The player is controller by using AVFoundation. There is only one audio controller and it is controlled through this view. When the popup opens there is an if statement that if it is not playing, then play audio. It is very simple and effective code to get working.
  
