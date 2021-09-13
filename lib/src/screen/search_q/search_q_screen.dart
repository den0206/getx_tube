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
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "キーワードを入力",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
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
              Divider(),
              Obx(
                () => Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,
                    ),
                    itemCount: controller.suggests.length,
                    itemBuilder: (context, index) {
                      final String suggest = controller.suggests[index];

                      return ListTile(
                        title: Text(suggest),
                        onTap: () => controller.pushListScreen(suggest),
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
