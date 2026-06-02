enum QuestionType {
  shortText,
  paragraph,
  multipleChoice,
  checkboxes,
  dropdown,
  fileUpload,
  multiFileUpload,
  filePicker,
  fileList,
  signaturePad,
  imageGallery,
  divider,
  spacer,
  matrixChoice,
  mapLocation,
  addressLookup,
  richText,
  markdownEditor,
  booleanValue,
  multiSelect,
  customField,
  colorPicker,
  dateRange,
  timeRange,
  countrySelect,
  stateSelect,
  citySelect,
  socialMediaHandle,
  websiteUrl,
  phoneNumber,
  unitSelect,
  multiCheckbox,
  emailList,
  qrCodeScan,
  time,
  rating,
  date,
  number,
  mobile,
  email,
  // Additional types
  image,
  slider,
  signature,
  otp,
  address,
  toggle,
  password,
  tel,
  url,
  calculate,
  calculated,
  range,
  stepper,
  captcha,
  price,
  age,
  search,
  file,
}

extension QuestionTypeLabel on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.shortText:
        return 'Short Text';
      case QuestionType.paragraph:
        return 'Paragraph';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.checkboxes:
        return 'Checkboxes';
      case QuestionType.dropdown:
        return 'Dropdown';
      case QuestionType.fileUpload:
        return 'File Upload';
      case QuestionType.multiFileUpload:
        return 'Multi File Upload';
      case QuestionType.filePicker:
        return 'File Picker';
      case QuestionType.fileList:
        return 'File List';
      case QuestionType.signaturePad:
        return 'Signature Pad';
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
      case QuestionType.addressLookup:
        return 'Address Lookup';
      case QuestionType.richText:
        return 'Rich Text';
      case QuestionType.markdownEditor:
        return 'Markdown Editor';
      case QuestionType.booleanValue:
        return 'Boolean';
      case QuestionType.multiSelect:
        return 'Multi Select';
      case QuestionType.customField:
        return 'Custom Field';
      case QuestionType.colorPicker:
        return 'Color Picker';
      case QuestionType.dateRange:
        return 'Date Range';
      case QuestionType.timeRange:
        return 'Time Range';
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
      case QuestionType.unitSelect:
        return 'Unit Select';
      case QuestionType.multiCheckbox:
        return 'Multi Checkbox';
      case QuestionType.emailList:
        return 'Email List';
      case QuestionType.qrCodeScan:
        return 'QR Code Scan';
      case QuestionType.time:
        return 'Time';
      case QuestionType.rating:
        return 'Rating';
      case QuestionType.date:
        return 'Date';
      case QuestionType.number:
        return 'Number';
      case QuestionType.mobile:
        return 'Mobile';
      case QuestionType.email:
        return 'Email';
      case QuestionType.image:
        return 'Image';
      case QuestionType.slider:
        return 'Slider';
      case QuestionType.signature:
        return 'Signature';
      case QuestionType.otp:
        return 'OTP';
      case QuestionType.address:
        return 'Address';
      case QuestionType.toggle:
        return 'Toggle';
      case QuestionType.password:
        return 'Password';
      case QuestionType.tel:
        return 'Telephone';
      case QuestionType.url:
        return 'URL';
      case QuestionType.calculate:
        return 'Calculate';
      case QuestionType.calculated:
        return 'Calculated';
      case QuestionType.range:
        return 'Range';
      case QuestionType.stepper:
        return 'Stepper';
      case QuestionType.captcha:
        return 'Captcha';
      case QuestionType.price:
        return 'Price';
      case QuestionType.age:
        return 'Age';
      case QuestionType.search:
        return 'Search';
      case QuestionType.file:
        return 'File';
    }
  }
}
