
class Validator {

    // Validate email
    String validateEmail(String value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Please enter a valid email';
        else
          return null;  // returning null indicates the validation has passed
      }

      // Validate password
      String validatePassword(String value) {
        if (value.length < 8) {
          return 'Must be at least 8 characters';
        } else
          return null;  // returning null indicates the validation passed
      }


} // end of class