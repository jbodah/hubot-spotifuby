# hubot-spotifuby

[![npm version](https://badge.fury.io/js/hubot-spotifuby.svg)](http://badge.fury.io/js/hubot-spotifuby)

hubot/spotifuby integration

[What is Spotifuby?](https://github.com/jbodah/spotifuby)

See [`src/spotifuby.coffee`](src/spotifuby.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-spotifuby --save`

Then add **hubot-spotifuby** to your `external-scripts.json`:

```json
["hubot-spotifuby"]
```

You'll also need to setup the `SPOTIFUBY_HOST` environment variable.

## Sample Interaction

```
user1>> play music
hubot>> As you wish
```

## Releasing

```
grunt release
```
