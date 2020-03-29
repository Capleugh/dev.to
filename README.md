## DEV.to Daily DEV
A new way to receive daily email from your favorite articles on DEV.to
Pair Project in MOdule 4 at Turing School of Software and Design

### Introduction
We were given 10 days to understand and implement a new feature in a large, already built, working code base. We were tasked with first annotating as best we could the functionality already built into the app. We split the codebase into two sections, front end and back end, and annotated over a dozen files between the three of us, walking step by step through some of the more relevant functionality. We then shared our annotations with the team to create a better understanding of the project for everyone working on it. Next we were tasked with adding a new functionality piece, a daily email that would send out to the user after checking a box requesting it, containing a single new article each day. We were expected to have the email successfully go out on the check of a new box that was built, and design the email to be pleasant to the user. 

### Screenshot
![wireframe](https://user-images.githubusercontent.com/53594458/77856066-d5e62000-71b1-11ea-8fa9-d5ad9f9d954a.png)
![email](https://user-images.githubusercontent.com/53594458/77856081-e6969600-71b1-11ea-8d79-65d5884779d7.png)

### Project Learning Goals
1. Learn and apply strategies for understanding how to analyze a large, existing code base.
2. Apply strategies for reading and evaluating documentation.
3. Explore and implement new concepts, patterns, or libraries that have not been explicitly taught while at Turing.
4. Practice an advanced, professional git workflow.

### Access Locally
- Clone this repo with: `git@github.com:Capleugh/dev.to.git`
- Install Ruby 2.6.5
- Install Rails 5.2.4
- Run `bundle install`
- Run `rails db:setup`
- Instructions for getting your environment configured for MacOS can be found [here](https://docs.dev.to/installation/mac/).

### Technologies Used
- HTML / INLINE CSS
- Ruby / Rails
- GitHub / Git / Rebase
- React 
- NPM
- Mail Catcher
- Elastic Search

### This Project Was Created By
- Carleigh Crockett https://github.com/Capleugh
- Linda Le https://github.com/linda-le1
- Virginia Ladd https://github.com/vladd-png

### Below is the Original README from the DEV.to Team

<div align="center">
  <br>
  <img alt="DEV" src="https://thepracticaldev.s3.amazonaws.com/i/ro3538by3b2fupbs63sr.png" width="500px">
  <h1>DEV Community 👩‍💻👨‍💻</h1>
  <strong>The Human Layer of the Stack</strong>
</div>
<br>
<p align="center">
  <a href="https://www.ruby-lang.org/en/">
    <img src="https://img.shields.io/badge/Ruby-v2.6.5-green.svg" alt="ruby version">
  </a>
  <a href="http://rubyonrails.org/">
    <img src="https://img.shields.io/badge/Rails-v5.2.3-brightgreen.svg" alt="rails version">
  </a>
  <a href="https://travis-ci.com/thepracticaldev/dev.to">
    <img src="https://travis-ci.com/thepracticaldev/dev.to.svg?branch=master" alt="Travis Status for thepracticaldev/dev.to">
  </a>
  <a href="https://codeclimate.com/github/thepracticaldev/dev.to/maintainability">
    <img src="https://api.codeclimate.com/v1/badges/ce45bf63293073364bcb/maintainability" alt="Code Climate maintainability">
  </a>
  <a href="https://codeclimate.com/github/thepracticaldev/dev.to/test_coverage">
    <img src="https://api.codeclimate.com/v1/badges/ce45bf63293073364bcb/test_coverage" alt="Code Climate test coverage">
  </a>
  <a href="https://codeclimate.com/github/thepracticaldev/dev.to/trends/technical_debt">
    <img src="https://img.shields.io/codeclimate/tech-debt/thepracticaldev/dev.to" alt="Code Climate technical debt">
  </a>
  <a href="https://www.codetriage.com/thepracticaldev/dev.to">
    <img src="https://www.codetriage.com/thepracticaldev/dev.to/badges/users.svg" alt="CodeTriage badge">
  </a>
  <img src="https://badgen.net/dependabot/thepracticaldev/dev.to?icon=dependabot" alt="Dependabot Badge">
  <a href="https://gitpod.io/from-referrer/">
    <img src="https://img.shields.io/badge/setup-automated-blue?logo=gitpod" alt="GitPod badge">
  </a>
  <a href="https://app.netlify.com/sites/devto/deploys">
    <img src="https://api.netlify.com/api/v1/badges/e5dbe779-7bca-4390-80b9-6e678b4806a3/deploy-status" alt="Netlify badge">
  </a>
  <img src="https://img.shields.io/github/languages/code-size/thepracticaldev/dev.to" alt="GitHub code size in bytes">
  <img src="https://img.shields.io/github/commit-activity/w/thepracticaldev/dev.to" alt="GitHub commit activity">
  <a href="https://github.com/thepracticaldev/dev.to/issues?q=is%3Aissue+is%3Aopen+label%3A%22ready+for+dev%22">
    <img src="https://img.shields.io/github/issues/thepracticaldev/dev.to/ready for dev" alt="GitHub issues ready for dev">
  </a>
  <a href="https://app.honeybadger.io/project/Pl5JzZB5ax">
    <img src="https://img.shields.io/badge/honeybadger-active-informational" alt="Honeybadger badge">
  </a>
</p>

Welcome to the [dev.to](https://dev.to) codebase. We are so excited to have you.
With your help, we can build out DEV to be more stable and better serve our
community.

## What is dev.to?

[dev.to](https://dev.to) (or just DEV) is a platform where software developers
write articles, take part in discussions, and build their professional profiles.
We value supportive and constructive dialogue in the pursuit of great code and
career growth for all members. The ecosystem spans from beginner to advanced
developers, and all are welcome to find their place within our community. ❤️

## Table of Contents

- [What is dev.to?](#what-is-devto)
- [Table of Contents](#table-of-contents)
- [Contributing](#contributing)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation Documentation](#installation-documentation)
- [Developer Documentation](#developer-documentation)
- [Core team](#core-team)
- [Vulnerability disclosure](#vulnerability-disclosure)
- [License](#license)

## Contributing

We encourage you to contribute to dev.to! Please check out the
[Contributing to dev.to guide](CONTRIBUTING.md) for guidelines about how to
proceed.

## Getting Started

This section provides a high-level quick start guide. If you're looking for the
[installation guide](https://docs.dev.to/installation/), you'll want to refer to
our complete [Developer Documentation](https://docs.dev.to).

We run on a [Rails](https://rubyonrails.org/) backend, and we are currently
transitioning to a [Preact](https://preactjs.com/)-first frontend.

A more complete overview of our stack is available in
[our docs](https://docs.dev.to/technical-overview/).

### Prerequisites

- [Ruby](https://www.ruby-lang.org/en/): we recommend using
  [rbenv](https://github.com/rbenv/rbenv) to install the Ruby version listed on
  the badge.
- [Yarn](https://yarnpkg.com/) 1.x: please refer to their
  [installation guide](https://classic.yarnpkg.com/en/docs/install).
- [PostgreSQL](https://www.postgresql.org/) 9.4 or higher.
- [ImageMagick](https://imagemagick.org/): please refer to ImageMagick's
  [installation instructions](https://imagemagick.org/script/download.php).
- [Redis](https://redis.io/) 4 or higher.
- [Elasticsearch](https://www.elastic.co) 7 or higher.

### Installation Documentation

[View Full Installation Documentation](https://docs.dev.to/installation/).

## Developer Documentation

[Check out our dedicated docs page for more technical documentation](https://docs.dev.to).

## Core team

- [@benhalpern](https://dev.to/ben)
- [@jessleenyc](https://dev.to/jess)
- [@peterkimfrank](https://dev.to/peter)
- [@maestromac](https://dev.to/maestromac)
- [@zhao-andy](https://dev.to/andy)
- [@lightalloy](https://dev.to/lightalloy)
- [@rhymes](https://dev.to/rhymes)
- [@jacobherrington](https://dev.to/jacobherrington)
- [@mstruve](https://dev.to/molly_struve)
- [@atsmith813](https://dev.to/atsmith813)
- [@citizen428](https://dev.to/citizen428)
- [@nickytonline](https://dev.to/nickytonline)
- [@joshpuetz](http://dev.to/joshpuetz)
- [@vaidehijoshi](https://dev.to/vaidehijoshi)
- [@juliannatetreault](https://dev.to/juliannatetreault)
- [@ridhwana](https://dev.to/ridhwana)
- [@fdoxyz](https://dev.to/fdoxyz)

## Vulnerability disclosure

We welcome security research on DEV under the terms of our
[vulnerability disclosure policy](https://dev.to/security).

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version. Please see the [LICENSE](./LICENSE.md) file in our repository for
the full text.

Like many open source projects, we require that contributors provide us with a
Contributor License Agreement (CLA). By submitting code to the DEV project, you
are granting us a right to use that code under the terms of the CLA.

Our version of the CLA was adapted from the Microsoft Contributor License
Agreement, which they generously made available to the public domain under
Creative Commons CC0 1.0 Universal.

Any questions, please refer to our [license FAQ](https://docs.dev.to/licensing/)
doc or email yo@dev.to.

<br>

<p align="center">
  <img alt="Sloan, the sloth mascot" width="250px" src="https://thepracticaldev.s3.amazonaws.com/uploads/user/profile_image/31047/af153cd6-9994-4a68-83f4-8ddf3e13f0bf.jpg">
  <br>
  <strong>Happy Coding</strong> ❤️
</p>
