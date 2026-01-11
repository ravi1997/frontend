import Link from 'next/link';

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
      <div className="max-w-4xl mx-auto px-6 py-12 text-center">
        <div className="mb-8">
          <h1 className="text-6xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-purple-600 mb-4">
            Form Management System
          </h1>
          <p className="text-xl text-gray-600 dark:text-gray-300 mb-8">
            A modern, feature-rich platform for creating, managing, and analyzing forms with AI-powered capabilities
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-6 mb-12">
          <div className="p-6 rounded-xl bg-white dark:bg-gray-800 shadow-lg hover:shadow-xl transition-shadow">
            <div className="text-4xl mb-4">🎨</div>
            <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-white">Advanced Builder</h3>
            <p className="text-gray-600 dark:text-gray-300">
              Drag-and-drop interface with 15+ field types and conditional logic
            </p>
          </div>

          <div className="p-6 rounded-xl bg-white dark:bg-gray-800 shadow-lg hover:shadow-xl transition-shadow">
            <div className="text-4xl mb-4">🤖</div>
            <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-white">AI Powered</h3>
            <p className="text-gray-600 dark:text-gray-300">
              Generate forms with AI assistance and smart field suggestions
            </p>
          </div>

          <div className="p-6 rounded-xl bg-white dark:bg-gray-800 shadow-lg hover:shadow-xl transition-shadow">
            <div className="text-4xl mb-4">📊</div>
            <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-white">Analytics</h3>
            <p className="text-gray-600 dark:text-gray-300">
              Comprehensive analytics with export and approval workflows
            </p>
          </div>
        </div>

        <div className="flex gap-4 justify-center">
          <Link
            href="/login"
            className="px-8 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg font-semibold hover:from-blue-700 hover:to-purple-700 transition-all shadow-lg hover:shadow-xl"
          >
            Get Started
          </Link>
          <Link
            href="/dashboard"
            className="px-8 py-3 bg-white dark:bg-gray-800 text-gray-900 dark:text-white rounded-lg font-semibold border-2 border-gray-200 dark:border-gray-700 hover:border-blue-500 transition-all shadow-lg hover:shadow-xl"
          >
            Dashboard
          </Link>
        </div>

        <div className="mt-12 text-sm text-gray-500 dark:text-gray-400">
          <p>Built with Next.js, TypeScript, and Tailwind CSS</p>
        </div>
      </div>
    </div>
  );
}
