# ridp_api.api.SectionHooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsFormIdSectionsSectionIdHooksTriggerPost**](SectionHooksApi.md#formapiv1formsformidsectionssectionidhookstriggerpost) | **POST** /form/api/v1/forms/{form_id}/sections/{section_id}/hooks/trigger | Synchronously trigger all hooks for a section
[**formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost**](SectionHooksApi.md#formapiv1projectsprojectidformsformidsectionssectionidhookstriggerpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/sections/{section_id}/hooks/trigger | Synchronously trigger all hooks for a section


# **formApiV1FormsFormIdSectionsSectionIdHooksTriggerPost**
> formApiV1FormsFormIdSectionsSectionIdHooksTriggerPost(formId, sectionId, body)

Synchronously trigger all hooks for a section

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSectionHooksApi();
final String formId = formId_example; // String | 
final String sectionId = sectionId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1FormsFormIdSectionsSectionIdHooksTriggerPost(formId, sectionId, body);
} catch on DioError (e) {
    print('Exception when calling SectionHooksApi->formApiV1FormsFormIdSectionsSectionIdHooksTriggerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **sectionId** | **String**|  | 
 **body** | **Object**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost**
> formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost(formId, sectionId, body)

Synchronously trigger all hooks for a section

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSectionHooksApi();
final String formId = formId_example; // String | 
final String sectionId = sectionId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost(formId, sectionId, body);
} catch on DioError (e) {
    print('Exception when calling SectionHooksApi->formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **sectionId** | **String**|  | 
 **body** | **Object**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

