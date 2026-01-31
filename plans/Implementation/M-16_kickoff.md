# Feature Kickoff: Login OTP Verification Flow

## Name: Login OTP Verification Flow

## Linked Task: M-16

## Description

Implement a secondary login mechanism using Mobile Number and One-Time Password (OTP). This involves a two-step process: entering the mobile number to receive an OTP, and then verifying that OTP to establish a session.

## Implementation Plan

1. **AuthRepository Update**:
    * Add `generateOtp(String mobile)` method.
    * Add `verifyOtp(String mobile, String otp)` method.
2. **State Management**:
    * Extend `AuthController` to handle OTP-specific states (waiting for OTP, verifying, resend timer).
3. **UI Implementation**:
    * **Login Toggle**: Add a choice on `LoginScreen` between "Email" and "Mobile".
    * **Mobile Input**: Field for mobile number with validation.
    * **OTP Screen**: Create `OtpVerificationScreen` using the `pinput` package for a premium input experience.
    * **Resend Logic**: Add a countdown timer for OTP resending.
4. **Routing**: Add `/verify-otp` route to `AppRouter`.

## Tests

* [ ] **OTP Generation**: Verify API call to request OTP with a valid mobile number.
* [ ] **OTP Input UI**: Ensure `pinput` behaves correctly and handles auto-focus.
* [ ] **Successful Verification**: Verify mobile session establishment upon correct OTP entry.
* [ ] **Error Handling**: Handle invalid OTP, expired OTP, and rate limiting for resends.

## Checkpoints

* [ ] Repository methods implemented.
* [ ] OTP Screen UI complete.
* [ ] Resend timer logic working.
* [ ] Navigation flow integrated.
* [ ] Tests passing.
