import 'package:enagro_app/datasource/remote/user_address_remote.dart';
import 'package:flutter/material.dart';

class UserAddressCombo extends StatefulWidget {
  final int userId;
  final Function(int) onSelectionChanged;
  final int? selUserAddress;
  final String fieldlabel;

  const UserAddressCombo(
      {Key? key,
      required this.onSelectionChanged,
      required this.fieldlabel,
      required this.userId,
      this.selUserAddress})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserAddressComboState createState() => _UserAddressComboState();
}

class _UserAddressComboState extends State<UserAddressCombo> {
  Map<int, String> userAddresses = {};
  bool userAddressChange = false;
  late int selectedUserAddressId;

  @override
  void initState() {
    super.initState();
    selectedUserAddressId = widget.selUserAddress ?? 0;
    loadUserAddress();
  }

  Future<void> loadUserAddress() async {
    final userAddressRemote = UserAddressRemote();
    final userAddressList = await userAddressRemote.comboGetByUser(widget.userId);

    final map = userAddressList.fold<Map<int, String>>({}, (previousMap, userAddress) {
      final id = userAddress['id'] as int;
      final description = userAddress['city'] as String;
      previousMap[id] = description;
      return previousMap;
    });

    setState(() {
      userAddresses = map;
    });
    widget.onSelectionChanged(selectedUserAddressId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.fieldlabel, style: const TextStyle(fontSize: 18)),
        DropdownButton<int>(
          value: selectedUserAddressId,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          dropdownColor: Theme.of(context).primaryColorLight,
          hint: const Text('Selecione o endereço'),
          items: userAddresses.entries.map((MapEntry<int, String> entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              selectedUserAddressId = newValue!;
              userAddressChange = true;
              widget.onSelectionChanged(selectedUserAddressId);
            });
          },
          iconSize: 24,
          isExpanded: true,
          underline:
              Container(height: 1, color: Theme.of(context).primaryColorDark),
        ),
      ],
    );
  }
}