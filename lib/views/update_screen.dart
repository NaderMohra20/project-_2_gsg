// Do you know how to design this screen ...
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/cubit/cubit.dart';
import 'package:todo/controller/cubit/states.dart';
import 'package:todo/shared/componant.dart';

class UpdateTaskScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController desController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int id;
  UpdateTaskScreen({required this.id});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (BuildContext context, state) {
        if (state is SuccessUpdatingDataFromDatabaseState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, Object? state) {
        var cubit = TodoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Update your notes'.tr()),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomTextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please add your title'.tr();
                          }
                        },
                        label: 'Title',
                        hintText: 'Add your Title',
                        prefixIcon: Icons.title),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomTextFormField(
                        controller: timeController,
                        keyboardType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please add your Time'.tr();
                          }
                        },
                        label: 'Time',
                        hintText: 'Add your Time',
                        prefixIcon: Icons.watch_later_outlined,
                        onTap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            timeController.text = value!.format(context);
                          }).catchError((error) {
                            timeController.clear();
                          });
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomTextFormField(
                        controller: dateController,
                        keyboardType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please add your Date'.tr();
                          }
                        },
                        label: 'Date',
                        hintText: 'Add your Date',
                        prefixIcon: Icons.calendar_view_day,
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2040-12-30'))
                              .then((value) {
                            dateController.text =
                                DateFormat.yMMMd().format(value!);
                          }).catchError((error) {
                            dateController.clear();
                          });
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomTextFormField(
                        controller: desController,
                        lines: 5,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please add your description'.tr();
                          }
                        },
                        label: 'Description',
                        hintText: 'Add your Description',
                        prefixIcon: Icons.note),
                    const SizedBox(
                      height: 10.0,
                    ),
                    MaterialButton(
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      minWidth: double.infinity,
                      color: Colors.teal,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.updateDataIntoDatabase(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text,
                              description: desController.text,
                              id: id);
                        }
                      },
                      child: Text('Update Notes'.tr()),
                    ),
                    // so now we get our texts...
                    // lets go to our component
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
