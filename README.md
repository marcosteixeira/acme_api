# Acme Corp API Service

A Ruby on Rails application providing an API service for fetching information about Acme Corp and its products. This repository contains solutions to various tasks and challenges related to improving the API service.

## Table of Contents

- [Description](#description)
- [Installation](#installation)
- [Tests](#tests)
- [Coverage](#coverage)
- [Rubocop](#rubocop)
- [Tasks](#tasks)
- [Contact](#contact)

## Description

The Acme Corp API service offers registered users access to a wide range of information about the company and its products. The repository contains solutions to tasks aiming to enhance the API's performance, resolve quota-related issues, and improve code quality.

## Installation

### Prerequisites

- Ruby (version 3.1.2)
- Ruby on Rails (version 7.0.8)
- PostgreSQL

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/acme-corp-api.git
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:create db:migrate
   ```

## Tests

Run RSpec tests to ensure functionality and reliability:

```bash
bundle exec rspec
```

```bash
bundle exec rspec -f d

ApplicationController
  #user_quota
    creates the hit
    creates the hit with an endpoint
    increases the hits count
    does not render an error
    when user is over quota
      renders an error

User
  #timezone
    validates inclusion of timezone
    allows blank timezone
    allows valid timezone
  #count_hits
    counts hits for the current month
    when user has no timezone
      counts only the hits current month
    when user has a timezone
      counts only the hits current month in the user timezone
      when the hits are created after the end of the month in UTC
        when its the end of the month in the user timezone
          counts the hits of the current month in the user timezone
        when its the beginning of the month in the user timezone
          counts the hits current month in the user timezone
```

## Coverage

Open the coverage report after running RSpec

```bash
open coverage/index.html
```

## Coverage

Run Rubocop to enforce Acme code format guidelines

```bash
bundle exec rubocop
```

## Tasks

- [Task 1](https://github.com/marcosteixeira/acme_api/pull/1)
- [Task 2](https://github.com/marcosteixeira/acme_api/pull/2)
- [Task 3](https://github.com/marcosteixeira/acme_api/pull/3)
- [Task 4](https://github.com/marcosteixeira/acme_api/pull/4)

## Contact

For any questions, reach out to [m.viniteixeira@gmail.com](mailto:m.viniteixeira@gmail.com).
