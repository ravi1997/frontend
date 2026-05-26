# ridp_api.api.SectionApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsFormIdSectionsPost**](SectionApi.md#formapiv1formsformidsectionspost) | **POST** /form/api/v1/forms/{form_id}/sections | Add a new section to a form.
[**formApiV1ProjectsProjectIdFormsFormIdSectionsPost**](SectionApi.md#formapiv1projectsprojectidformsformidsectionspost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/sections | Add a new section to a form.


# **formApiV1FormsFormIdSectionsPost**
> formApiV1FormsFormIdSectionsPost(formId)

Add a new section to a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSectionApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdSectionsPost(formId);
} catch on DioError (e) {
    print('Exception when calling SectionApi->formApiV1FormsFormIdSectionsPost: $e\n');
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

# **formApiV1ProjectsProjectIdFormsFormIdSectionsPost**
> formApiV1ProjectsProjectIdFormsFormIdSectionsPost(formId)

Add a new section to a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSectionApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdSectionsPost(formId);
} catch on DioError (e) {
    print('Exception when calling SectionApi->formApiV1ProjectsProjectIdFormsFormIdSectionsPost: $e\n');
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

