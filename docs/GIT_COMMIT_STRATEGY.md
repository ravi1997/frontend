# Git Commit Strategy Guide

A comprehensive guide for managing and committing code changes with atomic, well-documented commits.

---

## Table of Contents

1. [Change Type Categories](#1-change-type-categories)
2. [Criteria for Each Change Type](#2-criteria-for-each-change-type)
3. [Commit Message Format](#3-commit-message-format)
4. [When to Split vs. Combine Commits](#4-when-to-split-vs-combine-commits)
5. [Best Practices](#5-best-practices)
6. [Commit Message Examples](#6-commit-message-examples)
7. [Commit Workflow](#7-commit-workflow)

---

## 1. Change Type Categories

### 1.1 Feature (`feat`)

New functionality or capabilities added to the codebase.

**Examples:**

- Adding a new API endpoint
- Creating a new UI component
- Implementing a new business logic feature
- Adding a new configuration option

### 1.2 Bug Fix (`fix`)

Resolving defects or unintended behavior.

**Examples:**

- Fixing a runtime crash
- Correcting incorrect calculations
- Addressing security vulnerabilities
- Fixing UI rendering issues

### 1.3 Refactor (`refactor`)

Restructuring code without changing external behavior.

**Examples:**

- Renaming variables for clarity
- Extracting repeated logic into utilities
- Improving performance without functionality change
- Updating architecture patterns

### 1.4 Documentation (`docs`)

Changes to documentation only.

**Examples:**

- Updating README files
- Adding code comments
- Creating API documentation
- Writing usage guides

### 1.5 Test (`test` or `spec`)

Adding or modifying tests.

**Examples:**

- Adding unit tests for new functionality
- Creating integration tests
- Fixing broken tests
- Adding test fixtures

### 1.6 Chore (`chore`)

Maintenance tasks that don't affect production code.

**Examples:**

- Updating dependencies
- Changing build configuration
- Refreshing generated files
- Repository cleanup

### 1.7 Style (`style`)

Changes that improve code formatting without affecting logic.

**Examples:**

- Fixing linting errors
- Adjusting whitespace
- Updating code formatting
- Changing variable naming conventions

### 1.8 Performance (`perf`)

Changes that improve performance.

**Examples:**

- Optimizing database queries
- Reducing memory usage
- Improving rendering speed
- Caching improvements

### 1.9 Build (`build`)

Changes affecting the build system or dependencies.

**Examples:**

- Updating build scripts
- Changing compiler options
- Adding build targets
- Modifying CI/CD configuration

### 1.10 Revert (`revert`)

Reverting a previous commit.

**Examples:**

- Undoing a problematic commit
- Rolling back a feature
- Restoring previous behavior

---

## 2. Criteria for Each Change Type

### 2.1 Feature Commit Criteria

✅ **Include when:**

- Adding new functionality not previously present
- Implementing user-requested capabilities
- Adding new API endpoints or routes
- Creating new domain entities or services

❌ **Exclude when:**

- The change is purely cosmetic
- Only fixing existing functionality
- Adding tests for existing features

### 2.2 Bug Fix Commit Criteria

✅ **Include when:**

- Fixing runtime errors or crashes
- Addressing incorrect output or behavior
- Resolving security vulnerabilities
- Correcting edge case failures

❌ **Exclude when:**

- The "fix" introduces new functionality
- Only refactoring without fixing behavior
- Changing requirements rather than bugs

### 2.3 Refactor Commit Criteria

✅ **Include when:**

- Improving code structure without behavior change
- Enhancing readability or maintainability
- Reducing code complexity
- Updating internal APIs

❌ **Exclude when:**

- The refactor accidentally changes behavior
- Mixed with new features or fixes
- Too large to review effectively

### 2.4 Documentation Commit Criteria

✅ **Include when:**

- Only documentation files are changed
- Adding inline code comments
- Updating API documentation
- Creating guides or tutorials

❌ **Exclude when:**

- Documentation changes accompany code changes (combine with relevant commit)
- Only fixing typos in code (use `style` instead)

---

## 3. Commit Message Format

### 3.1 Conventional Commits Structure

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 3.2 Header (Required)

```
<type>(<scope>): <subject>
```

**Rules:**

- Maximum 50 characters for subject
- Use imperative mood ("Add feature" not "Added feature")
- Don't capitalize the subject
- No period at the end

**Examples:**

```
feat(auth): add JWT token refresh mechanism
fix(payment): resolve double-charge issue on timeout
refactor(database): extract query builder utility
```

### 3.3 Scope (Optional but Recommended)

The scope identifies the affected component:

**Common scopes:**

- `auth` - Authentication and authorization
- `api` - API endpoints
- `ui`, `frontend`, `backend` - Frontend/backend specific
- `database` - Database layer
- `router` - Routing logic
- `config` - Configuration
- `tests` - Test files

**Examples:**

```
feat(auth): implement OAuth2 login
fix(api): resolve validation error on user creation
```

### 3.4 Body (Optional)

Provide detailed explanation of the change:

**Answer these questions:**

- **What** changed?
- **Why** was this change made?
- **How** does it impact the codebase?

**Guidelines:**

- Wrap text at 72 characters
- Use bullet points for lists
- Include technical details for complex changes
- Explain the problem being solved

**Example Body:**

```
Implement JWT token refresh mechanism to improve security.

- Added token expiration checking before API calls
- Created refresh endpoint that issues new tokens
- Updated auth interceptor to handle 401 responses
- Token refresh happens automatically without user action
```

### 3.5 Footer (Optional)

Reference issues and breaking changes:

**Issue References:**

```
Closes #123
Fixes #456
Resolves #789
```

**Breaking Changes:**

```
BREAKING CHANGE: The API response format for /users has changed.
Users must now access user data via data.user instead of directly.
```

### 3.6 Complete Example

```
feat(auth): implement two-factor authentication

Added 2FA support using TOTP (Time-based One-Time Password).

Changes made:
- Created TwoFactorService for TOTP generation and verification
- Added 2FA setup flow in user settings
- Implemented backup code generation
- Added 2FA verification to login flow

Security considerations:
- Backup codes are hashed before storage
- TOTP secrets are encrypted at rest
- Rate limiting applied to verification attempts

Closes #234
```

---

## 4. When to Split vs. Combine Commits

### 4.1 When to Split Commits

**Split when:**

1. **Multiple independent features**
   - Each feature should have its own commit
   - Example: Adding login AND registration → Two commits

2. **Mixed concerns in one change**
   - Code cleanup mixed with bug fix → Separate them
   - Refactor mixed with new feature → Separate them

3. **Large feature (>400 lines)**
   - Break into logical components
   - Example: Feature with API, UI, and database → Three commits

4. **Breaking changes**
   - Breaking changes should be isolated
   - Allow easy rollback of problematic changes

**Splitting Strategy:**

```
❌ BAD: "feat(auth): add login, fix bugs, update tests"
✅ GOOD:
   1. feat(auth): add login functionality
   2. fix(auth): resolve session timeout issue
   3. test(auth): add login integration tests
```

### 4.2 When to Combine Commits

**Combine when:**

1. **Tightly coupled changes**
   - Changes that must work together
   - Example: API endpoint + its tests + documentation

2. **Small related fixes**
   - Multiple small fixes for the same component
   - Example: Several CSS fixes for one component

3. **Work in progress (WIP) commits**
   - Temporary commits during development
   - Squash before merging to main

**Combining Strategy:**

```
❌ BAD: Separate commits for each file changed
   - feat: add user model
   - feat: add user service
   - feat: add user controller
   - feat: add user routes
✅ GOOD: Single cohesive commit
   - feat(api): implement user management API
```

### 4.3 Decision Matrix

| Scenario | Action | Example |
|----------|--------|---------|
| New feature + its tests | Combine | Feature + Tests in one commit |
| New feature + unrelated fix | Split | Two separate commits |
| Refactor + behavior fix | Split | Separate refactor from fix |
| Multiple small style fixes | Combine | All style fixes in one commit |
| Breaking change + new feature | Split | Breaking change isolated |
| API changes + frontend updates | Split | Backend and frontend separate |

---

## 5. Best Practices

### 5.1 Review Staged Changes Before Committing

**Always run these commands:**

```bash
# Check what files are staged
git status

# Review staged changes
git diff --cached

# Check for unintended changes
git diff --cached --stat
```

**Review Checklist:**

- [ ] Only intended files are staged
- [ ] No sensitive data (API keys, passwords)
- [ ] Changes align with commit message
- [ ] No debugging code left behind
- [ ] Code follows project standards

### 5.2 Writing Meaningful Commit Messages

**Do:**

- ✅ Be specific and descriptive
- ✅ Explain the "why" not just the "what"
- ✅ Reference relevant issues or tickets
- ✅ Use consistent formatting
- ✅ Keep subject line under 50 characters

**Don't:**

- ❌ Use vague messages like "fix" or "update"
- ❌ Write messages in present tense (use past)
- ❌ Include unnecessary details
- ❌ Leave body empty for complex changes
- ❌ Use profanity or unprofessional language

### 5.3 Branch Strategy for Commit Organization

**Branch Naming Conventions:**

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/*` | `feature/user-authentication` |
| Bug Fix | `bugfix/*` | `bugfix/login-crash` |
| Hotfix | `hotfix/*` | `hotfix/security-patch` |
| Refactor | `refactor/*` | `refactor/data-layer` |
| Release | `release/*` | `release/v1.2.0` |

**Commit Flow:**

```
1. Create feature branch
   git checkout -b feature/new-login

2. Make commits during development
   git add .
   git commit -m "feat(auth): add login form UI"
   git commit -m "feat(auth): implement login API"

3. Review and clean up
   git rebase -i main
   git log --oneline

4. Merge with clear history
   git checkout main
   git merge --squash feature/new-login
```

### 5.4 Using Git Hooks for Quality

**Pre-commit Hook Example:**

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Check for debug statements
if grep -r "console.log" --include="*.js" .; then
  echo "Error: Debug statements found"
  exit 1
fi

# Run linter
npm run lint

# Run tests
npm run test
```

---

## 6. Commit Message Examples

### 6.1 Feature Example

```
feat(api): add user profile endpoint

Implemented GET /api/users/:id endpoint with full profile data.

Technical details:
- Returns user object with profile, settings, and preferences
- Includes pagination for related data
- Rate limited to 100 requests/minute
- Cached for 5 minutes

Response format:
{
  "id": "uuid",
  "email": "user@example.com",
  "profile": { ... },
  "settings": { ... }
}

Closes #123
```

### 6.2 Bug Fix Example

```
fix(auth): resolve session expiration handling

Fixed issue where users were logged out immediately after
successful authentication due to incorrect token expiration
calculation.

Root cause:
- Token expiration was set to current time instead of
  current time + TTL
- Clock skew between server and client exacerbated issue

Solution:
- Fixed token generation to use Date.now() + ttl
- Added clock skew tolerance of 60 seconds
- Added server time validation

Tested with:
- Local development environment
- Staging environment with real users

Fixes #456
Related: #455
```

### 6.3 Refactor Example

```
refactor(database): extract data access layer

Separated data access logic from business logic for
better maintainability and testability.

Changes:
- Created UserRepository interface
- Moved all SQL queries to repository
- Updated services to use repository
- Added unit tests for repository

Before:
```dart
class UserService {
  Future<User> getUser(String id) async {
    final result = await db.query(
      'SELECT * FROM users WHERE id = ?',
      [id],
    );
    return User.fromMap(result.first);
  }
}
```

After:

```dart
class UserRepository implements IUserRepository {
  @override
  Future<User> findById(String id) async {
    final result = await db.query(
      'SELECT * FROM users WHERE id = ?',
      [id],
    );
    return User.fromMap(result.first);
  }
}

class UserService {
  UserService(this.repository);
  final IUserRepository repository;
}
```

Benefits:

- Easier to mock for testing
- Can swap database implementations
- Clearer separation of concerns
- Simplified service classes

Impact:

- 15 new files created
- 8 existing files modified
- All tests passing
- No breaking changes to API

```

### 6.4 Documentation Example

```

docs(api): update authentication documentation

Added comprehensive documentation for OAuth2 flow.

Content added:

- Authorization code flow explanation
- Token refresh procedure
- Error response codes
- Sample requests and responses

Updated files:

- docs/api/auth.md (completely rewritten)
- docs/getting-started.md (added auth section)

Reviewed by: @developer1
Closes #789

```

### 6.5 Test Example

```

test(payment): add transaction failure scenarios

Added comprehensive test coverage for payment failures.

Test cases added:

- Network timeout handling
- Insufficient funds scenario
- Card declined responses
- Duplicate transaction detection
- Currency validation

Coverage improvement:

- Before: 65%
- After: 89%

All tests passing in CI pipeline.

```

### 6.6 Chore Example

```

chore(deps): update dependencies to latest versions

Updated npm dependencies for security and performance.

Updated packages:

- express: 4.17.1 → 4.18.2
- mongoose: 6.0.0 → 6.11.3
- jwt: 8.5.1 → 9.0.0
- debug: 4.3.2 → 4.3.4

Breaking changes reviewed:

- jwt@9.0 requires async verify
- All others backward compatible

Audit: `npm audit` shows no vulnerabilities after update

```

### 6.7 Performance Example

```

perf(database): optimize user query performance

Reduced average user query time from 450ms to 45ms.

Optimizations:

- Added composite index on (email, status)
- Removed N+1 query in user list endpoint
- Implemented query result caching
- Added pagination to large result sets

Benchmark results:

- User by ID: 450ms → 12ms (-97%)
- User list (100): 2300ms → 85ms (-96%)
- Search users: 890ms → 78ms (-91%)

Database load reduced by 40%

```

### 6.8 Breaking Change Example

```

feat(api): migrate user data structure

BREAKING CHANGE: User data structure has been normalized.

The user object has been split into separate entities:

Before:

```json
{
  "id": "123",
  "name": "John",
  "address": { "city": "NYC", "zip": "10001" }
}
```

After:

```json
{
  "id": "123",
  "profile": { "name": "John" },
  "address": { "city": "NYC", "zip": "10001" }
}
```

Migration required:

1. Update client code to handle new structure
2. Run database migration script
3. Update any stored references

Migration script: `scripts/migrate-user-data.js`

Steps:

```bash
node scripts/migrate-user-data.js --dry-run
node scripts/migrate-user-data.js
```

Affected endpoints:

- GET /api/users/:id
- POST /api/users
- PUT /api/users/:id

Related: #321, #322, #323

```

---

## 7. Commit Workflow

### 7.1 Step-by-Step Process

```bash
# 1. Check current status
git status

# 2. Review all changes
git diff

# 3. Stage only related changes
git add path/to/relevant/files

# 4. Review staged diff
git diff --cached

# 5. Verify staged files
git diff --cached --stat

# 6. Craft commit message
git commit -m "type(scope): subject

body explaining what, why, and how

footer with issues and breaking changes"

# 7. Verify commit
git log -1

# 8. Push to remote
git push origin branch-name
```

### 7.2 Staging Strategy

**Individual file staging:**

```bash
# Stage specific files
git add src/auth/login.dart tests/auth/login_test.dart

# Stage entire directory
git add src/auth/

# Stage with pattern
git add "src/**/*.service.dart"
```

**Partial file staging:**

```bash
# Stage specific hunks
git add -p src/auth/login.dart

# Options:
# y - stage this hunk
# n - don't stage this hunk
# s - split into smaller hunks
# e - manually edit hunk
```

### 7.3 Review Before Commit Checklist

```bash
# 1. Check status
git status
# Expected: Only relevant files staged

# 2. Review staged changes
git diff --cached
# Expected: Changes match commit intent

# 3. Check for sensitive data
git diff --cached | grep -i "password\|secret\|key\|token"
# Expected: No matches

# 4. Verify no debug code
git diff --cached | grep -i "console.log\|debug\|print\|log\("
# Expected: No debug statements

# 5. Run linter
npm run lint  # or your project's lint command

# 6. Run tests
npm test  # or your project's test command
```

### 7.4 Commit Message Template

Create a template file:

```bash
# ~/.gitmessage.txt
# <type>(<scope>): <subject>
#
# Body: Explain what changed and why
#
# Footer: Reference issues and breaking changes
```

Configure git to use it:

```bash
git config commit.template ~/.gitmessage.txt
```

### 7.5 Automated Commit Checks

**Pre-commit checklist script:**

```bash
#!/bin/bash
# scripts/pre-commit-checks.sh

echo "Running pre-commit checks..."

# Check message length
commit_msg=$(git log -1 --format=%s)
if [ ${#commit_msg} -gt 50 ]; then
  echo "Warning: Commit subject exceeds 50 characters"
fi

# Check for TODO comments
if grep -r "TODO" --include="*.dart" lib/ | grep -v "// TODO:"; then
  echo "Warning: Found TODO comments without assignee"
fi

# Check for hardcoded URLs
if grep -r "http://" --include="*.dart" lib/ | grep -v "http://localhost"; then
  echo "Warning: Found non-HTTPS URLs"
fi

echo "Pre-commit checks complete."
```

---

## 8. Summary

### Key Principles

1. **Atomic Commits**: Each commit should do one thing well
2. **Descriptive Messages**: Explain the "why" not just the "what"
3. **Consistent Format**: Use Conventional Commits for clarity
4. **Review First**: Always review staged changes before committing
5. **Reference Issues**: Connect commits to project management

### Quick Reference

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New functionality | `feat(api): add user search` |
| `fix` | Bug fixes | `fix(auth): resolve login crash` |
| `refactor` | Code restructuring | `refactor(service): extract validator` |
| `docs` | Documentation only | `docs(readme): add setup guide` |
| `test` | Test changes | `test(api): add user validation tests` |
| `chore` | Maintenance | `chore(deps): update packages` |
| `style` | Formatting | `style(lint): fix formatting` |
| `perf` | Performance | `perf(db): add query index` |
| `build` | Build changes | `build(webpack): add minification` |
| `revert` | Revert commit | `revert: revert #123` |

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Maintained By:** Development Team
