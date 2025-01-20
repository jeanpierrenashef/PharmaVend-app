import 'package:flutter_application/models/machine.dart';

class loadMachinesAction {}

class loadMachinesSuccessAction {
  final List<Machine> machines;
  loadMachinesSuccessAction(this.machines);
}

class loadMachinesFailureAction {
  final String error;
  loadMachinesFailureAction(this.error);
}
