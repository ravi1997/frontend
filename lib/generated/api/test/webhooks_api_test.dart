import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for WebhooksApi
void main() {
  final instance = RidpApi().getWebhooksApi();

  group(WebhooksApi, () {
    // Trigger webhook delivery. Restricted to managers and above.
    //
    //Future formApiV1WebhooksDeliverPost() async
    test('test formApiV1WebhooksDeliverPost', () async {
      // TODO
    });

    // Admin only: Cancel a pending/retrying delivery.
    //
    //Future formApiV1WebhooksDeliveryIdCancelDelete(String deliveryId) async
    test('test formApiV1WebhooksDeliveryIdCancelDelete', () async {
      // TODO
    });

    // View system-wide or specific delivery history. Manager restricted.
    //
    //Future formApiV1WebhooksDeliveryIdHistoryGet() async
    test('test formApiV1WebhooksDeliveryIdHistoryGet', () async {
      // TODO
    });

    // Admin only: Manually retry a failed delivery.
    //
    //Future formApiV1WebhooksDeliveryIdRetryPost(String deliveryId) async
    test('test formApiV1WebhooksDeliveryIdRetryPost', () async {
      // TODO
    });

    // View status of a specific delivery.
    //
    //Future formApiV1WebhooksDeliveryIdStatusGet(String deliveryId) async
    test('test formApiV1WebhooksDeliveryIdStatusGet', () async {
      // TODO
    });

    // View system-wide or specific delivery history. Manager restricted.
    //
    //Future formApiV1WebhooksHistoryGet() async
    test('test formApiV1WebhooksHistoryGet', () async {
      // TODO
    });

    // Admin only: Retrieve low-level delivery logs.
    //
    //Future formApiV1WebhooksLogsGet() async
    test('test formApiV1WebhooksLogsGet', () async {
      // TODO
    });

    // Admin only: Test webhook delivery to a specific URL.
    //
    //Future formApiV1WebhooksTestPost() async
    test('test formApiV1WebhooksTestPost', () async {
      // TODO
    });

  });
}
