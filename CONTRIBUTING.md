# Contributing guidelines

## Introduction

The following document describes the contribution process adopted by this project.

## Development

- All development should come in the form of a Pull Request (PR in short).
- PRs SHOULD be monothematic (one bugfix, one feature, etc...).
- PRs SHOULD have at least one reviewer other than the creator.
- PRs SHOULD only be merged into `main` once the review process is completed.
- PRs MUST follow the PR template.
- PRs that are subject to changes SHOULD be created as drafts.

## Creating a PR

- Fork the [main repository](https://github.com/RickWillcox/butter).
- Clone the fork on your machine.
- Create a new branch from `main`, use a meaningful name or the number of the issue, eg. `git cheackout -b feat/in-game-menu`, this both crates a new branch named `feat/in-game-menu` and switches the current active branch to it.
- Make your changes. Try to create single-scoped commit with meaningful messages, the use of [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) is encouraged but optional.
- Push your changes to the remote branch, eg. `git push --set-upstream origin feat/in-game-menu`
- Go to the [main repository](https://github.com/RickWillcox/butter) and create a PR, assigning at least one reviewer.
