// ignore_for_file: unnecessary_getters_setters
class AppUser {
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _phoneNumber;
  String _address;
  String _bio;
  String _pricing;
  String _ratings;
  String _rating;
  String _amountOfBedrooms;
  String _amountOfBathrooms;
  String _sqftOfHome;
  String _houseType;
  String _floorType;
  String _storiesCount;
  bool _startupPage;
  bool _isAdmin;
  bool _isCleaner;
  bool _isCustomer;
  bool _firstTime;


  AppUser({
    //Required parameters
    required String email,
    required String password,
    String firstName = "none",
    String lastName = "none",
    String phoneNumber = "none",
    String address = "none",

    //Default and optional parameters
    String bio = "none",
    String pricing = "none",
    String ratings = "0",
    String rating = "0.0",
    String amountOfBedrooms = "0",
    String amountOfBathrooms = "0",
    String sqftOfHome = "0",
    String houseType = "none",
    String storiesCount = "0",
    String floorType = "none",

    //If False user goes to customer page, if True user goes to cleaner page
    bool startupPage = false,
    bool isAdmin = false,
    bool isCleaner = false,
    bool isCustomer = false,
    bool firstTime = true,

    //Constructor
  })  : _email = email,
        _password = password,
        _firstName = firstName,
        _lastName = lastName,
        _phoneNumber = phoneNumber,
        _address = address,
        _isAdmin = isAdmin,
        _isCleaner = isCleaner,
        _bio = bio,
        _startupPage = startupPage,
        _firstTime = firstTime,
        _isCustomer = isCustomer,
        _rating = rating,
        _ratings = ratings,
        _pricing = pricing,
        _amountOfBedrooms = amountOfBedrooms,
        _amountOfBathrooms = amountOfBathrooms,
        _sqftOfHome = sqftOfHome,
        _floorType = floorType,
        _storiesCount = storiesCount,
        _houseType = houseType;

  //Getters and setters

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

  bool get firstTime => _firstTime;
  set firstTime(bool value) => _firstTime = value;

  String get rating => _rating;
  set rating(String value) => _rating = value;

  String get ratings => _ratings;
  set ratings(String value) => _ratings = value;

  bool get startupPage => _startupPage;
  set startupPage(bool value) => _startupPage = value;

  String get pricing => _pricing;
  set pricing(String value) => _pricing = value;

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

  bool get isAdmin => _isAdmin;
  set isAdmin(bool value) => _isAdmin = value;

  bool get isCleaner => _isCleaner;
  set isCleaner(bool value) => _isCleaner = value;

  bool get isCustomer => _isCustomer;
  set isCustomer(bool value) => _isCustomer = value;

  String get bio => _bio;
  set bio(String value) => _bio = value;

  @override
  String toString() {
    return 'AppUser(email: $_email, password: $_password, firstName: $_firstName, lastName: $_lastName, phoneNumber: $_phoneNumber, address: $_address, isAdmin: $_isAdmin, isCleaner: $_isCleaner, isCustomer: $_isCustomer, bio: $_bio, pricing: $_pricing, amountOfBedrooms: $_amountOfBedrooms, amountOfBathrooms: $_amountOfBathrooms, sqftOfHome: $_sqftOfHome, startupPage: $_startupPage, firstTime: $_firstTime, rating: $_rating, ratings: $_ratings, houseType: $_houseType)';
  }

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
      'startupPage': _startupPage,
      'isAdmin': _isAdmin,
      'isCleaner': _isCleaner,
      'isCustomer': _isCustomer,
      'firstTime': _firstTime,
      'rating': _rating,
      'ratings': _ratings,
      'amountOfBedrooms': _amountOfBedrooms,
      'amountOfBathrooms': _amountOfBathrooms,
      'sqftOfHome': _sqftOfHome,
      'houseType': _houseType,
      'storiesCount': _storiesCount,
      'floorType': _floorType,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      address: map['address'] as String,
      bio: map['bio'] as String,
      pricing: map['pricing'] as String,
      storiesCount: map['storiesCount'] as String,
      floorType: map['floorType'] as String,
      amountOfBathrooms: map['amountOfBathrooms'] as String,
      amountOfBedrooms: map['amountOfBedrooms'] as String,
      sqftOfHome: map['sqftOfHome'] as String,
      houseType: map['houseType'] as String,
      startupPage: map['startupPage'] as bool,
      isAdmin: map['isAdmin'] as bool,
      isCleaner: map['isCleaner'] as bool,
      isCustomer: map['isCustomer'] as bool,
      firstTime: map['firstTime'] as bool,
      rating: map['rating'] as String,
      ratings: map['ratings'] as String,
    );
  }
}
