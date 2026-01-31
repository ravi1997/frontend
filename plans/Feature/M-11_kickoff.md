# Feature Kickoff: Form Analytics & Reporting

## Name: M-11 - Form Analytics & Reporting

## Linked Task: M-11

## Description

Implement a dedicated Analytics view for forms to provide creators with insights into submission trends and data distribution.

## Implementation Plan

1. **New Screen**: `AnalyticsPage` as a sub-page of the form (e.g., `/forms/<id>/analytics`).
2. **Components**:
    - **Trend Chart**: Line chart showing submissions over time.
    - **Distribution Chart**: Bar or Pie chart for field-specific distribution (e.g., "Which options were selected").
    - **Stats Grid**: Summary cards for Total Submissions, Completion Rate, Average Time.
3. **Data Model**:
    - Define `FormAnalytics` entity.
    - Create `AnalyticsRepository` to fetch simulated/real data.
4. **Navigation**:
    - Add an "Analytics" button to the Form Card in the Dashboard.

## Tests

- [ ] Unit test for analytics data mapping.
- [ ] Widget test for chart rendering.

## Checkpoints

- [ ] Analytics Repository implemented.
- [ ] UI Shell and Grid ready.
- [ ] Line/Bar charts integrated with `fl_chart`.
- [ ] Linter passing.
