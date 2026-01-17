# CLAUDE.md

This file provides guidance for AI assistants working with this repository.

## Project Overview

**dns-filter-lists** is a collection of personal DNS filter lists for use with
AdGuard Home, Pi-hole, and other DNS filtering solutions. The repository
contains blocklists, allowlists, and custom filtering rules for enhanced
privacy and security.

**License:** Beerware License

## Repository Structure

```
dns-filter-lists/
├── adguardhome/           # AdGuard Home filter lists
│   ├── allowlist.txt      # Domains to whitelist (allow)
│   ├── blocklist.txt      # Domains to block
│   └── custom.txt         # Custom filtering rules
├── bind9/                 # BIND9 DNS server configs (placeholder)
│   └── .gitkeep
├── scripts/               # Automation scripts
│   └── create-apple-enterprise-list.sh
├── .github/               # GitHub configuration
│   ├── workflows/         # CI workflows (currently disabled)
│   ├── CONTRIBUTING.md    # Contribution guidelines
│   ├── SUPPORT.md         # Support information
│   ├── CODEOWNERS         # Code ownership
│   └── dependabot.yml     # Dependency updates
├── justfile               # Task runner commands
└── [config files]         # Linting and editor configs
```

## Filter List Formats

### AdGuard Home Lists

Filter lists use plain text format with one domain per line:

```
# Comments start with hash
domain.com
subdomain.example.com
*.wildcard.com
```

#### Allowlist (`adguardhome/allowlist.txt`)

- Contains domains that should bypass blocking
- Organized by category with section headers: `### Category ###`
- Sub-categories use: `## Subcategory`
- Comments document source URLs when available
- Categories include: Hardware, Productivity, Gaming

#### Blocklist (`adguardhome/blocklist.txt`)

- Contains domains to block
- Commented-out entries (prefixed with `#`) indicate inactive rules
- Add inline comments to document why entries are blocked

#### Custom Rules (`adguardhome/custom.txt`)

- For advanced AdGuard-specific filtering syntax
- Currently empty, reserved for complex rules

### Domain Entry Conventions

- One domain per line (except for related entries on same line)
- Use comments to document sources and reasons
- Group related domains together
- Wildcard entries: Use `*.domain.com` format for subdomains
- Sort entries alphabetically within sections when practical

## Development Workflow

### Prerequisites

- `just` - Command runner ([casey/just](https://github.com/casey/just))
- `shellcheck` - Shell script linter
- `markdownlint` - Markdown linter
- `yamllint` - YAML linter
- Standard Unix tools: `curl`, `grep`, `sort`

### Task Runner

Use `just` for common tasks:

```bash
just          # List available tasks
just help     # Show help
just sysinfo  # Display system information
```

### Scripts

Scripts are located in `scripts/` and follow bash best practices:

- **create-apple-enterprise-list.sh**: Fetches Apple enterprise domains from
  Apple's support documentation and generates a domain list

Script conventions:
- Use `set -euo pipefail` for strict error handling
- Include version, logging functions, and cleanup traps
- Check dependencies before execution
- Output to `out/` directory (gitignored)

## Code Style and Conventions

### General

- **Charset:** UTF-8
- **Line endings:** LF (Unix-style)
- **Final newline:** Always include
- **Trailing whitespace:** Remove (except in Markdown)

### Shell Scripts (`.sh`)

- **Indentation:** 2 spaces
- **Max line length:** 80 characters
- **Shebang:** `#!/bin/bash`
- **Use `shellcheck`** for linting (config in `.shellcheckrc`)
- Enable all shellcheck rules with `enable=all`
- Use bash-specific features allowed

### Markdown (`.md`)

- **Indentation:** 4 spaces
- **Max line length:** 80 characters
- **Headings:** ATX-style (`#`)
- **Lists:** Use dashes (`-`)
- **Code blocks:** Fenced with backticks
- Trailing whitespace allowed for line breaks

### YAML (`.yml`, `.yaml`)

- **Indentation:** 2 spaces
- **Document start:** Required (`---`)
- **Max line length:** 120 characters (warning)
- Use `yamllint` for validation

### Justfile

- **Indentation:** 2 spaces
- Use recipe aliases for common commands

## Linting Configuration

### ShellCheck (`.shellcheckrc`)

```
enable=all
shell=bash
color=always
external-sources=true
```

### Markdownlint (`.markdownlint.yaml`)

Key rules:
- ATX-style headings only
- Line length: 80 characters (code blocks and tables exempt)
- Allow bare URLs (MD034 disabled)
- Allow inline HTML: `<br>`, `<hr>` only

### Yamllint (`.yamllint.yml`)

Key rules:
- Extends `default` config
- 2-space indentation
- Document start required
- Max line length: 120 (warning level)

## Git Workflow

### Branch Strategy

- Main branch: `main`
- Feature branches for development
- Pull requests for contributions

### Commit Messages

- Write clear, concise commit messages
- Use conventional format when appropriate:
  - `feat:` for new features
  - `fix:` for bug fixes
  - `docs:` for documentation
  - `refactor:` for refactoring

### CI/CD

CI workflow is currently disabled (`.github/workflows/ci.yml.off`). When
enabled, it runs on push/PR to `main` using Ubuntu latest.

## Adding New Filter Entries

### To Allowlist

1. Identify the appropriate category section
2. Add domain(s) with optional comment for source
3. Keep related domains grouped together

Example:
```
## Service Name
# https://documentation-url.com
domain1.example.com
domain2.example.com
```

### To Blocklist

1. Add domain with comment explaining the reason
2. Use `#` prefix to temporarily disable entries
3. Reference sources in comments when available

### Testing Changes

- Verify syntax is correct (one domain per line)
- Test in AdGuard Home or target DNS filter
- Check that no essential services break

## Important Notes for AI Assistants

1. **Filter list format is simple**: One domain per line, comments with `#`
2. **Preserve organization**: Keep category headers and groupings
3. **Document sources**: Add comments with URLs when adding new entries
4. **Avoid duplicates**: Check existing entries before adding new ones
5. **Wildcards**: Use `*.domain.com` sparingly and only when needed
6. **Test impact**: Consider what services might break from blocking
7. **Shell scripts**: Follow strict bash practices with proper error handling
8. **Respect line limits**: 80 chars for shell/markdown, 120 for YAML

## Common Tasks

### Add a domain to allowlist

```bash
echo "newdomain.com" >> adguardhome/allowlist.txt
```

### Generate Apple enterprise domain list

```bash
./scripts/create-apple-enterprise-list.sh
# Output: out/apple-enterprise-domains.txt
```

### Validate shell scripts

```bash
shellcheck scripts/*.sh
```

### Validate YAML files

```bash
yamllint .
```

### Validate Markdown files

```bash
markdownlint "**/*.md"
```

## Resources

- [AdGuard Filter Syntax](https://adguard.com/kb/general/ad-filtering/create-own-filters/)
- [Pi-hole Commonly Whitelisted Domains](https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212)
- [RFC 5234 - ABNF Grammar](https://datatracker.ietf.org/doc/html/rfc5234)
