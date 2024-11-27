# Incul-manager

## Overview

Incul-manager is a project aimed at replicating some functionalities of Qubes OS using Incus containers and XPRA for seamless application access through ssh.

## Disclaimer

This project is a hobbyist endeavor and not developed by a security expert. It does not guarantee the same level of security as Qubes OS, which is renowned for it's stringent security practices. It is also currently incomplete and should be run in a virtual machine for testing only.

## Requirements

- Debian 12 (Bookworm) 
- XFCE4/KDE/GNOME desktop environment

## Installation

   ```
   curl -s https://raw.githubusercontent.com/AlessandroMIlani/incul-manager/refs/heads/personal-main/install.sh | bash
   ```

## Getting Started

1. **Create Template**: Create a Debian-based Incus system container template:
   ```
   incul-manager create-template
   ```
   This template includes essential applications like Thunar, XFCE4-terminal, and more.

2. **Manage Containers**: Create and manage containers using commands like:
   - `incul-manager create <container-name>` to create new containers.
   - `incul-manager list` to list all created containers.
   - `incul-manager delete <container-name>` to remove containers when no longer needed.

3. **Application Integration**: Sync container applications to the host menu with:
   ```
   incul-manager sync
   ```
   This integrates container applications seamlessly into your desktop environment.

4. **Running Applications**: Launch applications within containers directly from the updated host menu. 

5. **Additional Features**: Utilize XPRA for managing X11 applications remotely, clipboard sharing, and file uploads to containers.

## Architecture

Incul-manager utilizes Incus containers, developed as an alternative to LXD, and XPRA for remote application access. 

## Limitations

- Not as secure as Qubes OS due to different underlying technologies specifically containers.
- Developed as a personal hobby project, hence may lack robustness or comprehensive security features.


## Feedback and Contributions

- This project is open to contributions and feedback.
