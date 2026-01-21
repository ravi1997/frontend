'use client';

import { useForms } from '@/hooks/useForms';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { FileText, Plus, Search, MoreHorizontal, Loader2 } from 'lucide-react';
import Link from 'next/link';
import { formatDistanceToNow } from 'date-fns';
import { IForm } from '@/types';
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { useState } from 'react';
import { useResponses } from '@/hooks/useResponses';
import { Download } from 'lucide-react';

export default function FormsPage() {
    const { forms, isLoading } = useForms();
    const { exportCsv, exportJson, isExportingCsv, isExportingJson } = useResponses();
    const [search, setSearch] = useState('');

    const filteredForms = (forms as IForm[]).filter((form) =>
        form.title.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight">Forms</h1>
                    <p className="text-muted-foreground mt-1">
                        Manage and organize your forms.
                    </p>
                </div>
                <Button asChild>
                    <Link href="/builder/new">
                        <Plus className="mr-2 h-4 w-4" />
                        Create Form
                    </Link>
                </Button>
            </div>

            <div className="flex items-center gap-2">
                <div className="relative flex-1 max-w-sm">
                    <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                    <Input
                        type="search"
                        placeholder="Search forms..."
                        className="pl-8"
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                    />
                </div>
            </div>

            <Card>
                <CardHeader>
                    <CardTitle>All Forms</CardTitle>
                    <CardDescription>
                        A list of all forms you have created or have access to.
                    </CardDescription>
                </CardHeader>
                <CardContent>
                    {isLoading ? (
                        <div className="flex justify-center py-12">
                            <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
                        </div>
                    ) : filteredForms.length > 0 ? (
                        <div className="divide-y">
                            {filteredForms.map((form) => (
                                <div
                                    key={form.id}
                                    className="flex items-center justify-between py-4"
                                >
                                    <div className="flex items-center gap-4">
                                        <div className="bg-primary/10 p-2.5 rounded-lg">
                                            <FileText className="h-5 w-5 text-primary" />
                                        </div>
                                        <div>
                                            <h4 className="font-medium hover:underline">
                                                <Link href={`/builder/${form.id}`}>{form.title}</Link>
                                            </h4>
                                            <p className="text-sm text-muted-foreground">
                                                {form.is_public ? (
                                                    <span className="inline-flex items-center px-1.5 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
                                                        Public
                                                    </span>
                                                ) : (
                                                    <span className="inline-flex items-center px-1.5 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400">
                                                        Draft
                                                    </span>
                                                )}
                                                <span className="mx-2">•</span>
                                                Updated {formatDistanceToNow(new Date(form.updated_at || form.created_at), { addSuffix: true })}
                                            </p>
                                        </div>
                                    </div>

                                    <div className="flex items-center gap-2">
                                        <Button variant="ghost" size="sm" asChild className="hidden sm:flex">
                                            <Link href={`/builder/${form.id}`}>
                                                Edit
                                            </Link>
                                        </Button>

                                        <DropdownMenu>
                                            <DropdownMenuTrigger asChild>
                                                <Button variant="ghost" size="icon">
                                                    <MoreHorizontal className="h-4 w-4" />
                                                    <span className="sr-only">Actions</span>
                                                </Button>
                                            </DropdownMenuTrigger>
                                            <DropdownMenuContent align="end">
                                                <DropdownMenuLabel>Actions</DropdownMenuLabel>
                                                <DropdownMenuItem asChild>
                                                    <Link href={`/builder/${form.id}`}>Edit Form</Link>
                                                </DropdownMenuItem>
                                                <DropdownMenuItem>Preview</DropdownMenuItem>
                                                <DropdownMenuSeparator />
                                                <DropdownMenuLabel>Export Responses</DropdownMenuLabel>
                                                <DropdownMenuItem
                                                    onClick={() => exportCsv(form.id)}
                                                    disabled={isExportingCsv}
                                                >
                                                    <Download className="mr-2 h-4 w-4" />
                                                    Export CSV
                                                </DropdownMenuItem>
                                                <DropdownMenuItem
                                                    onClick={() => exportJson(form.id)}
                                                    disabled={isExportingJson}
                                                >
                                                    <Download className="mr-2 h-4 w-4" />
                                                    Export JSON
                                                </DropdownMenuItem>
                                                <DropdownMenuSeparator />
                                                <DropdownMenuItem className="text-destructive">
                                                    Delete
                                                </DropdownMenuItem>
                                            </DropdownMenuContent>
                                        </DropdownMenu>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div className="flex flex-col items-center justify-center py-16 text-center">
                            <div className="bg-muted/50 p-4 rounded-full mb-4">
                                <FileText className="h-8 w-8 text-muted-foreground" />
                            </div>
                            <h3 className="text-lg font-medium mb-1">No forms found</h3>
                            <p className="text-sm text-muted-foreground mb-4 max-w-xs">
                                {search ? 'Try adjusting your search query.' : 'Get started by creating your first form.'}
                            </p>
                            {!search && (
                                <Button asChild>
                                    <Link href="/builder/new">Create Form</Link>
                                </Button>
                            )}
                        </div>
                    )}
                </CardContent>
            </Card>
        </div>
    );
}
