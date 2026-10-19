# lim.college

A ranked math problem ladder in two subjects, each with its own rating, rank and leaderboard: 368 calculus problems and 208 linear algebra problems, fixed points per problem, nine ranks, monthly seasons, concept explainers, player profiles, English and Portuguese.

It's a static site (no build step). Accounts, the leaderboard and profiles use a free [Supabase](https://supabase.com) project.

```
index.html      the whole site
config.js       your Supabase URL and public key  ← the only file you edit
supabase.js     the Supabase browser library (v2.117.2), bundled so the site has no extra dependency
schema.sql      one-time database setup
vercel.json     hosting settings
favicon.svg     tab icon
prof/           the professor's worked solutions for IST mode (images, loaded on demand)
```

## 1. Set up Supabase (about 5 minutes)

1. Create a free account at supabase.com and click **New project**. Any name and region (pick one close to your players); save the database password somewhere.
2. When the project is ready, open **SQL Editor → New query**, paste the whole of `schema.sql`, and click **Run**. You should see "Success. No rows returned". (Updating an existing site? Run the whole file again: it only adds what's missing.)
3. Open **Authentication → Sign In / Providers → Email**. Email sign-in is on by default. Decide on **Confirm email**:
   - On (default): new players must click a link in their inbox before they can sign in. Supabase's built-in mailer only sends a few emails per hour, which is fine for a small group.
   - Off: players can sign in right after creating an account. Simplest for a class or a group of friends.
4. Open **Project Settings → API Keys** (or click **Connect** at the top of the dashboard). Copy:
   - the **Project URL**, like `https://abcdefghijklmnop.supabase.co`
   - the **anon / publishable key** (starts with `eyJ…` or `sb_publishable_…`). Never use the `service_role` / secret key here.
5. Put both into `config.js`.

## 2. Deploy to Vercel

The free address will be `https://<project-name>.vercel.app`, so name the project `limcollege` to get `limcollege.vercel.app` (if nobody has taken it).

**Option A, no installs (GitHub + Vercel website)**

1. On github.com, create a new repository called `limcollege` and use **Add file → Upload files** to upload every file in this folder.
2. On vercel.com, sign in with GitHub, click **Add New → Project**, and import the `limcollege` repository.
3. Framework preset: **Other**. Leave build and output settings empty. Click **Deploy**.

Every later change you push to the repository redeploys the site automatically.

**Option B, command line (needs Node.js)**

```
cd limcollege
npx vercel          # first time: log in, accept the defaults, name the project limcollege
npx vercel --prod   # publish to limcollege.vercel.app
```

If `limcollege` is taken, Vercel adds a suffix. You can change it under **Project → Settings → Domains**.

## 3. Point Supabase back at the site

In Supabase, open **Authentication → URL Configuration**:

- **Site URL**: `https://limcollege.vercel.app` (your real address)
- **Redirect URLs**: add the same address

This makes confirmation and password-reset emails link to your site instead of `localhost`.

## A real domain

`limcollege.vercel.app` is free. A domain of your own (for example `lim.college` or `limcollege.com`) has to be bought from a registrar or through **Vercel → Settings → Domains**, which also connects it for you. Students can sometimes get a free domain for a year through the GitHub Student Developer Pack.

## Good to know

- Answers are checked in the visitor's browser, so a technically minded player could fake a rating. Fine for friends and classmates; a public competition would need server-side checking.
- **IST mode**: players whose profile school is IST or Técnico get the course week (calculus) or Ficha (linear algebra) on University problems, and Solution shows the professor's worked solution without counting as a miss; the problem comes back with new numbers worth half the points. Upload the `prof/` folder together with `index.html`, or those solutions won't load.
- Players who never sign in can still play: their progress stays in their browser. When they create an account, that progress moves into it.
- The free Supabase tier pauses a project after about a week without any visits. Opening the dashboard wakes it up.
