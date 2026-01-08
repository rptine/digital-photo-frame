# 📸 Raspberry Pi Digital Photo Frame (iCloud Sync)

This project turns a Raspberry Pi and any HDMI monitor into a **cloud-based digital photo frame** that automatically displays photos from an **Apple iCloud Shared Album**.

It is designed to be:
- Headless-friendly (SSH-based setup)
- Reproducible from a fresh SD card
- Resilient (auto-starts on boot using systemd)

---

## 🧠 What This Project Does

- Downloads photos from a single **iCloud Shared Album**
- Stores them locally on the Pi
- Displays them in a fullscreen slideshow
- Automatically syncs new photos on a schedule
- Automatically resumes after reboot

---

## 🧰 Requirements

### Hardware
- Raspberry Pi **3 B+ or newer**
- 16–32GB micro-SD card  
  **Recommended:** SanDisk or Samsung (cheap cards often fail)
- HDMI monitor
- Power supply (Pi 3: 5V / 2.5A)

### Software / Accounts
- **Raspberry Pi OS (32-bit, Desktop)**  
  ⚠️ Do NOT use 64-bit or Lite on Pi 3
- Apple ID with an **iCloud Shared Album**
- Wi-Fi network

---

## 📂 Repository Structure

```text
digital-photo-frame/
├── README.md
├── config.env.example
├── setup.sh
├── scripts/
│   ├── install_on_pi.sh
│   ├── icloud_sync.sh
│   └── slideshow.sh
└── systemd/
    ├── icloud-sync.service
    └── slideshow.service
```
## 🚀 Full Setup Guide (Start to Finish)

---

### 1️⃣ Flash Raspberry Pi OS (Critical Step)

Use **Raspberry Pi Imager** and configure **before writing**.

**Select:**
- **Device:** Raspberry Pi 3
- **OS:** Raspberry Pi OS (32-bit)
- **Storage:** Your SD card

#### ⚙️ Advanced Options (REQUIRED)

Enable **ALL** of the following:

- ✔ Enable SSH (password auth)
- ✔ Set hostname: `digital-photo-frame`
- ✔ Set username/password (user assumed: `pi`)
- ✔ Configure Wi-Fi (SSID + password)
- ✔ Wi-Fi country = `US`
- ✔ Skip first-run wizard

Write the image and wait for **“Write successful”**.

⚠️ **If you later see `(initramfs)` on boot, the SD card flash failed.**

---

### 2️⃣ Boot the Pi

- Insert SD card
- Plug in power
- Connect HDMI monitor

You should see Raspberry Pi OS boot normally.  
If it drops to `(initramfs)`, **reflash the SD card**.

---

### 3️⃣ SSH Into the Pi

From your Mac/Linux machine:
```bash
ssh pi@digital-photo-frame.local
```

If `.local` does not resolve, find the IP:

    arp -a
    ssh pi@<PI_IP_ADDRESS>

If SSH does not connect, possible causes:

- SSH was not enabled in Imager
- The Pi did not finish booting
- The SD card is bad

---

## 4️⃣ Install Git & Clone the Repo

    sudo apt update
    sudo apt install -y git
    cd ~
    git clone https://github.com/rptine/digital-photo-frame.git
    cd digital-photo-frame

---

## 5️⃣ Create Configuration File

    cp config.env.example config.env
    nano config.env

Edit at minimum:

    ICLOUD_USERNAME="your_apple_id@example.com"
    ALBUM_NAME="Frame"

Save and exit:

- CTRL + O → Enter
- CTRL + X

---

## 6️⃣ Run the Setup Script

    chmod +x setup.sh
    ./setup.sh

This will:

- Install dependencies (`feh`, `python3-pip`, `icloudpd`)
- Create the photo directory
- Install and enable systemd services

---

## 7️⃣ One-Time iCloud Authentication (Required)

Apple requires manual 2FA once.

    icloudpd --username "your_apple_id@example.com" \
             --directory /home/pi/Pictures/frame \
             --auth-only

You will be prompted for:

- Apple ID password
- 2FA code

After this, the Pi syncs automatically.

---

## 8️⃣ Start the Services

    sudo systemctl start icloud-sync.service
    sudo systemctl start slideshow.service

Verify:

    sudo systemctl status icloud-sync.service
    sudo systemctl status slideshow.service

Both services are enabled to start automatically on reboot.

---

## 🔄 How the System Works

### iCloud Sync

- Managed by `icloud-sync.service`
- Runs `scripts/icloud_sync.sh`
- Uses `icloudpd`
- Syncs the configured Shared Album on a schedule

### Slideshow

- Managed by `slideshow.service`
- Runs `scripts/slideshow.sh`
- Uses `feh` to display a fullscreen slideshow

Photos live at:

    /home/pi/Pictures/frame

---

## ⚙️ Configuration Reference

### config.env.example

    PI_USER=pi
    HOSTNAME=digital-photo-frame
    ICLOUD_USERNAME="your_apple_id@example.com"
    ALBUM_NAME="Frame"
    FRAME_DIR="/home/pi/Pictures/frame"
    SYNC_INTERVAL_SECONDS=3600
    ICLOUDPD_BIN="/usr/local/bin/icloudpd"

After editing config, restart services:

    sudo systemctl restart icloud-sync.service
    sudo systemctl restart slideshow.service

---

## 🧪 Testing

Add a photo to the Shared Album.

Restart sync:

    sudo systemctl restart icloud-sync.service

Confirm download:

    ls /home/pi/Pictures/frame

Watch it appear on the display.

---

## 🛠 Troubleshooting

### `(initramfs)` on boot

- Root filesystem missing
- SD card flash failed
- Reflash with Raspberry Pi OS (32-bit)
- Replace SD card if it persists

### SSH not working

- SSH not enabled in Imager
- Pi not connected to Wi-Fi
- Use IP instead of hostname

### Slideshow not visible

- Ensure Desktop OS (not Lite)
- Check logs:

    journalctl -u slideshow.service -n 50

---

## 💡 Future Enhancements

- Time/date overlay
- Weather overlay
- Portrait-aware cropping
- Fade transitions
- Video / Live Photo support
- Web UI for configuration

---

## 📄 License

MIT License


