# Form Management System

A modern, feature-rich platform designed to simplify the creation, distribution, and analysis of digital forms.

## Overview

The Form Management System provides a self-service infrastructure for data collection workflows. It includes a drag-and-drop Form Builder, public/private form distribution, and real-time response analysis.

## Features

- **Form Builder**: Interactive UI to add, reorder, and configure form fields.
- **Data Management**: Sortable response grids and export capabilities.
- **Authentication**: Secure login and user management.
- **Analysis**: Dashboards for submission trends.

## Getting Started

### Prerequisites

- Node.js >= 20.9.0
- npm or yarn

### Installation

1. Clone the repository.
2. Install dependencies:

   ```bash
   npm install
   ```

### Running the Application

To start the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

### Building for Production

```bash
npm run build
npm start
```

### Testing

Run unit tests:

```bash
npm run test:unit
```

Run E2E tests:

```bash
npm run test:e2e
```

## Documentation

- **SRS**: See `plans/SRS/` for detailed requirements.
- **Project State**: See `agent/agent/09_state/PROJECT_STATE.md`.
