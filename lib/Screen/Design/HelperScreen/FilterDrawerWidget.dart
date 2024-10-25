import 'package:flutter/material.dart';

class FilterDrawerWidget extends StatefulWidget {
  const FilterDrawerWidget({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<FilterDrawerWidget> createState() => _FilterDrawerWidgetState();
}

class _FilterDrawerWidgetState extends State<FilterDrawerWidget> {
  String? _selectedFilter;
  String? _selectedOrder;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(left: 15),
        children: [
          DrawerHeader(
            child: Center(
              child: IconButton(
                onPressed: () {
                  widget.scaffoldKey.currentState!.closeEndDrawer();
                },
                icon: Icon(
                  Icons.close_outlined,
                  color: Color(0xFFDD153C),
                  size: 50,
                ),
              ),
            ),
          ),
          Text(
            "Filter By",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFDD153C),
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Discount'),
                leading: Radio(
                  value: 'discount',
                  toggleable: true,
                  groupValue: _selectedFilter,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Name'),
                leading: Radio(
                  value: 'name',
                  toggleable: true,
                  groupValue: _selectedFilter,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Created At'),
                leading: Radio(
                  value: 'createdAt',
                  toggleable: true,
                  groupValue: _selectedFilter,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Updated At'),
                leading: Radio(
                  value: 'updatedAt',
                  toggleable: true,
                  groupValue: _selectedFilter,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Selected: $_selectedFilter'),
              ),
            ],
          ),
          Text(
            "Filter Order",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFDD153C),
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Ascending'),
                leading: Radio(
                  value: 'ASC',
                  toggleable: true,
                  groupValue: _selectedOrder,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOrder = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Descending'),
                leading: Radio(
                  value: 'DESC',
                  toggleable: true,
                  groupValue: _selectedOrder,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOrder = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Selected: $_selectedOrder'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              alignment: Alignment.center,
              width: 150, // Set the button width
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  // Open the drawer when the button is pressed
                  debugPrint("Filter Button Clicked ");
                  _selectedFilter = null;
                  _selectedOrder = null;
                  widget.scaffoldKey.currentState!.closeEndDrawer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDD153C),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // side: BorderSide(
                    //   color: Colors.black,
                    // ),
                  ),
                ),
                child: Text(
                  "Clear All",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
