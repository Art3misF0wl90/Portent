<#
.SYNOPSIS
  Create all Portent v3 labels, milestones, and issues via the GitHub CLI.

.DESCRIPTION
  Native PowerShell port of create-issues.sh. Creates 11 labels, 6 milestones,
  and 27 issues on the target repo.

  Prerequisites:
    1. Install gh:    winget install --id GitHub.cli
    2. Authenticate:  gh auth login
    3. Run from anywhere.

  Safe to re-run for labels/milestones (create-or-skip). Issues are NOT
  de-duplicated by GitHub, so re-running WILL create duplicate issues.
  Run the issue section once. Use -DryRun to preview without writing.

.PARAMETER Repo
  Target repository as owner/name. Defaults to Art3misF0wl90/Portent.

.PARAMETER DryRun
  Print every gh command without executing it.

.EXAMPLE
  .\create-issues.ps1 -DryRun

.EXAMPLE
  .\create-issues.ps1

.EXAMPLE
  .\create-issues.ps1 -Repo Art3misF0wl90/stock-predictor
#>

[CmdletBinding()]
param(
  [string]$Repo = "Art3misF0wl90/Portent",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------------
# Helper: run a gh command, echoing it first. Honors -DryRun.
# Args are passed as an array so multi-word values (titles, bodies) stay intact.
# ---------------------------------------------------------------------------
function Invoke-Gh {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GhArgs)
  Write-Host "+ gh $($GhArgs -join ' ')" -ForegroundColor DarkGray
  if ($DryRun) { return }
  & gh @GhArgs
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "gh (GitHub CLI) is not on PATH. Install with: winget install --id GitHub.cli, then open a new terminal."
  exit 1
}
if (-not $DryRun) {
  & gh auth status *> $null
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Not authenticated. Run 'gh auth login' first."
    exit 1
  }
}

Write-Host "Target repo: $Repo"
if ($DryRun) { Write-Host "(dry run - no changes will be made)" -ForegroundColor Yellow }
Write-Host ""

# ---------------------------------------------------------------------------
# Labels - create-or-update via --force.
# ---------------------------------------------------------------------------
Write-Host "== Labels ==" -ForegroundColor Cyan
function New-Label {
  param([string]$Name, [string]$Color, [string]$Description)
  Invoke-Gh label create $Name --repo $Repo --color $Color --description $Description --force
}

New-Label "phase-1-design"       "1d76db" "Phase 1 - Product Design / SRS"
New-Label "phase-2-architecture" "0e8a16" "Phase 2 - Architectural design / SAD"
New-Label "phase-2-detailed"     "5319e7" "Phase 2 - Detailed design / SDD"
New-Label "phase-3-impl"         "fbca04" "Phase 3 - Implementation"
New-Label "phase-4-verify"       "d93f0b" "Phase 4 - Verification (SWE 3643)"
New-Label "phase-5-docs"         "c5def5" "Phase 5 - Documentation & delivery"
New-Label "srs"                  "bfdadc" "Software Requirements Specification"
New-Label "sad"                  "bfdadc" "Software Architecture Document"
New-Label "sdd"                  "bfdadc" "Software Design Document"
New-Label "next-up"              "e99695" "Immediate next action"
New-Label "blocked"              "000000" "Blocked by another issue"
Write-Host ""

# ---------------------------------------------------------------------------
# Milestones - via REST API (gh has no native milestone command).
# Idempotent: checks for an existing title before POSTing.
# ---------------------------------------------------------------------------
Write-Host "== Milestones ==" -ForegroundColor Cyan
function New-Milestone {
  param([string]$Title)
  if ($DryRun) { Write-Host "+ (milestone) ensure '$Title'" -ForegroundColor DarkGray; return }
  Write-Host "+ milestone: $Title" -ForegroundColor DarkGray
  $endpoint = "repos/$Repo/milestones"
  & gh api $endpoint -f "title=$Title" 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "  (already exists or skipped: $Title)"
  }
}

New-Milestone "Phase 1 - SRS"
New-Milestone "Phase 2 - SAD"
New-Milestone "Phase 2 - SDD"
New-Milestone "Phase 3 - Implementation"
New-Milestone "Phase 4 - Verification"
New-Milestone "Phase 5 - Documentation"
Write-Host ""

# ---------------------------------------------------------------------------
# Issues
# Bodies are here-strings (@' ... '@) so multi-line markdown survives intact.
# ---------------------------------------------------------------------------
Write-Host "== Issues ==" -ForegroundColor Cyan
function New-Issue {
  param([string]$Title, [string]$Labels, [string]$Milestone, [string]$Body)
  Invoke-Gh issue create --repo $Repo --title $Title --label $Labels --milestone $Milestone --body $Body
}

# ---- Phase 1 - SRS --------------------------------------------------------

New-Issue "Derive the actor list from the 14 external events" "phase-1-design,srs,next-up" "Phase 1 - SRS" @'
The event list is complete (14 events). Derive the actor list from it. This unblocks the use case diagram.

**Acceptance criteria**
- [ ] Every actor traces to at least one of the 14 events
- [ ] Each candidate validated against the five L6 rules (noun; not the system; appears in >=1 use case; role not person; Clock allowed)
- [ ] Resolve the open question: is "External Data Provider" one actor or three (market / sentiment / earnings)? Document the decision and reason.
- [ ] The Portfolio and Audit Trail are confirmed *excluded* (they are stakeholders/internal concepts, not actors)

**Governed by:** L6 (Use Case). See `docs/03-events-and-actors.md`.
'@

New-Issue "Write the problem-domain glossary" "phase-1-design,srs" "Phase 1 - SRS" @'
Define the problem-domain terms the SRS and conceptual model depend on. Consistent terms are a prerequisite for L8 conceptual modeling.

**Acceptance criteria**
- [ ] Every noun used in a functional requirement has a glossary entry
- [ ] The four flagged-undefined terms are pinned down: macro relevance, confidence, multi-horizon meshing, data sufficiency (one-calendar-year threshold)
- [ ] Definitions are domain-specific where they differ from general finance usage

**Governed by:** L5 (deliverable), L8 (depends on it). See `docs/04-glossary.md`.
'@

New-Issue "Draft the use case diagram" "phase-1-design,srs,blocked" "Phase 1 - SRS" @'
Draw actors <-> use cases with the system boundary.

**Blocked by:** actor list.

**Acceptance criteria**
- [ ] System boundary drawn; all actors placed outside it
- [ ] No `<<include>>`, `<<extend>>`, or generalization (forbidden by L6 at this stage)
- [ ] Every actor connects to >=1 use case; every use case to >=1 actor
- [ ] ~12-14 use cases total

**Governed by:** L6 (Use Case).
'@

New-Issue "Write use case descriptions (start with Onboard Ticker)" "phase-1-design,srs,blocked" "Phase 1 - SRS" @'
Write each use case in the L7 template. **Start with _Onboard Ticker_** - it is the most complex and stress-tests the actors, glossary, and needs upstream.

**Blocked by:** use case diagram.

**Acceptance criteria (per use case)**
- [ ] Name (verb phrase), scope, level, primary actor
- [ ] Stakeholders & needs (citing the needs from `docs/02-needs.md`)
- [ ] Preconditions, postconditions
- [ ] Main success scenario
- [ ] Extensions (each becomes an edge-case test in Phase 4)
- [ ] ~12-14 descriptions complete

**Governed by:** L7 (Use Case Descriptions).
'@

New-Issue "Specify functional, data, non-functional, and interface requirements" "phase-1-design,srs" "Phase 1 - SRS" @'
Write the requirements sections of the SRS.

**Acceptance criteria**
- [ ] **Functional:** atomic, "must"/"shall", active voice, verifiable
- [ ] **Data:** the full entity set (16+ with options confirmed and any multi-horizon additions)
- [ ] **Non-functional:** organized into Operational (performance, availability, security, reliability, usability) and Developmental (maintainability, reusability); each tied to a stakeholder and measurable where possible
- [ ] **Interface:** user / hardware / software (SRS section 5)

**Governed by:** L5, L10 (NFR categories).
'@

New-Issue "Finalize and inspect the SRS" "phase-1-design,srs" "Phase 1 - SRS" @'
Assemble the SRS in the L5 template (section 1 Product Description -> section 5 Interface Requirements) and run the inspection.

**Acceptance criteria**
- [ ] SRS section 1 consolidated from mission + scope decisions (`docs/00-mission.md`)
- [ ] Requirements inspection checklist run: atomic? verifiable? consistent? complete? prioritized?
- [ ] Desk check + walkthrough done
- [ ] **Closing this issue closes Phase 1**

**Governed by:** L5.
'@

# ---- Phase 2 - SAD --------------------------------------------------------

New-Issue "Identify architectural drivers from the SRS" "phase-2-architecture,sad,blocked" "Phase 2 - SAD" @'
Analyze the finished SRS for the requirements that most constrain the design (candidates: reusable onboarding pipeline, derived-state portfolio, config-versioning, per-ticker model isolation).

**Blocked by:** SRS.

**Acceptance criteria**
- [ ] Architectural drivers listed and justified against specific requirements
- [ ] Risky parts flagged for prototyping (multi-horizon signal abstraction, suggestion-engine meshing)

**Governed by:** L8.
'@

New-Issue "Build the conceptual model and CRC cards" "phase-2-architecture,sad" "Phase 2 - SAD" @'
**Acceptance criteria**
- [ ] L8 process followed: Identify Classes (noun extraction from SRS) -> Attributes -> Associations -> Multiplicities
- [ ] CRC cards for the major problem-domain entities (Class, Responsibilities, Collaborators)

**Governed by:** L8.
'@

New-Issue "Prototype the risky parts" "phase-2-architecture,sad" "Phase 2 - SAD" @'
Feasibility prototypes before committing the architecture.

**Acceptance criteria**
- [ ] Multi-horizon signal abstraction prototyped
- [ ] Suggestion-engine meshing logic prototyped
- [ ] Findings fed back into the architecture candidates

**Governed by:** L10/L11 feasibility & adequacy.
'@

New-Issue "Generate and score candidate architectures" "phase-2-architecture,sad" "Phase 2 - SAD" @'
**Do not skip to one structure.** Produce 2-3 candidate styles and score them.

**Acceptance criteria**
- [ ] 2-3 candidate architectures drawn from the L16 style menu (Layered, Pipe-and-Filter, Shared-Data/Blackboard, Event-Driven, MVC, heterogeneous combos)
- [ ] Utility tree built (profiles: usage, reliability, performance, changeability; 3-10 scenarios per leaf, from the SRS)
- [ ] Multi-dimensional weighted analysis table: normalized weights x ratings, summed and compared
- [ ] Architecture selected and justified in a written rationale

**Governed by:** L10, L11, L16. See `docs/architecture.md` (current draft is a *candidate*, not the decision).
'@

New-Issue "Produce the structural views and data model" "phase-2-architecture,sad" "Phase 2 - SAD" @'
**Acceptance criteria**
- [ ] Component diagram (components, responsibilities, provided/required interfaces)
- [ ] Box-and-line structural diagram
- [ ] Data model (entity set as ER/class model)
- [ ] Non-functional requirements mapped to components (reliability -> per-ticker isolation; changeability -> config service + seams; reusability -> cohesion/coupling)

**Governed by:** L10.
'@

New-Issue "Finalize and review the SAD" "phase-2-architecture,sad" "Phase 2 - SAD" @'
**Acceptance criteria**
- [ ] SAD assembled in the L10 template (Overview, Architectural Models via DeSCRIPTR, Mapping, Rationale)
- [ ] Checked well-formed / complete / clear / consistent
- [ ] Review run (desk check -> walkthrough -> inspection)

**Governed by:** L10, L11.
'@

# ---- Phase 2 - SDD --------------------------------------------------------

New-Issue "Mid-level design: decompose components into classes" "phase-2-detailed,sdd" "Phase 2 - SDD" @'
**Acceptance criteria**
- [ ] Each component decomposed via creational or transformational technique
- [ ] Responsibility-driven decomposition: one operational + one data responsibility per class, no overlap
- [ ] Design-level class diagrams (attributes, operations, associations, multiplicities - no implementation detail)

**Governed by:** L12, L8.
'@

New-Issue "Sequence diagrams for key use cases" "phase-2-detailed,sdd" "Phase 2 - SDD" @'
**Acceptance criteria**
- [ ] Diagrams for Onboard Ticker, Generate Suggestion, Evaluate Alert Conditions
- [ ] opt/alt/break/loop fragments used
- [ ] Delegated control (no centralized/bloated controllers); Law of Demeter respected

**Governed by:** L13.
'@

New-Issue "State transition diagrams for lifecycle entities" "phase-2-detailed,sdd" "Phase 2 - SDD" @'
**Acceptance criteria**
- [ ] Onboarding status: PENDING->FETCHING->ANALYZING->TRAINING->COMPLETE/FAILED
- [ ] Option position: OPEN->CLOSED/EXPIRED
- [ ] Alert delivery: PENDING->DELIVERED/FAILED->ACKNOWLEDGED
- [ ] `event [guard] / action` notation; entry/exit/do where relevant

**Governed by:** L14. See `docs/architecture.md`.
'@

New-Issue "Low-level design (PAID) and mid-level patterns" "phase-2-detailed,sdd" "Phase 2 - SDD" @'
**Acceptance criteria**
- [ ] PAID: packaging into compilation units, detailed algorithms, visibility/accessibility, concrete data structures
- [ ] Patterns classified by GoF purpose and documented (Name, Problem, Solution, Consequences). Candidates: Strategy (swappable models), Factory (onboarding construction), Observer (dashboard pushes / alerts), State (lifecycle entities), Iterator (collection traversal)
- [ ] SDD assembled: mid-level + low-level models + mapping + rationale + glossary

**Governed by:** L15, L17, L12.
'@

# ---- Phase 3 - Implementation --------------------------------------------

New-Issue "Walking skeleton: one ticker, end to end" "phase-3-impl" "Phase 3 - Implementation" @'
Build in **dependency order**, not feature order. Get a walking skeleton working first.

**Acceptance criteria**
- [ ] One ticker onboards, produces one signal, renders on one dashboard view - full path
- [ ] Project skeleton, config service + history, DB schema + migrations, entity set in place
'@

New-Issue "Data layer" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Data-source interfaces, **interval-parameterized** (intraday is a clean future add)
- [ ] Caching, throttling, MacroCorrelationAnalyzer
- [ ] Macro join uses `end=None` + `.ffill().bfill()`
'@

New-Issue "Model layer" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Multi-horizon training; model registry/audit; accept/reject by AUC
- [ ] **The `config.pkl` rule enforced:** load `feat_cols`/`fwd_days`/horizons from saved config, never regenerate (see the TSLA 57-vs-53 case in `docs/architecture.md`)
'@

New-Issue "Onboarding pipeline" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Reusable unit callable from web / API / cron / CLI
- [ ] Status tracking through the onboarding state machine
'@

New-Issue "Portfolio layer" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Transaction model; derived-state computation; validation before recording
- [ ] Options handled as a distinct flow
'@

New-Issue "Signal + suggestion engines" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Per-horizon signals
- [ ] Intent-aware multi-horizon meshing
- [ ] Every suggestion cites sentiment/earnings/signal data
'@

New-Issue "Alert system" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Evaluation, delivery, retry/queue
- [ ] Full audit trail; acknowledgement stops re-notification
'@

New-Issue "Web / API + WebSocket, and chatbot" "phase-3-impl" "Phase 3 - Implementation" @'
**Acceptance criteria**
- [ ] Dashboard with real-time pushes
- [ ] Chatbot answers grounded in real system state
'@

# ---- Phase 4 - Verification ----------------------------------------------

New-Issue "Unit + boundary-value testing" "phase-4-verify" "Phase 4 - Verification" @'
Each use case becomes a test spec: main scenario -> happy path, each extension -> an edge case.

**Acceptance criteria**
- [ ] White-box unit tests with mocked data sources
- [ ] BVA on config thresholds (VIX ceilings, min confidence, AUC margin), the one-year data-sufficiency threshold, position-validation edges
'@

New-Issue "Integration, system, performance, regression, coverage" "phase-4-verify" "Phase 4 - Verification" @'
**Acceptance criteria**
- [ ] Integration: onboarding stages in sequence; signal->suggestion->alert chain
- [ ] System (black-box): every use case main scenario + extension
- [ ] Performance: inference latency for the "feels live" dashboard requirement
- [ ] Regression: around config-versioning and model accept/reject
- [ ] Code coverage analysis
'@

# ---- Phase 5 - Documentation ---------------------------------------------

New-Issue "Vault, README, ADRs, and traceability audit" "phase-5-docs" "Phase 5 - Documentation" @'
**Acceptance criteria**
- [ ] Obsidian project vault (numbered folders 00-14; SRS/SAD/SDD as core notes)
- [ ] README / setup docs for Future-Maintainer-Self
- [ ] ADRs preserving the rationale sections
- [ ] Traceability audit: every line of code -> use case -> need -> stakeholder
'@

Write-Host ""
Write-Host "Done. Created (or previewed) 11 labels, 6 milestones, 27 issues on $Repo." -ForegroundColor Green
if ($DryRun) { Write-Host "That was a dry run - re-run without -DryRun to apply." -ForegroundColor Yellow }
