/// This class represents one of the Trip class' attributes.
/// We use them on Nominatim API
class Coordinate {
  ///This is the latitude of the place
  double latitude;
  ///This is the longitude of the place
  double longitude;

  ///That's the constructor
  Coordinate({required this.latitude, required this.longitude});
}
