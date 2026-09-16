# Gmail Message Clipping

## What it is

Gmail (web and mobile apps) clips any message whose **HTML part** is larger
than **102KB (104,448 bytes)**. Once the HTML crosses that size, Gmail renders
only the first chunk and replaces everything after it with:

> [Message clipped] **View entire message**

Clicking the link opens the full email in a separate page. The message itself
is delivered intact — this is purely a Gmail *rendering* limit, not a
delivery/SMTP limit.

### What counts toward the 102KB

- The raw HTML markup of the message (tags, inline `style`, comments,
  whitespace).
- Any text content, and tracking/redirect URLs baked into `href`/`src`
  attributes.
- **Not** the byte size of linked images — Gmail loads `<img src="...">`
  separately, so image file size doesn't count. Only the `<img ...>` tag
  markup itself counts.
- Only the HTML part is measured. The plain-text alternative part
  (`multipart/alternative`) doesn't affect clipping since Gmail's web/app UI
  renders the HTML part.

### Why it matters

- Anything below the clip point — CTAs, footers, unsubscribe links, tracking
  pixels — is invisible until the reader clicks "View entire message," which
  most people don't.
- Open-tracking pixels placed near the bottom of an email won't fire for
  clipped opens, undercounting open rates.
- A missing/hidden unsubscribe link below the clip point can be a compliance
  problem (CAN-SPAM/GDPR).
- Safe target: keep HTML well under 102KB — a common rule of thumb is **~80KB**,
  since an ESP or Gmail itself may append a few KB of extra markup
  (tracking, list headers) on top of what you send.

## Confirmed in this project

`app/views/user_mailer/welcome_email.html.erb` (before this refactor) was
**105,323 bytes** — already over Gmail's 104,448-byte threshold — because the
same 3-column feature block had been copy-pasted ~30 times instead of looped.
`UserReadBookJobs` (the job that actually sends this email on every book-read
event) confirmed this in production: it had ad-hoc debug code that measured
the rendered HTML size and dumped it to `output.html` (105,934 bytes) — both
numbers land just past the clip line, which matches the clipping the team
observed in real Gmail inboxes.

### The fix

- Replaced the duplicated markup with a single `_feature_grid` partial looped
  over a small `FEATURES` array (`app/mailers/user_mailer.rb`) — this is the
  actual root cause fix.
- `welcome_email` now renders at **~4.7KB**, comfortably under the limit.
- `ApplicationMailer` gained a `GMAIL_CLIP_LIMIT_BYTES` constant and an
  `after_action` callback (`warn_if_over_gmail_clip_limit`) that logs a
  `Rails.logger.warn` for *any* mailer/action whose HTML part exceeds the
  threshold — a regression guard, not just a one-off fix for this template.
- `spec/mailers/user_mailer_spec.rb` asserts `welcome_email`'s HTML stays at
  or under the limit, so a future copy-paste regression fails CI instead of
  reaching Gmail.

### Reproducing clipping on demand

`UserMailer.clipping_demo(user, block_count: 70)` deliberately repeats the
feature grid until the HTML exceeds 102KB (~114KB by default), to:

- Preview at `http://localhost:3000/rails/mailers/user_mailer/clipping_demo`.
- Send a real message to a Gmail address (`UserMailer.clipping_demo(user).deliver_now`)
  to see the actual "[Message clipped] View entire message" behavior.
- Assert against it in specs (`spec/mailers/user_mailer_spec.rb` checks the
  demo *does* exceed the limit and *does* trigger the warning), proving the
  guard actually fires when it should.

## Sources

- [Gmail is clipping my email — Mailchimp](https://mailchimp.com/help/gmail-is-clipping-my-email/)
- [Why is Gmail "clipping" my email? — ActiveCampaign](https://help.activecampaign.com/hc/en-us/articles/115001060524-Why-is-Gmail-clipping-my-email)
- [Gmail Email Clipping and How to Avoid It — Email on Acid](https://www.emailonacid.com/blog/article/email-development/gmail-email-clipping/)
- [Avoid Email Clipping In Gmail — Drip](https://help.drip.com/hc/en-us/articles/4424710412941-Avoid-Email-Clipping-In-Gmail)
- [Why did my email get clipped in Gmail? — Palisade](https://www.palisade.email/learning/email-questions/why-did-my-email-get-clipped-in-gmail)
