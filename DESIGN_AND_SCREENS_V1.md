# Design System and Screen Specification v1.0

Status: Authoritative MVP design direction  
Date: 30 October 2026  
Working name: ScoutLink

## 1. Design objective

The product should feel like a modern football scouting dossier—not an AI startup template, betting product, generic social network, or gaming interface.

Desired qualities:

- credible;
- ambitious;
- Egyptian but internationally professional;
- energetic without visual noise;
- evidence-led;
- safe for families;
- fast for scouts;
- clear in Arabic and English.

## 2. Visual concept: The Scout's Notebook

The visual language combines:

- football pitch geometry;
- editorial sports photography;
- scout-report grids and labels;
- physical match tickets/team sheets;
- strong numeric typography;
- restrained colour used for meaning.

Avoid the common AI-product aesthetic:

- no purple/blue glowing gradients;
- no glassmorphism;
- no floating neon orbs;
- no excessive pill-shaped containers;
- no generic bento-grid landing page;
- no robot/AI illustrations;
- no meaningless animated charts;
- no fake generated player imagery;
- no huge empty hero with vague “revolutionise talent” copy.

## 3. Colour system

Working palette; confirm through visual prototype and accessibility testing.

### Foundation

- `Ink 950` — `#0B1420`: primary navigation, dark surfaces, text on light backgrounds.
- `Ink 800` — `#1A2938`: secondary dark surface.
- `Paper 50` — `#F6F3EA`: warm main background, recalling paper scout notes.
- `White` — `#FFFFFF`: cards and high-contrast form surfaces.
- `Line 200` — `#D8D6CE`: borders and dividers.
- `Muted 600` — `#66717D`: secondary copy.

### Brand and action

- `Pitch 700` — `#0D6248`: primary brand/action colour.
- `Pitch 600` — `#14795A`: hover/highlight.
- `Signal 500` — `#D89A2B`: opportunity, attention, pending state.
- `Sky 600` — `#2476A8`: information and verified-professional signal.

### Status

- Success — `#287A4B`
- Warning — `#B87612`
- Danger — `#B13A32`
- Neutral — `#66717D`

Rules:

- Colour never carries meaning alone; pair with icon and text.
- Green is not used for every button merely because the product is football-related.
- Status colours are reserved for status.
- Check WCAG contrast in both Arabic and English sizes.

## 4. Typography

Recommended:

- Arabic: IBM Plex Sans Arabic.
- Latin: IBM Plex Sans.
- Optional condensed display for campaign headlines only: IBM Plex Sans Condensed.
- Numeric/metadata moments: IBM Plex Mono sparingly.

Why:

- professional and editorial rather than playful;
- strong Arabic/Latin family relationship;
- readable in dense scout interfaces;
- avoids the overused geometric “AI SaaS” look.

Scale:

- Display: 32/38 mobile.
- H1: 26/34 mobile.
- H2: 24/32.
- H3: 20/28.
- Body: 16/24.
- Small: 14/20.
- Metadata: 12/16 with adequate contrast.

Do not use uppercase styling for Arabic. Latin labels may use restrained uppercase/letter spacing only for metadata.

## 5. Layout and geometry

- Base spacing unit: 4px; main rhythm in 8px increments.
- Content respects phone safe areas and readable line lengths; tablet layouts may use a centred 720px content column.
- Border radius: 6–10px; avoid excessive 20–32px cards.
- Borders: 1px, used more often than shadows.
- Shadows: minimal and shallow, reserved for overlays/floating navigation.
- Grid: 4-column phone, 8-column tablet.
- Mobile safe-area support.
- Sticky primary action only when it prevents long-scroll loss.

Football/pitch-line motifs appear in marketing and empty states, not behind dense text or forms.

## 6. Iconography and imagery

- One line-icon family, recommended Lucide.
- Use filled icons only for selected navigation/status where needed.
- Real, rights-cleared football images.
- Match context over staged portraits.
- Consistent crop ratios.
- Never use AI-generated “young footballer” imagery for trust claims.
- Guardian-approved minor imagery only.

## 7. Motion

- 150–220ms functional transitions.
- Feed movement follows user scroll/swipe; no decorative parallax.
- Respect reduced-motion preference.
- Upload/processing animation shows real progress/state.
- Avoid confetti when a child receives interest; keep opportunity status calm and clear.

## 8. Component system

### Foundation components

- Button: primary, secondary, outline, ghost, danger.
- Icon button with label/tooltip requirements.
- Link.
- Input, textarea, number, date, select, combobox.
- Checkbox, radio, switch.
- Search/filter chip.
- Card and section.
- Badge: verification, evidence, state; not decorative.
- Avatar/player photo.
- Alert, inline message, toast.
- Dialog, drawer, bottom sheet.
- Tabs.
- Stepper.
- Progress.
- Skeleton.
- Empty state.
- Structured list/card.
- Cursor loader.
- File/video uploader.
- Video player.

### Domain components

- Player identity header.
- Player compact card.
- Feed video card.
- Evidence label.
- Verification badge with explanation.
- Position marker.
- Availability freshness.
- Profile completeness checklist.
- Recruitment brief card.
- Shortlist selector.
- Professional-interest action.
- Meeting timeline.
- Meeting attendee card.
- Verification case panel.
- Risk/safeguarding banner.
- Audit-event row.

## 9. Interaction principles

- Every action uses football/business language, not internal technical language.
- Verification badges explain exactly what was checked.
- Dangerous actions name the consequence.
- No ambiguous “Submit” when “Submit profile for review” is clearer.
- Preserve user input on errors.
- Make status and next action visible on every workflow screen.
- Mobile bottom sheets for short actions; full pages for complex forms.
- Preserve list position when opening and returning from player or verification detail.
- Undo reversible feed actions where possible.

## 10. RTL and localisation

- RTL/LTR controlled at document/container level.
- Use logical margin/padding/inset properties.
- Icons that express direction mirror; universal icons do not.
- Numbers, dates, player positions, currencies, and measurement units are tested in mixed-direction text.
- Arabic text can expand beyond English copy.
- Football position abbreviations may retain standard Latin notation with Arabic explanation.
- User can switch language without losing the current workflow.

## 11. Responsive roles

### Player/guardian

- Designed at 360–430px first.
- Single-column forms.
- Bottom navigation.
- Large media/upload controls.
- Dashboard driven by next action.

### Recruiter

- Full-screen video feed and quick shortlist actions.
- Filter sheets, saved searches, and focused full-page player detail.
- Dense tools remain touch-friendly and readable on phones.

### Admin

- Mobile app with assigned roles and explicit re-authentication for sensitive actions.
- Review queues use cards and full-page detail rather than compressed tables.
- Sensitive documents use protected, time-limited views and cannot appear in notifications.

## 12. Screen inventory

### Public and authentication

P01 Landing  
P02 Role entry / waitlist path  
P03 Sign up  
P04 Login  
P05 Email verification  
P06 Password/account recovery  
P07 Terms/privacy/consent summaries  
P08 Restricted/not authorised  

### Player and guardian

G01 Guardian/player onboarding choice  
G02 Player age gate  
G03 Guardian identity/relationship  
G04 Consent and visibility  
G05 Dashboard  
G06 Profile basics  
G07 Football identity  
G08 Team/history  
G09 Opportunity/availability  
G10 Profile media library  
G11 Video upload/context  
G12 Profile privacy  
G13 Recruiter-view preview  
G14 Submission/review status  
G15 Aggregate engagement  
G16 Opportunities list  
G17 Meeting request detail  
G18 Meeting schedule/detail  
G19 Post-meeting outcome/safety feedback  
G20 Notifications  
G21 Account/security/privacy  

### Recruiter

R01 Recruiter onboarding  
R02 Recruiter type/organisation  
R03 Identity/professional evidence  
R04 Verification status  
R05 Welcome/preferences  
R06 Discovery feed  
R07 Search/filters/results  
R08 Player full profile  
R09 Shortlist selector  
R10 Shortlists index  
R11 Shortlist detail  
R12 Briefs index  
R13 Create/edit brief  
R14 Brief matching results  
R15 Meeting request form  
R16 Meetings index  
R17 Meeting detail/timeline  
R18 Notifications  
R19 Account/organisation/security  

### Academy

C01 Academy invitation/authority confirmation  
C02 Academy overview  
C03 Player affiliation/history validation  

### Administration

A01 Operations overview  
A02 Player/guardian verification queue  
A03 Player verification case  
A04 Recruiter verification queue  
A05 Recruiter verification case  
A06 Profile/media review queue  
A07 Profile/media review  
A08 Meeting operations board  
A09 Meeting operations detail  
A10 Reports queue  
A11 Report detail  
A12 Safeguarding queue  
A13 Safeguarding case  
A14 Users/organisations search  
A15 User/organisation detail  
A16 Audit explorer  
A17 Taxonomy/settings  

## 13. Key screen specifications

### P01 — Landing

Purpose: explain value and route each audience.

Sections:

1. Direct headline and short evidence-based explanation.
2. Three audience actions: Player/Guardian, Recruiter, Academy.
3. How it works: profile/evidence → verified discovery → managed meeting.
4. Trust principles: verification, guardian control, platform attendance.
5. Pilot statement: free, limited, no guaranteed opportunity.
6. Build With Me content/latest update.
7. Arabic/English switch and complete footer.

Avoid stock SaaS dashboard collage. Show one real/authorised football moment plus a clear scout-profile artifact.

### G05 — Player/guardian dashboard

Header:

- player identity and current status;
- guardian relationship indicator for minor;
- profile completeness.

Main:

- single primary next-action card;
- verification/profile/video statuses;
- opportunities requiring response;
- aggregate applause/professional-interest summary;
- availability confirmation;
- safety/help entry.

Mobile priority: urgent action visible without scrolling.

### G06–G12 — Profile editor

- Stepper at top/compact mobile dropdown.
- Save status always visible.
- One logical section per screen.
- Contextual examples, not long generic help text.
- Required/optional labels.
- Preview link available after minimum data.
- Bottom action: Save and continue.
- Exit preserves draft.

### G10/G11 — Media and upload

- Separate approved, processing, draft, and rejected sections.
- Add media button always reachable.
- Upload card displays progress, pause/retry, and connection guidance.
- Metadata form follows upload selection so data can be entered during transfer.
- Evidence type explained visually.
- Rejection explains exact fix.

### R06 — Discovery feed

- video occupies most viewport;
- bottom gradient only for legibility, not decorative glow;
- player facts and evidence label over lower section;
- vertical action rail: applaud, interest, shortlist, profile, report;
- tabs above feed;
- sound control and progress.

Feed shows why recommended: “Matches U17 left-footed CB brief,” “New verified evidence,” etc.

### R07 — Search

- Filter sheet with active filters visible and removable above results.
- Result count/candidate availability without exposing restricted records.
- Compact player cards with thumbnail, facts, badges, freshness, and quick shortlist.
- Clear zero-result recovery.

### R08 — Player profile

Top summary:

- photo/display identity;
- age, position, foot, height, governorate;
- team/academy;
- verification badges;
- availability freshness;
- professional-interest and shortlist actions;
- request meeting.

Sections:

1. Evidence playlist: highlights plus contextual/continuous footage.
2. Football overview and playing style.
3. Career/team history.
4. Structured facts and languages.
5. Verification/source explanation.
6. Availability/opportunity status.
7. Safety/report action.

No guardian contact, home/school location, public comments, or social follower count.

### R11 — Shortlist detail

- Name, brief link, and status filters.
- Compact candidates.
- Private note and status.
- Open profile or request meeting.
- No complex kanban or comparison in MVP.

### R13 — Recruitment brief

- Stepped mobile form with saved progress.
- Required football criteria separated from preferences.
- Candidate-estimate preview.
- Warning against discriminatory or unsafe criteria.
- Save draft/activate.

### R15 — Meeting request

- Player summary fixed/visible.
- Purpose and meeting type.
- Proposed times/location/mode.
- Attendee identity and role.
- Structured supporting note.
- Introduction/conduct acknowledgement.
- Review summary before submission.
- Explicit statement: this is not an offer or contract.

### G17/R17/A09 — Meeting detail

Shared structure with role-specific visibility:

- status and next action;
- player/recruiter/organisation summary;
- platform representative;
- purpose;
- attendees;
- proposed/confirmed schedule;
- safe venue/link;
- event timeline;
- structured questions/changes;
- outcome and follow-up;
- report/cancel.

No unrestricted chat. Use structured status updates and operator notes/messages.

### A01 — Operations overview

- Urgent safety/report items first.
- Today's meetings and required confirmations.
- Ageing verification queues.
- Failed video/webhook/jobs.
- Pilot funnel summary.
- Never show vanity charts above operational work.

### A03/A05 — Verification case

- Fixed identity/context summary.
- Evidence pane.
- Claim-by-claim checklist.
- Duplicate/history indicators.
- Approve/request changes/reject/escalate.
- Mandatory reason for sensitive decisions.
- Audit timeline.
- Document access warnings and no casual download.

### A08 — Meeting board

Columns or filtered list:

- Review
- Waiting for information
- Waiting for player/guardian
- Scheduling
- Confirmed
- Follow-up
- Closed/unsafe

Every card displays age/minor indicator, recruiter verification, next action, owner, and deadline.

### A12/A13 — Safeguarding

- Visually distinct restricted area.
- High-risk state at top.
- Limited staff access.
- Evidence and timeline.
- Immediate restriction controls.
- Escalation/checklist.
- No sensitive detail in notification previews.

## 14. Empty/error/state writing

Tone:

- calm;
- specific;
- non-accusatory;
- tells the user what happened and what to do next.

Examples:

- “Your video is uploaded and still processing. You can leave this page; we’ll notify you when it is ready.”
- “This profile needs two changes before recruiters can see it.”
- “No players match every requirement. Try widening the height range or governorate.”
- “We could not confirm this recruiter’s current role. Your information remains private while we review it.”

Avoid “Oops!”, jokes during serious errors, or celebratory language around safety/verification.

## 15. Accessibility checklist per screen

- Correct page title and one H1.
- Logical focus order.
- Visible keyboard focus.
- Form labels and described errors.
- Touch targets at least approximately 44px.
- Video keyboard controls and captions where applicable.
- Alternative to swipe.
- Contrast checked.
- RTL checked.
- 200% zoom usable.
- Status not colour-only.
- Motion reduced when requested.

## 16. Design delivery process

To build efficiently:

1. Create tokens and five foundation components.
2. Design one representative screen per role: G05, R06, A01.
3. Validate the visual theme.
4. Create low-fidelity flows for every screen.
5. Create high-fidelity designs only for unique/complex screens.
6. Build the reusable components in code.
7. Assemble simple screens directly from the system.
8. Review Android, iOS, phone/tablet, Arabic, English, empty, error, and permission states.

Do not fully mock every CRUD screen before implementation. Fully design the system and the high-risk experiences; assemble routine screens from approved patterns.

## 17. Design approval gates

Before implementation week 2:

- palette and typography approved;
- player, recruiter, and admin shells approved;
- feed card approved;
- player profile approved;
- form/stepper pattern approved;
- Arabic RTL proof reviewed;
- no obvious AI-template aesthetic.

Before pilot:

- five player/guardian usability sessions;
- five recruiter usability sessions;
- accessibility review;
- low-end Android and iPhone Safari checks;
- all sensitive visibility states reviewed with test accounts.

