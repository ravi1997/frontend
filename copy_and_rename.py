import re

with open('lib/features/form_builder/presentation/pages/form_preview_page.dart', 'r') as f:
    content = f.read()

# Replacements
content = content.replace('FormPreviewPage', 'FormSubmitPage')
content = content.replace('previewFormDataProvider', 'submitFormDataProvider')
content = content.replace('_PreviewSectionWidget', '_SubmitSectionWidget')
content = content.replace('_PreviewFieldWidget', '_SubmitFieldWidget')
content = content.replace('PREVIEW MODE', '')
content = content.replace("Preview Mode: Workflows (Email/Slack) will be simulated in logs.", "")
content = content.replace("Close Preview", "Close")

with open('lib/features/form_builder/presentation/pages/form_submit_page.dart', 'w') as f:
    f.write(content)

