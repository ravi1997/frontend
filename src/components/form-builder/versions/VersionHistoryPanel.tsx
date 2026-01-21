'use client';

import React, { useState } from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { IFormVersion } from '@/types';
import { formatDistanceToNow } from 'date-fns';
import { History, RotateCcw } from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from '@/components/ui/dialog';

export const VersionHistoryPanel = () => {
    const { versions, loadVersion } = useBuilderStore();
    const [isOpen, setIsOpen] = useState(false);

    const handleRestore = (version: IFormVersion) => {
        if (confirm('Are you sure? This will replace your current editor content with the selected version.')) {
            loadVersion(version);
            setIsOpen(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={setIsOpen}>
            <DialogTrigger asChild>
                <Button variant="ghost" size="sm">
                    <History className="mr-2 h-4 w-4" />
                    History
                </Button>
            </DialogTrigger>
            <DialogContent className="max-w-md max-h-[80vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>Version History</DialogTitle>
                    <DialogDescription>
                        View and restore previous versions of this form.
                    </DialogDescription>
                </DialogHeader>

                <div className="space-y-4 mt-4">
                    {versions.length === 0 ? (
                        <div className="text-center text-muted-foreground py-8">
                            No history available.
                        </div>
                    ) : (
                        <div className="space-y-2">
                            {/* Sort versions descending by date (assuming v1 is oldest) usually versions come from API sorted, but let's reverse to show newest first */}
                            {[...versions].sort((a, b) => b.version_number - a.version_number).map((version) => (
                                <div key={version.version_number} className="flex items-center justify-between p-3 border rounded-lg hover:bg-muted/50 transition-colors">
                                    <div className="space-y-1">
                                        <div className="flex items-center gap-2">
                                            <span className="font-semibold text-sm">Version {version.version_number}</span>
                                            <span className="text-xs text-muted-foreground bg-muted px-1.5 py-0.5 rounded">
                                                {version.sections.length} Sections
                                            </span>
                                        </div>
                                        <p className="text-xs text-muted-foreground">
                                            {formatDistanceToNow(new Date(version.created_at), { addSuffix: true })}
                                        </p>
                                    </div>
                                    <Button
                                        size="sm"
                                        variant="outline"
                                        onClick={() => handleRestore(version)}
                                        title="Restore this version"
                                    >
                                        <RotateCcw className="h-3 w-3 mr-1" /> Restore
                                    </Button>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </DialogContent>
        </Dialog>
    );
};
