
# quicklist

Simple shopping/list manager UI built with React + Vite. This repository contains the frontend source, a small in-repo test suite (Robot Framework), and example test artifacts.

## Features
- React + Vite application scaffold
- Simple component-based UI in `src/`
- Robot Framework tests in `tests/` with example result artifacts in `tests/results/`
- Basic ESLint config and a development server via Vite

## Quick start

Prerequisites: Node.js (16+), npm or yarn, and Git.

Install dependencies:

```bash
npm install
```

Run the dev server:

```bash
npm run dev
```

Build for production:

```bash
npm run build
```

Run tests (Robot Framework):

```bash
# from repository root
pytest -q   # if you use pytest-based hooks, otherwise run your Robot commands
```

## Contributing
- Make a topic branch for your change: `git checkout -b feat/your-feature`
- Commit with clear messages and run linters/tests locally
- Open a pull request against `main` and describe the change

## SSH / Git setup (this repository)

I configured a remote and added an SSH key so you can push using SSH. Typical commands used locally:

```bash
git config --global user.name "renatovlima"
git config --global user.email "renatovieira.pe@gmail.com"
ssh-keygen -t ed25519 -C "renatovieira.pe@gmail.com" -f ~/.ssh/id_ed25519_quicklist
ssh-add ~/.ssh/id_ed25519_quicklist
git remote add origin git@github.com:renatovlima/quicklist.git
git push -u origin main
```

## License

Add a license file or choose a license that fits your project (e.g., MIT).

## Where to look
- Application entry: `src/main.jsx`
- Components: `src/components/`
- Tests: `tests/`

If you want I can expand this README with screenshots, deploy instructions, or CI setup — tell me what you'd like.
