# MVP User Flows v1.0

Status: Authoritative interaction flows  
Date: 30 October 2026

## 1. Navigation model

### Player/guardian mobile navigation

Bottom navigation:

1. Home
2. Profile
3. Videos
4. Opportunities
5. Account

### Recruiter mobile navigation

Bottom navigation, with secondary tools under More:

1. Discover
2. Search
3. Briefs
4. Shortlists
5. Meetings
6. Account/Organisation

### Assigned staff mobile navigation

Staff roles are assigned by the platform, never chosen during public onboarding. Bottom navigation uses Overview, Reviews, Meetings, Reports, and More; More contains:

1. Overview
2. Player verification
3. Recruiter verification
4. Profiles and media
5. Meetings
6. Reports
7. Safeguarding
8. Users and organisations
9. Audit
10. Settings/taxonomy

## 2. Minor player and guardian onboarding

### Primary flow

```text
Landing page
→ Choose Player/Guardian
→ Create guardian account
→ Verify guardian email
→ Enter player's birth date
→ System detects player is under 18
→ Explain guardian-controlled account
→ Add guardian identity/relationship evidence
→ Guardian reviews consent and privacy choices
→ Create player draft
→ Player and guardian complete football profile
→ Upload photo and videos
→ Preview recruiter view
→ Submit for review
→ Operator approves or requests changes
→ Guardian fixes changes if required
→ Profile published to verified marketplace
```

### Required screens/states

- Role choice.
- Guardian account creation.
- Child-age explanation.
- Guardian identity/relationship submission.
- Consent summary with version and withdrawal path.
- Player identity and football information.
- Media upload and context.
- Completeness checklist.
- Preview.
- Review status.

### Rules

- Minor cannot create an independent recruiter-visible profile.
- Guardian relationship must be approved before publication.
- Guardian can draft before verification but cannot publish.
- Guardian controls visibility and meetings.
- Child contact, school, home address, and precise schedule are never displayed.
- Changing birth date across the adult/minor boundary triggers review and access freeze.

### Error/exception flows

- Duplicate player detected → operator review; do not create second public profile.
- Guardian evidence unclear → changes requested with secure resubmission.
- Guardianship disputed → freeze profile/meetings and escalate.
- Consent withdrawn → unpublish profile, stop new processing except required retention/audit.
- Player turns 18 → guided transition to adult control after identity confirmation; history remains audited.

## 3. Adult player onboarding, ages 18–19

```text
Landing page
→ Choose Player
→ Create and verify account
→ Enter date of birth
→ Adult identity/age verification
→ Accept privacy/marketplace terms
→ Complete football profile
→ Upload and label media
→ Set marketplace/public-teaser visibility
→ Preview recruiter view
→ Submit for review
→ Approve/fix changes
→ Publish
```

Rules:

- Public teaser is opt-in; detailed profile remains verified-recruiter-only by default.
- Contact details remain private.
- Adult player responds to meeting requests; platform still reviews and attends.

## 4. Player profile creation

Use a stepper with autosave:

1. Basics
2. Football identity
3. Team/history
4. Opportunity and availability
5. Videos/evidence
6. Privacy/visibility
7. Preview and submit

### Completion behaviour

- Dashboard shows percent complete and exact blocking items.
- Users may leave and resume.
- Validation occurs per step and again on submission.
- Submission creates an immutable review version; later edits remain drafts until approved where material.

### Review outcomes

- Approved: profile becomes published.
- Changes requested: exact field/media issues shown.
- Rejected: only for ineligible, fraudulent, unsafe, or unresolvable cases; reason and support path shown.
- Paused: profile hidden until availability/consent is reconfirmed.

## 5. Video upload flow

```text
Videos
→ Add video
→ Choose highlight / contextual clip / continuous / full-match link
→ Select file or supported link
→ Enter match context
→ Confirm rights/guardian permission
→ Request upload session
→ Direct resumable upload
→ Processing
→ Choose thumbnail/player marker
→ Preview
→ Submit for review
→ Approved / changes requested / rejected
```

States:

- Not started
- Uploading with percentage
- Paused/retrying
- Uploaded, processing
- Ready, missing metadata
- Submitted
- Approved
- Changes requested
- Failed
- Deleted

Failure rules:

- Network failure preserves draft metadata and resumes where supported.
- Unsupported/corrupt file explains the fix.
- Processing timeout produces retry/support action.
- Deleted/replaced video disappears from future feed impressions immediately.

## 6. Player/guardian dashboard

Priority order:

1. Urgent meeting or safety action.
2. Verification/review action.
3. Profile completion/availability expiry.
4. Video processing/status.
5. Aggregate professional interest and applause.
6. Education/safety guidance.

Do not display competitive follower counts or public ranking.

## 7. Recruiter application and verification

```text
Landing page
→ Choose Recruiter
→ Create/verify account
→ Enter role and organisation
→ Select recruiter type
→ Submit identity
→ Submit professional evidence/references
→ Accept conduct, child-safety, privacy, and introduction terms
→ Book/complete manual interview if requested
→ Operator review
→ Approved / changes requested / rejected
→ Set preferences and enter Discover
```

Recruiter types:

- club employee/scout;
- independent scout;
- academy recruiter;
- agency staff;
- licensed football agent.

### Pending access

- Can see onboarding, demo/synthetic examples, and verification status.
- Cannot see identifiable minor profiles, private video, search results, or meetings.

### Approval output

- Separate identity, organisation/employment, recruiter, and licensed-agent badges.
- Last-verified date.
- Expiry/reverification date.
- Allowed markets/actions.

## 8. Recruiter first-use flow

```text
Verification approved
→ Welcome checklist
→ Set countries/governorates, age bands, positions, feet, and levels
→ Optional: create first recruitment brief
→ Open personalised feed
→ Watch/applaud/interest/shortlist/pass
→ Open player profile
→ Review contextual evidence
→ Add private note or request meeting
```

The system explains:

- applause is not contact;
- professional interest remains private/aggregate;
- shortlist is private;
- meeting request begins the controlled introduction process;
- direct contact with minors is prohibited.

## 9. Discovery feed flow

```text
Discover
→ Select tab/brief
→ Video autoplays muted
→ Recruiter watches
→ Applaud / professional interest / shortlist / pass / profile
→ Next video
```

### Card interactions

- Tap video: pause/play.
- Sound button: opt-in audio.
- Swipe/scroll: next/previous.
- Open profile preserves return position.
- Shortlist prompts selection/creation without leaving feed.
- Pass optionally requests private reason; never shown to player.
- Report pauses recommendation and opens reason sheet.

### Empty states

- Brief too narrow → show which filters constrain results and allow editing.
- No unseen players → allow revisiting or broaden preferences.
- Verification expired → lock restricted feed and start reverification.

## 10. Search flow

```text
Search
→ Enter filters/query
→ View player cards
→ Adjust/sort
→ Open profile
→ Interest/shortlist/meeting
```

Search and feed share the same access policy. Search cannot reveal a player excluded by privacy, moderation, consent, or recruiter verification state.

## 11. Recruitment brief flow

```text
Briefs
→ New brief
→ Define football requirement and timing
→ Preview candidate estimate
→ Save draft
→ Activate
→ Matching Briefs feed/results
→ Shortlist candidates
→ Pause/close/expire brief
```

Operator may review abusive, discriminatory, impossible, or suspicious briefs. Private operator notes never appear to players.

## 12. Shortlist flow

```text
Feed/search/profile
→ Add to shortlist
→ Choose existing or create new
→ Add optional private note/status
→ Shortlist workspace
→ Sort/filter/open player
→ Request meeting or close candidate
```

No side-by-side comparison in the MVP. The shortlist provides compact cards and private statuses.

## 13. Meeting request — recruiter

```text
Player profile/shortlist
→ Request meeting
→ Select purpose/type
→ Add proposed dates/mode/location
→ Add attendees and organisation
→ Accept conduct/introduction acknowledgement
→ Submit
→ Platform review
→ More information or forwarded to player/guardian
→ Await response
→ Scheduling/confirmation
→ Attend with platform representative
→ Provide outcome
```

Recruiter cannot see guardian/player contact details. All changes are recorded.

## 14. Meeting request — guardian/adult player

```text
Platform-approved request received
→ View verified recruiter/organisation summary
→ View purpose, attendees, proposed mode/date, and safety guidance
→ Ask platform a structured question / request change
→ Accept or decline
→ Confirm schedule
→ Receive reminders
→ Attend with platform representative
→ Give outcome/safety feedback
```

Guardian/player sees no salary or transfer offer in the MVP. Suspicious request can be reported instead of answered.

## 15. Meeting operations — platform representative

```text
New request queue
→ Verify recruiter status and brief/purpose
→ Check player eligibility/availability
→ Validate attendees/location/link
→ Forward or request more information/reject
→ Coordinate responses
→ Confirm date and participants
→ Pre-meeting checklist
→ Attend/check in
→ Record completion, outcome, concerns, and next action
→ Follow up with both sides
→ Close or escalate
```

Unsafe state stops scheduling and routes to safeguarding.

## 16. Academy partner flow

MVP is invitation only:

```text
Operator creates/invites academy organisation
→ Academy representative verifies account and authority
→ Views validation requests for nominated players
→ Confirms/declines affiliation and selected history claims
→ Operator records validation source/date
→ Academy sees aggregate approved roster/opportunity count
```

Academy cannot control guardian consent, read scout notes, or access another academy's players.

## 17. Player verification/admin flow

```text
Queue sorted by age/risk/age of submission
→ Open player and guardian evidence
→ Check duplicates and relationship
→ Review profile and video context
→ Approve individual claims or request changes
→ Preview recruiter visibility
→ Approve publication / request changes / escalate
→ Audit action
```

Operator sees only the sensitive evidence required for their permission level.

## 18. Recruiter verification/admin flow

```text
Application queue
→ Identity check
→ Organisation/employment/reference check
→ Licence check if claimed
→ Review conduct/safeguarding acceptance
→ Optional interview notes
→ Approve with expiry/scope / request changes / reject
→ Notify applicant and audit
```

Any later material role/organisation change moves verification to review and may restrict access.

## 19. Report and safeguarding flow

```text
User selects Report
→ Choose subject and reason
→ Add details/evidence
→ Submit
→ Risk triage
→ Immediate automatic restriction when configured
→ Operator/safeguarding review
→ Request evidence / take action / refer externally where required
→ Resolution and audit
→ Reporter notification when appropriate
```

High-risk examples:

- guardian bypass;
- request for secrecy/private travel;
- sexual or abusive conduct;
- money for guaranteed opportunity;
- fake recruiter/organisation;
- identity/document misuse;
- unsafe meeting change;
- credible threat.

## 20. Account and privacy flow

All users can:

- view/edit permitted account details;
- manage active sessions;
- change password/email with recent authentication;
- see verification state;
- manage notifications;
- request data export/deletion;
- report account compromise;
- contact support.

Guardian additionally controls child profile publication and consent withdrawal. Adult transition and disputed guardianship require operator review.

## 21. Notification routing

| Event | Player 18+ | Guardian | Recruiter | Operator |
|---|---:|---:|---:|---:|
| Profile changes requested | Yes | Yes for minor | No | Assigned reviewer |
| Profile approved/published | Yes | Yes for minor | No | Audit only |
| Professional interest aggregate | Yes | Yes for minor | Actor confirmation | No |
| Meeting submitted | No until approved | No until approved | Yes | Yes |
| Meeting forwarded | Yes | Yes for minor | Yes | Yes |
| Meeting accepted/declined | Yes | Yes | Yes | Yes |
| Meeting schedule/change | Yes | Yes | Yes | Yes |
| Report/safety action | As appropriate | As appropriate | As appropriate | Yes |
| Verification expiring | Yes if relevant | Yes if relevant | Yes | Queue |

## 22. Universal failure states

Every flow must define:

- loading;
- empty;
- validation error;
- permission denied without leaking existence;
- expired verification/consent;
- network offline/retry;
- rate limited;
- record changed by another actor;
- service/provider unavailable;
- account restricted;
- support/escalation path.

