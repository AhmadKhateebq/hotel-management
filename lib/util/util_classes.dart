enum ROLE { customer, admin, reception }

class Role {
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
}
