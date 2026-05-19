import 'package:freezed_annotation/freezed_annotation.dart';

enum QuestionType {
  @JsonValue('input')
  shortText,
  @JsonValue('textarea')
  paragraph,
  @JsonValue('number')
  number,
  @JsonValue('password')
  password,
  @JsonValue('date')
  date,
  @JsonValue('time')
  time,
  @JsonValue('tel')
  tel,
  @JsonValue('calculate')
  calculate,
  @JsonValue('select')
  dropdown,
  @JsonValue('checkboxes')
  checkboxes,
  @JsonValue('radio')
  multipleChoice,
  @JsonValue('file_upload')
  fileUpload,
  @JsonValue('multi-file_upload')
  multiFileUpload,
  @JsonValue('file_picker')
  filePicker,
  @JsonValue('file_list')
  fileList,
  @JsonValue('email')
  email,
  @JsonValue('mobile')
  mobile,
  @JsonValue('url')
  url,
  @JsonValue('rating')
  rating,
  @JsonValue('signature')
  signature,
  @JsonValue('signature_pad')
  signaturePad,
  @JsonValue('slider')
  slider,
  @JsonValue('image')
  image,
  @JsonValue('image_gallery')
  imageGallery,
  @JsonValue('note')
  divider,
  @JsonValue('hidden')
  spacer,
  @JsonValue('matrix_choice')
  matrixChoice,
  @JsonValue('map_location')
  mapLocation,
  @JsonValue('address')
  address,
  @JsonValue('address_lookup')
  addressLookup,
  @JsonValue('otp')
  otp,
  @JsonValue('rich_text')
  richText,
  @JsonValue('markdown_editor')
  markdownEditor,
  @JsonValue('boolean')
  booleanValue,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('calculated')
  calculated,
  @JsonValue('custom_field')
  customField,
  @JsonValue('color_picker')
  colorPicker,
  @JsonValue('range')
  range,
  @JsonValue('date_range')
  dateRange,
  @JsonValue('time_range')
  timeRange,
  @JsonValue('stepper')
  stepper,
  @JsonValue('country_select')
  countrySelect,
  @JsonValue('state_select')
  stateSelect,
  @JsonValue('city_select')
  citySelect,
  @JsonValue('social_media_handle')
  socialMediaHandle,
  @JsonValue('website_url')
  websiteUrl,
  @JsonValue('phone_number')
  phoneNumber,
  @JsonValue('captcha')
  captcha,
  @JsonValue('unit_select')
  unitSelect,
  @JsonValue('price')
  price,
  @JsonValue('age')
  age,
  @JsonValue('toggle')
  toggle,
  @JsonValue('multi_checkbox')
  multiCheckbox,
  @JsonValue('email_list')
  emailList,
  @JsonValue('qr_code_scan')
  qrCodeScan,
  @JsonValue('search')
  search,
  @JsonValue('file')
  file,
}

extension QuestionTypeExtension on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.shortText:
        return 'Short Text';
      case QuestionType.paragraph:
        return 'Long Text';
      case QuestionType.number:
        return 'Number';
      case QuestionType.password:
        return 'Password';
      case QuestionType.date:
        return 'Date';
      case QuestionType.time:
        return 'Time';
      case QuestionType.tel:
        return 'Telephone';
      case QuestionType.calculate:
        return 'Calculate';
      case QuestionType.dropdown:
        return 'Dropdown';
      case QuestionType.checkboxes:
        return 'Checkboxes';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.fileUpload:
        return 'File Upload';
      case QuestionType.multiFileUpload:
        return 'Multi File Upload';
      case QuestionType.filePicker:
        return 'File Picker';
      case QuestionType.fileList:
        return 'File List';
      case QuestionType.email:
        return 'Email';
      case QuestionType.mobile:
        return 'Mobile';
      case QuestionType.url:
        return 'URL';
      case QuestionType.rating:
        return 'Rating';
      case QuestionType.signature:
        return 'Signature';
      case QuestionType.signaturePad:
        return 'Signature Pad';
      case QuestionType.slider:
        return 'Slider';
      case QuestionType.image:
        return 'Image';
      case QuestionType.imageGallery:
        return 'Image Gallery';
      case QuestionType.divider:
        return 'Divider';
      case QuestionType.spacer:
        return 'Spacer';
      case QuestionType.matrixChoice:
        return 'Matrix Choice';
      case QuestionType.mapLocation:
        return 'Map Location';
      case QuestionType.address:
        return 'Address';
      case QuestionType.addressLookup:
        return 'Address Lookup';
      case QuestionType.otp:
        return 'OTP';
      case QuestionType.richText:
        return 'Rich Text';
      case QuestionType.markdownEditor:
        return 'Markdown Editor';
      case QuestionType.booleanValue:
        return 'Boolean';
      case QuestionType.multiSelect:
        return 'Multi Select';
      case QuestionType.calculated:
        return 'Calculated';
      case QuestionType.customField:
        return 'Custom Field';
      case QuestionType.colorPicker:
        return 'Color Picker';
      case QuestionType.range:
        return 'Range';
      case QuestionType.dateRange:
        return 'Date Range';
      case QuestionType.timeRange:
        return 'Time Range';
      case QuestionType.stepper:
        return 'Stepper';
      case QuestionType.countrySelect:
        return 'Country Select';
      case QuestionType.stateSelect:
        return 'State Select';
      case QuestionType.citySelect:
        return 'City Select';
      case QuestionType.socialMediaHandle:
        return 'Social Media Handle';
      case QuestionType.websiteUrl:
        return 'Website URL';
      case QuestionType.phoneNumber:
        return 'Phone Number';
      case QuestionType.captcha:
        return 'Captcha';
      case QuestionType.unitSelect:
        return 'Unit Select';
      case QuestionType.price:
        return 'Price';
      case QuestionType.age:
        return 'Age';
      case QuestionType.toggle:
        return 'Toggle';
      case QuestionType.multiCheckbox:
        return 'Multi Checkbox';
      case QuestionType.emailList:
        return 'Email List';
      case QuestionType.qrCodeScan:
        return 'QR Code Scan';
      case QuestionType.search:
        return 'Search';
      case QuestionType.file:
        return 'File';
    }
  }
}
