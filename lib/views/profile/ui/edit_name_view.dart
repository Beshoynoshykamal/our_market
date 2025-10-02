import 'package:flutter/material.dart';
import 'package:our_market/core/functions/build_appbar.dart';
import 'package:our_market/views/auth/ui/widgets/custom_elevated_btn.dart';
import 'package:our_market/views/auth/ui/widgets/custom_text_form_field.dart';

class EditNameView extends StatelessWidget {
  const EditNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, "Edit Name"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomTextFormField(
              labelText: "Enter Your Name",
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 20),
            CustomEBtn(text: "Update", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
