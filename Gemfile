# frozen_string_literal: true

source "https://rubygems.org"

# ── SketchUp API autocomplete + IDE support ───────────────────────────────────
gem "sketchup-api-stubs"   # Full API stubs for VS Code intellisense (Solargraph)
gem "solargraph"           # Ruby language server — autocomplete, go-to-def, hover docs

# ── Static analysis of generated .rb scripts ─────────────────────────────────
gem "rubocop",         ">= 1.85", "< 2.0"  # Core linter
gem "rubocop-sketchup", "~> 2.1.1"          # SketchUp-specific cops:
                                             #   SketchupDeprecations   — removed API calls
                                             #   SketchupPerformance    — slow patterns
                                             #   SketchupRequirements   — Extension Warehouse rules
                                             #   SketchupSuggestions    — best practices
                                             #   SketchupBugs           — known API pitfalls

# ── Testing (for manual unit tests on generated scripts) ─────────────────────
gem "minitest"             # Required by Solargraph for test insights
gem "rake"                 # Task automation (e.g. rake lint, rake test)

# ── Documentation ─────────────────────────────────────────────────────────────
gem "yard",         "~> 0.9"
gem "commonmarker", "~> 0.23"  # Markdown support in YARD
