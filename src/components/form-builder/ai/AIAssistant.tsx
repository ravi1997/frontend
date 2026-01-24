'use client';

import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Sparkles, Send, Loader2, Bot, User } from 'lucide-react';
import { generateFormStructure } from '@/lib/aiService';
import { useBuilderStore } from '@/store/builderStore';
import { ISection } from '@/types';

interface Message {
    role: 'user' | 'assistant';
    content: string;
    generatedSections?: ISection[];
}

export const AIAssistant = () => {
    const [open, setOpen] = useState(false);
    const [messages, setMessages] = useState<Message[]>([
        { role: 'assistant', content: 'Hi! I can help you build forms instantly. Try "Create a job application" or "Build a feedback form".' }
    ]);
    const [input, setInput] = useState('');
    const [loading, setLoading] = useState(false);

    // Store access
    const sections = useBuilderStore((state) => state.sections);
    const setSections = useBuilderStore((state) => state.setSections);

    const handleSend = async () => {
        if (!input.trim() || loading) return;

        const userMsg = input;
        setInput('');
        setMessages(prev => [...prev, { role: 'user', content: userMsg }]);
        setLoading(true);

        try {
            const response = await generateFormStructure(userMsg, sections);

            if (response.error) {
                setMessages(prev => [...prev, { role: 'assistant', content: response.error! }]);
                return;
            }

            const assistantMsg: Message = {
                role: 'assistant',
                content: response.suggestion || `I've generated a form with ${response.sections.length} sections based on your request.`,
                generatedSections: response.sections
            };

            setMessages(prev => [...prev, assistantMsg]);
        } catch (error) {
            const errorMsg = error instanceof Error ? error.message : 'Sorry, I encountered an error generating the form.';
            setMessages(prev => [...prev, { role: 'assistant', content: errorMsg }]);
        } finally {
            setLoading(false);
        }
    };

    const handleApply = (sections: ISection[]) => {
        setSections(sections);
        setOpen(false);
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button
                    variant="outline"
                    className="w-full gap-2 border-dashed border-primary/50 text-primary hover:bg-primary/5"
                >
                    <Sparkles className="h-4 w-4" />
                    AI Assistant
                </Button>
            </DialogTrigger>
            <DialogContent className="max-w-[500px] flex flex-col h-[600px] gap-0 p-0">
                <DialogHeader className="p-4 border-b">
                    <DialogTitle className="flex items-center gap-2">
                        <Sparkles className="h-5 w-5 text-primary" />
                        AI Form Assistant
                    </DialogTitle>
                </DialogHeader>

                <div className="flex-1 flex flex-col overflow-hidden">
                    <div className="flex-1 overflow-y-auto p-4 space-y-4">
                        {messages.map((msg, idx) => (
                            <div key={idx} className={`flex gap-3 ${msg.role === 'user' ? 'flex-row-reverse' : ''}`}>
                                <div className={`h-8 w-8 rounded-full flex items-center justify-center shrink-0 ${msg.role === 'assistant' ? 'bg-primary/10 text-primary' : 'bg-muted text-muted-foreground'}`}>
                                    {msg.role === 'assistant' ? <Bot className="h-4 w-4" /> : <User className="h-4 w-4" />}
                                </div>
                                <div className={`flex flex-col gap-2 max-w-[85%]`}>
                                    <div className={`p-3 rounded-lg text-sm ${msg.role === 'assistant' ? 'bg-muted' : 'bg-primary text-primary-foreground'}`}>
                                        {msg.content}
                                    </div>
                                    {msg.generatedSections && (
                                        <div className="border rounded p-3 bg-card space-y-2">
                                            <p className="text-xs text-muted-foreground font-medium">Generated Form:</p>
                                            <div className="text-xs space-y-1">
                                                {msg.generatedSections.map(s => (
                                                    <div key={s.id} className="flex items-center gap-2">
                                                        <span className="font-semibold">{s.title}</span>
                                                        <span className="text-muted-foreground ml-auto">{s.questions.length} fields</span>
                                                    </div>
                                                ))}
                                            </div>
                                            <Button size="sm" className="w-full mt-2" onClick={() => handleApply(msg.generatedSections!)}>
                                                Apply to Builder
                                            </Button>
                                        </div>
                                    )}
                                </div>
                            </div>
                        ))}
                        {loading && (
                            <div className="flex gap-3">
                                <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center">
                                    <Loader2 className="h-4 w-4 animate-spin text-primary" />
                                </div>
                                <div className="bg-muted p-3 rounded-lg text-sm text-muted-foreground">
                                    Thinking...
                                </div>
                            </div>
                        )}
                    </div>
                </div>

                <div className="p-4 bg-muted/20 border-t flex gap-2">
                    <Input
                        value={input}
                        onChange={e => setInput(e.target.value)}
                        onKeyDown={e => {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                                handleSend();
                            }
                        }}
                        placeholder="Describe your form..."
                        disabled={loading}
                    />
                    <Button size="icon" type="button" onClick={handleSend} disabled={loading || !input.trim()}>
                        <Send className="h-4 w-4" />
                    </Button>
                </div>
            </DialogContent>
        </Dialog>
    );
};
