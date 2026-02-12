# Authentication Flow Diagrams

## Overview
This document provides visual flow diagrams for all authentication scenarios in the Flutter frontend application.

---

## 1. Email/Password Login Flow

```
┌─────────────────┐
│  Login Screen   │
│  (Email Tab)    │
└────────┬────────┘
         │
         │ User enters email/password
         │ Clicks "Sign In"
         ▼
┌─────────────────┐
│ AuthController  │
│  .login()       │
└────────┬────────┘
         │
         │ POST /auth/login
         ▼
┌─────────────────┐
│ AuthRemoteSource│
│  API Call       │
└────────┬────────┘
         │
         ├─── Success ───┐
         │               │
         │               ▼
         │        ┌─────────────────┐
         │        │  Token Storage  │
         │        │  (Hive)         │
         │        └────────┬────────┘
         │                 │
         │                 ▼
         │        ┌─────────────────┐
         │        │ Get Current User│
         │        │ (User Entity)   │
         │        └────────┬────────┘
         │                 │
         │                 ▼
         │        ┌─────────────────┐
         │        │ Update State    │
         │        │ AsyncData<User> │
         │        └────────┬────────┘
         │                 │
         │                 ▼
         │        ┌─────────────────┐
         │        │  Navigate to    │
         │        │  Dashboard (/)  │
         │        └─────────────────┘
         │
         └─── Error ─────┐
                         │
                         ▼
                ┌─────────────────┐
                │  Update State   │
                │  AsyncError     │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │  Show Snackbar  │
                │  Error Message  │
                └─────────────────┘
```

---

## 2. Mobile/OTP Login Flow

```
┌─────────────────┐
│  Login Screen   │
│  (Mobile Tab)   │
└────────┬────────┘
         │
         │ User enters mobile number
         │ Clicks "Send OTP"
         ▼
┌─────────────────┐
│ AuthController  │
│  .generateOtp() │
└────────┬────────┘
         │
         │ POST /auth/generate-otp
         ▼
┌─────────────────┐
│ AuthRemoteSource│
│  API Call       │
└────────┬────────┘
         │
         ├─── Success ───┐
         │               │
         │               ▼
         │        ┌─────────────────┐
         │        │  Navigate to    │
         │        │  OTP Verify     │
         │        │  Screen         │
         │        └────────┬────────┘
         │                 │
         │                 ▼
         │        ┌─────────────────┐
         │        │ OTP Verification│
         │        │ Screen          │
         │        └────────┬────────┘
         │                 │
         │                 │ User enters 6-digit OTP
         │                 │ Auto-submit on completion
         │                 ▼
         │        ┌─────────────────┐
         │        │ AuthController  │
         │        │ .loginWithOtp() │
         │        └────────┬────────┘
         │                 │
         │                 │ POST /auth/login
         │                 ▼
         │        ┌─────────────────┐
         │        │ AuthRemoteSource│
         │        │  API Call       │
         │        └────────┬────────┘
         │                 │
         │                 ├─── Success ───┐
         │                 │               │
         │                 │               ▼
         │                 │        ┌─────────────────┐
         │                 │        │  Token Storage  │
         │                 │        │  (Hive)         │
         │                 │        └────────┬────────┘
         │                 │                 │
         │                 │                 ▼
         │                 │        ┌─────────────────┐
         │                 │        │ Get Current User│
         │                 │        └────────┬────────┘
         │                 │                 │
         │                 │                 ▼
         │                 │        ┌─────────────────┐
         │                 │        │  Navigate to    │
         │                 │        │  Dashboard      │
         │                 │        └─────────────────┘
         │                 │
         │                 └─── Error ─────┐
         │                                 │
         │                                 ▼
         │                        ┌─────────────────┐
         │                        │  Show Error     │
         │                        │  Snackbar       │
         │                        └─────────────────┘
         │
         └─── Error ─────┐
                         │
                         ▼
                ┌─────────────────┐
                │  Show Error     │
                │  Snackbar       │
                └─────────────────┘
```

---

## 3. OTP Resend Flow

```
┌─────────────────┐
│ OTP Verification│
│ Screen          │
└────────┬────────┘
         │
         │ Timer started at 30s
         │ Countdown display
         ▼
┌─────────────────┐
│ OtpController   │
│  startTimer()   │
└────────┬────────┘
         │
         │ Every 1 second
         │ state--
         ▼
┌─────────────────┐
│  Timer Count    │
│  30...29...28   │
└────────┬────────┘
         │
         ├─── Timer > 0 ──┐
         │                │
         │                ▼
         │        ┌─────────────────┐
         │        │ "Resend in Xs"  │
         │        │  (Disabled)     │
         │        └─────────────────┘
         │
         └─── Timer = 0 ──┐
                          │
                          ▼
                 ┌─────────────────┐
                 │  "Resend" Link  │
                 │  (Enabled)      │
                 └────────┬────────┘
                          │
                          │ User clicks "Resend"
                          ▼
                 ┌─────────────────┐
                 │ OtpController   │
                 │  .resendOtp()   │
                 └────────┬────────┘
                          │
                          │ POST /auth/generate-otp
                          ▼
                 ┌─────────────────┐
                 │ AuthRemoteSource│
                 └────────┬────────┘
                          │
                          ├─── Success ───┐
                          │               │
                          │               ▼
                          │        ┌─────────────────┐
                          │        │  Start Timer    │
                          │        │  (30s)          │
                          │        └─────────────────┘
                          │
                          └─── Error ─────┐
                                          │
                                          ▼
                                 ┌─────────────────┐
                                 │  Show Error     │
                                 └─────────────────┘
```

---

## 4. Registration Flow

```
┌─────────────────┐
│ Register Screen │
└────────┬────────┘
         │
         │ User fills form:
         │ - Username
         │ - Email
         │ - Employee ID (optional)
         │ - Mobile
         │ - Password
         │ - Confirm Password
         │
         │ Clicks "Create Account"
         ▼
┌─────────────────┐
│  Client-side    │
│  Validation     │
└────────┬────────┘
         │
         ├─── Password Mismatch ─┐
         │                       │
         │                       ▼
         │              ┌─────────────────┐
         │              │  Show Error     │
         │              │  "Passwords do  │
         │              │   not match"    │
         │              └─────────────────┘
         │
         └─── Valid ────┐
                        │
                        ▼
               ┌─────────────────┐
               │ AuthController  │
               │  .register()    │
               └────────┬────────┘
                        │
                        │ Determine user_type:
                        │ employee_id.isEmpty ? 'general' : 'employee'
                        │
                        │ POST /auth/register
                        ▼
               ┌─────────────────┐
               │ AuthRemoteSource│
               │  API Call       │
               └────────┬────────┘
                        │
                        ├─── Success ───┐
                        │               │
                        │               ▼
                        │        ┌─────────────────┐
                        │        │  Update State   │
                        │        │  AsyncData(null)│
                        │        └────────┬────────┘
                        │                 │
                        │                 ▼
                        │        ┌─────────────────┐
                        │        │  Show Snackbar  │
                        │        │  "Account       │
                        │        │   created!"     │
                        │        └────────┬────────┘
                        │                 │
                        │                 ▼
                        │        ┌─────────────────┐
                        │        │  Navigate to    │
                        │        │  Login Screen   │
                        │        └─────────────────┘
                        │
                        └─── Error ─────┐
                                        │
                                        ▼
                               ┌─────────────────┐
                               │  Update State   │
                               │  AsyncError     │
                               └────────┬────────┘
                                        │
                                        ▼
                               ┌─────────────────┐
                               │  Show Snackbar  │
                               │  Error Message  │
                               └─────────────────┘
```

---

## 5. Forgot Password Flow

```
┌─────────────────┐
│ Forgot Password │
│ Screen          │
└────────┬────────┘
         │
         │ User enters email
         │ Clicks "Reset Password"
         ▼
┌─────────────────┐
│ AuthController  │
│ .requestPassword│
│ Reset()         │
└────────┬────────┘
         │
         │ POST /auth/request-password-reset
         ▼
┌─────────────────┐
│ AuthRemoteSource│
│  API Call       │
└────────┬────────┘
         │
         ├─── Success ───┐
         │               │
         │               ▼
         │        ┌─────────────────┐
         │        │  Show Snackbar  │
         │        │  "Reset link    │
         │        │   sent to email"│
         │        └────────┬────────┘
         │                 │
         │                 │ Wait 2 seconds
         │                 ▼
         │        ┌─────────────────┐
         │        │  Navigate to    │
         │        │  Login Screen   │
         │        └─────────────────┘
         │
         └─── Error ─────┐
                         │
                         ▼
                ┌─────────────────┐
                │  Show Error     │
                │  Snackbar       │
                └─────────────────┘
```

---

## 6. Logout Flow

```
┌─────────────────┐
│  Any Screen     │
│  (Authenticated)│
└────────┬────────┘
         │
         │ User clicks "Logout"
         ▼
┌─────────────────┐
│ AuthController  │
│  .logout()      │
└────────┬────────┘
         │
         │ POST /auth/logout
         ▼
┌─────────────────┐
│ AuthRemoteSource│
│  API Call       │
└────────┬────────┘
         │
         │ Success or Error (both proceed)
         ▼
┌─────────────────┐
│  Clear Tokens   │
│  (TokenService) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Update State   │
│  AsyncData(null)│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Router Refresh │
│  (Auto-redirect │
│   to /login)    │
└─────────────────┘
```

---

## 7. Route Guard Flow

```
┌─────────────────┐
│  App Router     │
│  (GoRouter)     │
└────────┬────────┘
         │
         │ Navigation request
         │ (e.g., context.go('/'))
         ▼
┌─────────────────┐
│  redirect()     │
│  callback       │
└────────┬────────┘
         │
         │ Watch authControllerProvider
         ▼
┌─────────────────┐
│  Check Auth     │
│  State          │
└────────┬────────┘
         │
         ├─── Loading State ──┐
         │                    │
         │                    ▼
         │           ┌─────────────────┐
         │           │  return null    │
         │           │  (no redirect)  │
         │           └─────────────────┘
         │
         ├─── Authenticated + Auth Path ─┐
         │                               │
         │                               ▼
         │                      ┌─────────────────┐
         │                      │  return '/'     │
         │                      │  (dashboard)    │
         │                      └─────────────────┘
         │
         ├─── Not Authenticated + Protected Path ─┐
         │                                        │
         │                                        ▼
         │                               ┌─────────────────┐
         │                               │  return '/login'│
         │                               └─────────────────┘
         │
         └─── Valid Request ──┐
                              │
                              ▼
                     ┌─────────────────┐
                     │  return null    │
                     │  (proceed)      │
                     └─────────────────┘
```

---

## 8. Token Management Flow

```
┌─────────────────┐
│  Login Success  │
└────────┬────────┘
         │
         │ Response: { access_token, refresh_token? }
         ▼
┌─────────────────┐
│  TokenService   │
│  .setTokens()   │
└────────┬────────┘
         │
         │ Store in Hive
         ▼
┌─────────────────┐
│  Local Storage  │
│  (Hive Box)     │
└────────┬────────┘
         │
         │ Tokens persisted
         ▼
┌─────────────────┐
│  Future API     │
│  Requests       │
└────────┬────────┘
         │
         │ Dio interceptor
         ▼
┌─────────────────┐
│ AuthInterceptor │
│ adds header:    │
│ Authorization:  │
│ Bearer <token>  │
└────────┬────────┘
         │
         ├─── Request Success ──┐
         │                      │
         │                      ▼
         │             ┌─────────────────┐
         │             │  API Response   │
         │             └─────────────────┘
         │
         └─── 401 Unauthorized ─┐
                                │
                                ▼
                       ┌─────────────────┐
                       │  Clear Tokens   │
                       │  Logout User    │
                       └────────┬────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │  Redirect to    │
                       │  Login          │
                       └─────────────────┘
```

---

## 9. State Management Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │   Login     │  │  Register   │  │  OTP Verify │    │
│  │   Screen    │  │   Screen    │  │   Screen    │    │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘    │
│         │                │                │            │
│         └────────────────┼────────────────┘            │
│                          │                             │
│                          ▼                             │
│            ┌──────────────────────────┐                │
│            │   AuthController         │                │
│            │   (Riverpod Provider)    │                │
│            │   State: AsyncValue<User>│                │
│            └────────────┬─────────────┘                │
│                         │                              │
└─────────────────────────┼──────────────────────────────┘
                          │
┌─────────────────────────┼──────────────────────────────┐
│                    Domain Layer                         │
├─────────────────────────┼──────────────────────────────┤
│                         │                              │
│                         ▼                              │
│            ┌──────────────────────────┐                │
│            │   AuthRepository         │                │
│            │   (Interface)            │                │
│            └────────────┬─────────────┘                │
│                         │                              │
│                         ▼                              │
│            ┌──────────────────────────┐                │
│            │   User Entity            │                │
│            │   (Freezed)              │                │
│            └──────────────────────────┘                │
│                                                         │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────┼───────────────────────────────┐
│                    Data Layer                            │
├─────────────────────────┼───────────────────────────────┤
│                         │                               │
│                         ▼                               │
│            ┌──────────────────────────┐                 │
│            │  AuthRepositoryImpl      │                 │
│            │  (Implementation)        │                 │
│            └────────────┬─────────────┘                 │
│                         │                               │
│         ┌───────────────┼───────────────┐               │
│         │               │               │               │
│         ▼               ▼               ▼               │
│  ┌──────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  Auth    │  │  Token       │  │  Dio         │     │
│  │  Remote  │  │  Service     │  │  HTTP        │     │
│  │  Source  │  │  (Hive)      │  │  Client      │     │
│  └──────────┘  └──────────────┘  └──────────────┘     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 10. Complete User Journey Map

```
┌────────────┐
│  App Start │
└──────┬─────┘
       │
       ▼
┌────────────────┐
│ Check Token    │
│ (TokenService) │
└────────┬───────┘
         │
         ├─── No Token ─────────┐
         │                      │
         │                      ▼
         │             ┌─────────────────┐
         │             │  Login Screen   │
         │             └────────┬────────┘
         │                      │
         │                      ├─── Email/Password ───┐
         │                      │                      │
         │                      │                      ▼
         │                      │             ┌─────────────────┐
         │                      │             │  Enter Creds    │
         │                      │             │  → Login        │
         │                      │             │  → Dashboard    │
         │                      │             └─────────────────┘
         │                      │
         │                      └─── Mobile/OTP ───┐
         │                                         │
         │                                         ▼
         │                                ┌─────────────────┐
         │                                │  Enter Mobile   │
         │                                │  → OTP Screen   │
         │                                │  → Enter OTP    │
         │                                │  → Login        │
         │                                │  → Dashboard    │
         │                                └─────────────────┘
         │
         └─── Has Token ───┐
                           │
                           ▼
                  ┌─────────────────┐
                  │  Get Current    │
                  │  User           │
                  └────────┬────────┘
                           │
                           ├─── Success ───┐
                           │               │
                           │               ▼
                           │      ┌─────────────────┐
                           │      │  Dashboard      │
                           │      │  (Authenticated)│
                           │      └────────┬────────┘
                           │               │
                           │               ├─── Create Forms
                           │               ├─── View Responses
                           │               ├─── Analytics
                           │               └─── Logout ──┐
                           │                             │
                           │                             ▼
                           │                    ┌─────────────────┐
                           │                    │  Clear Tokens   │
                           │                    │  → Login Screen │
                           │                    └─────────────────┘
                           │
                           └─── Error ───┐
                                         │
                                         ▼
                                ┌─────────────────┐
                                │  Clear Tokens   │
                                │  → Login Screen │
                                └─────────────────┘

┌────────────────────────────────────────────────────────┐
│  Additional Paths:                                     │
│                                                        │
│  • Forgot Password: Login → Forgot Password →         │
│    Email Reset Link → Check Email → Login             │
│                                                        │
│  • New User: Login → Register → Fill Form →           │
│    Success → Login → Dashboard                        │
│                                                        │
│  • Session Expired: Any Screen → 401 Error →          │
│    Clear Tokens → Login Screen                        │
└────────────────────────────────────────────────────────┘
```

---

## Screen Navigation Map

```
                        ┌─────────────────┐
                   ┌────│  Login Screen   │────┐
                   │    └─────────────────┘    │
                   │                           │
        "Sign up"  │                           │  "Forgot password?"
                   │                           │
                   ▼                           ▼
        ┌─────────────────┐         ┌─────────────────┐
        │ Register Screen │         │ Forgot Password │
        └────────┬────────┘         │     Screen      │
                 │                  └────────┬────────┘
                 │                           │
        Success  │                           │  Success (2s delay)
                 │                           │
                 ▼                           ▼
        ┌─────────────────┐         ┌─────────────────┐
        │  Login Screen   │◄────────│  Login Screen   │
        └────────┬────────┘         └─────────────────┘
                 │
                 │  Mobile Tab → Send OTP
                 │
                 ▼
        ┌─────────────────┐
        │ OTP Verification│
        │     Screen      │
        └────────┬────────┘
                 │
                 │  OTP Verified
                 │
                 ▼
        ┌─────────────────┐
        │   Dashboard     │
        │   (Protected)   │
        └─────────────────┘
```

---

**Document Created**: February 11, 2026
**Developer**: Lucas Chen
**Purpose**: Visual reference for authentication flows
