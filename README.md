1. Create a Branch
Always create a new branch for your work:

# Update your main branch
git checkout main
git pull upstream main

# Create a new branch
git checkout -b feature/your-feature-name
Branch naming convention:

2. Guide Commit
feature/description - New features (e.g., feature/auction-support)
fix/description - Bug fixes (e.g., fix/reentrancy-vulnerability)
docs/description - Documentation (e.g., docs/api-guide)
test/description - Test improvements (e.g., test/integration-tests)
refactor/description - Code refactoring (e.g., refactor/optimize-gas)
chore/description - Maintenance tasks (e.g., chore/update-dependencies)
