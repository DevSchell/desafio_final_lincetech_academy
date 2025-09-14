import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../entities/review.dart';
import '../../entities/stopover.dart';
import '../../file_repository/trip_repository.dart';
import 'widgets/all_widgets.dart';

/// A screen that displays the details of a single stopover.
///
/// This screen shows the stopover's date range,
/// planned activities, map location, and a list of reviews.
/// It also provides functionality to add and delete reviews.

class StopoverDetailsScreen extends StatefulWidget {
  /// The stopover object whose details are to be displayed.
  final Stopover stopover;

  /// The ID of the trip to which this stopover belongs
  final int tripId;

  /// The constructor method
  const StopoverDetailsScreen({
    super.key,
    required this.stopover,
    required this.tripId,
  });

  @override
  State<StopoverDetailsScreen> createState() => _StopoverDetailsScreenState();
}

class _StopoverDetailsScreenState extends State<StopoverDetailsScreen> {
  /// The provider responsible for managing and
  /// fetching reviews for the stopover.
  late final ReviewsProvider _reviewsProvider;

  @override
  void initState() {
    super.initState();
    _reviewsProvider = ReviewsProvider(stopoverId: widget.stopover.id!);
    _reviewsProvider.loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    final stopoverLocation = LatLng(
      widget.stopover.latitude,
      widget.stopover.longitude,
    );

    final markers = <Marker>{
      Marker(
        markerId: MarkerId(widget.stopover.cityName),
        position: stopoverLocation,
        infoWindow: InfoWindow(
          title: widget.stopover.cityName,
          snippet: 'Your trip stopover',
        ),
      ),
    };

    return Scaffold(
      appBar: CustomAppbar(title: widget.stopover.cityName),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NewCustomDatePicker(
                isEditable: false,
                initialStartDate: widget.stopover.arrivalDate,
                initialEndDate: widget.stopover.departureDate,
              ),
              SizedBox(height: 8),

              SizedBox(height: 16),
              CustomHeader(text: 'Activities'),
              Text(widget.stopover.actvDescription ?? 'No activities planned'),
              SizedBox(height: 16),

              CustomHeader(text: 'Map Location'),
              SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: stopoverLocation,
                    zoom: 14,
                  ),
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  markers: markers,
                  onMapCreated: (mapController) {},
                ),
              ),
              SizedBox(height: 16),
              CustomHeader(text: 'Reviews'),

              ChangeNotifierProvider.value(
                value: _reviewsProvider,
                child: Consumer<ReviewsProvider>(
                  builder: (_, reviewState, _) {
                    if (reviewState.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(255, 165, 0, 1),
                        ),
                      );
                    } else if (reviewState.reviews.isEmpty) {
                      return Center(child: Text('No reviews yet'));
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reviewState.reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviewState.reviews[index];
                          return ReviewItem(
                            review: review,
                            onDelete: () async {
                              final isConfirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'You are about to delete this review',
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this review?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop((false));
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (isConfirmed == true) {
                                await reviewState.removeReview(
                                  review.reviewID!,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Review deleted successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              CustomAddButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return ChangeNotifierProvider.value(
                        value: _reviewsProvider,
                        child: AddReviewBottomSheet(
                          tripId: widget.tripId,
                          stopoverId: widget.stopover.id!,
                        ),
                      );
                    },
                  );
                },
                heroTag: 'showReviewBottomSheet',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A provider that manages the state of reviews for a specific stopover.
///
/// This class uses [ChangeNotifier] to notify its listeners about changes
/// in the review list, loading state, or participant data. It handles fetching,
/// adding, and removing reviews by interacting with a [TripRepositorySQLite].
class ReviewsProvider with ChangeNotifier {
  /// It represents the [TripRepositorySQLite] and makes it possible to use
  /// it's methods here
  final TripRepositorySQLite tripRepo = TripRepositorySQLite();

  /// The unique identifier of the stopover in [stopoverDetails]
  final int stopoverId;
  List<Review> _reviews = [];
  bool _isLoading = false;

  /// The list of reviews for the current stopover.
  List<Review> get reviews => _reviews;

  /// A boolean indicating whether data is currently being loaded.
  bool get isLoading => _isLoading;

  ///The constructor method
  ReviewsProvider({required this.stopoverId});

  /// Loads all reviews associated with the stopover from the database.
  ///
  /// This method sets the loading state to `true`, fetches the reviews,
  /// and then sets the loading state back to `false` when finished.
  Future<void> loadReviews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = await tripRepo.listReviewFromStopover(stopoverId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new review to the database and the local list.
  ///
  /// The method interacts with the repository to create the new review.
  /// After a successful creation, it reloads the reviews to ensure
  /// the UI is up to date.
  Future<void> addReview(Review review) async {
    try {
      await tripRepo.createReview(review);
      _reviews.add(review);
    } catch (e) {
      rethrow;
    }
    await loadReviews();
  }

  /// Removes a review from the database and the local list by its ID.
  ///
  /// The method interacts with the repository to delete the review and
  /// then reloads the reviews to reflect the changes in the UI.
  Future<void> removeReview(int reviewId) async {
    try {
      await tripRepo.deleteReview(reviewId);
      _reviews.removeWhere((review) {
        return review.reviewID != null && review.reviewID == reviewId;
      });
    } catch (e) {
      rethrow;
    }
    await loadReviews();
  }
}
