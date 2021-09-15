import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_tube/src/screen/search_q/search_q_controller.dart';

class SearchQScreen extends GetView<SearchQController> {
  const SearchQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: controller.tX,
                        decoration: InputDecoration(
                          labelText: "キーワードを入力",
                          labelStyle: TextStyle(color: Colors.white),
                          focusColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        onChanged: controller.getSuggest,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () {
                        controller.tX.clear();
                        controller.suggests.clear();
                      },
                    )
                  ],
                ),
              ),
              Divider(),
              Obx(
                () => Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,
                    ),
                    itemCount: controller.suggests.isEmpty
                        ? controller.predicts.length
                        : controller.suggests.length,
                    itemBuilder: (context, index) {
                      String keyword;
                      if (controller.suggests.isEmpty) {
                        keyword = controller.predicts[index];
                      } else {
                        keyword = controller.suggests[index];
                      }

                      return ListTile(
                        title: Text(keyword),
                        onTap: () => controller.pushListScreen(keyword),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
