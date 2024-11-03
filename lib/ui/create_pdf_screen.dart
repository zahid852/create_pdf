import 'package:create_pdf/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreatePdfScreen extends StatefulWidget {
  const CreatePdfScreen({super.key});

  @override
  State<CreatePdfScreen> createState() => _CreatePdfScreenState();
}

class _CreatePdfScreenState extends State<CreatePdfScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController vehicleRegNo = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController chargesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Generate Contract'),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(children: [
                  Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Name',
                              style: get14Light(),
                            ),
                          ),
                          TextFormField(
                              controller: nameController,
                              style: get14Light(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name';
                                }
                                if (value.length > 255) {
                                  return maxErrorString('Name', '255');
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter Full Name')),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Vehicle Reg No.',
                              style: get14Light(),
                            ),
                          ),
                          TextFormField(
                              controller: vehicleRegNo,
                              style: get14Light(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter vehicle reg no.';
                                }
                                if (value.length > 255) {
                                  return maxErrorString(
                                      'Vehicle reg no', '255');
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter vehicle reg no.')),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'No. Of Days',
                              style: get14Light(),
                            ),
                          ),
                          TextFormField(
                              controller: daysController,
                              style: get14Light(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter no. of days';
                                }
                                if (value.length > 255) {
                                  return maxErrorString('No. of days', '255');
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter no. of days')),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Rent Per Day',
                              style: get14Light(),
                            ),
                          ),
                          TextFormField(
                              controller: chargesController,
                              style: get14Light(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter rent per day';
                                }
                                if (value.length > 255) {
                                  return maxErrorString('Rent per day', '255');
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter rent per day')),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      )),
                ]),
              ),
              SizedBox(
                height: 50,
                width: Get.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await rootBundle
                            .load('assets/image.png')
                            .then((value) => Utils.downloadingPdf(
                                  img: value,
                                  date: DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime.now()),
                                  regNo: vehicleRegNo.text,
                                  rentPerDay: num.parse(chargesController.text),
                                  days: num.parse(daysController.text),
                                  driverName: nameController.text,
                                ));
                        formKey.currentState!.reset();
                        nameController.clear();
                        vehicleRegNo.clear();
                        daysController.clear();
                        chargesController.clear();
                      }
                    },
                    child: const Text(
                      'GENERATE CONTRACT PDF',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
