import 'package:flutter_application/redux/load_machines_actions.dart';
import 'package:flutter_application/redux/app_state.dart';

AppState loadMachinesReducer(AppState state, dynamic action) {
  if (action is loadMachinesAction) {
    return state.copyWith(error: null);
  } else if (action is loadMachinesSuccessAction) {
    return state.copyWith(machines: action.machines, error: null);
  } else if (action is loadMachinesFailureAction) {
    return state.copyWith(error: action.error);
  }
  return state;
}
