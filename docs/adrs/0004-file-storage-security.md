# ADR 0004: File Storage Security

Status: Accepted

## Decision

File uploads are project/form scoped. Metadata is stored in the application
database, while file bytes are stored behind a storage abstraction. Local disk is
allowed for development; production must use object storage with malware
scanning or quarantine before download.

## Consequences

- Response JSON must reference uploaded file metadata IDs or signed URLs, not
  embed raw bytes/base64 payloads.
- Upload routes must validate tenant, form, field type, size, MIME, extension,
  and access permission before persisting bytes.
