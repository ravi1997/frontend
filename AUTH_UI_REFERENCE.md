# Authentication UI Reference Guide

## Visual Design Reference
This document provides detailed descriptions of each authentication screen's UI layout and design.

---

## 1. Login Screen

### Layout
```
┌──────────────────────────────────────┐
│                                      │
│         [Welcome Back]               │
│    Sign in to your account to        │
│           continue                   │
│                                      │
│  ┌──────────────────────────────┐   │
│  │  [Email] 📧  │  Mobile 📱    │   │  ← Tab Switcher
│  └──────────────────────────────┘   │
│                                      │
│  Email                               │
│  ┌──────────────────────────────┐   │
│  │ you@example.com              │   │
│  └──────────────────────────────┘   │
│                                      │
│  Password        Forgot password?    │
│  ┌──────────────────────────────┐   │
│  │ ••••••••                     │   │
│  └──────────────────────────────┘   │
│                                      │
│  ┌──────────────────────────────┐   │
│  │        Sign In               │   │  ← Button
│  └──────────────────────────────┘   │
│                                      │
│  Don't have an account? Sign up      │
│                                      │
└──────────────────────────────────────┘
```

### Color Scheme
- **Background**: White (#FFFFFF)
- **Card**: White with subtle shadow
- **Brand Color**: Blue (#3B82F6)
- **Text**: Dark slate (#1E293B)
- **Border**: Light gray (#E2E8F0)
- **Input Background**: White (#FFFFFF)

### Mobile Tab View
```
┌──────────────────────────────────────┐
│                                      │
│         [Welcome Back]               │
│    Sign in to your account to        │
│           continue                   │
│                                      │
│  ┌──────────────────────────────┐   │
│  │  Email 📧  │  [Mobile] 📱    │   │  ← Mobile tab active
│  └──────────────────────────────┘   │
│                                      │
│  Mobile Number                       │
│  ┌──────────────────────────────┐   │
│  │ 9876543210                   │   │
│  └──────────────────────────────┘   │
│                                      │
│  Enter your 10-digit mobile number   │
│  to receive OTP                      │
│                                      │
│  ┌──────────────────────────────┐   │
│  │        Send OTP              │   │
│  └──────────────────────────────┘   │
│                                      │
│  Don't have an account? Sign up      │
│                                      │
└──────────────────────────────────────┘
```

### Responsive Behavior
- **Max Width**: 440px
- **Padding**: 24px (mobile), 32px horizontal + 48px vertical (card)
- **Center aligned** on large screens
- **Full width** on mobile with safe padding

---

## 2. Registration Screen

### Layout
```
┌──────────────────────────────────────┐
│                                      │
│        [Create Account]              │
│   Sign up to start creating and      │
│      managing forms                  │
│                                      │
│  Username                            │
│  ┌──────────────────────────────┐   │
│  │ johndoe                      │   │
│  └──────────────────────────────┘   │
│                                      │
│  Email                               │
│  ┌──────────────────────────────┐   │
│  │ you@example.com              │   │
│  └──────────────────────────────┘   │
│                                      │
│  Employee ID (Optional)              │
│  ┌──────────────────────────────┐   │
│  │ EMP12345                     │   │
│  └──────────────────────────────┘   │
│                                      │
│  Mobile Number                       │
│  ┌──────────────────────────────┐   │
│  │ 9876543210                   │   │
│  └──────────────────────────────┘   │
│                                      │
│  Password                            │
│  ┌──────────────────────────────┐   │
│  │ ••••••••                     │   │
│  └──────────────────────────────┘   │
│  Must be 8+ characters with          │
│  uppercase, number, and special      │
│  character                           │
│                                      │
│  Confirm Password                    │
│  ┌──────────────────────────────┐   │
│  │ ••••••••                     │   │
│  └──────────────────────────────┘   │
│                                      │
│  ┌──────────────────────────────┐   │
│  │     Create Account           │   │
│  └──────────────────────────────┘   │
│                                      │
│  Already have an account? Sign in    │
│                                      │
└──────────────────────────────────────┘
```

### Design Features
- **Max Width**: 480px
- **Spacing**: 20px between fields
- **Helper Text**: Password requirements shown in gray
- **Validation**: Real-time password matching check
- **Loading State**: Spinner replaces button text during registration

---

## 3. OTP Verification Screen

### Layout
```
┌──────────────────────────────────────┐
│  ←                                   │  ← Back button
│                                      │
│         ┌───────┐                    │
│         │  📱  │                     │  ← Phone icon
│         └───────┘                    │
│                                      │
│       [Verify Mobile]                │
│                                      │
│   We have sent a 6-digit code to    │
│        +91 9876543210               │
│                                      │
│                                      │
│    ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐  │
│    │ 1 │ │ 2 │ │ 3 │ │ 4 │ │ 5 │ │ 6 │  │  ← OTP Input
│    └───┘ └───┘ └───┘ └───┘ └───┘ └───┘  │
│                                      │
│                                      │
│                                      │
│   Didn't receive code?               │
│   Resend in 15s                      │  ← Countdown
│                                      │
└──────────────────────────────────────┘
```

### OTP Input States

**Focused**:
```
┌───┐
│ 1│█  ← Blue border (2px)
└───┘
```

**Submitted**:
```
┌───┐
│ 1 │  ← White background
└───┘
```

**Default**:
```
┌───┐
│   │  ← Light gray border
└───┘
```

### Timer States

**Active (counting down)**:
```
Didn't receive code? Resend in 15s
                     ────────────
                     Gray, disabled
```

**Expired (ready to resend)**:
```
Didn't receive code? Resend
                     ──────
                     Blue, clickable
```

### Design Features
- **Pin Length**: 6 digits
- **Auto-submit**: On completion
- **Pin Size**: 56x56px
- **Spacing**: 8px between pins
- **Timer**: 30 seconds countdown
- **Colors**: Blue focus, light gray default

---

## 4. Forgot Password Screen

### Layout
```
┌──────────────────────────────────────┐
│                                      │
│         ┌───────┐                    │
│         │  🔒  │                     │  ← Lock icon
│         └───────┘                    │
│                                      │
│      [Forgot Password?]              │
│                                      │
│   No worries, we'll send you reset   │
│          instructions.               │
│                                      │
│                                      │
│  Email Address                       │
│  ┌──────────────────────────────┐   │
│  │ you@example.com              │   │
│  └──────────────────────────────┘   │
│                                      │
│                                      │
│  ┌──────────────────────────────┐   │
│  │     Reset Password           │   │
│  └──────────────────────────────┘   │
│                                      │
│                                      │
│     ← Back to Login                  │
│                                      │
└──────────────────────────────────────┘
```

### Design Features
- **Icon**: Lock reset icon in blue circle background
- **Max Width**: 440px
- **CTA Button**: Blue with white text
- **Back Link**: Arrow icon + text in blue
- **Auto-redirect**: After 2 seconds on success

---

## Common UI Elements

### Input Field (Default State)
```
Label Text (14px, Semi-bold, Dark)
┌────────────────────────────────────┐
│ placeholder text (gray)            │  ← 12px vertical padding
└────────────────────────────────────┘  ← 1.5px light gray border
```

### Input Field (Focused State)
```
Label Text (14px, Semi-bold, Dark)
┌────────────────────────────────────┐
│ user input (dark)                  │
└────────────────────────────────────┘  ← 1.5px blue border
```

### Primary Button (Default)
```
┌────────────────────────────────────┐
│          Button Text               │  ← 48px height
└────────────────────────────────────┘  ← Blue background
                                        White text (16px, Semi-bold)
```

### Primary Button (Loading)
```
┌────────────────────────────────────┐
│            ⏳                       │  ← Spinner animation
└────────────────────────────────────┘  ← Blue background (dimmed)
                                        Disabled state
```

### Tab Button (Inactive)
```
┌─────────────────┐
│ 📧 Email        │  ← Gray icon & text
└─────────────────┘  ← Transparent background
```

### Tab Button (Active)
```
┌─────────────────┐
│ 📱 Mobile       │  ← White icon & text
└─────────────────┘  ← Blue background
```

### Snackbar (Error)
```
┌────────────────────────────────────┐
│ ❌ Invalid credentials             │  ← Red background
└────────────────────────────────────┘  ← White text
```

### Snackbar (Success)
```
┌────────────────────────────────────┐
│ ✅ Account created successfully!   │  ← Green background
└────────────────────────────────────┘  ← White text
```

---

## Typography

### Headings
- **Screen Title**: 28px, Bold, Dark (#1E293B)
- **Subtitle**: 14px, Regular, Gray (#64748B)

### Form Labels
- **Field Label**: 14px, Semi-bold, Dark (#1E293B)
- **Helper Text**: 12px, Regular, Gray (#64748B)

### Buttons
- **Primary Button**: 16px, Semi-bold, White
- **Link Text**: 14px, Bold, Blue (#3B82F6)

### Input Text
- **User Input**: 14px, Regular, Dark (#1E293B)
- **Placeholder**: 14px, Regular, Light Gray (#9CA3AF)

---

## Spacing System

### Component Spacing
- **Between sections**: 32px
- **Between fields**: 20px
- **Between label and input**: 8px
- **Button height**: 48px
- **Card padding**: 32px horizontal, 48px vertical
- **Screen padding**: 24px

### Border Radius
- **Cards**: 16px
- **Inputs**: 8px
- **Buttons**: 8px
- **Tabs**: 8px (inner), 10px (outer)
- **Icons**: 12px

---

## Animations

### Screen Transitions
- **Type**: Slide from right
- **Duration**: 300ms
- **Curve**: Ease-in-out

### Button States
- **Hover**: Slight darkening (10%)
- **Press**: Scale 0.98
- **Loading**: Rotation animation

### OTP Input
- **Focus**: Border color transition (200ms)
- **Fill**: Smooth background change

### Snackbar
- **Entry**: Slide up from bottom
- **Exit**: Fade out
- **Duration**: 3 seconds

---

## Accessibility Features

### Color Contrast
- **Text on White**: 18.5:1 (AAA)
- **Blue on White**: 4.5:1 (AA)
- **Gray on White**: 4.6:1 (AA)

### Focus Indicators
- **Keyboard focus**: Blue outline (2px)
- **Tab order**: Logical top-to-bottom

### Screen Reader Support
- **Semantic labels**: All inputs have labels
- **Error messages**: Announced on validation
- **Loading states**: "Loading..." announced

### Touch Targets
- **Minimum size**: 48x48px
- **Spacing**: 8px minimum between targets

---

## Responsive Breakpoints

### Mobile (< 600px)
- Full width screens
- 24px padding
- Stacked layout
- Single column forms

### Tablet (600px - 1024px)
- Centered cards (max 440px/480px)
- Increased padding
- Same layout as desktop

### Desktop (> 1024px)
- Centered cards (max 440px/480px)
- 32px card padding
- Hover states active
- Keyboard shortcuts enabled

---

## Loading States

### Login Button Loading
```
┌────────────────────────────────────┐
│         ⏳ (20x20 spinner)         │
└────────────────────────────────────┘
```

### OTP Verification Loading
```
        ⏳ (circular progress indicator)
     Verifying OTP...
```

### Full Screen Loading (Initial)
```
┌────────────────────────────────────┐
│                                    │
│              ⏳                     │
│         Loading...                 │
│                                    │
└────────────────────────────────────┘
```

---

## Error States

### Invalid Input
```
Email
┌────────────────────────────────────┐
│ invalid-email                      │  ← Red border
└────────────────────────────────────┘
⚠️ Please enter a valid email address  ← Red text (12px)
```

### Password Mismatch
```
Confirm Password
┌────────────────────────────────────┐
│ ••••••••                           │  ← Red border
└────────────────────────────────────┘
⚠️ Passwords do not match              ← Red text
```

### API Error
```
┌────────────────────────────────────┐
│ ❌ Invalid credentials             │  ← Snackbar (red)
│    Please try again                │
└────────────────────────────────────┘
```

---

## Success States

### Registration Success
```
┌────────────────────────────────────┐
│ ✅ Account created successfully!   │  ← Snackbar (green)
│    Please sign in                  │
└────────────────────────────────────┘
(Auto-redirect to login after showing message)
```

### Password Reset Success
```
┌────────────────────────────────────┐
│ ✅ Reset link sent to your email   │  ← Snackbar (green)
└────────────────────────────────────┘
(Auto-redirect to login after 2 seconds)
```

### OTP Sent
```
┌────────────────────────────────────┐
│ ✅ OTP sent to your mobile         │  ← Snackbar (green)
└────────────────────────────────────┘
(Navigate to OTP verification screen)
```

---

## Icon Reference

### Screen Icons
- **Login Email Tab**: 📧 (email_outlined)
- **Login Mobile Tab**: 📱 (phone_android_outlined)
- **OTP Verification**: 📱🔒 (phonelink_lock)
- **Forgot Password**: 🔒 (lock_reset_rounded)
- **Back Arrow**: ← (arrow_back)

### Status Icons
- **Success**: ✅ (checkmark)
- **Error**: ❌ (error/close)
- **Warning**: ⚠️ (warning)
- **Loading**: ⏳ (CircularProgressIndicator)

---

## Platform-Specific Considerations

### iOS
- Uses Cupertino-style navigation
- Back swipe gesture enabled
- Keyboard automatically dismisses on tap outside
- Haptic feedback on button press

### Android
- Material Design ripple effects
- System back button support
- Keyboard auto-dismiss on form submit
- Toast-style snackbars

### Web
- Tab navigation support
- Enter key submits forms
- Escape key dismisses dialogs
- Copy/paste enabled in all fields

---

**Document Purpose**: UI Reference for developers, designers, and QA
**Last Updated**: February 11, 2026
**Developer**: Lucas Chen
