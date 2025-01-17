import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import '../constant/colors_utils.dart';

class ContactField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(CountryCode)? onChanged;
  const ContactField({
    Key? key,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13)),
              color: Colors.white),
          child: CountryCodePicker(
            backgroundColor: Colors.white,
            onChanged: onChanged,
            initialSelection: '+996',
            textStyle: TextStyle(color: textBrownColor),
            showFlag: false,
            padding: EdgeInsets.zero,
          ),
        ),
        Flexible(
          child: TextFormField(
            maxLength: 9,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            controller: controller,
            decoration: const InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.all(1),
              constraints: BoxConstraints(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomRight: Radius.circular(13)),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomRight: Radius.circular(13)),
                  borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomRight: Radius.circular(13)),
                  borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomRight: Radius.circular(13)),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: "123456789",
              errorStyle: TextStyle(height: 0.05),
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}
