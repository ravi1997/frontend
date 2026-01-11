'use client';

import { useAuth } from '@/hooks/useAuth';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { FileText, Users, BarChart3, Settings, PlusCircle } from 'lucide-react';
import Link from 'next/link';

export default function DashboardPage() {
  const { user } = useAuth();

  const stats = [
    {
      title: 'Total Forms',
      value: '0',
      description: 'Forms created',
      icon: FileText,
      href: '/dashboard/forms',
    },
    {
      title: 'Responses',
      value: '0',
      description: 'Total submissions',
      icon: Users,
      href: '/dashboard/responses',
    },
    {
      title: 'Active Forms',
      value: '0',
      description: 'Published forms',
      icon: BarChart3,
      href: '/dashboard/analytics',
    },
  ];

  return (
    <div className="space-y-8">
      {/* Welcome Section */}
      <div>
        <h1 className="text-3xl font-bold tracking-tight">
          Welcome back, {user?.username}!
        </h1>
        <p className="text-muted-foreground mt-2">
          Here&apos;s what&apos;s happening with your forms today.
        </p>
      </div>

      {/* Quick Actions */}
      <div className="flex gap-4">
        <Button asChild size="lg">
          <Link href="/builder/new">
            <PlusCircle className="mr-2 h-5 w-5" />
            Create New Form
          </Link>
        </Button>
        <Button asChild variant="outline" size="lg">
          <Link href="/dashboard/forms">
            <FileText className="mr-2 h-5 w-5" />
            View All Forms
          </Link>
        </Button>
      </div>

      {/* Stats Cards */}
      <div className="grid gap-4 md:grid-cols-3">
        {stats.map((stat) => {
          const Icon = stat.icon;
          return (
            <Link key={stat.title} href={stat.href}>
              <Card className="hover:shadow-lg transition-shadow cursor-pointer">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    {stat.title}
                  </CardTitle>
                  <Icon className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">{stat.value}</div>
                  <p className="text-xs text-muted-foreground">
                    {stat.description}
                  </p>
                </CardContent>
              </Card>
            </Link>
          );
        })}
      </div>

      {/* Recent Activity */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Activity</CardTitle>
          <CardDescription>
            Your latest form submissions and updates
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex flex-col items-center justify-center py-12 text-center">
            <FileText className="h-12 w-12 text-muted-foreground mb-4" />
            <h3 className="text-lg font-medium mb-2">No activity yet</h3>
            <p className="text-sm text-muted-foreground mb-4">
              Create your first form to get started
            </p>
            <Button asChild>
              <Link href="/builder/new">Create Form</Link>
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Getting Started Guide */}
      <Card className="bg-gradient-to-r from-blue-50 to-purple-50 dark:from-gray-800 dark:to-gray-900 border-none">
        <CardHeader>
          <CardTitle>Getting Started</CardTitle>
          <CardDescription>
            Learn how to make the most of Form Management System
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <h4 className="font-medium">1. Create Your First Form</h4>
              <p className="text-sm text-muted-foreground">
                Use our drag-and-drop builder to create beautiful forms in minutes
              </p>
            </div>
            <div className="space-y-2">
              <h4 className="font-medium">2. Share & Collect Responses</h4>
              <p className="text-sm text-muted-foreground">
                Publish your form and start collecting responses from users
              </p>
            </div>
            <div className="space-y-2">
              <h4 className="font-medium">3. Analyze Data</h4>
              <p className="text-sm text-muted-foreground">
                View analytics and export responses in multiple formats
              </p>
            </div>
            <div className="space-y-2">
              <h4 className="font-medium">4. Automate Workflows</h4>
              <p className="text-sm text-muted-foreground">
                Set up approval workflows and automated actions
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
