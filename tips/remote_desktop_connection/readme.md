# Opening a RDP connection to the Linux local instance

> [https://www.nextofwindows.com/how-to-enable-wsl2-ubuntu-gui-and-use-rdp-to-remote](https://www.nextofwindows.com/how-to-enable-wsl2-ubuntu-gui-and-use-rdp-to-remote)

When WSLg is enabled, it's possible to access to the graphical user interface of your Linux distribution (in my case, it's Ubuntu).

If you don't have `xrdp` yet, you can install it by running:

```bash
sudo apt update && sudo apt-get install -y xrdp
```

If you wish to use another port than `3390`, please run:

```bash
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
```

(see [https://www.nextofwindows.com/how-to-enable-wsl2-ubuntu-gui-and-use-rdp-to-remote](https://www.nextofwindows.com/how-to-enable-wsl2-ubuntu-gui-and-use-rdp-to-remote) for more in-depth information)

When done, run `sudo service xrdp start` to start the service.

![Start the RDP connection](./images/rdp_localhost.png)

> ℹ️ **IMPORTANT NOTICE**
> The connection is only possible when `xrdp` is started. So, if it didn't work, you kwow what to do (you can also run `sudo service xrdp status` to get detailed information's).

![Authentication screen](./images/authentication.png)

Use your local Linux user and make a connection.

![Desktop screen](./images/desktop.png)

When you don't need RDP anymore, free some resources by running `sudo service xrdp stop`.

