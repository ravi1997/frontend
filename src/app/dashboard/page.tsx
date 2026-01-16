'use client';

import { useAuth } from '@/hooks/useAuth';
import { useForms } from '@/hooks/useForms'; // Import the new hook
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { FileText, Users, BarChart3, PlusCircle, Loader2, ArrowRight } from 'lucide-react';
import Link from 'next/link';
import { formatDistanceToNow } from 'date-fns';
import { IForm } from '@/types';

export default function DashboardPage() {
  const { user } = useAuth();
  const { forms, totalForms, isLoading: isFormsLoading } = useForms();

  const stats = [
    {
      title: 'Total Forms',
      value: isFormsLoading ? '...' : totalForms.toString(),
      description: 'Forms created',
      icon: FileText,
      href: '/dashboard/forms',
    },
    {
      title: 'Responses',
      value: '0', // Placeholder until responses API is ready
      description: 'Total submissions',
      icon: Users,
      href: '/dashboard/responses',
    },
    {
      title: 'Active Forms',
      value: isFormsLoading ? '...' : (forms as IForm[]).filter((f: IForm) => f.is_public).length.toString(),
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
      <div className="flex flex-col sm:flex-row gap-4">
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

      {/* Recent Activity / Forms */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Forms</CardTitle>
          <CardDescription>
            Your recently created or modified forms
          </CardDescription>
        </CardHeader>
        <CardContent>
          {isFormsLoading ? (
            <div className="flex justify-center py-8">
              <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
            </div>
          ) : forms.length > 0 ? (
            <div className="space-y-4">
              {(forms as IForm[]).slice(0, 5).map((form: IForm) => (
                <div
                  key={form.id}
                  className="flex items-center justify-between p-4 border rounded-lg hover:bg-muted/50 transition-colors"
                >
                  <div className="flex items-center gap-4 flex-1 min-w-0">
                    <div className="bg-primary/10 p-2 rounded-full shrink-0">
                      <FileText className="h-5 w-5 text-primary" />
                    </div>
                    <div className="min-w-0 flex-1">
                      <h4 className="font-medium truncate" title={form.title}>{form.title}</h4>
                      <p className="text-sm text-muted-foreground truncate">
                        {form.is_public ? 'Public' : 'Draft'} • {formatDistanceToNow(new Date(form.created_at), { addSuffix: true })}
                      </p>
                    </div>
                  </div>
                  <Button variant="ghost" size="sm" asChild className="ml-4 shrink-0">
                    <Link href={`/builder/${form.id}`}>
                      Edit <ArrowRight className="ml-2 h-4 w-4 hidden sm:inline-block" />
                    </Link>
                  </Button>
                </div>
              ))}
              <div className="pt-2 text-center">
                <Button variant="link" asChild>
                  <Link href="/dashboard/forms">View all activity</Link>
                </Button>
              </div>
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center py-12 text-center">
              <FileText className="h-12 w-12 text-muted-foreground mb-4" />
              <h3 className="text-lg font-medium mb-2">No forms yet</h3>
              <p className="text-sm text-muted-foreground mb-4">
                Create your first form to get started
              </p>
              <Button asChild>
                <Link href="/builder/new">Create Form</Link>
              </Button>
            </div>
          )}
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
