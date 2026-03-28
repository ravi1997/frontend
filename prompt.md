You previously generated a Postman collection for my backend. Now I want you to REWORK and UPGRADE THE ENTIRE COLLECTION.

Your task is to update the COMPLETE Postman collection so that:

1. every request has proper pre-request scripts where needed,
2. every request has proper post-response test scripts where needed,
3. every request with a vague, placeholder, fake, generic, schema-like, or incorrect body is replaced with a realistic request body,
4. the collection looks like it was designed for real backend testing, not just route listing.

IMPORTANT CONTEXT

- Backend base URL: <http://localhost:8051>
- This is a Flask + MongoDB-centered form backend.
- The project has many routes, including auth, forms, AI, analytics, templates, dashboards, external integrations, SMS, translations, permissions, user management, summarization, semantic search, and health routes. These routes were discovered from the project route output and existing collection draft. :contentReference[oaicite:0]{index=0} :contentReference[oaicite:1]{index=1}
- The current collection has many weak spots:
  - some requests have no scripts,
  - some bodies are `{}` only,
  - some bodies are fake schema dumps rather than realistic API payloads,
  - some DELETE requests incorrectly contain response-shaped bodies,
  - some routes have empty path variable values,
  - some requests look synthetic instead of runnable. :contentReference[oaicite:2]{index=2}

CRITICAL RULES

1. Do not skip any route already discovered.
2. Do not drop any request from the collection.
3. Do not leave vague bodies like `{}` if the endpoint logically needs input.
4. Do not use model/schema declarations as request bodies.
5. Do not use placeholder nonsense like `"typing.Literal[...]"`
6. Do not use response examples as request bodies.
7. Do not leave request bodies empty when the endpoint behavior clearly suggests it needs data.
8. Do not invent random structures blindly — infer realistic payloads from:
   - route names,
   - flow context,
   - auth logic,
   - existing data models,
   - route purpose,
   - related endpoints,
   - existing examples in the collection,
   - audited findings from the code review.
9. If an endpoint’s exact body cannot be proven, provide the most likely realistic payload and mark it with:
   - `"x_inference_level": "inferred"`
   - plus a note in the request description explaining the assumption.
10. Preserve route coverage.
11. Add both pre-request and test scripts where they make sense.
12. Use collection variables / environment variables properly.
13. Make the collection runnable in sequence as much as possible.
14. Do not modify source code. Only output Postman artifacts and documentation.

==================================================
PHASE 1 — AUDIT THE CURRENT COLLECTION
==================================================

Start by reviewing the current collection and identify all weak requests.

For every request, classify the current state:

- Good as-is
- Needs pre-request script
- Needs post-response test script
- Needs realistic request body
- Needs variable extraction
- Needs auth handling
- Needs path/query parameter defaults
- Needs chaining support
- Needs safer negative tests
- Needs description / notes
- Non-executable / partial / inference-based

Explicitly identify bad examples such as:

- `{}` bodies for POST endpoints that likely need structured input
- schema-definition bodies instead of request payloads
- DELETE requests with response-shaped bodies
- path params named badly like `:string:employee_id`
- empty IDs with no setup strategy
- missing token extraction after login
- missing assertions on status/body/content-type

==================================================
PHASE 2 — UPDATE EVERY REQUEST
==================================================

For EACH request in the Postman collection, revise it as needed.

A. REQUEST BODY QUALITY
If a request has a body, make it realistic.

Replace bad bodies with business-realistic payloads.
Examples of what I mean:

BAD:
{
  "id": "string",
  "created_at": "...",
  "updated_at": "...",
  "typing.Literal[...]": "..."
}

GOOD:
A realistic payload that a real client would send to that endpoint.

Rules for body updates:

1. Auth routes:
   - login, register, otp, reset password, change password, refresh
   - use believable user credentials and org/role data
2. Form routes:
   - use realistic form creation payloads
   - include title, slug, description, category, status, supported_languages, settings, etc. if relevant
3. AI routes:
   - use meaningful prompts, response IDs, search queries, summarization options, analysis options
4. Dashboard/widget routes:
   - use realistic widget metadata, layout, filters, chart config, dimensions
5. Templates/custom-fields:
   - use realistic field definitions, labels, variable names, validation, UI config, options
6. External mail/sms:
   - use realistic recipient/message/template payloads
7. Search / semantic / summarization:
   - use real query strings, thresholds, filters, date ranges, pagination fields
8. Translation routes:
   - use realistic source language / target language / translated content payloads
9. Permissions routes:
   - use realistic users/roles/access-policy payloads
10. User/admin routes:

- use realistic user profile update, role update, lock/unlock payloads

11. Avoid sending fields that should normally be server-generated unless the route clearly expects them.

If exact request shape is uncertain:

- infer the most realistic payload,
- explain why,
- mark it in description.

B. PRE-REQUEST SCRIPTS
Add pre-request scripts where needed.

Use them for:

- injecting Authorization header if access_token exists
- generating unique names/slugs/emails to avoid collisions
- ensuring required variables exist before request runs
- generating timestamps
- generating test mobile/email values
- deriving dependent payload values
- short-circuiting or clearly failing when prerequisite variables are missing

Examples of variables to maintain:

- access_token
- refresh_token
- form_id
- response_id
- template_id
- dashboard_id
- widget_id
- user_id
- search_id
- job_id
- organization_id
- template_slug
- created_email
- created_username

C. TEST SCRIPTS
Add post-response scripts for each request.

At minimum:

- assert status code
- assert JSON response where appropriate
- assert request did not silently HTML-fail
- assert key fields exist where relevant
- extract IDs/tokens where relevant
- validate error shape for negative tests
- store reusable values for later requests

Examples:

- login → store access_token and refresh_token
- register → store user_id / created_email
- create form → store form_id / slug
- create template → store template_id
- create dashboard → store dashboard_id
- create widget → store widget_id
- create translation job → store job_id
- create response/submission → store response_id
- create search-history item → store search_id if returned

==================================================
PHASE 3 — REALISTIC FLOW CHAINING
==================================================

Make the collection runnable across real flows.

Add or improve chaining for:

1. Register → Login → Authenticated routes
2. Create form → Fetch form → Preview → Validate → Publish → Export
3. Create custom field/template → Fetch → Delete
4. Create dashboard → Update → Fetch by slug
5. Create widget → Update → Reposition → Delete
6. AI routes dependent on form_id
7. Search-history create → list → delete item → clear all
8. User creation → fetch → update → lock/unlock → delete
9. Translation jobs → status → content → cancel/delete
10. SMS/mail utility routes if executable

If some IDs cannot be created because the supporting create route is missing, add:

- a request description,
- variable expectation,
- and test skip note.

==================================================
PHASE 4 — REQUEST-BY-REQUEST QUALITY STANDARDS
==================================================

For every request, enforce all applicable items below:

1. Name is clean and explicit
2. Correct HTTP method
3. Correct URL with variable usage
4. Correct path variables
5. Correct headers
6. Correct content type
7. Realistic body
8. Useful pre-request script
9. Useful test script
10. Description with:

- endpoint purpose
- prerequisites
- variables used
- inference note if needed

11. Example response expectations in test logic
2. Variable extraction if relevant

==================================================
PHASE 5 — FIX KNOWN BAD PATTERNS IN THE CURRENT COLLECTION
==================================================

Explicitly correct issues like these from the current draft:

1. Empty `{}` bodies on AI endpoints such as export/summarize/validate-design/generate/suggestions/search where more realistic inputs are likely needed. :contentReference[oaicite:3]{index=3}
2. Fake schema-like bodies in custom-fields and user update requests using internal model metadata rather than client payloads. :contentReference[oaicite:4]{index=4}
3. DELETE routes carrying response-shaped bodies such as deleted_count/message payloads in search-history delete requests. :contentReference[oaicite:5]{index=5}
4. Missing bodies on routes that likely need them, such as:
   - request-otp
   - dashboards create/update
   - templates create
   - external mail
   - external sms
   - dashboard settings update
   - dashboard widgets create/update
   - semantic/nlp search-related POST routes
   - translation save/preview/job creation routes if included
5. Missing token extraction and auth propagation after login/register.
6. Missing script coverage across the collection.

==================================================
PHASE 6 — USE PROJECT-SPECIFIC REALISM
==================================================

The bodies should reflect this project domain:

- enterprise/internal organization users
- forms/surveys/data capture
- healthcare / public-sector / operations style naming is acceptable
- multilingual support may exist
- complex forms may include validations, options, sections, translations, calculations, repeats, etc.
- some advanced features are only partially supported according to prior audit findings, so do not over-assume perfect support.

When building sample request bodies, prefer realistic examples like:

- hospital intake form
- employee grievance form
- inspection checklist
- household survey
- compliance audit form
- multilingual patient registration form
- dashboard widgets for submission trends / completion rates
- semantic search queries over response data
- summary generation over submitted responses

==================================================
PHASE 7 — OUTPUT FORMAT
==================================================

Your output must contain:

SECTION 1: Collection Upgrade Summary

- what was weak in the original collection
- what was fixed

SECTION 2: Request Improvement Matrix
For every request:

- request name
- issue(s) found
- body updated? yes/no
- pre-request added? yes/no
- test script added? yes/no
- inference used? yes/no
- notes

SECTION 3: Updated Postman Collection JSON

- full export-ready Postman collection v2.1 JSON
- include event scripts at collection/folder/request levels as needed
- do not provide pseudocode
- provide real JSON

SECTION 4: Updated Postman Environment JSON

- include all needed variables
- initialize blanks where appropriate

SECTION 5: Coverage Notes / Assumptions

- requests still inference-based
- routes requiring unavailable IDs/auth/setup
- manual-only cases
- non-destructive limitations

==================================================
SCRIPT QUALITY REQUIREMENTS
==================================================

Use practical Postman scripts like:

PRE-REQUEST EXAMPLES

- ensure access token exists for protected routes
- create unique email using timestamp
- create unique slug using sanitized title + timestamp
- assert prerequisite variables are present
- set defaults for optional variables

TEST SCRIPT EXAMPLES

- pm.test("Status code is 200/201/202/204", ...)
- parse JSON safely
- store tokens/ids if present
- store slug/template_id/dashboard_id/widget_id/job_id
- verify content-type includes application/json when expected
- verify error route returns expected status class
- tolerate 200/201/202 differences only when route design suggests it

==================================================
IMPORTANT BEHAVIOR
==================================================

1. Do not stop with analysis only.
2. Do not tell me what you could do next.
3. Actually produce the updated collection JSON.
4. Do not omit requests just because their bodies are uncertain.
5. If uncertain, infer carefully and label the inference.
6. Make the collection feel like a real QA artifact, not a route dump.

Start now by auditing the current collection, then output the fully updated Postman collection and environment.
