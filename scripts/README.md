# Scripts

## git-push.sh

Interactive git push script for FilmStudioPilot.

### Usage

```bash
./scripts/git-push.sh
```

### Features

- Shows current git status
- Stages all changes
- Prompts for commit message (with default)
- Confirms before committing
- Pushes to current branch
- Color-coded output
- Error handling

### Example

```bash
$ ./scripts/git-push.sh
=== FilmStudioPilot Git Push Script ===

Current branch: main

Current status:
M  FilmStudioPilot/Models/VoiceOver/CharacterBackstory.swift
A  FilmStudioPilot/Services/VoiceOver/VoiceOverService.swift

Staging all changes...
Enter commit message (or press Enter for default):
Add voice over and dialogue rigging system

Commit these changes? (y/n)
y

Committing changes...
✓ Commit successful

Push to main? (y/n)
y

Pushing to origin/main...
✓ Push successful

=== All done! ===
```

