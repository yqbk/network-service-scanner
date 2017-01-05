# Network Service Scanner
[![npm version](https://img.shields.io/npm/dm/localeval.svg)](  )


Web application for scanning ports and network services written in Ruby and React.

Features:
- Detect active hosts in the current network
- Scanning TCP and UDP ports using multiple methods
- Provide information about network services detected on ports
- Display interactive network map
- Get information about performed scans, like time, date and status
- Filter results based on port state


## Screenshots

### Scann few hosts on port number 22
![Form edit](/app/assets/images/screenshot1.png)

### Detect active hosts in the current network
![Submissions](/app/assets/images/screenshot2.png)

### History of previous scans
![Submissions](/app/assets/images/screenshot3.png)


## Installation

### The Composer Way (preferred)

Install the plugin via [Composer](https://getcomposer.org/)
```
composer require anttiviljami/wp-libre-form
```

Activate the plugin
```
wp plugin activate wp-libre-form




== README

1. Install gem:
$ bundle install

2. Establish the node packages (may take a few moments)
$ npm install

3. Make sure you have webpack installed globally:
$ npm install webpack -g

4. Generate react_bundle.js file for first time:
$ webpack

5a. keep webpack running in watch mode, it will recompile any changes.
$ npm start # it's a shorthand for webpack -w --config webpack/dev.config.js

5b. run webpack with hot reload config
$ npm run start-hot-dev

Porduction:
Run webpack in production mode before compiling assets using script:
$ npm run build
or manually:
$ webpack -p --config YOUR_CONFIG



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
