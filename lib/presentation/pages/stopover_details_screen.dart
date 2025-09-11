import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../entities/participant.dart';
import '../../entities/review.dart';
import '../../entities/stopover.dart';
import '../../file_repository/review_repository.dart';
import '../../file_repository/trip_repository.dart';
import 'widgets/add_review_bottom_sheet.dart';
import 'widgets/all_widgets.dart';
import 'widgets/custom_action_button.dart';
import 'widgets/custom_add_button.dart';
import 'widgets/review_item.dart';

class StopoverDetailsScreen extends StatefulWidget {
  final Stopover stopover;
  final int tripId;

  const StopoverDetailsScreen({
    super.key,
    required this.stopover,
    required this.tripId,
  });

  @override
  State<StopoverDetailsScreen> createState() => _StopoverDetailsScreenState();
}

class _StopoverDetailsScreenState extends State<StopoverDetailsScreen> {
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

class ReviewsProvider with ChangeNotifier {
  final TripRepositorySQLite tripRepo = TripRepositorySQLite();
  final int stopoverId;
  List<Review> _reviews = [];
  bool _isLoading = false;

  Map<int, Participant> _participants = {};

  List<Review> get reviews => _reviews;

  bool get isLoading => _isLoading;

  ReviewsProvider({required this.stopoverId}) {}

  Future<void> loadReviews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = await tripRepo.listReviewFromStopover(stopoverId);
    } catch (e) {
      print('Falha ao carregar reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await tripRepo.createReview(review);
      _reviews.add(review);
    } catch (e) {
      print('Falha ao adicionar um Review: $e');
    }
    loadReviews();
  }

  Future<void> removeReview(int reviewId) async {
    try {
      await tripRepo.deleteReview(reviewId);
      _reviews.removeWhere((review) {
        return review.reviewID != null && review.reviewID == reviewId;
      });
    } catch (e) {
      print('Falhou ao remover Review: $e');
    }
    loadReviews();
  }
}
