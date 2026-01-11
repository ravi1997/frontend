'use client';

import React from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { FieldType } from '@/types';
import { 
  Type, 
  AlignLeft, 
  Hash, 
  Calendar, 
  Clock, 
  ChevronDown, 
  CheckSquare, 
  CircleDot, 
  FileUp, 
  Mail, 
  Phone, 
  Link as LinkIcon,
  MousePointer2
} from 'lucide-react';
import { cn } from '@/lib/utils';

const FIELD_LIBRARY = [
  { type: FieldType.SHORT_TEXT, label: 'Short Text', icon: Type },
  { type: FieldType.LONG_TEXT, label: 'Paragraph', icon: AlignLeft },
  { type: FieldType.NUMBER, label: 'Number', icon: Hash },
  { type: FieldType.DATE, label: 'Date', icon: Calendar },
  { type: FieldType.TIME, label: 'Time', icon: Clock },
  { type: FieldType.DROPDOWN, label: 'Dropdown', icon: ChevronDown },
  { type: FieldType.CHECKBOX, label: 'Checkboxes', icon: CheckSquare },
  { type: FieldType.RADIO, label: 'Multiple Choice', icon: CircleDot },
  { type: FieldType.FILE_UPLOAD, label: 'File Upload', icon: FileUp },
  { type: FieldType.EMAIL, label: 'Email', icon: Mail },
  { type: FieldType.MOBILE, label: 'Mobile', icon: Phone },
  { type: FieldType.URL, label: 'URL', icon: LinkIcon },
];

export const BuilderSidebar = () => {
  const addField = useBuilderStore((state) => state.addField);
  const sections = useBuilderStore((state) => state.sections);

  const handleAddField = (type: FieldType) => {
    if (sections.length > 0) {
      addField(sections[0].id, type);
    }
  };

  return (
    <aside className="w-64 border-r bg-card flex flex-col h-[calc(100vh-3.5rem)]">
      <div className="p-4 border-b">
        <h3 className="font-semibold text-sm flex items-center gap-2">
          <MousePointer2 className="h-4 w-4" />
          Field Library
        </h3>
        <p className="text-xs text-muted-foreground mt-1">
          Click or drag to add fields
        </p>
      </div>
      
      <div className="flex-1 overflow-y-auto p-4 space-y-2">
        <div className="grid grid-cols-2 gap-2">
          {FIELD_LIBRARY.map((field) => {
            const Icon = field.icon;
            return (
              <button
                key={field.type}
                onClick={() => handleAddField(field.type)}
                className={cn(
                  "flex flex-col items-center justify-center p-3 rounded-lg border bg-background hover:border-primary hover:text-primary transition-all group gap-2 text-center"
                )}
              >
                <Icon className="h-5 w-5 text-muted-foreground group-hover:text-primary" />
                <span className="text-[10px] font-medium leading-tight">{field.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    </aside>
  );
};
