# supabase-username-login

This repo demonstrates how you can allow users to sign up to your site using either:

- email address and password
- username and password

### Demo
[Live Demo App](https://supabase-username-login.vercel.app/)

There are many reasons why you **SHOULD NOT DO THIS**.  However, it is possible.

### Why not do this?

- users will not be able to recover their account if they forget the password
- your site will become filled with a bunch of anonymous randos
- ==fill in whatever potential security issues you can dream up here==

### Why am I still here?

Even though this is something you'll never implement (because you always follow the advice written in the README.md file of a public GitHub repo) there's plenty to learn here, including:

- how flexible the Supabase Auth system is
- how to use a trigger to update an `auth.users` object during the signup process
- hey, what's this SvelteKit all about?
- basic auth flows

### Getting Started

clone the repo
`git clone git@github.com:burggraf/supabase-username-login.git`

install the modules using a package manager
- bun (my new favorite) `bun install`
- pnpm (faster than npm) `pnpm install`
- npm (old skool kool) `npm install`

run the dev server
`npm run dev -- --open`


