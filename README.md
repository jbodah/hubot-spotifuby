# hubot-spotifuby

[![npm version](https://badge.fury.io/js/hubot-spotifuby.svg)](http://badge.fury.io/js/hubot-spotifuby)

hubot/spotifuby integration

## Description

[hubot](https://github.com/github/hubot) plug-in for talking to a [spotifuby](https://github.com/jbodah/spotifuby) server.
Spotifuby is a web server for communicating with a Spotify process ([more_detail](https://github.com/jbodah/spotifuby))

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

See [`src/spotifuby.coffee`](src/spotifuby.coffee) for full documentation.

## Releasing

```
grunt release
```
