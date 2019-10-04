import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/forms/app_form.dart';
import 'package:invoiceninja_flutter/ui/app/forms/decorated_form_field.dart';
import 'package:invoiceninja_flutter/ui/settings/settings_scaffold.dart';
import 'package:invoiceninja_flutter/ui/settings/user_details_vm.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final UserDetailsVM viewModel;

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool autoValidate = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    _controllers.forEach((dynamic controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _controllers = [
      _firstNameController,
      _lastNameController,
      _emailController,
      _phoneController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final user = widget.viewModel.state.user;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    //_phoneController.text = user.

    _controllers
        .forEach((dynamic controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  void _onChanged() {
    final user = widget.viewModel.user.rebuild((b) => b
          ..firstName = _firstNameController.text.trim()
          ..lastName = _lastNameController.text.trim()
          ..email = _emailController.text.trim()
        //..firstName = _firstNameController.text.trim()
        );
    if (user != widget.viewModel.user) {
      widget.viewModel.onChanged(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;

    return SettingsScaffold(
      title: localization.userDetails,
      onSavePressed: viewModel.onSavePressed,
      onCancelPressed: viewModel.onCancelPressed,
      body: AppForm(
        formKey: _formKey,
        children: <Widget>[
          DecoratedFormField(
            label: localization.firstName,
            controller: _firstNameController,
            validator: (val) => val.isEmpty || val.trim().isEmpty
                ? localization.pleaseEnterAFirstName
                : null,
            autovalidate: autoValidate,
          ),
          DecoratedFormField(
            label: localization.lastName,
            controller: _lastNameController,
            validator: (val) => val.isEmpty || val.trim().isEmpty
                ? localization.pleaseEnterALastName
                : null,
            autovalidate: autoValidate,
          ),
          DecoratedFormField(
            label: localization.email,
            controller: _emailController,
            validator: (val) => val.isEmpty || val.trim().isEmpty
                ? localization.pleaseEnterYourEmail
                : null,
            autovalidate: autoValidate,
          ),
          DecoratedFormField(
            label: localization.phone,
            controller: _phoneController,
          ),
        ],
      ),
    );
  }
}