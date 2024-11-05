import 'package:expense_repository/expense_repository.dart';
import 'package:finance_tracker_app/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package
//import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

getCategoryCreation(BuildContext context) {
  List<String> myCategoriesIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel'
  ];

  return showDialog(
            context: context,
            builder: (ctx) {
              bool isExpanded = false;
              String iconSelected = '';
              Color categoryColor = Colors.white;
              TextEditingController categoryNameController =
                  TextEditingController();
              TextEditingController categoryIconController =
                  TextEditingController();
              TextEditingController categoryColorController =
                  TextEditingController();
              bool isLoading = false;

              return BlocProvider.value(
                value: context.read<CreateCategoryBloc>(),
                child: StatefulBuilder(
                  builder: (ctx, setState) {
                  return BlocListener<CreateCategoryBloc, CreateCategoryState>(
                    listener: (context, state) {
                      if(state is CreateCategorySuccess) {
                        Navigator.pop(ctx);
                      } else if(state is CreateCategoryLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                    },
                    child: AlertDialog(
                      title: const Text('Create a Category'),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onTap: () {
                                setState(() {
                                  if (isExpanded)
                                    isExpanded =
                                        false; // Collapse if expanded
                                });
                              },
                              controller: categoryNameController,
                              textAlignVertical:
                                  TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: categoryIconController,
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              textAlignVertical:
                                  TextAlignVertical.center,
                              readOnly: true,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                suffixIcon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  size: 20,
                                ),
                                fillColor: Colors.white,
                                hintText: 'Icon',
                                border: OutlineInputBorder(
                                    borderRadius: isExpanded
                                        ? const BorderRadius
                                            .vertical(
                                            top: Radius.circular(
                                                12))
                                        : BorderRadius.circular(
                                            12),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            isExpanded
                                ? Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.vertical(
                                                bottom: Radius
                                                    .circular(
                                                        12))),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(
                                              8.0),
                                      child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      3,
                                                  mainAxisSpacing:
                                                      5,
                                                  crossAxisSpacing:
                                                      5),
                                          itemCount:
                                              myCategoriesIcons
                                                  .length,
                                          itemBuilder:
                                              (context, int i) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  iconSelected =
                                                      myCategoriesIcons[
                                                          i];
                                                });
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: iconSelected ==
                                                                myCategoriesIcons[
                                                                    i]
                                                            ? Colors
                                                                .green
                                                            : Colors
                                                                .grey),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                12),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/${myCategoriesIcons[i]}.png'))),
                                              ),
                                            );
                                          }),
                                    ),
                                  )
                                : Container(),
                            TextFormField(
                              controller: categoryColorController,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx2) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize:
                                            MainAxisSize.min,
                                        children: [
                                          ColorPicker(
                                            pickerColor:
                                                categoryColor,
                                            onColorChanged:
                                                (value) {
                                              setState(() {
                                                categoryColor =
                                                    value;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width:
                                                double.infinity,
                                            height: 50,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    ctx2);
                                              },
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors
                                                          .black,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12))),
                                              child: const Text(
                                                'Save Color',
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              textAlignVertical:
                                  TextAlignVertical.center,
                              readOnly: true,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: categoryColor,
                                hintText: 'Color',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: kToolbarHeight,
                              child: isLoading == true
                                ? const Center (
                                  child: CircularProgressIndicator(),
                                  )
                                : TextButton(
                                onPressed: () {
                                  Category category =
                                      Category.empty;
                                  category.categoryId =
                                      const Uuid().v1();
                                  category.name =
                                      categoryNameController.text;
                                  category.icon = iconSelected;
                                  category.color =
                                      categoryColor.value;
                                  context
                                      .read<CreateCategoryBloc>()
                                      .add(CreateCategory(
                                          category));
                                  //Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
}