# ridp_api.api.SectionApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdSectionsPost**](SectionApi.md#mahasangrahaapiv1projectsprojectidformsformidsectionspost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/sections | Add a new section to a form.


# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdSectionsPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdSectionsPost(formId)

Add a new section to a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSectionApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdSectionsPost(formId);
} on DioException catch (e) {
    print('Exception when calling SectionApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdSectionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

