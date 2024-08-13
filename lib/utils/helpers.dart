String kelvintocelcius(double k) {
  try {
    const double toCelcius = 273.15;
    return "${(k - toCelcius).toStringAsFixed(2)} °C";
  } catch (e) {
    rethrow;
  }
}
