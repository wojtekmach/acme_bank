# Auth

Authentication system for the platform.

Right now, `Auth` just handles a simple email/password combination.

In the future this could be extended to support:

- different authentication strategies, e.g.: username+password for customers, LDAP for operators, OAuth for partners
- 2FA
- tracking sign in count
- tracking sign in attempts and locking down
- tracking IP
- tracking sign ins from multiple devices
- showing active sessions across devices (using Phoenix Presence)
