# Football Talent Marketplace — Product Specification v0.4

Status: Founder direction confirmed; legal validation gates remain  
Date: 30 October 2026  
Working name: **ScoutLink** (placeholder only)

## 1. Executive summary

ScoutLink is an Egypt-based youth football discovery and representation platform where aspiring players aged 6–23 have evidence-based portfolios, verified talent recruiters worldwide discover Egyptian talent, and the platform safely arranges meetings. When representation is legally permitted, a named and appropriately licensed football agent may separately represent the player and negotiate on the player's behalf.

The first product will not be a transfer-registration, contract-signing, or payment system. Its job is to solve four painful problems well:

1. Talented players are difficult to discover and evaluate consistently.
2. Scouts waste time on incomplete, exaggerated, or unverified player information.
3. Parents lack a safe, credible path for exposing young talent to legitimate recruiters.
4. Interest and meetings are managed through fragmented calls, messages, spreadsheets, and personal networks.

The MVP will provide guardian-controlled youth accounts, verified identities, rich player profiles, video, powerful search, shortlists, meeting requests, protected messaging, and an auditable opportunity pipeline. It will not contain offers or contract negotiation. Representation and negotiation occur as a separate human service only through a named licensed agent and a valid representation agreement. The official employment contract, transfer agreement, medical, payment, association registration, FIFA TMS submission, and final legal approval remain outside the platform.

### Recommended initial positioning

> Discover verified football talent. Evaluate the evidence. Start the right conversation.

### Confirmed launch boundary

- Supply launches in Egypt; verified recruiters may discover talent from any country.
- Players are aspiring professionals aged 6–23.
- Every player under 18 must be created and controlled by a verified legal guardian.
- Children never receive direct recruiter messages and their private contact/location data is never exposed.
- Any talent recruiter may apply, whether or not they are an agent, but must pass identity and professional-purpose verification before seeing detailed profiles.
- Unlicensed recruiters may scout, shortlist, and request a platform-arranged meeting; they may not represent a party or negotiate a football transaction.
- The MVP ends at a safely arranged meeting and recorded outcome.
- The platform's agency service is legally and operationally separate: only named licensed agents may negotiate, and representation of minors is offered only when FIFA/EFA and Egyptian-law requirements permit it.
- No transfer fees or salaries are paid through the platform.
- No legally binding transfer or employment contract is executed in the product.

The product must not market six-year-olds as transferable assets or promise overseas transfers. For younger children, the value is a long-term development portfolio and credible visibility. International transfers of players under 18 are generally prohibited by FIFA except for narrow exceptions.

## 2. Product principles

1. **Trust before volume.** A smaller verified marketplace is more valuable than a large database of questionable profiles.
2. **Evidence over claims.** Important claims should show their source and verification status.
3. **Privacy by design.** Sensitive information is visible only when it is needed and authorised.
4. **Football-native workflows.** Position, dominant foot, contract status, availability, level, clips, match context, and role suitability must be first-class data.
5. **Mobile first.** Most players will create and maintain profiles from a phone; scouts must be able to review players during travel or matches.
6. **Human-controlled decisions.** Rankings and recommendations assist discovery but do not make recruitment decisions.
7. **Compliance is a product feature.** Identity, permissions, consent, audit history, and report handling are part of the core experience.

## 3. Target market and beachhead

### Confirmed beachhead

Start with Egyptian boys and girls aged 6–23 who aspire to play professionally. Recruitment demand may be global, but the first recruiter network should still be curated rather than open to anonymous accounts. The first operational cohort should be narrower than the full age promise: one or two Egyptian governorates, partner academies, and selected age bands provide a manageable safeguarding and verification pilot.

The final geography should be selected using founder access, not total market size. The best first market is where the team can personally recruit at least:

- 300 credible players;
- 20 clubs/academies that can validate profiles;
- 30 active scouts or recruitment staff;
- 5–10 design partners who agree to weekly product feedback.

### Expansion sequence

1. Guardian-controlled Egyptian talent portfolios and a curated recruiter network.
2. Nationwide Egyptian supply and international recruiter discovery.
3. Licensed-agent representation for eligible players through a separate compliant service.
4. Academy, tournament, and development-report integrations.
5. Carefully selected trial, document, and registration workflows where legally appropriate.

## 4. User types and permissions

### 4.1 Player

An adult player can create and edit a profile, upload media, specify availability and preferences, see privacy-preserving analytics, respond to authorised conversations, and control privacy settings. A minor may participate in creating the profile in an age-appropriate way, but the guardian owns the account permissions, consent, publication, and communications.

Cannot certify their own club record, identity, match statistics, contract status, medical information, or agent relationship as verified.

### 4.2 Scout / recruitment staff

Must belong to a verified organisation or pass enhanced professional verification. Can search, view permitted player details, save searches, create shortlists, add private notes, request contact, message, and initiate an expression of interest.

### 4.3 Club administrator / sporting director

Manages organisation membership and permissions. Can see organisation-wide shortlists and opportunity workspaces, invite colleagues, approve outbound meeting requests, and close opportunities.

### 4.4 Academy or current club representative

May maintain an organisation page and validate factual claims about affiliated players. Validation must show the validating organisation and date; it is not a guarantee of quality.

### 4.5 Licensed football agent

May manage authorised player relationships and participate in deal conversations after identity, FIFA licence, and applicable national requirements are checked. The platform must store the verification date and licence identifier. It should not imply that a verified licence proves a current representation mandate.

#### What the platform's "named licensed agent" means

FIFA licenses a person, not a software platform. Therefore, if ScoutLink promises to represent and negotiate for a player:

1. A specific person working with ScoutLink must hold an active FIFA football-agent licence.
2. That individual must be identified to the player/guardian as the responsible agent.
3. The agent and player must sign a compliant representation agreement before agent services begin.
4. For a minor, the agent also needs the minors accreditation, prior written guardian consent, guardian co-signature, and the player must be within the permitted representation window.
5. Other platform staff may arrange logistics and meetings, but may not independently negotiate or act as the football agent.

The business may hire or partner with a licensed agent for the pilot while a founder pursues the licence. The exact employment/partnership and fee structure requires Egyptian sports counsel and EFA confirmation.

### 4.6 Platform administrator / trust and safety

Reviews verification, content reports, impersonation, fraud, disputed affiliations, and account restrictions. Every sensitive administrative action must be logged.

### 4.7 Guardian — P0

Required for every player under 18. The guardian must pass identity verification and provide evidence of guardianship appropriate to the risk and local requirements. The guardian approves profile publication, media, visibility, meeting requests, communication, and any later representation process. The child never has an unrestricted standalone account. Guardian authority is rechecked periodically and whenever a dispute or material account change occurs.

## 5. Core jobs to be done

### Player

- Present a credible football CV and video portfolio.
- Become discoverable by relevant decision-makers.
- Understand who is viewing or interested without exposing personal contact details publicly.
- Manage opportunities without being exploited or impersonated.

### Scout / club

- Find players matching a precise sporting and commercial need.
- Judge whether information is complete, recent, and trustworthy.
- Compare candidates and collaborate privately.
- Contact the correct authorised party and track what happens next.

### Academy / agent

- Present an accurate portfolio of players.
- Receive qualified interest.
- Control access and maintain an auditable conversation history.

## 6. MVP scope

### 6.1 Authentication and onboarding — P0

- Email and phone verification.
- Secure password login; optional Google/Apple login where appropriate.
- Role selection with role-specific onboarding.
- Date-of-birth gate that automatically requires the guardian flow for anyone under 18.
- Verified guardian identity, guardian-player relationship evidence, and explicit child-data/media consent with purpose and validity period.
- Child profiles are created under the guardian account; no child can bypass the guardian by changing the entered age.
- Terms, privacy notice, community rules, and marketing consent stored separately with version and timestamp.
- Player age/identity check before a profile receives a verified identity badge, using a child-appropriate process.
- Professional verification for scouts, clubs, academies, and agents.
- Organisation invitation and membership approval.
- Role-based access control; users may hold more than one approved role.

### 6.2 Player profile and football CV — P0

Visibility is age-banded:

- **Ages 6–11:** recruiter-only profile; first name/display name, birth year, broad governorate, football development information, and guardian-approved footage. No public indexing, direct contact, precise location, school, training schedule, or commercial status.
- **Ages 12–15:** verified-recruiter-only detailed profile with the same contact restrictions and stronger child participation in consent/assent.
- **Ages 16–17:** verified-recruiter profile, guardian-controlled meetings, and representation only if the player is within the legally permitted window for a first professional contract and every agent requirement is satisfied.
- **Ages 18–23:** player-controlled professional profile; public teaser is optional, with details restricted to verified recruiters by default.

Public/discovery fields:

- display name;
- profile photo;
- nationality and football nationality where relevant;
- birth year or age (not full date of birth publicly);
- height;
- dominant foot;
- primary and secondary positions;
- current level, club, academy, league, and country;
- biography and playing-style summary;
- development/opportunity status: training only, open to assessment, open to academy trial, open to club trial, or professional opportunity; contract/registration status appears only where age-appropriate;
- contract end month/year for eligible players, with visibility controls;
- preferred destinations and willingness to relocate;
- languages;
- representative/agent status;
- profile completeness and verification markers;
- latest activity date.

Private/restricted fields:

- legal name and full date of birth;
- identity documents;
- phone, email, and address;
- representation agreements and other legal documents;
- expected compensation or commercial expectations;
- medical data, if introduced later, with separate consent and strict access;
- internal verification notes.

Football history:

- season, club/academy, competition, team level, shirt number, appearances, minutes, goals, assists, cards, clean sheets, and optional position-specific statistics;
- achievements, trials, and references;
- source and verification status for every important record.

CV export:

- generate a clean, shareable PDF from the approved profile data;
- public sharing link may be revoked and should not expose restricted data.

### 6.3 Video portfolio — P0

- Direct mobile upload and supported external video link.
- Highlight reel plus individual clips.
- Required metadata: match/date, opponent, competition, position, shirt colour/number, clip type, and whether the footage is a full match or edited highlight.
- Player marker at the start of a clip to identify the player.
- Automatic transcoding and adaptive streaming.
- Thumbnail selection.
- Captions/description.
- Upload progress, processing state, and failure recovery.
- Maximum durations and storage quotas by plan.
- Report copyrighted, misleading, abusive, or unrelated footage.
- Visibility: marketplace, approved organisations only, link-only, or private draft.

The platform should clearly distinguish edited highlights from full-match evidence. Automated performance analysis is not an MVP feature.

### 6.4 Discovery and search — P0

- Vertical, mobile-first highlight feed for fast discovery.
- Feed tabs: For You, Matching My Briefs, New Talent, Verified Evidence, and Following/Shortlisted.
- Each clip shows the player, age band, position, dominant foot, governorate, verification markers, clip context, and whether it is edited or continuous footage.
- Fast scout actions: applaud, mark professional interest, shortlist, open profile, pass, report, and request meeting.
- Search by name and keyword.
- Filters: position, age range, dominant foot, height, nationality, location, current level, availability, contract end, club/academy, verified status, video availability, and updated date.
- Sort by relevance, recently updated, age, and profile completeness.
- Saved searches and optional alerts.
- Search result cards showing only decision-useful data.
- Recently viewed players.
- Pagination or cursor-based infinite scrolling.

The feed is a discovery surface, not the final evaluation. Opening a profile reveals the longer contextual evidence, history, references, and meeting workflow.

Do not offer a universal "talent score" in the MVP. Recommendations should use explicit scout requirements and transparent signals rather than claiming to measure a player's absolute potential.

#### Reaction and ranking model

Separate community engagement from professional intent:

- **Applause/like:** a lightweight positive reaction. Guardians and players may see the count, but it has limited ranking weight.
- **Professional interest:** only a verified recruiter can use this signal. It is not publicly attributed unless the recruiter later requests contact.
- **Shortlist:** a private recruiter/organisation action and a stronger relevance signal.
- **Pass:** a private signal used to improve that recruiter's recommendations; the player never sees individual rejection reasons.
- **Comments:** not included in the MVP. Recruiters use private shortlist notes, pass reasons, and meeting outcomes; none appear as a public player comment thread.

Feed ranking should combine:

1. match to the scout's saved recruitment briefs and filters;
2. profile and evidence completeness;
3. verification and footage context;
4. freshness and availability;
5. professional-interest, shortlist, and meaningful watch signals from verified recruiters;
6. a new-talent/exploration quota so every recruiter-ready player receives initial distribution;
7. diversity controls to prevent one academy, governorate, position, or already-popular group from dominating;
8. trust and safety quality signals.

Raw public likes must never be the dominant ranking factor. Otherwise early popularity, family networks, and paid promotion will compound into a visibility monopoly.

#### Scout discovery flow

1. Recruiter completes verification and selects markets, age bands, and positions.
2. Recruiter optionally creates a specific brief, for example: U17–U19 left-footed centre-back, Cairo/Alexandria, available for assessment.
3. Home opens on a vertical feed prioritised to those preferences, with a deliberate share of new/unseen players.
4. Recruiter watches a clip and can applaud, mark interest, shortlist, pass, or open the full profile without leaving the feed context.
5. Full profile shows verified history, contextual clips, continuous/full-match evidence, guardian/representation status, and last-confirmed availability.
6. Recruiter saves the player to a shortlist or compares candidates.
7. Recruiter submits a structured meeting request; the platform reviews it and coordinates attendance.
8. Outcome is tracked through meeting, trial, registration, or closure.

### 6.5 Shortlists and collaboration — P0

- Personal and organisation shortlists.
- Add private notes and internal status.
- Share a shortlist with authorised colleagues.
- Compare up to four players side by side.
- Export a limited scouting report if allowed by the organisation.
- Player cannot see scout notes or exact shortlist membership.

### 6.6 Contact and messaging — P0

- Recruiters submit a structured meeting request; they cannot freely message a child.
- For every player under 18, all communication routes to the guardian and a platform safeguarding inbox. The child cannot be the sole participant.
- For adult players, messaging follows the player's representation and privacy settings.
- If a player has an authorised representative, that representative is included according to the valid mandate.
- In-app messaging with attachments limited to safe file types.
- Conversation participants and organisation identity are always visible.
- Block, report, archive, and retention controls.
- In-app and email notifications; WhatsApp/SMS can be added later for selected transactional alerts.
- Personal phone/email remain hidden. For minors they are never released to a recruiter through the platform; meetings are coordinated by the guardian and platform.
- Automated detection and manual enforcement target requests for money, secrecy, sexual content, private travel, unsupported guarantees, or attempts to bypass the guardian.

### 6.7 Meeting and opportunity workspace — P0

An opportunity is a private workspace used to qualify and arrange a meeting. It is not an offer, representation agreement, negotiation channel, or official transfer record.

Stages:

1. Contact requested
2. Interest accepted
3. Recruiter purpose reviewed
4. Meeting proposed
5. Meeting confirmed
6. Meeting completed
7. Referred to licensed representation service, if eligible and requested
8. Closed — follow-up, declined, expired, withdrawn, unsafe, or no response

Structured meeting request:

- interested organisation;
- player and authorised representative;
- opportunity type: introduction, assessment, academy trial discussion, club trial discussion, development discussion, or information request;
- proposed dates;
- meeting format and verified location/online link;
- identities, roles, and organisations of every attendee;
- stated purpose and requested follow-up;
- expiry date;
- free-text note;
- immutable event history.

For a minor, the guardian and an approved platform safeguarding/representation participant must be included in scheduling, and the child must never be instructed to attend alone. The platform records check-in, outcome, concerns, and next steps. Any representation or negotiation starts a separate compliance process handled by a named licensed agent.

### 6.8 Verification and trust — P0

Verification badges are separate, not one generic blue tick:

- identity verified;
- organisation verified;
- employment/membership verified;
- football history validated by named organisation;
- licensed agent checked, with date;
- video context validated;
- contact/representation authority confirmed.

Verification can expire or be revoked. Users must see what a badge means and what it does not mean.

#### Recruiter verification model

"Verified recruiter" means the platform has evidence of both the person's identity and a legitimate football recruitment purpose. It does not mean ScoutLink guarantees their judgment, honesty, financial capacity, club authority, or future conduct.

Minimum checks for every recruiter:

- government identity document, selfie/liveness check, verified phone and email;
- full legal name, nationality, residence, football role, organisation, and reason for access;
- professional email or explanation for its absence;
- signed recruiter code of conduct, child-safeguarding rules, privacy rules, and anti-circumvention terms;
- manual video interview for the pilot;
- at least two football references, checked independently;
- organisation/employment evidence where claimed;
- payment method and billing identity for paid access;
- adverse-history, sanctions, and lawful background checks proportionate to child access;
- periodic reverification, recommended annually and after any material role change.

Additional evidence by recruiter type:

- **Club employee/scout:** official club email or signed authority letter, club registry/contact confirmation, role and territory.
- **Independent scout:** recruitment history, two club/academy references, portfolio or prior placements, interview, and enhanced manual approval.
- **Agency employee:** agency registration evidence, principal's authorisation, and identity of the licensed football agent responsible for any regulated activity.
- **Football agent:** active licence checked against FIFA's directory plus minors accreditation where relevant. This creates a separate "licensed agent" badge.

#### Access levels

| Capability | Unverified visitor/account | Verified recruiter | Verified licensed agent |
|---|---:|---:|---:|
| View public adult teaser profiles | Yes | Yes | Yes |
| See marketplace supply counts and sample/demo data | Yes | Yes | Yes |
| View identifiable minor profiles | No | Yes, purpose-limited | Yes, purpose-limited |
| View guardian-approved player videos | No | Yes | Yes |
| Use detailed filters and shortlists | No | Yes | Yes |
| Request a platform-arranged meeting | No | Yes | Yes |
| Directly message a minor | No | No | No |
| Receive private player/guardian contact details | No | No by default | No by default |
| Negotiate or represent a party | No | No | Only with a valid mandate and applicable authorisation |
| See precise home/school/training location | No | No | No |

Unverified users should see enough aggregated supply and adult demo content to understand the product, but no identifiable child data. There is no paid shortcut around verification.

Admin capabilities:

- verification queue;
- document review with reason codes;
- request more information;
- approve, reject, expire, or revoke;
- duplicate/impersonation checks;
- report queue and enforcement history;
- account warning, temporary restriction, suspension, and appeal notes;
- audit log.

### 6.9 Notifications — P0

- Verification status changed.
- Profile or video approved/rejected.
- Contact request or new message.
- Expression of interest received, changed, expiring, accepted, declined, or withdrawn.
- Saved-search alert, opt-in only.
- Security alert for password or sensitive account changes.
- Per-channel notification preferences.

### 6.10 Administration and operations — P0

- User and organisation search.
- Verification and moderation queues.
- Profile/video visibility controls.
- Report investigation.
- Taxonomy management: positions, competitions, countries, levels, and opportunity types.
- Feature flags and plan limits.
- Basic marketplace analytics.
- Support case notes.
- Data export and deletion workflow.

## 7. Explicitly out of scope for MVP

- Livestreaming matches.
- AI-generated player ratings or automated scouting decisions.
- Automated analysis of speed, distance, actions, or biometrics from video.
- Comments, private adult-to-child threads, follower-count competition, or a feed ranked mainly by popularity.
- Open access for unverified scouts.
- Money movement, escrow, commission collection, payroll, or transfer-fee settlement.
- Offers, salary/fee negotiation, representation agreements, and legally binding transfer/employment contracts inside the product.
- FIFA TMS or association registration submission.
- Medical records and medical-clearance decisions.
- Visa/work-permit processing.
- Ticketed trials or pay-to-play promises.
- Scraping player data or videos from third parties without rights.
- Public transfer rumours or public offer amounts.
- Direct recruiter-to-child messaging.
- Publicly indexed profiles for minors.
- Overseas relocation or international transfer promises for minors.
- Representing a young child before the legally permitted representation window.

## 8. Critical user journeys

### 8.1 Player publishes a credible profile

1. Register and verify email/phone.
2. Select player role and accept required policies.
3. Enter football CV and privacy choices.
4. Upload identity document privately.
5. Add current club/academy and request affiliation validation.
6. Upload a highlight reel and at least one contextual clip/full-match link.
7. Preview profile as a scout would see it.
8. Submit for review.
9. Admin approves or asks for corrections.
10. Profile becomes discoverable and player receives a completeness checklist.

Target: a serious player can submit a complete profile in under 15 minutes, excluding video processing and verification review.

### 8.2 Scout finds and shortlists a player

1. Join or create a verified organisation.
2. Search for a recruitment need.
3. Filter and open player profiles.
4. Review verification, recency, clips, and full-match context.
5. Add players to an organisation shortlist with private notes.
6. Compare candidates.
7. Request contact with one or more players.

Target: a scout can reach a credible five-player shortlist in under 10 minutes for a well-defined need.

### 8.3 Club starts an opportunity

1. Scout requests contact.
2. Player/representative accepts.
3. Participants clarify sporting interest.
4. Authorised club user creates a structured, non-binding expression of interest.
5. Receiving party accepts, declines, or asks to continue discussion.
6. Both sides see the current stage, next action, and expiry.
7. Official negotiation, contracts, registrations, and payments happen through the legally appropriate channels.
8. Club closes the workspace and records an outcome.

## 9. Business model

### Recommended model: hybrid SaaS plus regulated representation

Players should have a useful free plan. Charging unknown players for the promise of being discovered creates trust and incentive problems. Clubs, academies, scouts, and agents receive workflow and access value and are better subscription customers.

The optional representation business is a separate regulated service and revenue line. Its agreements, eligibility, agent licence, service scope, fees, conflicts, disclosures, and payment handling require Egyptian sports counsel and EFA confirmation. It must never be a condition for a child to keep a basic profile or receive fair visibility.

### Revenue stream 1 — recruiter subscriptions

This should be the predictable core revenue:

- **Verified Recruiter:** individual seat, detailed search, video access, shortlists, and a limited number of meeting requests.
- **Recruiter Pro:** more active shortlists/requests, saved-search alerts, reports, and priority scheduling.
- **Club/Agency Team:** multiple seats, shared shortlists, approvals, audit history, and account management.
- Annual plans for organisations; monthly or quarterly plans for individuals.

Pricing should be tested during the pilot rather than guessed in the specification. The pilot can be free for carefully selected design partners in exchange for weekly usage and feedback, then introduce paid plans once the platform repeatedly produces qualified meetings.

### Revenue stream 2 — academy portfolio software

Egyptian academies may pay to manage verified rosters, upload footage, validate history, produce development reports, and receive controlled recruitment enquiries. This is a software/service fee, not a promise that players will be signed.

### Revenue stream 3 — player-side representation fee

When an eligible player voluntarily appoints ScoutLink's named licensed agent under a valid representation agreement, the agent may charge the player an agreed percentage of the remuneration negotiated for that player, subject to the rules applicable to that transaction.

The preferred starting position is **player-side representation only**. This keeps the duty clear: the agent acts for the player. Do not also take a transfer-fee percentage from the releasing club or represent conflicting parties in the same transaction unless specialist counsel confirms a permitted structure and every required written consent is obtained.

FIFA's published framework uses a client-pays model. Its FAQ currently describes caps based on the client and transaction, including 5% of player remuneration up to USD 200,000 and 3% above that level for an individual client, but the exact enforceable fee for an Egyptian domestic or international transaction must be confirmed against current FIFA/EFA rules and applicable law when the agreement is signed. The commercial model must not hard-code a percentage before that review.

### Revenue stream 4 — optional production services, later

Guardian-requested filming, profile translation, verified measurements, or independent assessment may be sold at transparent fixed prices. These purchases must not improve search ranking, guarantee recruiter contact, or be required for basic participation. Do not launch these services until the free player path works credibly.

### Suggested plans

#### Player Free

- Complete profile and limited video storage.
- Marketplace discovery.
- Respond to contact requests.
- Basic profile-view analytics with privacy protection.
- PDF CV and revocable sharing link.

#### Player Pro — later, optional

- More video storage and profile presentation tools.
- Deeper aggregated analytics.
- Translation and CV variants.
- No ranking boost and no guaranteed scout contact.

#### Scout / small organisation

- Search and filters.
- Limited seats, shortlists, notes, messaging, and saved searches.
- Monthly or annual subscription.

#### Club / academy

- Multiple seats and roles.
- Organisation-wide lists and deal pipeline.
- Approval workflow, exports, analytics, and priority support.
- Annual contract.

#### Agent — after legal validation

- Verified portfolio management.
- Opportunity routing and meeting workspace.
- Subscription per licensed individual or organisation, subject to regulations.

### Do not use initially

- Pay-per-contact.
- Player ranking boosts.
- A marketplace percentage of every transfer or salary agreement.
- Charging children or parents for guaranteed trials, contracts, or visibility.
- Taking fees from both sides without a compliant, conflict-checked mandate.
- Selling personal data or individual browsing history.
- Advertising that compromises recruitment neutrality.

Agent service fees, including any success-related element, may be introduced only within the compliant representation service after specialised legal review; they are not marketplace fees.

### Recommended payer map

| Value received | Recommended payer | Revenue type |
|---|---|---|
| Search, video review, shortlists, meeting workflow | Recruiter/club/agency | Subscription |
| Academy roster and portfolio management | Academy | Subscription/service fee |
| Free profile and fair marketplace visibility | No charge to player/guardian | Supply acquisition |
| Negotiation and representation for an eligible appointed player | Player as the agent's client, unless a compliant exception applies | Regulated agent fee |
| Filming/translation/measurement, if requested | Guardian or adult player | Fixed optional service fee |

## 10. Marketplace operations and trust model

Technology alone will not create liquidity. The initial operating model should be managed:

- Recruit supply through partner academies and clubs.
- Review the first 500 profiles manually.
- Invite scouts individually and verify their employment or professional purpose.
- Run weekly recruitment briefs: clubs state needs, the team helps identify matching profiles.
- Track why searches fail: missing position, poor video, geography, compensation, verification, or player quality.
- Remove inactive or misleading availability quickly.
- Never promise contracts or trials.
- Publish clear anti-scam guidance and an official support channel.

### Marketplace quality rules

- A player profile is searchable only after minimum completeness and moderation.
- Availability must be reconfirmed at a defined interval, recommended every 30 days.
- Contract status should show source and "last confirmed" date.
- Professional accounts are periodically reverified.
- Repeated unsolicited, deceptive, discriminatory, or exploitative messages lead to restriction.
- Users may not move a conversation off-platform by deception or request advance fees for guaranteed opportunities.

### Keeping introductions and outcomes attributable to the platform

No marketplace can technically guarantee that two people will never exchange contact information or communicate elsewhere. The strategy is layered protection, evidence, and incentives:

1. **Controlled identity:** Detailed profiles, videos, full names where appropriate, and meeting requests are available only to approved recruiters.
2. **No exposed contacts:** Player and guardian phone, email, address, school, and precise training location remain hidden.
3. **Platform-arranged meetings:** Every pilot meeting—minor or adult—includes a platform representative, a verified attendee list, agenda, check-in, outcome, and follow-up.
4. **Introduction record:** The system time-stamps which recruiter first discovered/requested each player and maintains an immutable opportunity history.
5. **Contractual non-circumvention:** Recruiter terms prohibit using platform introductions to avoid agreed subscription, meeting, or representation obligations for a reasonable, lawyer-approved period. Player/guardian terms require disclosure of offers arising from a platform introduction. These clauses must be proportionate and enforceable under the applicable law.
6. **Representation agreement:** For an eligible player who appoints the licensed agent, the agreement defines scope, duration, fees, exclusivity if lawful, reporting, and what happens when an introduced club later signs the player. Player agreements cannot exceed applicable duration limits; FIFA's published framework limits a player/coach representation agreement to two years and permits only one agreement with the same agent at a time.
7. **Club/recruiter introduction acknowledgement:** Before a meeting, the recruiter acknowledges the platform introduced the player and records the organisation they represent.
8. **Ongoing value:** Document preparation, meeting support, negotiation, safeguarding, reminders, and a clean audit trail give both sides practical reasons not to bypass the platform.
9. **Outcome verification:** Regular guardian/player and recruiter follow-ups ask about trials, offers, registrations, and contracts. Academy/EFA/club evidence may be requested where lawful.
10. **Proportionate enforcement:** Warning, loss of access, subscription termination, withheld platform privileges, and contractual recovery where counsel confirms it. Never punish or hide a child because an adult circumvented the platform.

Do not rely on invasive surveillance, reading communications outside the service, withholding a player's documents, or blocking a beneficial football opportunity. The platform protects its economics through clear agreements and service value, not control over the child's career.

## 11. Legal, regulatory, privacy, and safeguarding requirements

This section is product guidance, not legal advice. Counsel in the launch jurisdiction must approve the final operating model and terms.

### Football regulation

Because the specification is dated October 2026, counsel must assess both the rules currently in force and FIFA's published January 2027 RSTP before launch.

- Only appropriately licensed/authorised natural persons may provide regulated football-agent services. The company cannot simply call itself the player's agent and assign negotiation to unlicensed staff.
- Verify agent identity and licence against the current authoritative source, and recheck periodically.
- The representation service must name the licensed individual responsible for the client and use a compliant written representation agreement.
- Staff must not negotiate, communicate preparatory to a transaction, or advise as the player's agent unless they are the licensed/authorised agent or are performing permitted support under that agent's direct legal responsibility.
- Domestic transactions may be subject to national association regulations in addition to FIFA rules.
- International transfers must follow the official FIFA/association process; the platform deal room does not replace it.
- Keep a clear distinction between marketplace communication, an expression of interest, representation, negotiation, employment contracts, transfer agreements, and registration.
- A minor may be approached for representation only within six months before the age at which the player may sign a first professional contract in the place of prospective employment, after prior written guardian consent. The agent also needs FIFA's minors accreditation and must satisfy applicable EFA/national requirements.
- International transfers of under-18 players are generally prohibited except for narrowly defined FIFA exceptions; discovery must never be marketed as a guaranteed international transfer route.

### Privacy and data governance

- Document a lawful basis for each processing purpose.
- Collect the minimum data required.
- Separate public, marketplace-only, organisation-only, deal-room, and administrator-only visibility.
- Encrypt data in transit and at rest.
- Use short-lived access URLs for private files and videos.
- Store identity documents separately from normal profile data.
- Define retention periods by data type and legal requirement.
- Provide access, correction, export, objection/consent withdrawal where applicable, and deletion workflows.
- Maintain a processor/subprocessor register and data-processing agreements.
- Complete child-rights, privacy, security, and safeguarding impact reviews before the alpha; repeat them before adding biometrics, medical data, or automated ranking.
- Treat all children's data as sensitive data under the Egyptian compliance design; obtain and record explicit guardian consent before collection, with purpose, time period, and withdrawal handling.
- Avoid behavioural advertising, public tracking, and opaque profiling of children. Product analytics for minors must be minimal, aggregated where possible, and legally reviewed.
- Do not use player videos or personal data to train machine-learning models without a separate, explicit, well-explained legal basis and choice.

### Safeguarding

Safeguarding is a launch-critical operational function, not a later feature. The MVP requires:

- verified guardian account and guardian-player relationship;
- age-appropriate Arabic/English notices, child assent where appropriate, and guardian consent/authorisation;
- no direct private adult-to-child messaging;
- guardian visibility and control over publication, communication, and meetings;
- trained safeguarding lead plus backup coverage and documented response targets;
- verified and specially authorised agents for any permitted representation of minors;
- restricted precise location, school, contact, travel, and schedule data;
- recruiter identity and professional-purpose checks, with periodic reverification;
- local background-check policy where lawful and proportionate;
- two-adult/guardian attendance rule for in-person meetings involving a child;
- verified venue, attendee list, check-in/check-out, and post-meeting guardian feedback;
- formal emergency, abuse, exploitation, missing-child, and law-enforcement referral procedures;
- child-rights, privacy, and safeguarding impact assessments before private alpha;
- visible reporting for guardians and age-appropriate reporting for children;
- immediate suspension path when a recruiter requests secrecy, private travel, payment, or guardian bypass.

### Content and media rights

- Uploaders warrant that they have permission to use footage, music, logos, and personal likenesses.
- Provide a rights complaint/takedown process and repeat-infringer policy.
- Avoid unlicensed commercial music in highlight reels.
- Preserve original upload and moderation evidence only as long as necessary.

## 12. Technical architecture

> Historical note: the stack in this section has been superseded by [`TECHNICAL_SPEC_V2.md`](./TECHNICAL_SPEC_V2.md). The authoritative implementation uses Flutter, FastAPI, and PostgreSQL.

### Recommended approach

Build a responsive web application/PWA and a modular monolith. Do not start with microservices or separate native mobile apps. The team needs fast iteration, consistent permissions, and simple operations more than independent scaling.

### Suggested stack

- Application: Next.js 16 stable with TypeScript, App Router, responsive PWA, server rendering where useful, and explicit domain modules.
- API: versioned REST endpoints/route handlers inside the modular monolith. Do not add NestJS until a separate client/team or measured service boundary justifies it.
- UI: Tailwind CSS plus shadcn/ui primitives, with a documented design system, Arabic RTL, English, and WCAG 2.2 AA target.
- Database/auth/files: Supabase managed PostgreSQL, Auth, and private Storage in a specifically selected region, with Row Level Security as defense in depth.
- Database access: Drizzle ORM/query builder plus reviewed SQL migrations and explicit RLS/grant tests.
- Video: Mux Direct Uploads and signed playback for the MVP; video bypasses the application server. Revisit vendor choice after data-protection/legal review and measured cost.
- Background work: PostgreSQL outbox/jobs table plus one scheduled worker initially; add a managed durable queue only when retries/volume require it.
- Search: PostgreSQL filters and full-text search first; OpenSearch/Elasticsearch only after measured need.
- Real-time: no WebSocket infrastructure initially; use normal request/response plus short polling where needed. Add realtime only after proven need.
- Email: transactional email provider with templates, delivery events, and suppression handling.
- Observability: structured privacy-scrubbed logs, Sentry-style error tracking, uptime checks, and first-party product events; no session replay on child experiences.
- Hosting: Vercel for the application and one explicitly chosen primary data region close to Egypt, with backups and tested restoration. Cross-border data flows require legal review.

### Core modules

1. Identity and access
2. Users, roles, and organisations
3. Player profiles and career history
4. Media and video processing
5. Verification and documents
6. Discovery and saved searches
7. Shortlists and notes
8. Messaging and notifications
9. Opportunities and meetings
10. Moderation, reports, and audit
11. Subscriptions and entitlements
12. Analytics and administration

### Key entities

- User
- GuardianRelationship
- ChildConsentRecord
- RoleAssignment
- Organisation
- OrganisationMember
- PlayerProfile
- PlayerAffiliation
- CareerEntry
- StatisticRecord
- MediaAsset
- VideoClip
- VerificationCase
- VerificationClaim
- AgentLicenceCheck
- SearchPreference
- Shortlist
- ShortlistEntry
- Conversation
- ConversationParticipant
- Message
- Opportunity
- OpportunityParticipant
- MeetingRequest
- MeetingAttendance
- SafeguardingCase
- OpportunityEvent
- Notification
- Report
- ModerationAction
- ConsentRecord
- AuditEvent
- Subscription
- Entitlement

Important records should use stable IDs, created/updated timestamps, actor IDs, and soft deletion or append-only history where appropriate.

### Opportunity state rules

- State changes are server-controlled and permission-checked.
- Meeting requests are versioned; edits never silently overwrite an earlier version.
- Meeting acceptance records the guardian/player actor as applicable, recruiter organisation, attendees, purpose, location, timestamp, and exact version.
- Closed opportunities are read-only except for admin corrections with audit history.
- Sensitive fields are visible only to current authorised participants.

### API principles

- Versioned HTTP JSON API initially.
- Cursor pagination for growing feeds and messages.
- Idempotency keys for meeting creation and other critical mutations.
- Explicit field-level authorisation, not only route-level checks.
- Rate limits by user, IP, organisation, and sensitive action.
- Malware scanning for document attachments.
- Webhooks for video processing and payment/subscription events, verified by signature.

## 13. Security baseline

- Multi-factor authentication required for administrators and recommended/required for professional accounts.
- Password hashing using a current memory-hard algorithm through a proven identity provider/library.
- Session revocation and device/session view.
- Principle of least privilege for infrastructure and support staff.
- Separate production and non-production environments; no production personal data in development.
- Secret manager, dependency scanning, static analysis, and protected deployment pipeline.
- Private backups, point-in-time database recovery, and tested restoration.
- Immutable or tamper-evident audit trail for verification and deal actions.
- File type, size, malware, and content checks.
- Protection against account enumeration, credential stuffing, spam, scraping, and bulk profile export.
- Security contact and incident-response playbook.
- Regular access review and penetration test before material commercial launch.

### Initial service targets

- 99.5% monthly availability during private beta; move to 99.9% after operational maturity.
- Restore service within 8 hours for a major disaster (initial RTO).
- Lose no more than 1 hour of new transactional data (initial RPO), with tighter targets later.
- Typical API reads under 500 ms at p95, excluding video delivery and third-party verification.
- Search results under 1 second at p95 for the initial dataset.
- At least 90% of recruiter-ready pilot players receive a defined minimum number of qualified feed impressions; monitor distribution by academy, governorate, age, and position.

## 14. Analytics and success metrics

### North-star metric

**Qualified opportunities started per month**, where a qualified opportunity is between verified parties, concerns a sufficiently complete player profile, and receives a meaningful response from the player/representative.

### Supply metrics

- verified and searchable player profiles;
- profile completion rate;
- profiles with recent contextual video;
- availability reconfirmation rate;
- time to verification;
- share of players receiving at least one qualified view/contact.

### Demand metrics

- verified professional organisations and active scouts;
- weekly active scouts;
- searches leading to a profile view, shortlist, and contact;
- time from search to shortlist/contact;
- saved-search return rate;
- professional subscription conversion and retention.

### Marketplace metrics

- contact acceptance rate;
- response time;
- opportunities per active organisation;
- stage conversion and time in stage;
- closed-successful opportunities, with evidence category;
- report/scam rate;
- supply-demand coverage by position, age, level, and geography.

Do not use raw profile views as the north star; they can grow without creating football outcomes.

## 15. Product analytics events

At minimum:

- onboarding_started/completed;
- verification_submitted/approved/rejected;
- profile_submitted/published/updated;
- video_uploaded/processed/viewed/completed;
- feed_impression, feed_clip_started/completed, applaud_added/removed, professional_interest_added, and player_passed;
- search_executed and filter_used, with sensitive values protected;
- profile_viewed;
- shortlist_created and player_shortlisted;
- contact_requested/accepted/declined;
- conversation_started and message_sent;
- opportunity_created and stage_changed;
- meeting_requested/reviewed/accepted/declined/completed;
- safeguarding_flag_created/resolved;
- opportunity_closed with reason;
- report_submitted and moderation_actioned;
- subscription_started/renewed/cancelled.

Analytics identities and retention must follow the privacy policy. Sensitive message, document, offer, and identity contents must not be copied into analytics tools.

## 16. Delivery plan

### Phase 0 — validation and operations design (3–4 weeks)

- Interview 15 players, 10 scouts/recruiters, 5 club decision-makers, 5 academies, and 3 licensed agents in the chosen market.
- Test the proposed profile fields and search filters with real examples.
- Prototype player onboarding, search, profile, and contact request.
- Obtain written Egyptian football-regulation, data-protection, child-rights, agency, terms, and safeguarding advice; confirm the EFA rules for first professional contracts and representing minors.
- Recruit design partners and define verification operations.
- Produce data classification, moderation policy, and marketplace rules.

Exit: at least five clubs/scouting organisations commit to testing, and the team can manually source credible matches for real recruitment briefs.

### Phase 1 — private alpha (8–10 weeks)

- Authentication, roles, organisations, guardian accounts, and age gating.
- Player profile, career history, privacy controls, video.
- Manual verification/admin queue.
- Search, filters, profile view, shortlists.
- Guardian-routed meeting request, protected messaging, notifications, and safeguarding case handling.
- Audit, reports, baseline analytics.

Exit: a small invited cohort—recommended 50 guardian-verified players and 10 verified recruiter organisations—can use discovery-to-meeting safely, and every safeguarding drill meets its response target.

### Phase 2 — private beta (6–8 weeks)

- Meeting workspace, attendance controls, and outcome tracking.
- Organisation collaboration and permissions.
- Saved searches and alerts.
- Subscription entitlements and billing for professionals.
- Improved moderation and operational dashboards.
- Security review and restoration test.

Exit: at least 25 qualified monthly opportunities, acceptable response times, repeat scout usage, and no unresolved critical trust/safety issue.

### Phase 3 — controlled commercial launch

- Paid plans and onboarding support.
- Marketplace quality programme.
- Performance, accessibility, and SEO improvements for approved public pages.
- Refined reporting, exports, and customer success.
- Decide whether the next investment is mobile apps, data integration, a second market, or minors—based on measured demand.

## 17. Prioritisation

### P0 — required to launch

- Secure identity, roles, organisations, guardian relationships, age gates, and recruiter verification.
- Player CV, privacy controls, video, and publishing review.
- Discovery, filtering, profiles, shortlists, and private notes.
- Guardian-routed meeting requests, protected messaging, and notifications.
- Meeting/opportunity pipeline, safeguarding controls, and audit history.
- Admin, moderation, reports, consent records, export/deletion workflow.
- Basic subscriptions/entitlements for commercial beta.

### P1 — shortly after launch

- Player comparison.
- Saved search alerts.
- Organisation approval workflow for outbound meeting requests.
- PDF scouting report and improved CV export.
- Profile translation.
- Calendar integration for trials/calls.
- More detailed marketplace analytics.
- Reverification automation.

### P2 — only after evidence

- Native iOS/Android apps.
- External scouting/statistics providers.
- Transparent recommendation engine.
- E-signature for limited documents.
- Trial management.
- Association/TMS-adjacent integrations where authorised.
- Guardian/minor experience.
- Video analysis and structured scouting assessments.

## 18. Key risks and mitigations

| Risk | Impact | Initial mitigation |
|---|---|---|
| Too few credible scouts | Players churn | Invite-only demand side; recruit clubs before mass player acquisition |
| Low-quality or misleading profiles | Scouts lose trust | Minimum completeness, manual review, claim-level verification, recency dates |
| Scam or fake opportunity | Severe player harm | Professional verification, in-app identity, reports, warnings, rapid enforcement |
| Platform performs regulated agent activity | Legal/regulatory exposure | Separate representation service, named licensed agents, compliant agreements, EFA/FIFA and local-counsel validation |
| False age or guardian relationship | Safeguarding and legal risk | Age/identity evidence, guardian verification, periodic reverification, dispute freeze and escalation |
| Recruiter targets or grooms a child | Severe child harm | No direct messaging, guardian/platform routing, meeting controls, detection, rapid suspension and referral policy |
| Copyrighted footage | Takedowns/liability | Rights warranty, reporting, takedown process, no unlicensed music guidance |
| Clubs bypass the platform | Weak retention | Collaboration, searchable evidence, deal history, alerts, and workflow value |
| Player pays but gets no opportunity | Reputation damage | Useful free plan; no visibility guarantees or paid ranking |
| Data breach or scraping | Personal and commercial harm | Layered visibility, rate limits, signed media URLs, monitoring, least privilege |
| Biased discovery | Missed talent/discrimination | Transparent filters, avoid opaque scores, monitor coverage and outcomes |

## 19. Acceptance criteria for the MVP

The MVP is ready for controlled commercial use when:

- A player can create, preview, submit, verify, publish, update, and deactivate a profile from mobile.
- A scout cannot access marketplace data until professional verification is approved.
- Every restricted field has tested role- and relationship-based visibility.
- Video uploads process reliably and cannot expose private source files through permanent public URLs.
- Scouts can search, shortlist, take private notes, request contact, and communicate.
- A verified recruiter can request a meeting, the guardian can respond, and the platform can safely coordinate and record the outcome.
- Every verification, moderation, and offer action has an audit record.
- Users can report and block another user, and staff can resolve the report.
- Child/guardian consent versions, privacy settings, consent withdrawal, data export, and deletion requests are operational.
- Backup restoration, incident response, and administrator MFA have been tested.
- Egyptian counsel and the appropriate football-regulatory specialist have reviewed the child-data model, terms, agent role boundaries, verification language, and EFA/FIFA requirements.
- Support, moderation, and safeguarding have named owners, escalation cover, and tested response targets.

## 20. Founder decisions recorded

| Decision | Confirmed direction |
|---|---|
| Supply geography | Egyptian players first |
| Recruiter geography | Worldwide |
| Players | Aspiring professional talent aged 6–23 |
| First pilot | 50 Egyptian boys aged 12–19; exact governorates/partners pending |
| Girls | Designed for later inclusion, not in the first pilot |
| Pilot pricing | Free for all sides during a defined validation period; no subscription, listing, meeting, or representation fee in the MVP pilot |
| Recruiter access | Any legitimate talent recruiter may apply; a football-agent licence is not required merely to scout |
| Recruiter safety gate | Identity and professional-purpose verification required; no anonymous detailed access |
| MVP transaction boundary | Platform arranges and records a meeting; no in-product offer or negotiation |
| Meeting attendance | A platform representative attends every meeting, including meetings with adult players |
| Representation | Platform intends to provide player representation through appropriately licensed agents |
| Minor communication | Guardian-controlled; no direct private recruiter-to-child contact |
| Official completion | Contracts, transfer registration, TMS, medical, and payments remain outside the product |

## 21. Remaining founder decisions

1. **Pilot location:** Which Egyptian governorate(s), academies, and tournaments will provide the first 50 boys aged 12–19?
2. **Profile visibility:** Confirm that all under-18 profiles are verified-recruiter-only, while 18–19-year-olds may opt into a limited public teaser.
3. **Representation capacity:** Will ScoutLink partner with an existing FIFA-licensed agent for the pilot, or will a founder pursue the licence? Minors accreditation is additionally required for eligible under-18 representation.
4. **Languages:** Arabic and English are recommended for launch; is French required for North/West African recruitment?
5. **Free-pilot exit gate:** Which evidence activates monetisation? Recommendation: do not charge until at least 10 qualified meetings, 3 verified trial invitations, repeat use by 5 recruiters, and acceptable safeguarding/response metrics.
6. **Academy model after validation:** Will partner academies pay for roster tools, participate free as supply partners, or use a mixed plan?
7. **Success definition:** Meeting completed, verified trial invitation, academy/club registration, signed professional contract, or registered transfer? Report each separately rather than one ambiguous "deal" number.
8. **Safeguarding ownership:** Who is the trained safeguarding lead and who covers urgent incidents when that person is unavailable?

## 22. Next specification artifacts

After the ten founder decisions are answered, create:

1. Product requirements document with screen-level requirements.
2. User-flow diagrams and low-fidelity wireframes.
3. Data model and visibility matrix.
4. API contract and event catalogue.
5. Verification, moderation, safeguarding, and support playbooks.
6. Terms/privacy/legal requirements checklist for the launch country.
7. Analytics dashboard definitions.
8. Delivery backlog with estimates, owners, and release gates.
9. Unit economics model based on video, verification, support, and acquisition costs.
10. Go-to-market plan for the first 300 players and 30 professional users.

## 23. Regulatory references consulted

- FIFA, Football Agents and Football Agent Regulations: https://legal.fifa.com/transfer-system/agents
- FIFA, Football Agent Regulations FAQ: https://legal.fifa.com/transfer-system/agents/faq-agents
- FIFA, National Football Agent Regulations: https://inside.fifa.com/transfer-system/agents/national-football-agent-regulations
- FIFA, International Player Transfer Guide/TMS overview: https://inside.fifa.com/legal/news/fifa-guide-provides-step-by-step-insight-into-the-process-behind-an-international-transfer
- FIFA, parent education and representation of minors: https://inside.fifa.com/transfer-system/agents/education/fifa-parent-education-on-football-agents/preparation-to-engage
- FIFA, 2026 Guide to Submitting a Minor Application: https://inside.fifa.com/legal/news/new-edition-guide-submitting-minor-application
- FIFA, Transfer System 2027 and published January 2027 RSTP: https://inside.fifa.com/transfer-system/transfer-system-2027
- Egyptian Football Association, 2025/2026 player registration and transfer rules: https://www.efa.com.eg/media/blmnqtdy/%D8%AA%D8%B9%D9%84%D9%8A%D9%85%D8%A7%D8%AA-%D8%A7%D9%84%D9%82%D9%8A%D8%AF-%D9%85%D9%88%D8%B3%D9%85-20252026.pdf
- Egypt Personal Data Protection Law No. 151 of 2020 and 2025 Executive Regulations (English translations require confirmation against the official Arabic text): https://www.legal500.com/intelligence/egypt/privacy/egypts-personal-data-protection-law-%28pdpl%29-english-translation
- EU GDPR Article 8 (relevant if EU/EEA child-data rules apply): https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?from=DE&uri=CONSIL%3AST_5419_2016_INIT

