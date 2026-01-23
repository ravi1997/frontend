'use client';
import React from 'react';
import { useParams } from 'next/navigation';
import { BuilderSidebar } from '@/components/form-builder/BuilderSidebar';
import { BuilderCanvas } from '@/components/form-builder/BuilderCanvas';
import { BuilderProperties } from '@/components/form-builder/BuilderProperties';
import { WorkflowManager } from '@/components/form-builder/workflow/WorkflowManager';
import { VersionHistoryPanel } from '@/components/form-builder/versions/VersionHistoryPanel';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Eye, Save, Send, ChevronLeft, Loader2 } from 'lucide-react';
import Link from 'next/link';
import { useBuilderStore } from '@/store/builderStore';
import { useForm, useFormDetails } from '@/hooks/useForm';
import { FormPreview } from '@/components/form-builder/FormPreview';

export default function EditBuilderPage() {
    const params = useParams();
    const id = params.id as string;

    const { sections, formTitle, formDescription, setFormMetadata, workflows, loadForm } = useBuilderStore();
    const { createVersion, updateForm, isSaving } = useForm();
    const { data: form, isLoading: isFetching } = useFormDetails(id);
    const [isPreviewOpen, setIsPreviewOpen] = React.useState(false);

    // Initialize store with form data
    React.useEffect(() => {
        if (form) {
            loadForm(form);
        }
    }, [form, loadForm]);

    const handleSave = async () => {
        if (!formTitle.trim()) {
            alert('Please enter a form title');
            return;
        }

        try {
            // 1. Update metadata
            await updateForm.mutateAsync({
                formId: id,
                payload: { title: formTitle, description: formDescription }
            });

            // 2. Create new version
            await createVersion.mutateAsync({
                formId: id,
                payload: {
                    version: '1.0', // Simple mock versioning
                    sections,
                    activate: true
                }
            });
        } catch {
            // Handled in mutation
        }
    };

    if (isFetching) {
        return (
            <div className="flex h-screen items-center justify-center">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
        );
    }

    return (
        <div className="flex flex-col h-screen overflow-hidden">
            {/* Builder Header */}
            <header className="h-14 border-b bg-background flex items-center justify-between px-4 shrink-0">
                <div className="flex items-center gap-4">
                    <Button variant="ghost" size="icon" asChild>
                        <Link href="/dashboard">
                            <ChevronLeft className="h-5 w-5" />
                        </Link>
                    </Button>
                    <div className="h-4 w-px bg-border" />
                    <div className="flex flex-col">
                        <Input
                            value={formTitle}
                            onChange={(e) => setFormMetadata({ title: e.target.value })}
                            className="h-7 text-sm font-semibold border-transparent hover:border-input focus:border-input px-2 -ml-2 w-[200px] sm:w-[300px]"
                            placeholder="Untitled Form"
                        />
                    </div>
                    <span className="text-xs bg-muted px-2 py-0.5 rounded text-muted-foreground font-medium hidden sm:inline-block">
                        Editing
                    </span>
                </div>

                <div className="flex items-center gap-2">
                    <Button variant="ghost" size="sm" onClick={() => setIsPreviewOpen(true)}>
                        <Eye className="mr-2 h-4 w-4" />
                        Preview
                    </Button>
                    <VersionHistoryPanel />
                    <WorkflowManager />
                    <Button variant="outline" size="sm" onClick={handleSave} disabled={isSaving}>
                        {isSaving ? (
                            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        ) : (
                            <Save className="mr-2 h-4 w-4" />
                        )}
                        Save Changes
                    </Button>
                    <Button size="sm">
                        <Send className="mr-2 h-4 w-4" />
                        Publish
                    </Button>
                </div>
            </header>

            {/* Builder Main Area */}
            <div className="flex flex-1 overflow-hidden">
                {/* Sidebar - Fields */}
                <BuilderSidebar />

                {/* Canvas - Form Layout */}
                <BuilderCanvas />

                {/* Properties - Field Settings */}
                <BuilderProperties />
            </div>

            <FormPreview open={isPreviewOpen} onOpenChange={setIsPreviewOpen} />
        </div>
    );
}
