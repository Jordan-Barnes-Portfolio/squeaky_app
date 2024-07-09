import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:intl/intl.dart';
import 'package:neatfreak/components/customer_appointment_card.dart';
import 'package:neatfreak/components/my_appbar.dart';
import 'package:neatfreak/components/my_cleaner_card.dart';
import 'package:neatfreak/components/my_gnav_bar.dart';
import 'package:neatfreak/objects/appointment.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/services/appointment_service.dart';

class CustomerMainPage extends StatefulWidget {
  final AppUser user;

  const CustomerMainPage({Key? key, required this.user}) : super(key: key);

  @override
  _CustomerMainPage createState() => _CustomerMainPage();
}

class _CustomerMainPage extends State<CustomerMainPage> {
  int currentPageIndex = 0;
  int availCleaners = 0;
  bool flipped = false;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late Future<void> _dataLoadingFuture;
  final Map<String, num> _distanceCache = {};

  // Pagination variables
  final int _pageSize = 5;
  List<QueryDocumentSnapshot> _cleaners = [];
  List<QueryDocumentSnapshot> _appointments = [];
  bool _isLoadingMoreCleaners = false;
  bool _isLoadingMoreAppointments = false;
  bool _hasMoreCleaners = true;
  bool _hasMoreAppointments = true;
  DocumentSnapshot? _lastCleanerDocument;
  DocumentSnapshot? _lastAppointmentDocument;

  late ScrollController _cleanerScrollController;
  late ScrollController _appointmentScrollController;

  @override
  void initState() {
    super.initState();
    _dataLoadingFuture = _loadInitialData();
    _cleanerScrollController = ScrollController()
      ..addListener(_scrollListenerCleaners);
    _appointmentScrollController = ScrollController()
      ..addListener(_scrollListenerAppointments);
  }

  @override
  void dispose() {
    _cleanerScrollController.removeListener(_scrollListenerCleaners);
    _appointmentScrollController.removeListener(_scrollListenerAppointments);
    _cleanerScrollController.dispose();
    _appointmentScrollController.dispose();
    super.dispose();
  }

  void _scrollListenerCleaners() {
    if (_cleanerScrollController.offset >=
            _cleanerScrollController.position.maxScrollExtent &&
        !_cleanerScrollController.position.outOfRange) {
      _loadMoreCleaners();
    }
  }

  void _scrollListenerAppointments() {
    if (_appointmentScrollController.offset >=
            _appointmentScrollController.position.maxScrollExtent &&
        !_appointmentScrollController.position.outOfRange) {
      _loadMoreAppointments();
    }
  }

  Future<void> _loadInitialData() async {
    await _loadInitialCleaners();
    await _loadInitialAppointments();
  }

  Future<void> _loadInitialCleaners() async {
    print('Starting to load initial cleaners');
    final query = _fireStore
        .collection('users')
        .where('isCleaner', isEqualTo: true)
        .orderBy('rating')
        .limit(_pageSize);

    print('Query: ${query.parameters}');

    try {
      final snapshot = await query.get();
      print('Query executed. Number of documents: ${snapshot.docs.length}');

      setState(() {
        _cleaners = snapshot.docs;
        if (_cleaners.isNotEmpty) {
          _lastCleanerDocument = _cleaners.last;
        }
        _hasMoreCleaners = _cleaners.length == _pageSize;
      });

      print('Loaded ${_cleaners.length} cleaners initially');
      _cleaners.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Cleaner: ${data['firstName']}, isCleaner: ${data['isCleaner']}');
      });
    } catch (e) {
      print('Error loading cleaners: $e');
    }
  }

  Future<void> _loadMoreCleaners() async {
    if (!_hasMoreCleaners || _isLoadingMoreCleaners) return;

    setState(() {
      _isLoadingMoreCleaners = true;
    });

    final query = _fireStore
        .collection('users')
        .where('isCleaner', isEqualTo: true)
        .orderBy('rating')
        .startAfterDocument(_lastCleanerDocument!)
        .limit(_pageSize);

    final snapshot = await query.get();
    setState(() {
      _cleaners.addAll(snapshot.docs);
      _isLoadingMoreCleaners = false;
      if (snapshot.docs.isNotEmpty) {
        _lastCleanerDocument = snapshot.docs.last;
      }
      _hasMoreCleaners = snapshot.docs.length == _pageSize;
    });
  }

  Future<void> _loadInitialAppointments() async {
    final query = AppointmentService()
        .getInitialPendingAppointments(widget.user.email, _pageSize);

    final snapshot = await query.get();
    setState(() {
      _appointments = snapshot.docs;
      if (_appointments.isNotEmpty) {
        _lastAppointmentDocument = _appointments.last;
      }
      _hasMoreAppointments = _appointments.length == _pageSize;
    });
  }

  Future<void> _loadMoreAppointments() async {
    if (!_hasMoreAppointments || _isLoadingMoreAppointments) return;

    setState(() {
      _isLoadingMoreAppointments = true;
    });

    final query = AppointmentService().getMorePendingAppointments(
        widget.user.email, _lastAppointmentDocument!, _pageSize);

    final snapshot = await query.get();
    setState(() {
      _appointments.addAll(snapshot.docs);
      _isLoadingMoreAppointments = false;
      if (snapshot.docs.isNotEmpty) {
        _lastAppointmentDocument = snapshot.docs.last;
      }
      _hasMoreAppointments = snapshot.docs.length == _pageSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataLoadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        return Scaffold(
          appBar: MyAppBar(user: widget.user),
          backgroundColor: Colors.grey[200],
          bottomNavigationBar: MyGnavBar(
            currentPageIndex: currentPageIndex,
            user: widget.user,
          ),
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  Expanded(child: _buildTabBarView()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return const TabBar(
      dividerColor: Colors.black,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(text: 'Cleaners in your area'),
        Tab(text: 'Upcoming Appointments'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: [
        _buildCleanerList(),
        _buildCurrentAppointmentList(),
      ],
    );
  }

  Widget _buildCleanerList() {
    if (_cleaners.isEmpty) {
      return const Center(child: Text('No cleaners available.'));
    }

    return ListView.builder(
      controller: _cleanerScrollController,
      itemCount: _cleaners.length + 1,
      itemBuilder: (context, index) {
        if (index == _cleaners.length) {
          return _buildLoaderIndicator(_isLoadingMoreCleaners);
        }
        final data = _cleaners[index].data() as Map<String, dynamic>;
        final cleanerLocation = data['location'] as GeoPoint;
        final distance =
            _getCachedDistance(cleanerLocation, widget.user.location);

        // Debug logging
        print(
            'Cleaner: ${data['firstName']}, Distance: $distance, Max Distance: ${data['maxDistance']}');

        // Remove the distance check for now
        return CleanerCard(
          cleaner: AppUser.fromMap(data),
          user: widget.user,
        );
      },
    );
  }

  Widget _buildCurrentAppointmentList() {
    return ListView.builder(
      controller: _appointmentScrollController,
      itemCount: _appointments.length + 1,
      itemBuilder: (context, index) {
        if (index == _appointments.length) {
          return _buildLoaderIndicator(_isLoadingMoreAppointments);
        }
        final data = _appointments[index].data() as Map<String, dynamic>;
        return _buildAppointmentCard(data);
      },
    );
  }

  Widget _buildLoaderIndicator(bool isLoading) {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : const SizedBox.shrink();
  }

  Widget _buildAppointmentCard(Map<String, dynamic> data) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
    final date = (data['sortByDate'] as Timestamp).toDate();
    final today = DateFormat('EEEE').format(now);

    if (data['formattedDate'].toString().contains(today)) {
      final formattedDate = data['formattedDate'].toString().split('at')[1];
      data['formattedDate'] = 'Today at$formattedDate';
    }

    return CustomerAppointmentCard(
      appointment: Appointment.fromMap(data),
      user: widget.user,
      pastDue: date.isBefore(yesterday),
    );
  }

  num _getCachedDistance(GeoPoint location1, GeoPoint location2) {
    final key =
        '${location1.latitude},${location1.longitude}-${location2.latitude},${location2.longitude}';
    if (!_distanceCache.containsKey(key)) {
      _distanceCache[key] = FlutterMapMath().distanceBetween(
        location1.latitude,
        location1.longitude,
        location2.latitude,
        location2.longitude,
        "miles",
      );
    }
    return _distanceCache[key]!;
  }
}
