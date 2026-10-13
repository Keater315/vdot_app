import 'dart:math';

double calculateVdot(double distance, String timeString) {
  List<String> timeParts = timeString.split(':');
  double minutes = double.parse(timeParts[0]);
  double seconds = double.parse(timeParts[1]);
  double time = minutes + seconds/60;
  double velocity = distance/time;
  double vsquared = pow(velocity, 2).toDouble();
  double vo2 = -4.60 + 0.182258*velocity + 0.000104*vsquared;
  double pctvo2max = 0.8 + 0.1894393*exp(-0.012778*time) + 0.2989558*exp(-0.1932605*time);
  double vdot = vo2/pctvo2max;
  return vdot;
  }

List<String> calculatePace(String difficulty, double vdot) {
  double tmin = 0.83;
  double tmax = 0.88;
  double imin = 0.95;
  double imax = 1;
  double rmin = 1.05;
  double rmax = 1.1;
  double lfrac = 0.95;
  double mfrac = 0.7;
  double hfrac = 0.425;
  double a = 0.000104;
  double b = 0.182258;
  if (difficulty == "hard") {
    double tpct = tmin + hfrac*(tmax-tmin);
    double ipct = imin + hfrac*(imax-imin);
    double rpct = rmin + hfrac*(rmax-rmin);
    double tvo2 = tpct*vdot;
    double ivo2 = ipct*vdot;
    double rvo2 = rpct*vdot;
    double tv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-tvo2)))/(2*a);
    double iv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-ivo2)))/(2*a);
    double rv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-rvo2)))/(2*a);
    double tmilemin = 1609.34/tv;
    int tminutes = tmilemin.floor();
    double tremainder = tmilemin - tminutes;
    int tseconds = (tremainder*60).toInt();
    String tpace = '$tminutes:${tseconds.toString().padLeft(2, '0')}';
    double imilemin = 1609.34/iv;
    int iminutes = imilemin.floor();
    double iremainder = imilemin - iminutes;
    int iseconds = (iremainder*60).toInt();
    String ipace = '$iminutes:${iseconds.toString().padLeft(2, '0')}';
    double rmilemin = 1609.34/rv;
    int rminutes = rmilemin.floor();
    double rremainder = rmilemin - rminutes;
    int rseconds = (rremainder*60).toInt();
    String rpace = '$rminutes:${rseconds.toString().padLeft(2, '0')}';
    return [tpace, ipace, rpace];
  }
  else if (difficulty == "mid") {
    double tpct = tmin + mfrac*(tmax-tmin);
    double ipct = imin + mfrac*(imax-imin);
    double rpct = rmin + mfrac*(rmax-rmin);
    double tvo2 = tpct*vdot;
    double ivo2 = ipct*vdot;
    double rvo2 = rpct*vdot;
    double tv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-tvo2)))/(2*a);
    double iv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-ivo2)))/(2*a);
    double rv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-rvo2)))/(2*a);
    double tmilemin = 1609.34/tv;
    int tminutes = tmilemin.floor();
    double tremainder = tmilemin - tminutes;
    int tseconds = (tremainder*60).toInt();
    String tpace = '$tminutes:${tseconds.toString().padLeft(2, '0')}';
    double imilemin = 1609.34/iv;
    int iminutes = imilemin.floor();
    double iremainder = imilemin - iminutes;
    int iseconds = (iremainder*60).toInt();
    String ipace = '$iminutes:${iseconds.toString().padLeft(2, '0')}';
    double rmilemin = 1609.34/rv;
    int rminutes = rmilemin.floor();
    double rremainder = rmilemin - rminutes;
    int rseconds = (rremainder*60).toInt();
    String rpace = '$rminutes:${rseconds.toString().padLeft(2, '0')}';
    return [tpace, ipace, rpace];
  }
  else if (difficulty == "light") {
    double tpct = tmin + lfrac*(tmax-tmin);
    double ipct = imin + lfrac*(imax-imin);
    double rpct = rmin + lfrac*(rmax-rmin);
    double tvo2 = tpct*vdot;
    double ivo2 = ipct*vdot;
    double rvo2 = rpct*vdot;
    double tv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-tvo2)))/(2*a);
    double iv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-ivo2)))/(2*a);
    double rv = (-b + sqrt(pow(b, 2).toDouble() - 4*a*(-4.6-rvo2)))/(2*a);
    double tmilemin = 1609.34/tv;
    int tminutes = tmilemin.floor();
    double tremainder = tmilemin - tminutes;
    int tseconds = (tremainder*60).toInt();
    String tpace = '$tminutes:${tseconds.toString().padLeft(2, '0')}';
    double imilemin = 1609.34/iv;
    int iminutes = imilemin.floor();
    double iremainder = imilemin - iminutes;
    int iseconds = (iremainder*60).toInt();
    String ipace = '$iminutes:${iseconds.toString().padLeft(2, '0')}';
    double rmilemin = 1609.34/rv;
    int rminutes = rmilemin.floor();
    double rremainder = rmilemin - rminutes;
    int rseconds = (rremainder*60).toInt();
    String rpace = '$rminutes:${rseconds.toString().padLeft(2, '0')}';
    return [tpace, ipace, rpace];
  }
  else {
    print('Invalid course difficulty. Use "hard, mid, or light".');
    return [];
  }
}