import 'package:quickresponse/main.dart';

class EmergencyAlert {
  final String id;
  final String type;
  final DateTime dateTime;
  final String location;
  final String details;
  final String customMessage;
  final bool hasLocationData; // Added to check if location data is available

  EmergencyAlert({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.location,
    required this.details,
    required this.customMessage,
    required this.hasLocationData,
  });
}

class EmergencyHistoryPage extends ConsumerStatefulWidget {
  const EmergencyHistoryPage({super.key});

  @override
  ConsumerState<EmergencyHistoryPage> createState() => _EmergencyHistoryPageState();
}

class _EmergencyHistoryPageState extends ConsumerState<EmergencyHistoryPage> {
  List<EmergencyAlert> emergencyAlerts = [
    EmergencyAlert(
      id: '1',
      type: 'Medical Emergency',
      dateTime: DateTime(2023, 9, 10, 10, 30),
      location: '123 Main St, City',
      details: 'Patient unconscious',
      customMessage: 'Please send help!',
      hasLocationData: true, // Example with location data
    ),
    EmergencyAlert(
      id: '2',
      type: 'Fire Emergency',
      dateTime: DateTime(2023, 9, 9, 15, 45),
      location: '456 Elm St, Town',
      details: 'Building on fire',
      customMessage: 'Fire department needed!',
      hasLocationData: false, // Example without location data
    ),
    EmergencyAlert(
      id: '11',
      type: 'Fire Emergency',
      dateTime: DateTime(2023, 9, 11, 8, 15),
      location: '789 Oak St, Village',
      details: 'Smoke in the building',
      customMessage: 'Call the fire department!',
      hasLocationData: false,
    ),
    EmergencyAlert(
      id: '12',
      type: 'Medical Emergency',
      dateTime: DateTime(2023, 9, 10, 12, 30),
      location: '567 Pine St, Town',
      details: 'Patient with severe injuries',
      customMessage: 'Urgent medical assistance needed!',
      hasLocationData: true,
    ),
    EmergencyAlert(
      id: '13',
      type: 'Security Alert',
      dateTime: DateTime(2023, 9, 9, 18, 45),
      location: '321 Cedar St, City',
      details: 'Suspicious activity reported',
      customMessage: 'Requesting police presence',
      hasLocationData: true,
    ),
    EmergencyAlert(
      id: '14',
      type: 'Natural Disaster',
      dateTime: DateTime(2023, 9, 8, 14, 30),
      location: '123 Maple St, Village',
      details: 'Earthquake tremors detected',
      customMessage: 'Stay safe!',
      hasLocationData: true,
    ),
    EmergencyAlert(
      id: '15',
      type: 'Medical Emergency',
      dateTime: DateTime(2023, 9, 7, 16, 20),
      location: '456 Birch St, Town',
      details: 'Patient unconscious',
      customMessage: 'Please send help!',
      hasLocationData: true,
    ),
    EmergencyAlert(
      id: '16',
      type: 'Fire Emergency',
      dateTime: DateTime(2023, 9, 6, 10, 45),
      location: '987 Elm St, City',
      details: 'Building on fire',
      customMessage: 'Fire department needed!',
      hasLocationData: false,
    ),
    EmergencyAlert(
      id: '17',
      type: 'Security Alert',
      dateTime: DateTime(2023, 9, 5, 19, 15),
      location: '654 Cedar St, Village',
      details: 'Burglary reported',
      customMessage: 'Requesting immediate assistance',
      hasLocationData: true,
    ),
    EmergencyAlert(
      id: '18',
      type: 'Natural Disaster',
      dateTime: DateTime(2023, 9, 4, 13, 55),
      location: '234 Pine St, Town',
      details: 'Flood warning in effect',
      customMessage: 'Seek higher ground!',
      hasLocationData: true,
    ),
    EmergencyAlert(
      id: '19',
      type: 'Fire Emergency',
      dateTime: DateTime(2023, 9, 3, 17, 10),
      location: '567 Oak St, City',
      details: 'Smoke and flames visible',
      customMessage: 'Urgent fire response needed!',
      hasLocationData: false,
    ),
    EmergencyAlert(
      id: '20',
      type: 'Medical Emergency',
      dateTime: DateTime(2023, 9, 2, 9, 30),
      location: '123 Elm St, Village',
      details: 'Patient with difficulty breathing',
      customMessage: 'Call an ambulance!',
      hasLocationData: true,
    ),
  ];

  // Add variables for filtering, sorting, searching, and export
  String? selectedFilter;
  String? selectedSort;
  String searchText = '';
  List<EmergencyAlert> selectedAlerts = [];
  final FocusNode _focusNode = FocusNode();

  final PageController _pageController = PageController();
  int currentPage = 0;
  int totalPages = 0;

  // Define two boolean variables to track the checkbox states
  bool searchByKeyword = false;
  bool searchByLocation = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedAlerts = List.from(emergencyAlerts); // Initialize with all alerts
  }

  @override
  Widget build(BuildContext context) {
    // Filter, sort, and search the alerts
    final filteredAlerts = _filterAndSortAlerts(emergencyAlerts);
    final dp = Density.init(context);
    final page = ref.watch(pageProvider.select((value) => value));
    //final theme = ref.watch(themeProvider.select((value) => value));

    return WillPopScope(
      onWillPop: () async {
        bool isLastPage = page.isEmpty;
        if (isLastPage) {
          launch(context, Constants.home);
          return false;
          //return (await showAnimatedDialog(context))!;
        } else {
          launch(context, page.last);
          ref.watch(pageProvider.notifier).setPage = page..remove(page.last);
          return true;
        }
      },
      child: focus(
        _focusNode,
        Scaffold(
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          appBar: CustomAppBar(
            leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor(theme).navIconSelected),
            title: const Text('Emergency History', style: TextStyle(fontSize: 20)),
            actionTitle: '',
            actionIcon: null,
          ),
          body: Column(children: [
            // Filter and Sort Options
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 16),
              //padding: const EdgeInsets.all(10.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                OutlinedDropdownButton(
                  label: Text(selectedFilter ?? 'Filter by Type'),
                  icon: Icons.filter_list,
                  onPressed: () => _showFilterDropdown(context),
                ),
                OutlinedDropdownButton(
                  label: Text(selectedSort ?? 'Sort by Date'),
                  icon: Icons.sort,
                  onPressed: () => _showSortDropdown(context),
                ),
              ]),
            ),

            // Search Bar (Customized with Material 3 Styling)
            Container(
              height: 50,
              margin: const EdgeInsets.all(20).copyWith(bottom: 16),
              child: TextField(
                focusNode: _focusNode,
                onChanged: (String text) {
                  setState(() {
                    searchText = text;
                    // Update the selectedAlerts and currentPage immediately
                    selectedAlerts = _filterAndSortAlerts(emergencyAlerts);
                    currentPage = 0; // Reset to the first page when searching
                  });
                },
                style: TextStyle(
                  // Customize text style
                  color: AppColor(theme).black,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  fillColor: AppColor(theme).white,
                  filled: true,
                  focusColor: AppColor(theme).white,
                  prefixIconColor: AppColor(theme).navIconSelected,
                  suffixIconColor: AppColor(theme).navIconSelected,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColor(theme).border)),
                  hintText: 'Search by keyword or location',
                  prefixIcon: const Icon(CupertinoIcons.search, size: 20),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // Clear the search text
                      setState(() {
                        searchText = '';
                        selectedAlerts = _filterAndSortAlerts(emergencyAlerts);
                      });
                    },
                    child: const Icon(Icons.clear, size: 20),
                  ),
                ),
              ),
            ),

            // Add the two checkboxes to your UI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: searchByKeyword,
                  onChanged: (value) {
                    setState(() {
                      searchByKeyword = value!;
                    });
                  },
                ),
                const Text('Search by Keyword'),
                Checkbox(
                  value: searchByLocation,
                  onChanged: (value) {
                    setState(() {
                      searchByLocation = value!;
                    });
                  },
                ),
                const Text('Search by Location'),
              ],
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages, // Updated itemCount
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final startIndex = index * itemsPerPage;
                  final endIndex = (startIndex + itemsPerPage <= selectedAlerts.length) ? (startIndex + itemsPerPage) : selectedAlerts.length;
                  final pageItems = selectedAlerts.sublist(startIndex, endIndex);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: pageItems.length,
                      itemBuilder: (context, innerIndex) {
                        final alert = pageItems[innerIndex];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                          color: AppColor(theme).white,
                          elevation: 0,
                          child: ListTile(
                            title: Text('${alert.type} Alert'),
                            subtitle: Text(
                              'Date & Time: ${formatDate(
                                ref,
                                alert.dateTime,
                                dateFormat,
                              )} ${formatTime(
                                ref,
                                alert.dateTime,
                                timeFormat,
                              )}',
                            ),
                            trailing: IconButton(
                              icon: Icon(CupertinoIcons.delete_simple, size: 18, color: AppColor(theme).navIconSelected),
                              onPressed: () => _showDeleteConfirmationDialog(context, alert),
                            ),
                            onTap: () {
                              // Implement navigation to a detailed view of the alert
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmergencyDetailPage(alert: alert),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Pagination indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                (selectedAlerts.length / itemsPerPage).ceil(),
                (pageIndex) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageIndex == currentPage
                          ? AppColor(theme).navIconSelected // Change this color to the desired color
                          : AppColor(theme).text, // Default color
                    ),
                  );
                },
              ),
            ),
          ]),
          floatingActionButton: OutlinedFab(
            theme,
            onPressed: () => _exportAlerts(selectedAlerts),
            isExpanded: false,
            child: const Icon(Icons.ios_share),
          ),
          bottomNavigationBar: const BottomNavigator(currentIndex: 3),
        ),
      ),
    );
  }

  // Callback for filter button pressed
  void _showFilterDropdown(BuildContext context) {
    dialog(
      context: context,
      title: const Text('Filter by Type'),
      list: [
        _buildOption(context, 'All'),
        _buildOption(context, 'Medical'),
        _buildOption(context, 'Fire'),
        _buildOption(context, 'Other'),
      ],
      selection: (value) => selectedFilter = value,
    );
  }

  // Callback for sort button pressed
  void _showSortDropdown(BuildContext context) {
    dialog(
      context: context,
      title: const Text('Sort by Date'),
      list: [
        _buildOption(context, 'Latest First'),
        _buildOption(context, 'Oldest First'),
      ],
      selection: (value) => selectedSort = value,
    );
  }

  Future<void> dialog({
    required BuildContext context,
    required Text title,
    required List<Widget> list,
    required Function(dynamic) selection,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: Column(mainAxisSize: MainAxisSize.min, children: list),
        );
      },
    ).then((selectedValue) {
      if (selectedValue != null) {
        setState(() {
          selection(selectedValue);
          selectedAlerts = _filterAndSortAlerts(emergencyAlerts);
        });
      }
    });
  }

  // Helper method to build filter options
  Widget _buildOption(BuildContext context, String value) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(value),
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(value)),
    );
  }

  // Helper method to filter and sort alerts
  List<EmergencyAlert> _filterAndSortAlerts(List<EmergencyAlert> alerts) {
    // Filter the alerts based on selectedFilter
    List<EmergencyAlert> filteredAlerts = alerts;

    if (selectedFilter != null && selectedFilter != 'All') {
      filteredAlerts = alerts.where((alert) => alert.type.toLowerCase().contains(selectedFilter!.toLowerCase())).toList();
    }

    // Filter the alerts based on searchText
    filteredAlerts = filteredAlerts.where((alert) {
      final typeMatch = alert.type.toLowerCase().contains(searchText.toLowerCase());
      final locationMatch = alert.location.toLowerCase().contains(searchText.toLowerCase());

      if (searchText.isEmpty) {
        return true; // Return true if searchText is empty
      } else if ((searchByKeyword && typeMatch) || (searchByLocation && locationMatch)) {
        return true; // Return true if either keyword or location matches based on checkbox selection
      } else if (searchByKeyword && searchByLocation && typeMatch && locationMatch) {
        return true; // Return true if both checkboxes are selected and both keyword and location match
      } else {
        return false; // Return false if none of the conditions are met
      }
    }).toList();

    // Sort the alerts based on selectedSort
    if (selectedSort == 'Latest First') {
      filteredAlerts.sort((a, b) {
        final comparison = b.dateTime.compareTo(a.dateTime);
        if (comparison != 0) {
          return comparison;
        }
        // If dates are the same, sort by type
        return a.type.compareTo(b.type);
      });
    } else if (selectedSort == 'Oldest First') {
      filteredAlerts.sort((a, b) {
        final comparison = a.dateTime.compareTo(b.dateTime);
        if (comparison != 0) {
          return comparison;
        }
        // If dates are the same, sort by type
        return a.type.compareTo(b.type);
      });
    }

    // Update selectedAlerts with the filtered and sorted alerts
    selectedAlerts = filteredAlerts;

    // Calculate the total number of pages
    totalPages = (selectedAlerts.length / itemsPerPage).ceil(); // Add this line

    // Check if the currentPage is valid based on the number of filtered alerts
    if (currentPage >= totalPages) {
      // If currentPage is out of range, set it to the last page
      currentPage = totalPages - 1;
    }

    return selectedAlerts;
  }

  // Function to show a confirmation dialog before deleting an alert
  Future<void> _showDeleteConfirmationDialog(BuildContext context, EmergencyAlert alert) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Alert'),
          content: const SingleChildScrollView(
            child: ListBody(children: [
              Text('Are you sure you want to delete this alert?'),
            ]),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Remove the alert from the list
                setState(() {
                  emergencyAlerts.remove(alert);
                  selectedAlerts = _filterAndSortAlerts(emergencyAlerts);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _exportAlerts(List<EmergencyAlert> alerts) {
    // Create a string to hold the exported data
    final StringBuffer exportData = StringBuffer();

    // Iterate through the alerts and add them to the exportData string
    for (final alert in alerts) {
      exportData.writeln('Type: ${alert.type}');
      exportData.writeln('Date & Time: ${alert.dateTime}');
      exportData.writeln('Location: ${alert.location}');
      exportData.writeln('Details: ${alert.details}');
      exportData.writeln('Custom Message: ${alert.customMessage}');
      exportData.writeln(''); // Add an empty line to separate alerts
    }

    // Convert the StringBuffer to a string
    final String exportText = exportData.toString();

    // Share the exported data using the share package
    Share.share(exportText, subject: 'Emergency Alerts Export');
  }
}

class EmergencyDetailPage extends ConsumerStatefulWidget {
  final EmergencyAlert alert;

  const EmergencyDetailPage({super.key, required this.alert});

  @override
  ConsumerState<EmergencyDetailPage> createState() => _EmergencyDetailPageState();
}

class _EmergencyDetailPageState extends ConsumerState<EmergencyDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.alert.type} Alert Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date & Time: ${_formatDate(widget.alert.dateTime)}'),
            Text('Location: ${widget.alert.location}'),
            Text('Details: ${widget.alert.details}'),
            Text('Custom Message: ${widget.alert.customMessage}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  // Helper method to format the date based on the selected date format
  String _formatDate(DateTime dateTime) {
    //final selectedDateFormat = ref.watch(dateFormatProvider.select((value) => value));
    switch (dateFormat) {
      case DateFormatOption.format1:
        return DateFormat.yMd().add_jm().format(dateTime);
      case DateFormatOption.format2:
        return DateFormat('MMMM dd, yyyy - HH:mm').format(dateTime);
      case DateFormatOption.format3:
        return DateFormat('EEE, MMM dd, yyyy').format(dateTime);
      default:
        return DateFormat.yMd().add_jm().format(dateTime);
    }
  }
}
