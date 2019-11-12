class TicketData {
  final String orderId;
  final String email;
  bool get filled => orderId != null && email != null;

  TicketData(this.orderId, this.email);
}
