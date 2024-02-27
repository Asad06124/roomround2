import 'package:roomrounds/core/constants/imports.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.title,
    // required this.hint,
    this.controller,
    this.isPasswordField = false,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.hintTextColor = AppColors.gry,
    this.textColor = AppColors.black,
    this.suffixIcon,
    this.onSuffixTap,
    this.textAlign,
    this.textFieldBorder,
    this.onChange,
    this.textCapitalization = TextCapitalization.words,
    this.fillColor,
    this.showBorder = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.onTap,
    this.isShadow = false,
    this.isRequiredField = true,
    this.hintText,
    this.borderRadius = 9.0,
  }) : super(key: key);

  final String? title, hintText;
  final TextEditingController? controller;
  final bool isPasswordField;
  final FormFieldValidator? validator;
  final bool readOnly;
  final bool enabled;
  final bool isShadow;
  final TextInputType? keyboardType;
  final Color? textColor, fillColor;
  final Color? hintTextColor;
  final String? prefixIcon;
  final String? suffixIcon;
  final VoidCallback? onSuffixTap, onTap;
  final TextAlign? textAlign;
  final InputBorder? textFieldBorder;
  final Function(String value)? onChange;
  final TextCapitalization? textCapitalization;
  final bool showBorder;
  final int maxLines;
  final bool isRequiredField;
  final double borderRadius;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? '', style: context.bodyLarge),
                if (widget.isRequiredField)
                  const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Icon(
                      Icons.star,
                      color: Colors.red,
                      size: 9,
                    ),
                  )
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.isShadow
                  ? [
                      BoxShadow(
                        color: AppColors.gry.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 9,
                      )
                    ]
                  : []),
          child: TextFormField(
            onTap: widget.onTap,
            onTapOutside: (e) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            cursorColor: widget.textColor,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            controller: widget.controller,
            onChanged: widget.onChange,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            textAlign: widget.textAlign ?? TextAlign.start,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            validator: widget.validator ??
                (value) => value!.toString().trim().isEmpty
                    ? "${widget.hintText ?? ''} ${AppStrings.cannotBeEmpty}"
                    : null,
            obscureText:
                widget.isPasswordField ? _hidePassword : widget.isPasswordField,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        widget.prefixIcon!,
                        color: context.secondary,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPasswordField
                  ? _hidePasswordIcon()
                  : widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: InkWell(
                            onTap: widget.onSuffixTap,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius:
                                    BorderRadius.circular(widget.borderRadius),
                              ),
                              child: SvgPicture.asset(
                                widget.suffixIcon!,
                              ),
                            ),
                          ),
                        )
                      : null,
              hintText: widget.hintText,
              hintStyle:
                  context.bodyLarge!.copyWith(color: widget.hintTextColor),
              fillColor: widget.fillColor,
              filled: true,
              contentPadding: //EdgeInsets.zero,
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              errorBorder: _inputBorder(),
              focusedErrorBorder: _inputBorder(),
              enabledBorder: _inputBorder(),
              disabledBorder: _inputBorder(),
              focusedBorder: _inputBorder(),
              border: _inputBorder(),
            ),
          ),
        ),
        SB.h(10),
      ],
    );
  }

  InputBorder? _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(widget.borderRadius),
      ),
    );
  }

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Widget _hidePasswordIcon() {
    return IconButton(
      onPressed: _toggleHidePassword,
      icon: Icon(
        _hidePassword ? Icons.visibility_off : Icons.visibility,
        color: context.onPrimary,
      ),
    );
  }
}

class SimpleTextField extends StatelessWidget {
  final VoidCallback? onTap;
  final bool readOnly;
  final bool? enabled;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  final String? hint, prefixText;
  final Widget? suffixIcon;

  const SimpleTextField(
      {super.key,
      this.onTap,
      this.readOnly = false,
      this.enabled,
      this.controller,
      this.textCapitalization,
      this.keyboardType,
      this.hint,
      this.prefixText,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      // width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly,
        enabled: enabled,
        controller: controller,
        // onChanged:onChange,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        // textAlign:textAlign ?? TextAlign.start,
        keyboardType: keyboardType,
        // maxLines:maxLines,
        // validator:validator ??
        //     (value) => value!.toString().trim().isEmpty
        //         ? "${widget.title ?? ''} required"
        //         : null,
        // obscureText:
        //    isPasswordField ? _hidePassword :isPasswordField,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          enabledBorder: _border(),
          disabledBorder: _border(),
          focusedBorder: _border(),
          border: _border(),
          // fillColor:fillColor,
          filled: true,
          hintText: hint,
          hintStyle: context.bodySmall?.copyWith(color: context.lightGrey),
          prefixIcon: prefixText != null
              ? SizedBox(
                  width: 0,
                  child: Center(
                    child: Text(
                      "${prefixText ?? ''}: ",
                      style: context.titleSmall,
                    ),
                  ),
                )
              : null,
          suffixIcon: suffixIcon != null
              ? Padding(padding: const EdgeInsets.all(5), child: suffixIcon)
              : null,
          //   suffixIcon:isPasswordField
          //       ? _hidePasswordIcon()
          //       :suffixIcon != null
          //           ? Padding(
          //               padding: const EdgeInsets.all(6),
          //               child: InkWell(
          //                 onTap:onSuffixTap,
          //                 borderRadius: BorderRadius.circular(10),
          //                 child: Container(
          //                   padding: const EdgeInsets.all(10),
          //                   decoration: BoxDecoration(
          //                     color: context.primary,
          //                     borderRadius: BorderRadius.circular(10),
          //                   ),
          //                   child: SvgPicture.asset(
          //                    suffixIcon!,
          //                   ),
          //                 ),
          //               ),
          //             )
          //           : null,
        ),
      ),
    );
  }

  InputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
