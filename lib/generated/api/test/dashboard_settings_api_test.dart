import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for DashboardSettingsApi
void main() {
  final instance = RidpApi().getDashboardSettingsApi();

  group(DashboardSettingsApi, () {
    // Update only the layout configuration.  Request Body:     {         \"columns\": 4,         \"rowHeight\": 120,         \"margin\": [15, 15],         \"compactType\": \"vertical\",         \"positions\": {             \"widget_id_1\": {\"x\": 0, \"y\": 0}         }     }  Returns:     200: Updated settings object     400: Validation error     401: Unauthorized
    //
    //Future formApiV1DashboardSettingsLayoutPut() async
    test('test formApiV1DashboardSettingsLayoutPut', () async {
      // TODO
    });

    // Reset user dashboard settings to defaults.
    //
    //Future formApiV1DashboardSettingsResetPost() async
    test('test formApiV1DashboardSettingsResetPost', () async {
      // TODO
    });

    // Get user dashboard settings.
    //
    //Future formApiV1DashboardSettingsSettingsGet() async
    test('test formApiV1DashboardSettingsSettingsGet', () async {
      // TODO
    });

    // Update user dashboard settings.
    //
    //Future formApiV1DashboardSettingsSettingsPut() async
    test('test formApiV1DashboardSettingsSettingsPut', () async {
      // TODO
    });

    // Get list of available widget types.
    //
    //Future formApiV1DashboardSettingsWidgetsGet() async
    test('test formApiV1DashboardSettingsWidgetsGet', () async {
      // TODO
    });

    // Update positions for multiple widgets.  Used for drag-and-drop reordering of widgets.  Request Body:     {         \"positions\": {             \"widget_id_1\": {\"x\": 0, \"y\": 0},             \"widget_id_2\": {\"x\": 2, \"y\": 0}         }     }  Returns:     200: List of updated widgets     400: Validation error     401: Unauthorized
    //
    //Future formApiV1DashboardSettingsWidgetsPositionsPut() async
    test('test formApiV1DashboardSettingsWidgetsPositionsPut', () async {
      // TODO
    });

    //Future formApiV1DashboardSettingsWidgetsPost() async
    test('test formApiV1DashboardSettingsWidgetsPost', () async {
      // TODO
    });

    // Remove a widget from the user's dashboard.  Args:     widget_id: ID of the widget to remove  Returns:     200: Success message     404: Widget not found     401: Unauthorized
    //
    //Future formApiV1DashboardSettingsWidgetsWidgetIdDelete(String widgetId) async
    test('test formApiV1DashboardSettingsWidgetsWidgetIdDelete', () async {
      // TODO
    });

    // Update a widget's configuration.  Args:     widget_id: ID of the widget to update  Request Body:     {         \"position\": {\"x\": 0, \"y\": 4},  // Optional new position         \"size\": {\"w\": 2, \"h\": 2},      // Optional new size         \"config\": {...},               // Optional config updates         \"is_visible\": True             // Optional visibility     }  Returns:     200: Updated widget object     404: Widget not found     401: Unauthorized
    //
    //Future formApiV1DashboardSettingsWidgetsWidgetIdPut(String widgetId) async
    test('test formApiV1DashboardSettingsWidgetsWidgetIdPut', () async {
      // TODO
    });

  });
}
