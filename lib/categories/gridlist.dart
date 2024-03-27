// import 'package:destination/categories/detail.dart';
// import 'package:flutter/material.dart';

// class CategoriesGridList extends StatefulWidget {
//   const CategoriesGridList({super.key, required this.categoryItem});
//   final List<Map<String, dynamic>> categoryItem;
//   @override
//   CategoriesGridListState createState() => CategoriesGridListState();
// }

// class CategoriesGridListState extends State<CategoriesGridList> {
//   bool isSelectionMode = false;
//   late int listLength = widget.categoryItem.length;

//   late List<bool> _selected;
//   bool _selectAll = false;
//   bool _isGridMode = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeSelection();
//   }

//   void initializeSelection() {
//     _selected = List<bool>.generate(listLength, (_) => false);
//   }

//   @override
//   void dispose() {
//     _selected.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String name = widget.categoryItem[0]["name"];

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         elevation: 0,
//         title: Text(
//           name,
//           style: const TextStyle(
//               color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         actions: <Widget>[
//           isSelectionMode
//               ? IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     setState(() {
//                       isSelectionMode = false;
//                     });
//                     initializeSelection();
//                   },
//                 )
//               : const SizedBox(),
//           if (_isGridMode)
//             IconButton(
//               icon: const Icon(Icons.grid_on),
//               onPressed: () {
//                 setState(() {
//                   _isGridMode = false;
//                 });
//               },
//             )
//           else
//             IconButton(
//               icon: const Icon(Icons.list),
//               onPressed: () {
//                 setState(() {
//                   _isGridMode = true;
//                 });
//               },
//             ),
//           if (isSelectionMode)
//             TextButton(
//               child: !_selectAll
//                   ? const Text(
//                       'select all',
//                       style: TextStyle(color: Colors.white),
//                     )
//                   : const Text(
//                       'unselect all',
//                       style: TextStyle(color: Colors.white),
//                     ),
//               onPressed: () {
//                 _selectAll = !_selectAll;
//                 setState(() {
//                   _selected =
//                       List<bool>.generate(listLength, (_) => _selectAll);
//                 });
//               },
//             ),
//         ],
//       ),
//       body: _isGridMode
//           ? GridBuilder(
//               isSelectionMode: isSelectionMode,
//               selectedList: _selected,
//               onSelectionChange: (bool x) {
//                 setState(() {
//                   isSelectionMode = x;
//                 });
//               },
//               categoryItem: widget.categoryItem)
//           : ListBuilder(
//               isSelectionMode: isSelectionMode,
//               selectedList: _selected,
//               onSelectionChange: (bool x) {
//                 setState(() {
//                   isSelectionMode = x;
//                 });
//               },
//               categoryItem: widget.categoryItem,
//             ),
//     );
//   }
// }

// class GridBuilder extends StatefulWidget {
//   const GridBuilder(
//       {super.key,
//       required this.selectedList,
//       required this.isSelectionMode,
//       required this.onSelectionChange,
//       required this.categoryItem});
//   final List<Map<String, dynamic>> categoryItem;
//   final bool isSelectionMode;
//   final Function(bool)? onSelectionChange;
//   final List<bool> selectedList;

//   @override
//   GridBuilderState createState() => GridBuilderState();
// }

// class GridBuilderState extends State<GridBuilder> {
//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index] = !widget.selectedList[index];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: widget.selectedList.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemBuilder: (context, index) {
//         String image = widget.categoryItem[index]["image"];
//         String title = widget.categoryItem[index]["title"];
//         return InkWell(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => const Detail(
//                     // topItem: widget.categoryItem[index],
//                     // hotelName: '',
//                     // hotelImg: '',
//                     // hotelRating: '',
//                     )));
//           },
//           onLongPress: () {
//             if (!widget.isSelectionMode) {
//               setState(() {
//                 widget.selectedList[index] = true;
//               });
//               widget.onSelectionChange!(true);
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: GridTile(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Stack(
//                   children: [
//                     Card(
//                       child: Column(
//                         children: [
//                           Image.asset(
//                             image,
//                             fit: BoxFit.cover,
//                             height: 160,
//                           ),
//                           Text(title,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 14)),
//                         ],
//                       ),
//                     ),
//                     if (widget.isSelectionMode)
//                       Positioned(
//                           left: 153,
//                           top: -16,
//                           child: Checkbox(
//                             checkColor: Colors.red,
//                             fillColor: MaterialStateProperty.resolveWith<Color>(
//                                 (Set<MaterialState> states) {
//                               if (states.contains(MaterialState.disabled)) {
//                                 return Colors.black.withOpacity(.32);
//                               }
//                               return Colors.white;
//                             }),
//                             onChanged: (bool? x) => _toggle(index),
//                             value: widget.selectedList[index],
//                           ))
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ListBuilder extends StatefulWidget {
//   const ListBuilder(
//       {super.key,
//       required this.selectedList,
//       required this.isSelectionMode,
//       required this.onSelectionChange,
//       required this.categoryItem});
//   final List<Map<String, dynamic>> categoryItem;
//   final bool isSelectionMode;
//   final List<bool> selectedList;
//   final Function(bool)? onSelectionChange;

//   @override
//   State<ListBuilder> createState() => _ListBuilderState();
// }

// class _ListBuilderState extends State<ListBuilder> {
//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index] = !widget.selectedList[index];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.selectedList.length,
//       itemBuilder: (context, index) {
//         String title = widget.categoryItem[index]["title"];
//         String rating = widget.categoryItem[index]["rating"];
//         return ListTile(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => const Detail(
//                     // topItem: widget.categoryItem[index],
//                     // hotelName: '',
//                     // hotelImg: '',
//                     // hotelRating: '',
//                     )));
//           },
//           onLongPress: () {
//             if (!widget.isSelectionMode) {
//               setState(() {
//                 widget.selectedList[index] = true;
//               });
//               widget.onSelectionChange!(true);
//             }
//           },
//           trailing: widget.isSelectionMode
//               ? Checkbox(
//                   checkColor: Colors.red,
//                   fillColor: MaterialStateProperty.resolveWith<Color>(
//                       (Set<MaterialState> states) {
//                     if (states.contains(MaterialState.disabled)) {
//                       return Colors.black.withOpacity(.32);
//                     }
//                     return Colors.white;
//                   }),
//                   value: widget.selectedList[index],
//                   onChanged: (bool? x) => _toggle(index),
//                 )
//               : const SizedBox.shrink(),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w600, fontSize: 14)),
//               Row(
//                 children: [
//                   const Icon(Icons.star, size: 20, color: Colors.red),
//                   Text(rating,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 13)),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
