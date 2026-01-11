# Form Management System - Frontend

A modern, feature-rich form management system frontend built with Next.js, TypeScript, and Tailwind CSS.

## 📋 Overview

This is the frontend application for a comprehensive form management system that provides:

- **Advanced Form Builder** - Drag-and-drop interface with AI assistance
- **Dashboard** - Role-based analytics and management
- **Public Submission** - PWA-enabled, accessible forms
- **Response Management** - Advanced filtering, export, and approval workflows
- **AI Assistant** - Conversational form generation
- **Workflow Automation** - Visual node-based workflow editor

## 🚀 Tech Stack

### Core
- **Framework**: [Next.js 16](https://nextjs.org/) with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS 4.0

### State Management
- **Server State**: TanStack Query (React Query) - Data fetching and caching
- **Client State**: Zustand - Lightweight global state management

### UI Components
- **Component Library**: Shadcn UI (Radix UI primitives)
- **Icons**: Lucide React
- **Drag & Drop**: DnD Kit

### Forms & Validation
- **Form Handling**: React Hook Form
- **Schema Validation**: Zod

### Charts & Analytics
- **Charts**: Recharts

### Testing
- **Unit/Component Tests**: Vitest + React Testing Library
- **E2E Tests**: Playwright
- **Accessibility**: axe-playwright

## 📁 Project Structure

```
frontend/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (auth)/             # Authentication routes
│   │   ├── (dashboard)/        # Main dashboard layout
│   │   │   ├── forms/          # Form management
│   │   │   ├── responses/      # Response viewer
│   │   │   ├── analytics/      # Analytics
│   │   │   └── settings/       # Settings
│   │   ├── builder/            # Form Builder
│   │   │   └── [formId]/       # Edit specific form
│   │   └── submit/             # Public form submission
│   │       └── [slug]/         # Dynamic route for forms
│   ├── components/
│   │   ├── ui/                 # Reusable atomic components
│   │   ├── form-builder/       # Builder-specific components
│   │   ├── dashboard/          # Dashboard widgets
│   │   └── layout/             # Sidebar, Header, Footer
│   ├── lib/
│   │   ├── api.ts              # Axios instance with interceptors
│   │   ├── utils.ts            # Helper functions
│   │   └── constants.ts        # App-wide constants
│   ├── hooks/                  # Custom React hooks
│   ├── store/                  # Zustand stores
│   ├── types/                  # TypeScript interfaces
│   └── styles/                 # Global styles
├── public/                     # Static assets
├── agent/                      # AI Agent configuration
└── tests/                      # Test files
```

## 🛠️ Getting Started

### Prerequisites

- Node.js 20.x or higher
- npm 10.x or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   # Copy the example env file
   cp .env.local.example .env.local
   
   # Edit .env.local with your configuration
   # At minimum, set NEXT_PUBLIC_API_URL to your backend URL
   ```

4. **Run the development server**
   ```bash
   npm run dev
   ```

5. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## 📝 Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm run test:unit` - Run unit tests
- `npm run test:component` - Run component tests with UI
- `npm run test:e2e` - Run end-to-end tests

## 🔐 Environment Variables

Create a `.env.local` file with the following variables:

```env
# Backend API URL (Required)
NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1

# Monitoring & Analytics (Optional)
NEXT_PUBLIC_SENTRY_DSN=
NEXT_PUBLIC_ANALYTICS_ID=

# Feature Flags (Optional)
NEXT_PUBLIC_FEATURE_FLAGS={}

# PWA (Optional)
NEXT_PUBLIC_PWA_ENABLED=true

# Theme (Optional)
NEXT_PUBLIC_THEME=light

# Environment (Optional)
NEXT_PUBLIC_ENV=development
```

## 🎯 Key Features

### 1. Authentication & Authorization
- Email/Password login
- Mobile OTP login
- Role-based access control (RBAC)
- Session management with JWT

### 2. Form Builder
- Drag-and-drop interface
- 15+ field types (text, select, date, file upload, etc.)
- Conditional logic builder
- Version management
- Preview mode
- Repeatable sections/questions

### 3. Public Submission
- Server-side rendering (SSR/ISR)
- Client-side validation with Zod
- Auto-save drafts
- File upload with progress
- Integration with external APIs (UHID lookup, OTP verification)

### 4. Response Management
- Advanced data grid with TanStack Table
- Filtering and searching
- Bulk export (CSV, JSON, PDF, Excel)
- Detail view with timeline

### 5. Approval Workflow
- Multi-step approval process
- Visual timeline
- Comments and history
- Status tracking

### 6. AI Features
- Conversational form generation
- Smart field suggestions
- Context-aware prompts

### 7. Workflow Automation
- Visual node-based editor (React Flow)
- Triggers, conditions, and actions
- Circular dependency validation

## 📚 Documentation

- **SRS**: See `FRONTEND_SRS.md` for complete specifications
- **Implementation Plan**: See `FRONTEND_PLAN.md` for development roadmap
- **AI Agent**: See `agent/README.md` for AI assistance configuration

## 🧪 Testing

### Unit Tests
```bash
npm run test:unit
```

### Component Tests
```bash
npm run test:component
```

### E2E Tests
```bash
npm run test:e2e
```

### Accessibility Tests
```bash
npm run test:e2e -- --grep "accessibility"
```

## 🚢 Deployment

### Vercel (Recommended)
1. Connect your repository to Vercel
2. Configure environment variables
3. Deploy automatically on push to main

### Docker
```bash
docker build -t form-management-frontend .
docker run -p 3000:3000 form-management-frontend
```

### Manual
```bash
npm run build
npm run start
```

## 🎨 Design System

- **Design System**: Tailwind utilities with custom components
- **Theme Support**: Light/Dark mode with system preference detection
- **Accessibility**: WCAG 2.1 AA compliant
- **Responsive**: Mobile-first approach

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

[Add your license here]

## 📞 Support

For support and questions, please [open an issue](link-to-issues).

---

Built with ❤️ using Next.js and TypeScript
