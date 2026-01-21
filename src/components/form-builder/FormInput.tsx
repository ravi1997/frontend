'use client';

import React from 'react';
import { IQuestion, FieldType } from '@/types';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Checkbox } from '@/components/ui/checkbox';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

interface FormInputProps {
    question: IQuestion;
    value: any;
    onChange: (value: any) => void;
    error?: string;
}

export const FormInput: React.FC<FormInputProps> = ({ question, value, onChange, error }) => {
    const handleChange = (val: any) => {
        onChange(val);
    };

    const renderInput = () => {
        switch (question.field_type) {
            case FieldType.SHORT_TEXT:
            case FieldType.EMAIL:
            case FieldType.URL:
            case FieldType.MOBILE:
            case FieldType.NUMBER:
                return (
                    <Input
                        type={
                            question.field_type === FieldType.EMAIL ? 'email' :
                                question.field_type === FieldType.NUMBER ? 'number' : 'text'
                        }
                        placeholder={question.placeholder}
                        value={value || ''}
                        onChange={(e) => handleChange(e.target.value)}
                    />
                );

            case FieldType.LONG_TEXT:
                return (
                    <textarea
                        className="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                        placeholder={question.placeholder}
                        value={value || ''}
                        onChange={(e) => handleChange(e.target.value)}
                    />
                );

            case FieldType.DROPDOWN:
                return (
                    <Select value={value} onValueChange={handleChange}>
                        <SelectTrigger>
                            <SelectValue placeholder="Select an option" />
                        </SelectTrigger>
                        <SelectContent>
                            {question.options?.map((opt) => (
                                <SelectItem key={opt.option_value} value={opt.option_value}>
                                    {opt.option_label}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                );

            case FieldType.RADIO:
                return (
                    <div className="space-y-2">
                        {question.options?.map((opt) => (
                            <div key={opt.option_value} className="flex items-center space-x-2">
                                <input
                                    type="radio"
                                    id={`${question.id}-${opt.option_value}`}
                                    name={question.id}
                                    value={opt.option_value}
                                    checked={value === opt.option_value}
                                    onChange={(e) => handleChange(e.target.value)}
                                    className="h-4 w-4 border-primary text-primary focus:ring-1 focus:ring-primary"
                                />
                                <Label htmlFor={`${question.id}-${opt.option_value}`}>{opt.option_label}</Label>
                            </div>
                        ))}
                    </div>
                );

            case FieldType.CHECKBOX:
                if (question.options && question.options.length > 0) {
                    const currentValues = Array.isArray(value) ? value : [];
                    return (
                        <div className="space-y-2">
                            {question.options.map((opt) => (
                                <div key={opt.option_value} className="flex items-center space-x-2">
                                    <Checkbox
                                        id={`${question.id}-${opt.option_value}`}
                                        checked={currentValues.includes(opt.option_value)}
                                        onCheckedChange={(checked: boolean | string) => {
                                            if (checked) {
                                                handleChange([...currentValues, opt.option_value]);
                                            } else {
                                                handleChange(currentValues.filter((v: string) => v !== opt.option_value));
                                            }
                                        }}
                                    />
                                    <Label htmlFor={`${question.id}-${opt.option_value}`}>{opt.option_label}</Label>
                                </div>
                            ))}
                        </div>
                    );
                }
                return (
                    <div className="flex items-center space-x-2">
                        <Checkbox
                            id={question.id}
                            checked={!!value}
                            onCheckedChange={(checked: boolean | string) => handleChange(checked)}
                        />
                        <Label htmlFor={question.id}>{question.placeholder || 'Yes'}</Label>
                    </div>
                );

            default:
                return <div className="text-muted-foreground italic">Field type {question.field_type} not supported in preview.</div>;
        }
    };

    return (
        <div className="space-y-2">
            <Label>
                {question.question_text}
                {question.is_required && <span className="text-destructive ml-1">*</span>}
            </Label>
            {renderInput()}
            {question.help_text && <p className="text-xs text-muted-foreground">{question.help_text}</p>}
            {error && <p className="text-xs text-destructive">{error}</p>}
        </div>
    );
};
