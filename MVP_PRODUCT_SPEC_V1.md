# MVP Product Specification v1.0

Status: Authoritative build scope  
Date: 30 October 2026  
Working name: ScoutLink  
Target: private Egyptian pilot, free on all sides

## 1. Product definition

ScoutLink is a verified Egyptian football talent network. Players build evidence-based profiles and share contextual football videos. Verified recruiters discover players through a vertical highlight feed, search, recruitment briefs, and shortlists. When a recruiter wants to proceed, ScoutLink coordinates and attends the meeting and records the outcome.

The MVP proves one business hypothesis:

> A curated group of Egyptian players can obtain legitimate, safely managed football opportunities when their evidence is professionally presented to verified recruiters.

The MVP is not a transfer marketplace, agency platform, payment system, or football social network.

## 2. Pilot parameters

- 50 Egyptian boys aged 12–19.
- First one or two governorates selected through founding academy partners.
- 3–5 academy/community partners.
- 10–15 verified Egyptian and international recruiters.
- Free for players, guardians, academies, and recruiters.
- Invitation/approval based; not a public open marketplace.
- One Flutter mobile app used by players, guardians, recruiters, academy representatives, and assigned platform staff.
- Users choose an eligible starting role during onboarding; staff roles cannot be self-selected.
- Android is the pilot release target; iOS follows from the same codebase.
- Platform representative attends every meeting.

## 3. User roles

### Player aged 18–19

Controls his profile, uploads media, manages visibility, sees aggregate engagement, and responds to meeting requests through the platform.

### Minor player aged 12–17

Participates in building the profile but does not own an unrestricted account or communicate privately with recruiters. The guardian controls consent, publication, and meeting responses.

### Guardian

Creates/manages the minor relationship, approves data/media, controls profile visibility, receives notifications, responds to meetings, and attends meetings involving the minor.

### Recruiter

Applies for verification, sets preferences or briefs, uses the feed/search, expresses professional interest, creates private shortlists, and requests meetings.

### Academy partner

Has a basic invited organisation identity. An authorised academy representative can confirm affiliation/history claims for nominated players. Full academy management software is not in the MVP.

### Platform operator

Reviews profiles, player/guardian/recruiter verification, video context, reports, and meeting requests; coordinates meetings and records outcomes.

### Safeguarding administrator

Receives high-risk reports, can freeze access or meetings, reviews sensitive evidence, and documents resolution. This may be the same trusted person as the operator during the pilot, but the permissions remain distinct.

## 4. MVP feature scope

### 4.1 Public marketing and entry

- Arabic/English landing page.
- Separate entry paths for Player/Guardian, Recruiter, and Academy.
- Clear pilot/waitlist status and no-guarantee language.
- Login and account recovery.
- No public searchable minor directory.

### 4.2 Authentication and access

- Email/password or email OTP/magic link.
- Email verification.
- Role-aware onboarding.
- Guardian relationship and consent records.
- Recruiter identity/professional verification status.
- Organisation membership for recruiters and academies.
- MFA required for administrators.
- Session management and logout-all-devices capability.

### 4.3 Player profile

Required:

- display and legal identity kept separately;
- birth date privately, age/birth year by visibility rule;
- nationality;
- governorate, never precise home location;
- height;
- dominant foot;
- primary and secondary positions;
- current academy/team or independent status;
- football history;
- playing style/short biography;
- languages;
- opportunity status;
- availability and last-confirmed date;
- guardian/representation status;
- verification badges and sources;
- profile completeness.

Profile states:

`Draft → Submitted → Changes requested → Approved → Published → Paused/Expired/Removed`

The player/guardian can preview the recruiter view before submission.

### 4.4 Media and video

- Profile photo.
- Highlight reel.
- Individual contextual clips.
- Optional continuous sequence/full-match link.
- Direct resumable upload.
- Automatic video processing and thumbnails.
- Required match/date/opponent/competition/position/shirt metadata.
- Edited/continuous/full-match evidence labels.
- Private draft, marketplace, or approved public-teaser visibility.
- Processing, failure, retry, replace, and delete states.
- Admin review before publication.
- Signed playback for restricted media.

### 4.5 Discovery feed

Vertical mobile-first feed.

Tabs:

- For You
- Matching Briefs
- New Talent
- Verified Evidence
- Shortlisted

Each card shows:

- video;
- player display identity;
- age or age band according to privacy;
- position, foot, height, and governorate;
- academy/team if approved;
- verification indicators;
- video context;
- availability freshness.

Actions:

- Applaud
- Professional interest, verified recruiters only
- Shortlist
- Pass
- Open full profile
- Report

No comments, followers, public scout identities, or paid boosts.

Feed inputs:

- recruiter preferences/brief match;
- evidence completeness and verification;
- freshness and availability;
- verified professional interest and shortlist signals;
- limited applause influence;
- new/unseen player exploration;
- exposure and diversity controls;
- safety/moderation status.

### 4.6 Search and filters

- Name/keyword search.
- Position.
- Age range.
- Dominant foot.
- Height range.
- Governorate.
- Current level/academy.
- Availability.
- Verified profile.
- Video evidence type.
- Recently updated.
- Cursor pagination.

### 4.7 Recruiter briefs

Recruiter creates a requirement containing:

- age range;
- position(s);
- foot;
- height if important;
- geography;
- current level;
- opportunity type;
- timing;
- evidence expectations;
- private note to platform operators.

Brief states:

`Draft → Active → Paused → Filled/Closed/Expired`

The feed may explain why a player matches the brief. No automated claim that a player is objectively talented.

### 4.8 Shortlists and private notes

- Personal shortlist creation.
- Add/remove player.
- Private recruiter note.
- Internal status: Watching, Review, Priority, Meeting requested, Closed.
- Sort and filter shortlist.
- Players/guardians do not see shortlist membership or private notes.
- Side-by-side comparison is excluded from MVP.

### 4.9 Professional interest

- Verified recruiter can mark interest from feed/profile.
- Player/guardian sees aggregate interest, not recruiter identity.
- Interest does not open contact.
- Recruiter identity becomes part of the process only through an approved meeting request.
- Duplicate/spam interest is rate limited.

### 4.10 Meeting request and coordination

Recruiter submits:

- player;
- recruiter and organisation;
- purpose;
- meeting type: introduction, assessment discussion, academy discussion, club trial discussion, or information request;
- preferred dates;
- location or online proposal;
- attendee names and roles;
- supporting note;
- acknowledgement of platform introduction and conduct rules.

States:

`Submitted → Platform review → More information → Guardian/player review → Accepted/Declined → Scheduling → Confirmed → Completed → Follow-up/Closed/Cancelled/Unsafe`

Rules:

- Platform reviews before player/guardian notification.
- Guardian controls every under-18 response.
- Personal contact details stay hidden by default.
- Platform representative attends every meeting.
- Attendees and location/link are verified before confirmation.
- Outcome recorded as no follow-up, further discussion, trial invitation, trial completed, registration, contract, or other verified result.
- No offer, salary, fee, or contract negotiation inside the product.

### 4.11 Notifications

In-app plus transactional email:

- account verification;
- profile submitted/approved/changes requested;
- video processed/rejected;
- meeting request status;
- meeting reminder/change/cancellation;
- security changes;
- report outcome when appropriate;
- availability reconfirmation.

No SMS/WhatsApp automation in the MVP.

### 4.12 Reports, moderation, and blocking

- Report player, recruiter, profile, video, or meeting.
- Reason categories and free-text evidence.
- Block/restrict interaction.
- Operator queue with priority and status.
- Hide media/profile while investigating.
- Warn, restrict, suspend, or remove account.
- Safeguarding escalation and audit history.
- Appeal/contact-support path.

### 4.13 Administration

- Overview counts and urgent tasks.
- User/profile/organisation search.
- Player/guardian verification queue.
- Recruiter verification queue.
- Profile and media review.
- Academy affiliation validation.
- Meeting operations board.
- Report and safeguarding queues.
- User restriction/suspension.
- Audit events.
- Controlled taxonomy: positions, opportunity types, governorates, evidence types.
- Basic pilot funnel metrics.

## 5. Explicit exclusions

- Native iOS/Android applications.
- Payments, subscriptions, commissions, or billing.
- Licensed-agent representation inside the product.
- Offers, salary/transfer negotiation, or contracts.
- Direct recruiter-player chat.
- Comments.
- Followers or public popularity leaderboards.
- Paid boosts.
- AI talent scores or video performance analysis.
- Livestreaming.
- Public searchable minor pages.
- Academy billing or full roster-management portal.
- PDF CV export.
- Player comparison.
- Saved-search alerts.
- Real-time WebSocket infrastructure.
- External statistics provider integrations.
- FIFA/EFA/TMS submission.
- Medical, visa, work-permit, or payment workflows.

## 6. Business-model alignment

The MVP is free and measures whether value exists.

Track:

- recruiter briefs;
- qualified feed/profile views;
- professional interest;
- shortlists;
- meeting requests;
- completed meetings;
- trial invitations and attendance;
- registrations/contracts when later confirmed;
- repeat recruiter use;
- academy and guardian satisfaction.

Monetisation remains disabled until the agreed validation gate is reached.

## 7. Success gate

The pilot is validated when it achieves:

- 50 verified, recruiter-ready players;
- 10–15 verified recruiters;
- at least three real active recruitment briefs;
- 10 qualified completed meetings;
- three verified trial invitations;
- five recruiters active in a second month;
- at least 60% of briefs generating a credible shortlist;
- no unresolved high-severity safeguarding case;
- five recruiters giving credible willingness-to-pay feedback.

## 8. Product quality requirements

- Arabic RTL and English supported throughout.
- Android app supported on representative pilot devices; iOS follows after pilot hardening.
- Mobile app experience designed for player, guardian, recruiter, academy, and assigned staff roles.
- WCAG 2.2 AA target.
- No permanent public URL for private media/documents.
- Permission checks at UI, API, database/storage, and audit layers.
- Autosaved profile drafts.
- Recoverable video upload failures.
- Clear empty, loading, error, processing, rejected, expired, and offline states.
- Audit trail for consent, verification, sensitive admin actions, and meetings.
- No sensitive contents in analytics/error logs.

## 9. Release gates

### Internal development gate

- Synthetic/test data only.
- Architecture and permissions established.
- No public claims of live partnerships or opportunities.

### Closed alpha gate

- Critical flows and authorization tests pass.
- Named internal operators.
- Vendor environments and backups configured.
- Test users only or specifically approved adults.

### Real-player private pilot gate

- Minimum Egyptian legal/privacy review complete.
- Guardian consent language and process approved.
- Academy/recruiter/player pilot terms ready.
- Safeguarding procedure and named lead ready.
- Incident and meeting procedures tested.
- Data retention and vendor processing decisions documented.

Legal work is sequenced near the end of construction, but it remains a release requirement before real minors are onboarded.

## 10. Definition of complete

The MVP is complete—not merely coded—when:

- all P0 user flows pass end to end;
- critical role/relationship/age permission tests pass;
- supported devices and RTL have been tested;
- video upload/playback failure modes work;
- admin operators can manage every pilot process without database access;
- reports and safeguarding escalations work;
- backup restore and access-revocation drills pass;
- accessibility has no critical blocker;
- analytics measure the validation funnel;
- pilot operations, support, and release documentation are ready.

