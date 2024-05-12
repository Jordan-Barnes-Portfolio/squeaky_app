class Review {
  final String details;
  final String reviewerName;
  final num rating;

  Review({
    required this.details,
    required this.reviewerName,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'details': details,
      'reviewerName': reviewerName,
      'rating': rating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      details: map['details'],
      reviewerName: map['reviewerName'],
      rating: map['rating'],
    );
  }
}
