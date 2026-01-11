'use client';

import React from 'react';
import { BuilderSidebar } from '@/components/form-builder/BuilderSidebar';
import { BuilderCanvas } from '@/components/form-builder/BuilderCanvas';
import { BuilderProperties } from '@/components/form-builder/BuilderProperties';
import { Button } from '@/components/ui/button';
import { Eye, Save, Send, ChevronLeft } from 'lucide-react';
import Link from 'next/link';

export default function BuilderPage() {
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
          <h1 className="font-semibold text-sm truncate max-w-[200px]">
            New Form
          </h1>
          <span className="text-xs bg-muted px-2 py-0.5 rounded text-muted-foreground font-medium">
            Draft
          </span>
        </div>
        
        <div className="flex items-center gap-2">
          <Button variant="ghost" size="sm">
            <Eye className="mr-2 h-4 w-4" />
            Preview
          </Button>
          <Button variant="outline" size="sm">
            <Save className="mr-2 h-4 w-4" />
            Save Draft
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
    </div>
  );
}
