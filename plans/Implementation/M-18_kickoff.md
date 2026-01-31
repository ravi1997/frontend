# Feature Kickoff: Skeleton Loading & Shimmer UX

## Name: Skeleton Loading & Shimmer UX

## Linked Task: M-18

## Description

Implement skeleton loading states across the application to improve perceived performance. Instead of static `CircularProgressIndicator`, we will use shimmering placeholders that match the shape of the content they are replacing.

## Implementation Plan

1. **Core Shimmer Component**:
    * Create a reusable `AppShimmer` widget in `lib/core/widgets/app_shimmer.dart`.
    * Create `SkeletonContainer` for generic shapes.
2. **Dashboard Skeletons**:
    * `StatsCardSkeleton`: Matches `DashboardStatsCard`.
    * `FormCardSkeleton`: Matches the list items in `RecentFormsList`.
3. **Refactoring Transitions**:
    * Update `DashboardPage` and `RecentFormsList` to use the skeletons while in `AsyncValue.loading()` state.
4. **Builder Skeletons**:
    * (Optional but good) Shimmering canvas for the Form Builder during initialization.

## Tests

* [ ] **Visual Consistency**: Skeletons must align with the actual cards' layout and height.
* [ ] **State Transition**: Ensure smooth transition from Shimmer to actual Content without jumping.

## Checkpoints

* [ ] `AppShimmer` widget created.
* [ ] Stats card skeleton implemented.
* [ ] Form card skeleton implemented.
* [ ] Dashboard integrated with skeletons.
