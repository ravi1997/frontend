'use client';

import React, { useState, useEffect } from 'react';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { useBuilderStore } from '@/store/builderStore';
import { FormInput } from './FormInput';
import { shouldShowField } from '@/lib/logicEngine';

interface FormPreviewProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
}

export const FormPreview: React.FC<FormPreviewProps> = ({ open, onOpenChange }) => {
    const { sections, formTitle, formDescription } = useBuilderStore();
    const [formData, setFormData] = useState<Record<string, any>>({});

    // Reset data when closed or opened? Maybe keep it persistence during session?
    // Let's reset on open to verify "fresh" state behavior
    useEffect(() => {
        if (open) {
            setFormData({});
        }
    }, [open]);

    const handleFieldChange = (fieldId: string, value: any) => {
        setFormData(prev => ({
            ...prev,
            [fieldId]: value
        }));
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="max-w-3xl h-[80vh] flex flex-col p-0">
                <DialogHeader className="p-6 pb-2">
                    <DialogTitle>Form Preview</DialogTitle>
                    <DialogDescription>
                        Test your form logic and layout.
                    </DialogDescription>
                </DialogHeader>

                <div className="flex-1 p-6 pt-2 overflow-y-auto">
                    <div className="max-w-2xl mx-auto space-y-8 pb-10">
                        {/* Form Header */}
                        <div className="space-y-2 border-b pb-4">
                            <h1 className="text-2xl font-bold">{formTitle || 'Untitled Form'}</h1>
                            {formDescription && <p className="text-muted-foreground">{formDescription}</p>}
                        </div>

                        {sections.map((section) => (
                            <div key={section.id} className="space-y-4">
                                {section.title && (
                                    <h3 className="text-lg font-semibold">{section.title}</h3>
                                )}
                                {section.description && (
                                    <p className="text-sm text-muted-foreground -mt-3 mb-4">{section.description}</p>
                                )}

                                <div className="grid gap-6">
                                    {section.questions.map((question) => {
                                        const isVisible = shouldShowField(question, formData);

                                        if (!isVisible) return null;

                                        return (
                                            <FormInput
                                                key={question.id}
                                                question={question}
                                                value={formData[question.id]}
                                                onChange={(val) => handleFieldChange(question.id, val)}
                                            />
                                        );
                                    })}
                                </div>
                            </div>
                        ))}

                        <div className="pt-6">
                            <Button className="w-full" onClick={() => alert('This is a preview. No data is saved.')}>
                                Submit Form
                            </Button>
                        </div>
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    );
};
