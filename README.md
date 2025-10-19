# 🔐 Security Tools Container

A lightweight, fast-building Docker container packed with essential security tools for CTF challenges and penetration testing practice. Built on Debian Bookworm Slim for minimal size and maximum efficiency.

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)](https://www.debian.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

## ✨ Features

- **⚡ Lightning Fast**: Build time of only 15-20 seconds
- **📦 Minimal Size**: Based on Debian Bookworm Slim
- **🎯 CTF Ready**: Pre-configured with essential tools and wordlists
- **🔧 Custom Aliases**: Convenient shortcuts for common tasks
- **💾 Persistent Storage**: Volume mounting for your work directory
- **🖥️ CPU Only**: No GPU required (hashcat runs in CPU mode)
- **🐚 Enhanced Shell**: Zsh with custom red `[SECURITY]` prompt

## 🛠️ Included Tools

### Web Fuzzers
- **ffuf** - Fast web fuzzer written in Go
- **gobuster** - Directory/file & DNS busting tool
- **dirb** - Web content scanner
- **wfuzz** - Web application fuzzer

### Password Crackers
- **John the Ripper** - Password cracking tool
- **hashcat** - Advanced password recovery (CPU mode)

### Development Tools
- **Python 3** - With pip for scripting
- **Go** - For building custom tools
- **git, curl, wget** - Essential utilities
- **nano** - Text editor

### Custom Wordlists
Located in `/usr/share/wordlists/`:
- `web-common.txt` - 50+ common web directories and files
- `passwords.txt` - 40+ common passwords
- `rockyou.txt` - Symlink to passwords.txt
- `common.txt` - Symlink to web-common.txt

## 📥 Installation

### Quick Install (Recommended)

1. Clone this repository:
```bash
git clone https://github.com/absalem42/tool.git
cd tool
```

2. Run the install script:
```bash
chmod +x install
./install
```

The install script will:
- Check for Docker installation
- Start Docker if not running
- Build the security-tools image
- Optionally add scripts to your PATH

### Manual Install

If you prefer manual setup:

```bash
# Make scripts executable
chmod +x build start stop run bgnd install

# Build the Docker image
./build
```

## 🚀 Quick Start

### Starting the Container

Navigate to your work directory and start the container:

```bash
cd /path/to/your/work
./start
```

This starts an interactive shell with your current directory mounted at `/home/security/work`.

### Running in Background

To run the container in the background:

```bash
./bgnd
```

### Executing Commands

Execute commands in a running container:

```bash
./run <command>
```

### Stopping the Container

```bash
./stop
```

## 📖 Usage Examples

### Web Fuzzing with ffuf

**Basic directory fuzzing:**
```bash
ffuf -u http://target.com/FUZZ -w /usr/share/wordlists/web-common.txt
```

**Fuzzing with extensions:**
```bash
ffuf -u http://target.com/FUZZ -w /usr/share/wordlists/web-common.txt -e .php,.html,.txt
```

**POST data fuzzing:**
```bash
ffuf -u http://target.com/login -X POST -d "username=admin&password=FUZZ" -w /usr/share/wordlists/passwords.txt
```

**Using the fuzz alias (colored output):**
```bash
fuzz -u http://target.com/FUZZ -w /usr/share/wordlists/web-common.txt
```

### Directory Busting with gobuster

**Basic directory enumeration:**
```bash
gobuster dir -u http://target.com -w /usr/share/wordlists/web-common.txt
```

**With specific extensions:**
```bash
gobuster dir -u http://target.com -w /usr/share/wordlists/web-common.txt -x php,html,txt
```

**DNS subdomain enumeration:**
```bash
gobuster dns -d target.com -w /usr/share/wordlists/web-common.txt
```

**With threads for faster scanning:**
```bash
gobuster dir -u http://target.com -w /usr/share/wordlists/web-common.txt -t 50
```

### Web Fuzzing with wfuzz

**Basic fuzzing:**
```bash
wfuzz -w /usr/share/wordlists/web-common.txt http://target.com/FUZZ
```

**Filter by status code:**
```bash
wfuzz -w /usr/share/wordlists/web-common.txt --hc 404 http://target.com/FUZZ
```

**POST parameter fuzzing:**
```bash
wfuzz -w /usr/share/wordlists/passwords.txt -d "username=admin&password=FUZZ" http://target.com/login
```

### Password Cracking with John the Ripper

**Crack a password hash:**
```bash
john --wordlist=/usr/share/wordlists/passwords.txt hash.txt
```

**Crack with specific format:**
```bash
john --format=raw-md5 --wordlist=/usr/share/wordlists/passwords.txt hash.txt
```

**Show cracked passwords:**
```bash
john --show hash.txt
```

**Crack with rules:**
```bash
john --wordlist=/usr/share/wordlists/passwords.txt --rules hash.txt
```

### Password Cracking with hashcat

**Basic MD5 cracking:**
```bash
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/passwords.txt --force
```

**SHA256 cracking:**
```bash
hashcat -m 1400 -a 0 hash.txt /usr/share/wordlists/rockyou.txt --force
```

**NTLM hash cracking:**
```bash
hashcat -m 1000 -a 0 hash.txt /usr/share/wordlists/passwords.txt --force
```

**Show cracked hashes:**
```bash
hashcat -m 0 hash.txt --show
```

**Common hash modes:**
- `-m 0` - MD5
- `-m 100` - SHA1
- `-m 1000` - NTLM
- `-m 1400` - SHA256
- `-m 1800` - sha512crypt (Unix)
- `-m 3200` - bcrypt

## 📝 Adding Custom Wordlists

### Method 1: Copy Files to Container

While the container is running:

```bash
# From your host machine
docker cp /path/to/your/wordlist.txt security-tools:/usr/share/wordlists/custom.txt
```

### Method 2: Mount a Wordlist Directory

Modify the start script or run with custom mount:

```bash
docker run -it --name security-tools --rm \
  -v "$PWD:/home/security/work" \
  -v "/path/to/wordlists:/usr/share/custom-wordlists" \
  security-tools "/bin/zsh"
```

### Method 3: Add to Dockerfile

Edit the Dockerfile and add your wordlist during build:

```dockerfile
COPY my-wordlist.txt /usr/share/wordlists/my-wordlist.txt
```

Then rebuild:
```bash
./build
```

### Method 4: Download During Runtime

From inside the container:

```bash
cd /usr/share/wordlists
wget https://example.com/wordlist.txt
```

## 🔧 Common Commands

### Container Management

```bash
# Build the container
./build

# Start interactive shell
./start

# Run in background
./bgnd

# Execute command in running container
./run ls -la

# Stop and remove container
./stop
```

### Built-in Aliases

The container includes these helpful aliases:

```bash
ll        # ls -lah - Detailed file listing
fuzz      # ffuf -c - Colored ffuf output
```

### Wordlist Locations

```bash
# List available wordlists
ls -lh /usr/share/wordlists/

# View wordlist contents
cat /usr/share/wordlists/web-common.txt
head -20 /usr/share/wordlists/passwords.txt
```

### Working with Files

Your host's current directory is mounted at `/home/security/work`:

```bash
# From inside container
cd /home/security/work

# Save output to your host
ffuf -u http://target.com/FUZZ -w /usr/share/wordlists/web-common.txt -o scan-results.txt

# Files saved here persist on your host machine
```

## 🐛 Troubleshooting

### Docker Not Running

**Issue:** `Cannot connect to the Docker daemon`

**Solution:**
```bash
# On macOS
open -a Docker

# On Linux
sudo systemctl start docker

# Verify Docker is running
docker ps
```

### Container Won't Start

**Issue:** Container name already in use

**Solution:**
```bash
# Stop and remove existing container
./stop

# Or manually
docker stop security-tools
docker rm security-tools
```

### Permission Denied on Scripts

**Issue:** `Permission denied` when running scripts

**Solution:**
```bash
chmod +x build start stop run bgnd install
```

### hashcat: No devices found

**Issue:** hashcat shows no devices

**Solution:** This is expected! The container runs hashcat in CPU mode only (with `--force` flag). No GPU is required or configured.

```bash
# Always use --force flag with hashcat
hashcat -m 0 -a 0 hash.txt wordlist.txt --force
```

### Container Runs Out of Space

**Issue:** Not enough disk space

**Solution:**
```bash
# Clean up Docker images and containers
docker system prune -a

# Remove unused volumes
docker volume prune
```

### Cannot Find Wordlists

**Issue:** Wordlist not found error

**Solution:**
```bash
# Verify wordlist location inside container
ls -la /usr/share/wordlists/

# If empty, rebuild the container
./build
```

### Changes Don't Persist

**Issue:** Files disappear after stopping container

**Solution:** Save all work in `/home/security/work` which is mounted from your host:

```bash
cd /home/security/work
# Save your files here
```

## 🏗️ Building from Source

The Dockerfile builds the container with these steps:

1. **Base Image**: Debian Bookworm Slim
2. **System Tools**: git, curl, wget, python3, golang, nano, zsh
3. **Security Tools**: john, hashcat, dirb
4. **Binary Tools**: ffuf, gobuster (downloaded from GitHub releases)
5. **Python Tools**: wfuzz (via pip)
6. **Wordlists**: Custom minimal wordlists for quick testing
7. **Shell Config**: Zsh with custom prompt and aliases

Build time: ~15-20 seconds (after Docker layer caching)

## 📜 Scripts Reference

| Script | Purpose |
|--------|---------|
| `build` | Builds the Docker image with tag `security-tools` |
| `start` | Starts an interactive container with current directory mounted |
| `stop` | Stops and removes the security-tools container |
| `run` | Executes a command inside the running container |
| `bgnd` | Runs the container in background/detached mode |
| `install` | Complete setup: makes scripts executable, builds image, optionally adds to PATH |

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Report bugs or issues
- Suggest new tools or features
- Submit pull requests
- Improve documentation

## 📄 License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## ⚠️ Disclaimer

This tool is intended for legal security testing and educational purposes only. Users are responsible for complying with applicable laws and regulations. The authors are not responsible for any misuse or damage caused by this tool.

## 🌟 Support

If you find this project useful, please give it a ⭐️ on GitHub!

---

**Happy Hacking! 🔓**