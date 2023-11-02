class Appointment {
  final int appointmentId;
  final int activationId;
  final int statusId;
  final String status;
  final num value;
  final DateTime date;
  final DateTime endDate;

  Appointment(
      {required this.activationId,
      required this.appointmentId,
      required this.statusId,
      required this.status,
      required this.value,
      required this.date,
      required this.endDate});

  factory Appointment.fromMap(Map<String, dynamic> appointment) {
    return Appointment(
        appointmentId: appointment['id'] ?? 0,
        activationId:  appointment['activation_id'] ?? 0,
        statusId: appointment['status_id'],
        status: appointment['status'],
        date: DateTime.parse(appointment['date'] ?? '1900-12-01'),
        endDate: DateTime.parse(appointment['end_date'] ?? '1900-12-01'),
        value: appointment['value'] ?? 0.0);
  }

  static List<Appointment> fromArray(List appointments) {
    List<Appointment> appointmentList = [];
    for (var appointment in appointments) {
      appointmentList.add(Appointment.fromMap(appointment));
    }
    return appointmentList;
  }
}
