import 'dart:convert';

import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_machines_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class MachineService {
  static Future<void> fetchMachines(Store<AppState> store) async {
    store.dispatch(loadMachinesAction());

    try {
      final response =
          await http.get(Uri.parse("http://127.0.0.1:8000/api/map"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final machines = data.map((item) => Machine.fromJson(item)).toList();
        store.dispatch(loadMachinesSuccessAction(machines));
      } else {
        store.dispatch(loadMachinesFailureAction('Failed to load machines.'));
      }
    } catch (e) {
      store.dispatch(loadMachinesFailureAction(e.toString()));
    }
  }
}
