import 'package:agen_nusantara/features/add_important_task/controllers/add_important_task_controller.dart';
import 'package:agen_nusantara/shared/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String _getMonthName(int month) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return months[month - 1];
}

class AddImportantTaskScreen extends GetView<AddImportantTaskController> {
  const AddImportantTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blueGrey2,
      appBar: AppBar(
        title: Text('Tambah Tugas Penting'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red[100],
              ),
              padding: EdgeInsets.all(5),
              child: Text(
                'PENTING',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Form(
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TANGGAL JATUH TEMPO', style: TextStyle(fontSize: 16)),

                    const SizedBox(height: 10),

                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.selectDate(context),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white70,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.selectedDate.value != null
                                      ? '${controller.selectedDate.value!.day} ${_getMonthName(controller.selectedDate.value!.month)} ${controller.selectedDate.value!.year}'
                                      : 'Pilih Tanggal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: controller.selectedDate.value != null
                                        ? Colors.black
                                        : Colors.grey[400],
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text('JUDUL TUGAS', style: TextStyle(fontSize: 16)),

                    TextFormField(
                      controller: controller.titleCtrl,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Rapat Penting',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.white70,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan masukkan judul tugas';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Text('DESKRIPSI', style: TextStyle(fontSize: 16)),

                    TextFormField(
                      controller: controller.descriptionCtrl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Jelaskan detail tugas penting Anda...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.white70,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan masukkan deskripsi tugas';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.addTask(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'TAMBAH TUGAS PENTING',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
