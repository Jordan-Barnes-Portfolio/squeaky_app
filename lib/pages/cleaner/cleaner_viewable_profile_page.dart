// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/customer/customer_booking_page.dart';

class CleanerDetailsPage extends StatefulWidget {
  AppUser cleaner;
  AppUser user;
  CleanerDetailsPage({super.key, required this.cleaner, required this.user});

  @override
  _CleanerDetailsPage createState() => _CleanerDetailsPage();
}

class _CleanerDetailsPage extends State<CleanerDetailsPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Book now",
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerBookingPage(
                        user: widget.user,
                        cleaner: widget.cleaner,
                      )));
        },
        icon:
            const Icon(CupertinoIcons.calendar_badge_plus, color: Colors.white),
        label: const Text("Book now"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            topBarForCleaner(),
            const SizedBox(height: 60),
            tabViews(),
          ],
        ),
      ),
    );
  }

  Widget tabViews() {
    TabController newTabControl = TabController(length: widget.cleaner.reviews.length, vsync: this);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            dividerColor: Color(Colors.black.value),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Info'),
              Tab(text: 'Reviews'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Text('About',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Text(widget.cleaner.bio,
                            style: const TextStyle(fontSize: 15)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Text('Skills',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Text(widget.cleaner.bio,
                            style: const TextStyle(fontSize: 15)),
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
                TabPageSelector(
                  color: Colors.black,
                  selectedColor: Colors.blue,
                  indicatorSize: 10,
                  controller: newTabControl,
                ),
                widget.cleaner.ratings == 0
                    ? const Text(
                        'No reviews.. yet...',
                        textAlign: TextAlign.center,
                      )
                    : PageView.builder(
                        onPageChanged: (value) => newTabControl.animateTo(value),
                        itemCount: widget.cleaner.reviews.length - 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Review from ${widget.cleaner.reviews[index].reviewerName}'),
                            subtitle: Text(
                                'Rating: ${widget.cleaner.reviews[index].rating.toString()}\n${widget.cleaner.reviews[index].details}'),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topBarForCleaner() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Hero(
          tag: 'cleanerImage',
          child: widget.cleaner.heroPhoto == "none"
              ? Image.asset(
                  'lib/assets/defaultHero.jpg',
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  widget.cleaner.heroPhoto,
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          bottom: -40,
          left: 5,
          child: widget.cleaner.profilePhoto == "none"
              ? const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Icon(
                    Icons.person_2_outlined,
                    size: 50,
                    color: Colors.black,
                  ),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.cleaner.profilePhoto),
                ),
        ),
        Positioned(
          bottom: -50,
          left: 110,
          child: Icon(
            Icons.star,
            color: Colors.yellow[700],
            size: 20,
          ),
        ),
        Positioned(
          bottom: -52,
          left: 134,
          child: Text(
            widget.cleaner.rating.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        const Positioned(
          bottom: -52,
          left: 163,
          child: Text(
            '.',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: -52,
          left: 175,
          child: Text(
            '${widget.cleaner.ratings} reviews',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: 130,
          child: Text(
            '${widget.cleaner.firstName} ${widget.cleaner.lastName[0]}.',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 30,
          bottom: -37,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '\$${widget.cleaner.pricing.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' per hour',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
