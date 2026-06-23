---
title: Portent — Full Project Roadmap
type: project-roadmap
course: SWE 3633 (Design & Architecture) + SWE 3643 (Testing & QA)
status: in-progress
phase: Product Design (Phase 1)
created: 2026-05-22
tags:
  - portent
  - swe3633
  - swe3643
  - project-roadmap
---
# Portent — Full Project Roadmap

> [!info] How this is organized
> This roadmap follows the **actual process taught in SWE 3633**, verified against the lecture set (L1–L17). The spine is L4's two-phase model: **Product Idea → Product Design → SRS → Engineering Design → Design Document → Implementation → Verification**. Each phase cites the governing lecture(s) so you can go back to the source. Checkboxes track progress.

> [!summary] The two big phases at a glance
> - **Phase 1 — Product Design** produces the **SRS** (the *problem*: what & why). Governed by [[L1-Intro SW Design]], [[L4-DesignProcess]], [[L5-Product Design]], [[L6-Use Case]], [[L7-Use Cases Descriptions]].
> - **Phase 2 — Engineering Design** produces the **Design Document / SAD** (the *solution*: how). Governed by [[L8-EngDesignAnalysis]], [[L10-ArchitectureDesign]], [[L11-Architecture Resolution]], [[L12-Detailed Design-Midlevel]], [[L13-Sequence Diagrams]], [[L14-State Transition Diagrams]], [[L15-Detailed Design-LowLevel]], [[L16-SW Patterns]], [[L17-Patterns-MidLevel]].
> - Then **Implementation** and **Verification** (the latter is your entire SWE 3643 course).

---

## Cross-cutting principle (from L4, L2, L11)

> [!important] Generate → Evaluate → Select, and iterate
> Every resolution stage in this process is a loop: **generate multiple candidates → evaluate them → select the best → loop back if inadequate**. The single most repeated lesson across L2, L4, and L11 is *"the best solution is rarely the first one you think of."* Do not design anything once. This applies especially to the **architecture** (Phase 2B), where you must produce 2–3 candidate styles and score them, not jump to the first structure that seems fine.

---

# PHASE 1 — PRODUCT DESIGN → produces the SRS

> [!info] Target deliverable: the SRS
> Per [[L5-Product Design]], the SRS has a fixed template (reproduced at the end of this phase). Everything in Phase 1 is feeding that document.

## 1A. Analysis: Design Problem
*Governed by [[L4-DesignProcess]], [[L5-Product Design]]. Work products: statement of interested parties, product concept, scope, business goals.*

- [x] Mission statement *(input to the whole process — L5 mission template)*
- [x] Stakeholders / interested parties *(six, including the User → User + User's Financial Position split)*
- [x] Scope decisions: execution **deferred** behind extension point; day-trading **declined** in favor of multi-horizon; multi-horizon signals **adopted**
- [ ] **Product concept / context statement** — consolidate the above into the SRS §1 form (Product Vision, Business Requirements, Users & Stakeholders, Project Scope, Assumptions, Constraints)

## 1B. Analysis: Detailed Needs
*Governed by [[L4-DesignProcess]], [[L6-Use Case]]. Work products: problem domain description, lists of needs & stakeholders, problem models.*

- [x] Needs list (27 needs, asymmetric by stakeholder — correct)
- [x] Event list (14 external events)
- [ ] **Actor list** ← *immediate next step*. Derive from the 14 events; validate against the five L6 actor rules (nouns; never the system itself; every actor in ≥1 use case; role not person; Clock is valid)
- [ ] **Problem domain glossary** — define: ticker, signal, horizon, position intent, macro relevance, onboarding status, etc. (L5 lists Glossary as a deliverable; L8 conceptual modeling depends on consistent terms)

## 1C. Resolution: Product Specification — the SRS itself
*Governed by [[L6-Use Case]], [[L7-Use Cases Descriptions]], [[L5-Product Design]]. Work products: the use case model + requirements doc.*

- [ ] **Use case diagram** — actors ↔ use cases, system boundary drawn. **No** `<<include>>`, `<<extend>>`, or generalization (L6 forbids them)
- [ ] **Use case descriptions** in the L7 template, ~12–14 total. Each: name (verb phrase), scope, level, primary actor, stakeholders & needs, preconditions, postconditions, main success scenario, extensions. **Start with _Onboard Ticker_** (most complex; stress-tests everything above)
- [ ] **Functional requirements** — stated per L5 rules: atomic, "must"/"shall", active voice, **verifiable**
- [ ] **Data requirements** — the entity set (15 in v1; now 16+ with options confirmed + any multi-horizon additions)
- [ ] **Non-functional requirements** — organized per L10 into **Operational** (performance, availability, security, reliability, usability) and **Developmental** (maintainability, reusability). Each tied to a stakeholder, stated measurably where possible
- [ ] **Interface requirements** — user / hardware / software interfaces (SRS §5)
- [ ] **SRS finalization** — run the [[L5-Product Design]] **requirements inspection checklist** (atomic? verifiable? consistent? complete? prioritized?). Do a desk check + walkthrough

> [!summary] SRS Template (from L5 — use this exact structure)
> 1. Product Description (1.1 Vision, 1.2 Business Reqs, 1.3 Users & Stakeholders, 1.4 Scope, 1.5 Assumptions, 1.6 Constraints)
> 2. Functional Requirements
> 3. Data Requirements
> 4. Non-Functional Requirements
> 5. Interface Requirements (5.1 User, 5.2 Hardware, 5.3 Software)

---

# PHASE 2 — ENGINEERING DESIGN → produces the Design Document / SAD

## 2A. Design Analysis
*Governed by [[L8-EngDesignAnalysis]]. Work products: analysis/conceptual models of the engineering problem.*

- [ ] **Analyze the SRS** for architectural drivers — which requirements most constrain the design? (Portent: reusable onboarding pipeline, derived-state portfolio, config-versioning, per-ticker model isolation)
- [ ] **Conceptual model** via the L8 process: Identify Classes (noun extraction from SRS) → Add Attributes → Add Associations → Add Multiplicities
- [ ] **CRC cards** for the major problem-domain entities (Class, Responsibilities, Collaborators)
- [ ] **Prototype the risky parts** (L10/L11 feasibility & adequacy principles): the multi-horizon signal abstraction and the suggestion-engine meshing logic

## 2B. Resolution: Architectural Design — produces the SAD
*Governed by [[L10-ArchitectureDesign]], [[L11-Architecture Resolution]], [[L16-SW Patterns]], [[Component Diagrams]], [[Box & Line Diagrams]].*

> [!summary] SAD Template (from L10 — use this exact structure)
> 1. Product Overview (from the SRS)
> 2. Architectural Models (use **DeSCRIPTR** as the modeling guide)
> 3. Mapping between Models
> 4. Architectural Design Rationale (alternatives considered, why this choice)

- [ ] **Develop candidate architectures** (L11's five methods; draw from the [[L16-SW Patterns]] catalog of styles)
  - Style menu (L16): **Layered**, **Pipe-and-Filter**, **Shared Data** (Blackboard / Repository), **Event-Driven**, **MVC**, plus **Heterogeneous** combos
  - Portent-relevant mappings to consider: MVC for the web app · Event-Driven for the alert/dispatch system · Shared-Data/Blackboard (+ DB triggers) for the config-and-audit core · Pipe-and-Filter for the onboarding pipeline
- [ ] **Build a utility tree** (L11) — sub-trees = profiles (usage, reliability, performance, changeability); leaves = 3–10 scenarios each, drawn from the SRS
- [ ] **Evaluate alternatives** against the profiles; use the **multi-dimensional weighted analysis table** (L11/L5, p.306): normalized weights × ratings, sum, compare
- [ ] **Select & justify** the architecture (the Rationale section — L10 says choosing *which* decisions to discuss is itself important)
- [ ] **Component diagram** — major components, responsibilities, provided/required interfaces
- [ ] **Box-and-line diagram** — structural view
- [ ] **Data model** — the entity set as an ER/class model
- [ ] **Map non-functional requirements to components** (L10's "very important task") — show *how* each quality attribute is achieved structurally (reliability → per-ticker isolation; changeability → config service + interface seams; reusability → high cohesion / loose coupling)
- [ ] **Finalize SAD** — check well-formed / complete / clear / consistent; run a **review** (desk check → walkthrough → inspection, per L11's five review types)

## 2C. Resolution: Detailed Design — produces the SDD
*Governed by [[L12-Detailed Design-Midlevel]], [[L13-Sequence Diagrams]], [[L14-State Transition Diagrams]], [[L15-Detailed Design-LowLevel]], [[L17-Patterns-MidLevel]].*

> [!summary] The two detailed-design acronyms (from L12)
> **Mid-level = DeSCRIPTR**: **De**composed components · **S**tates · **C**ollaboration · **R**esponsibilities · **I**nterfaces · **P**roperties · **T**ransition of states · **R**elationships.
> **Low-level = PAID**: **P**ackaging · **A**lgorithms · **I**mplementation issues · **D**ata structures.

- [ ] **Mid-level design** (L12) — decompose each component into classes via the *creational* (themes → candidate classes → evaluate) or *transformational* (convert actors/controllers from the conceptual model) technique. Apply **responsibility-driven decomposition**: one operational + one data responsibility per class, no overlap (cohesion/coupling)
- [ ] **Class diagrams** — design-level (attributes, operations, associations, multiplicities; no implementation detail yet). Follow L8 class-diagram rules & heuristics
- [ ] **Sequence diagrams** (L13) — for key use cases: *Onboard Ticker*, *Generate Suggestion*, *Evaluate Alert Conditions*. Use opt/alt/break/loop fragments. **Aim for delegated control**, avoid centralized/bloated controllers; respect the **Law of Demeter**
- [ ] **State transition diagrams** (L14) — for the lifecycle entities: onboarding status (PENDING→FETCHING→ANALYZING→TRAINING→COMPLETE/FAILED), option position (OPEN→CLOSED/EXPIRED), alert delivery (PENDING→DELIVERED/FAILED→ACKNOWLEDGED). Use `event [guard] / action`, entry/exit/do
- [ ] **Low-level design** (L15 / PAID) — packaging into compilation units, detailed algorithms, visibility/accessibility, concrete data structures
- [ ] **Apply mid-level patterns** (L17) — classify by GoF purpose (Creational / Structural / Behavioral). Candidates: **Strategy** (swappable models), **Factory** (onboarding pipeline construction), **Observer** (real-time dashboard pushes / Blackboard alerts), **State** (the lifecycle entities above), **Iterator** (collection traversal). Document each with the 4 pattern elements: Name, Problem, Solution, Consequences
- [ ] **SDD assembly** — mid-level models + low-level models + mapping + **design rationale** (L12 calls rationale "very important") + glossary

---

# PHASE 3 — IMPLEMENTATION

> [!info] Build in dependency order, not feature order
> Get a **walking skeleton** working first: one ticker → one signal → one dashboard render, end to end. Then thicken each layer against a running surface.

- [ ] **Foundation** — project skeleton; config service + history (everything depends on config); DB schema + migrations; the entity set
- [ ] **Data layer** — data-source interfaces (interval-parameterized so intraday is a clean future add); caching; throttling; MacroCorrelationAnalyzer
- [ ] **Model layer** — multi-horizon training; model registry/audit; accept/reject-by-AUC; the `config.pkl` loading rule (load `feat_cols`/`fwd_days`/horizons from saved config, never regenerate)
- [ ] **Onboarding pipeline** — reusable unit callable from web/API/cron/CLI; status tracking
- [ ] **Portfolio layer** — transaction model; derived-state computation; validation; options (distinct flow)
- [ ] **Signal + suggestion engines** — per-horizon signals; intent-aware multi-horizon meshing
- [ ] **Alert system** — evaluation; delivery; retry/queue; full audit trail
- [ ] **Web / API + WebSocket** — dashboard; real-time pushes
- [ ] **Chatbot** — grounded Q&A over system state

---

# PHASE 4 — VERIFICATION (SWE 3643)

> [!info] Each use case from Phase 1C becomes a test specification
> Main success scenario → happy-path test. Each extension → an edge-case test. The SRS and the test plan are the same document read twice.

- [ ] **Unit testing** (white-box) — components in isolation; mock the data sources (your testability NFR makes this achievable)
- [ ] **Boundary value analysis** — config thresholds (VIX ceilings, min confidence, AUC margin), the one-calendar-year data-sufficiency threshold, position-validation edges
- [ ] **Integration testing** — onboarding pipeline stages in sequence; signal→suggestion→alert chain
- [ ] **System testing** (black-box) — use-case-driven; every main scenario + extension
- [ ] **Performance testing** — inference latency for the "feels live" dashboard requirement
- [ ] **Regression testing** — especially around config-versioning and model accept/reject
- [ ] **Code coverage analysis**

---

# PHASE 5 — DOCUMENTATION & DELIVERY

- [ ] **Obsidian project vault** — numbered folders 00–14; SRS, SAD, SDD become core notes
- [ ] **README / setup docs** — for Future-Maintainer-Self (a real stakeholder)
- [ ] **Architectural decision records** — preserve the rationale sections
- [ ] **Traceability audit** — every line of code → a use case → a need → a stakeholder. Closes the loop the whole process is built around

---

## Where you are right now

> [!summary] Current position
> **Phase 1 (Product Design), step 1B → 1C transition. ~70% through Phase 1.**
> Next concrete actions, in order:
> 1. [ ] Actor list (derive from the 14 events)
> 2. [ ] Problem domain glossary
> 3. [ ] Use case diagram
> 4. [ ] Use case descriptions (start with *Onboard Ticker*)
> 5. [ ] Non-functional requirements section
> 6. [ ] → SRS complete → Phase 1 done

### Scope decisions locked (carry forward)
| Decision | Resolution | Rationale |
|---|---|---|
| Trade execution | Deferred behind clean extension point | Protect mission; preserve optionality; real-money risk too high for v2 |
| Day trading / live intraday | Declined | Fights the "explainable, human-in-loop" mission; needs paid real-time feed + new models |
| Multi-horizon signals | Adopted (short/med/long, all daily data) | Richer suggestions, no new events, cheap; intraday a clean future add |
| Options positions | Distinct event/use case | Separate lifecycle, fields, validation from equity |
| Suggestion engine triggers | User on-demand **and** clock-scheduled | Logic must be a reusable unit both call into |
| User stakeholder | Split into User + User's Financial Position | Enables strict intent-aware reasoning |