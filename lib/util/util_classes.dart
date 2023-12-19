

enum ROLE {
  customer,
  admin,
  reception,
}

enum STATUS { pending, approved, denied, reserved }
class RoleUtil {
  static const customer = ROLE.customer;
  static const admin = ROLE.admin;
  static const resp = ROLE.reception;

  static ROLE fromString(String str) {
    if (str == 'customer') {
      return customer;
    } else if (str == 'admin') {
      return admin;
    } else if (str == 'reception') {
      return resp;
    } else {
      return customer;
    }
  }

  static String roleToString(ROLE role) {
    if (role == ROLE.customer) {
      return 'customer';
    } else if (role == ROLE.admin) {
      return 'admin';
    } else if (role == ROLE.reception) {
      return 'reception';
    } else {
      return 'customer';
    }
  }
}

class StatusUtil {
  static STATUS getStatus(String status) => status == 'reserved'
      ? STATUS.reserved
      : status == 'approved'
          ? STATUS.approved
          : status == 'denied'
              ? STATUS.denied
              : STATUS.pending;

  static String getStatusString(STATUS status) => status == STATUS.reserved
      ? 'reserved'
      : status == STATUS.approved
          ? 'approved'
          : status == STATUS.denied
              ? 'denied'
              : 'pending';
}

