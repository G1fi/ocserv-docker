# 🛡️ ocserv-docker

A containerized version of [ocserv (OpenConnect VPN server)](http://www.infradead.org/ocserv/), built from source for security, flexibility, and minimal overhead.  
This project provides an easy-to-deploy VPN server with support for port forwarding and basic NAT out of the box.

---

## ✨ Features

- ✅ Lightweight image built from **Debian slim**
- 🔒 Compiles latest **ocserv v1.3.0** from source
- 🌐 Supports dynamic **TCP/UDP port forwarding** to VPN clients
- ⚙️ Includes a **default `ocserv.conf`** for quick setup
- 🐳 Fully containerized via **Docker & Compose**
- 📜 Licensed under **GPLv3**

---

## 📁 Project Structure

```plain
ocserv-docker/
├── config/                # Contains ocserv.conf (default server config)
│   └── ocserv.conf
├── docker-compose.yml     # Compose setup for the container
├── Dockerfile             # Builds ocserv from source
├── entrypoint.sh          # Entrypoint script (port forwarding + server start)
├── LICENSE                # GNU GPLv3 license
└── README                 # Project documentation
````

---

## 📦 Installation

### 1. Install Docker

```bash
apt-get update && apt-get upgrade -y
curl -sSL https://get.docker.com | sh
````

### 2. Clone the Repository

```bash
git clone https://github.com/gifi71/ocserv-docker.git /opt/ocserv-docker
cd /opt/ocserv-docker
```

### 3. Optimize Host Networking (optional)

Edit `/etc/sysctl.conf`:

```conf
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```

Apply changes:

```bash
sysctl -p
```

---

## ⚙️ Configuration

### 4. Edit ocserv Configuration

The default config is located at:

```plain
config/ocserv.conf
```

Customize it to fit your network and authentication setup.

### 5. Edit `.env` (optional, all values can be commented out)

To forward specific ports from the container to VPN clients, define the `PORTS` environment variable.

**Format:**

```env
PORTS="<host_port>:<client_ip>:<client_port> ..."
```

**Example:**

```env
PORTS="80:10.10.0.2:80 443:10.10.0.2:443 25565:10.10.0.3:25565"
```

This will forward traffic on ports `80`, `443`, and `25565` from the host to the specified VPN clients.

### 6. Edit `docker-compose.yml` (optional)

Adjust ports, volumes, or container settings if needed.

---

## 🚀 Running the Container

Start the VPN server:

```bash
docker compose up -d
```

View container logs:

```bash
docker compose logs -f ocserv
```

---

## 🧱 TODO

- [ ] Publish image to Docker Hub
- [ ] Implement a multi-stage Docker build to reduce image size

---

## 📜 License

This project includes `ocserv`, licensed under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.html). All derivative works must also be distributed under GPLv3.
