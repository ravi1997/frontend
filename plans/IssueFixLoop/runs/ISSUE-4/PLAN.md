# Implementation Plan

1. **Enhance Metadata**: Update `src/app/layout.tsx` to include:
    * `appleWebApp` configuration.
    * `formatDetection`.
    * `viewport` export (separate from metadata in Next.js 14+).
2. **Verify Build**: Run `npm run build` to confirm `sw.js` and `workbox-*.js` are generated in `public/`.
3. **Test**: Run existing tests.
