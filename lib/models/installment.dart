class Installment {
  final int installmentId;
  final int contractId;
  final int installmentNumber;
  final DateTime dueDate;
  final int statusId;
  final num value;

  Installment(
      {required this.installmentId,
      required this.contractId,
      required this.installmentNumber,
      required this.dueDate,
      required this.statusId,
      required this.value});

  factory Installment.fromMap(Map<String, dynamic> usr) {
    return Installment(
        installmentId: usr['id'] ?? 0,
        contractId: usr['contract_id'] ?? 0,
        installmentNumber: usr['installment_number'] ?? 0,
        dueDate: DateTime.parse(usr['due_date'] ?? '1900-12-01'),
        statusId: usr['status_id'] ?? 1,
        value: usr['value'] ?? 0);
  }

  static List<Installment> getInstallment(List installments) {
    List<Installment> conInstallment = [];
    for (var installment in installments) {
      conInstallment.add(Installment.fromMap(installment));
    }
    return conInstallment;
  }
}
