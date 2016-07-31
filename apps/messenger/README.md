# Messenger

Provides messaging services to the platform.

Right now, `Messenger` is a dummy, stateless service that just stores the messages in the filesystem.

In the future this could be extended to support:

- SMS
- rate-limiting 
- bouncing
- idempotence
- failure handling using e.g. retrying with backoff, circuit breakers, fallback providers
- analytics

See [`Messenger`](lib/messenger.ex) for docs.
