# PwnHub - CTF Collaboration Platform

<div align="center">

![PwnHub Logo](https://img.shields.io/badge/🔥-PwnHub-red?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJMMTMuMDkgOC4yNkwyMCA5TDEzLjA5IDE1Ljc0TDEyIDIyTDEwLjkxIDE1Ljc0TDQgOUwxMC45MSA4LjI2TDEyIDJaIiBmaWxsPSIjRkY2QjM1Ii8+Cjwvc3ZnPgo=)

[![Built with bash-stack](https://img.shields.io/badge/Built%20with-bash--stack-yellow?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://bashsta.cc)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey?style=flat-square&logo=linux)](https://www.linux.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-green?style=flat-square&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![JavaScript](https://img.shields.io/badge/JavaScript-ES6+-yellow?style=flat-square&logo=javascript)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![HTTP Server](https://img.shields.io/badge/Server-TCPServer-orange?style=flat-square)](https://cr.yp.to/ucspi-tcp.html)
[![Framework](https://img.shields.io/badge/Framework-bash--stack-yellow?style=flat-square)](https://bashsta.cc)

[![CTF Tools](https://img.shields.io/badge/CTF%20Tools-10+-red?style=flat-square&logo=hackaday)](https://github.com/your-repo)
[![Real-time](https://img.shields.io/badge/Real--time-HTMX-purple?style=flat-square&logo=htmx)](https://htmx.org/)

</div>

A collaborative Capture The Flag (CTF) platform built with bash-stack, designed for cybersecurity teams competing in CTF competitions.

---

## Features

### Authentication & Security
- Secure user registration and login with password hashing
- Session management with configurable timeouts
- User profiles with specialties and display names
- Basic brute force protection
- File upload validation

### Challenge Management
- Challenge tracking across multiple categories (Web, Pwn, Crypto, Reverse, Forensics, Misc)
- Status updates (Not Started, In Progress, Solved)
- Team collaboration with member assignment
- Shared notes per challenge
- Simple scoring system
- File upload and download for challenges

### Security Tools
Basic security tools for CTF competitions:

| Category | Tools Available |
|----------|----------------|
| **Text & Encoding** | JSON Formatter, Hash Identifier, Base Converter, URL Encoder/Decoder |
| **Cryptography** | Caesar Decoder, GCD/LCM Calculator, Prime Tools, JWT Decoder |
| **Web Security** | Timestamp Converter, JWT Token Analysis |
| **Analysis** | Pattern Detection tools |

### Wordlist Management
- Collection of common wordlists for penetration testing
- Custom wordlist uploads with metadata
- SQL injection payload collection
- Directory and subdomain enumeration lists
- Download functionality for team sharing

### Team Collaboration
- Live status tracking with periodic updates
- Shared notes per challenge
- Progress tracking and team statistics
- Specialty tracking for team members
- Real-time coordination using HTMX

---

## Installation

### Prerequisites
- Linux system (tested on Arch-based distributions)
- Bash shell (4.0+)
- TCP server: `tcpserver` (ucspi-tcp) or `netcat`
- Optional: Node.js + npm for Tailwind development

### Quick Start

```bash
# Clone the repository
git clone https://github.com/Maybe4a6f7365/PwnHub.git
cd PwnHub

# Make scripts executable
chmod +x start.sh core.sh pages/**/*.sh

# Configure (optional)
nano config.sh

# Launch PwnHub
./start.sh

# Access at http://localhost:3000
```

### Development Mode
```bash
# Enable Tailwind CSS watching
TAILWIND=true ./start.sh
```

---

## Project Structure

```
PwnHub/
├── pages/                    # Application routes & API
│   ├── index.sh             # Main interface
│   ├── api/                 # REST API endpoints
│   │   ├── challenges.sh    # Challenge management
│   │   ├── tools/           # Security tool implementations
│   │   ├── wordlists/       # Wordlist handlers
│   │   └── team.sh          # Team collaboration
│   └── uploads/             # Dynamic file serving
├── static/                  # Frontend assets
│   ├── style.css           # UI styles
│   └── script.js           # Client-side logic
├── includes/               # Shared utilities
│   ├── auth.sh            # Authentication library
│   └── icons.sh           # Icon definitions
├── data/                   # Application data
├── core.sh                # bash-stack framework
├── config.sh              # Configuration
└── LICENSE                # MIT License
```

### Security Features
- Password hashing with multiple rounds
- Input validation and sanitization
- Basic rate limiting protection
- File upload validation
- Session security with secure tokens

---

## Configuration

Key configuration options in `config.sh`:

```bash
# Basic settings
PROJECT_NAME=PwnHub
ENABLE_SESSIONS=true

# Security settings
MIN_PASSWORD_LENGTH=8
SESSION_TIMEOUT=3600
MAX_LOGIN_ATTEMPTS=5

# File upload settings  
MAX_UPLOAD_SIZE=52428800
ALLOWED_UPLOAD_EXTENSIONS="txt,py,sh,md,js,zip,tar,gz"

# Performance settings
API_RATE_LIMIT=100
```

---

## Deployment

### Docker Deployment
```bash
# Build container
docker build -t pwnhub .

# Run with port mapping
docker run -p 3000:3000 pwnhub
```

### Manual Deployment
```bash
# Install dependencies (Arch Linux)
sudo pacman -S ucspi-tcp

# Install dependencies (Debian/Ubuntu)
sudo apt-get install ucspi-tcp

# Launch server
./start.sh
```

Security Note: This is built for learning and small CTF teams, not production use. If you deploy it, use proper access controls like Cloudflare tunnels, ngrok, or VPN. Be careful about who you give access to.

---

## Development

### Adding New Security Tools
1. Create tool script in `pages/api/tools/your-tool.sh`
2. Add tool card to `pages/api/tools.sh`
3. Follow existing patterns for consistency
4. Test with various inputs

### Extending Wordlist Collections
1. Add wordlist metadata to `pages/api/wordlists.sh`
2. Implement download handler if needed
3. Include source attribution

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Built with [bash-stack](https://bashsta.cc)

---

## Contributing

Contributions are welcome. Please ensure:
- All scripts are tested and follow existing patterns
- Security practices are maintained
- Documentation is updated for new features
- Code style is consistent with the project 
