# Network Service Scanner

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

---
### Detect active hosts in the current network
![Submissions](/app/assets/images/screenshot2.png)

---
### History of previous scans
![Submissions](/app/assets/images/screenshot3.png)


## Requirements

* npm version 4.0.3
* rails version 5.0
* ruby version 2.3.1


## Installation

* Install gems:
```
bundle install
```

* Setup database:
```
rake db:create db:migrate
```

* Establish the node packages (may take a few moments)
```
npm install
```

* Start rails server (need root privileges)
```
sudo rails -s 3000 
```

* Build assets
```
npm run build
```

* Open application in your web browser
```
http://localhost:3000/
```

## Roadmap

- [x] Scann open ports
- [x] Detect active services
- [x] Implement user interface
- [ ] Add more scann methods
- [ ] OS detection
- [ ] Add chartkick to compare scann performance

