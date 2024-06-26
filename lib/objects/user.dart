// ignore_for_file: unnecessary_getters_setters
import 'package:squeaky_app/objects/review.dart';

class AppUser {
  //Every account has these parameters
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _phoneNumber;
  String _address;
  String _uuid;

  //These are dependent
  String _bio;
  num _ratings;
  num _rating;
  String _amountOfBedrooms;
  String _amountOfBathrooms;
  String _sqftOfHome;
  String _houseType;
  String _floorType;
  String _storiesCount;
  String _profilePhoto;
  String _skills;
  String _heroPhoto;
  num _pricing;
  bool _hasNotification;
  List<Review> _reviews = [];

  //These are for account type
  bool _isCleaner;
  bool _isCustomer;

  AppUser({
    //Required parameters
    required String email,
    required String password,
    String firstName = "none",
    String lastName = "none",
    String phoneNumber = "none",
    String address = "none",
    String uuid = "",

    //Default and optional parameters
    String bio = "none",
    num pricing = 0,
    num ratings = 0,
    num rating = 0,
    String amountOfBedrooms = "0",
    String amountOfBathrooms = "0",
    String sqftOfHome = "0",
    String houseType = "none",
    String storiesCount = "0",
    String floorType = "none",
    String profilePhoto = "none",
    String heroPhoto = "none",
    String skills = "none",
    bool isAdmin = false,
    bool isCleaner = false,
    bool isCustomer = false,
    bool hasNotification = false,
    List<Review> reviews = const [],

    //Constructor
  })  : _email = email,
        _password = password,
        _firstName = firstName,
        _lastName = lastName,
        _phoneNumber = phoneNumber,
        _address = address,
        _isCleaner = isCleaner,
        _bio = bio,
        _isCustomer = isCustomer,
        _rating = rating,
        _ratings = ratings,
        _pricing = pricing,
        _amountOfBedrooms = amountOfBedrooms,
        _amountOfBathrooms = amountOfBathrooms,
        _sqftOfHome = sqftOfHome,
        _floorType = floorType,
        _storiesCount = storiesCount,
        _profilePhoto = profilePhoto,
        _skills = skills,
        _heroPhoto = heroPhoto,
        _uuid = uuid,
        _hasNotification = hasNotification,
        _reviews = reviews,
        _houseType = houseType;

  //Getters and setters
  List<Review> get reviews => _reviews;
  set reviews(List<Review> value) => _reviews = value;

  bool get hasNotification => _hasNotification;
  set hasNotification(bool value) => _hasNotification = value;

  String get uuid => _uuid;
  set uuid(String value) => _uuid = value;

  String get skills => _skills;
  set skills(String value) => _skills = value;

  String get heroPhoto => _heroPhoto;
  set heroPhoto(String value) => _heroPhoto = value;

  String get profilePhoto => _profilePhoto;
  set profilePhoto(String value) => _profilePhoto = value;

  String get storiesCount => _storiesCount;
  set storiesCount(String value) => _storiesCount = value;

  String get floorType => _floorType;
  set floorType(String value) => _floorType = value;

  String get houseType => _houseType;
  set houseType(String value) => _houseType = value;

  String get amountOfBedrooms => _amountOfBedrooms;
  set amountOfBedrooms(String value) => _amountOfBedrooms = value;

  String get amountOfBathrooms => _amountOfBathrooms;
  set amountOfBathrooms(String value) => _amountOfBathrooms = value;

  String get sqftOfHome => _sqftOfHome;
  set sqftOfHome(String value) => _sqftOfHome = value;

  num get rating => _rating;
  set rating(num value) => _rating = value;

  num get ratings => _ratings;
  set ratings(num value) => _ratings = value;

  num get pricing => _pricing;
  set pricing(num value) => _pricing = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  String get firstName => _firstName;
  set firstName(String value) => _firstName = value;

  String get lastName => _lastName;
  set lastName(String value) => _lastName = value;

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) => _phoneNumber = value;

  String get address => _address;
  set address(String value) => _address = value;

  bool get isCleaner => _isCleaner;
  set isCleaner(bool value) => _isCleaner = value;

  bool get isCustomer => _isCustomer;
  set isCustomer(bool value) => _isCustomer = value;

  String get bio => _bio;
  set bio(String value) => _bio = value;

  Map<String, dynamic> toMap() {
    return {
      'email': _email,
      'password': _password,
      'firstName': _firstName,
      'lastName': _lastName,
      'phoneNumber': _phoneNumber,
      'address': _address,
      'bio': _bio,
      'pricing': _pricing,
      'isCleaner': _isCleaner,
      'isCustomer': _isCustomer,
      'rating': _rating,
      'ratings': _ratings,
      'amountOfBedrooms': _amountOfBedrooms,
      'amountOfBathrooms': _amountOfBathrooms,
      'sqftOfHome': _sqftOfHome,
      'houseType': _houseType,
      'storiesCount': _storiesCount,
      'floorType': _floorType,
      'profilePhoto': _profilePhoto,
      'skills': _skills,
      'uuid': _uuid,
      'reviews': _reviews.map((e) => e.toMap()).toList(),
      'hasNotification': _hasNotification,
      'heroPhoto': _heroPhoto,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    try {
      return AppUser(
        email: map['email'] as String,
        password: map['password'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        phoneNumber: map['phoneNumber'] as String,
        address: map['address'] as String,
        bio: map['bio'] as String,
        pricing: map['pricing'] as num,
        storiesCount: map['storiesCount'] as String,
        floorType: map['floorType'] as String,
        amountOfBathrooms: map['amountOfBathrooms'] as String,
        amountOfBedrooms: map['amountOfBedrooms'] as String,
        sqftOfHome: map['sqftOfHome'] as String,
        houseType: map['houseType'] as String,
        isCleaner: map['isCleaner'] as bool,
        isCustomer: map['isCustomer'] as bool,
        hasNotification: map['hasNotification'] as bool,
        rating: map['rating'] as num,
        ratings: map['ratings'] as num,
        profilePhoto: map['profilePhoto'] as String,
        skills: map['skills'] as String,
        reviews: List<Review>.from(
            map['reviews']?.map((x) => Review.fromMap(x)) ?? const []),
        heroPhoto: map['heroPhoto'] as String,
        uuid: map['uuid'] as String,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
