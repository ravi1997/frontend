# Test Specification: Login OTP Verification Flow

## 1. Overview

- **Connected Feature**: M-16 OTP Login
- **Quality Goal**: Ensure secure and user-friendly mobile authentication.

## 2. Test Cases (Success Path)

| ID | Scenario | Input | Expected Output | Status |
| --- | --- | --- | --- | --- |
| TS-001 | Request OTP | Valid 10-digit mobile | Navigation to OTP Screen + Success Toast | |
| TS-002 | Verify OTP | Correct 6-digit OTP | Session established + Navigation to Dashboard | |
| TS-003 | Resend OTP | Timer expired + Click Resend | New OTP requested + Timer reset | |

## 3. Edge Cases & Error Handling

| ID | Scenario | Input | Expected Behavior |
| --- | --- | --- | --- |
| TE-001 | Invalid Mobile Format | "12345" | Validation error on text field |
| TE-002 | Wrong OTP | "000000" | Error shake animation + Snackbar "Invalid OTP" |
| TE-003 | Expired OTP | Valid OTP after 5 mins | Snackbar "OTP Expired" |
| TE-004 | Rapid Resend | Click resend < 30s | Button disabled |

## 4. Environment Requirements

- [x] `pinput` package for OTP input.
- [ ] Mock backend endpoints for `/auth/generate-otp` and `/auth/verify-otp`.

## 5. Security Validation

- [x] OTP should not be logged in plaintext.
- [x] Session token storage must be consistent with Email/Password flow.

## 6. Verification Command

`flutter test test/features/auth/otp_flow_test.dart`
