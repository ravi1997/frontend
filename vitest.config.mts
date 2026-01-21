import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
    test: {
        environment: 'node',
        globals: true,
        coverage: {
            provider: 'v8',
            include: ['src/hooks/**', 'src/lib/**', 'src/store/**'],
            reporter: ['text', 'json', 'html'],
            exclude: ['**/__tests__/**', 'src/test/**'],
        },
    },
    resolve: {
        alias: {
            '@': path.resolve(__dirname, './src'),
        },
    },
});
