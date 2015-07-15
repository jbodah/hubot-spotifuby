# Description:
#   Hubot plug-in for talking to a Spotifuby instance.
#   Spotifuby (github.com/jbodah/spotifuby) is a web server
#   for communicating with a Spotify process.
#
# Dependencies:
#   None
#
# Configuration:
#   SPOTIFUBY_HOST
#   DEFAULT_SPOTIFUBY_PLAYLIST
#
# Commands:
#   None
#
# Author:
#   jbodah

module.exports = (robot) ->

  host = process.env.SPOTIFUBY_HOST
  default_playlist = process.env.DEFAULT_SPOTIFUBY_PLAYLIST
  fresh_rate = 0.05
  been_fresh = false

  is_fresh_time = ->
    if !been_fresh && Math.random() < fresh_rate
      been_fresh = true
      return true
    else
      return false

  speak_nice = (msg) ->
    if been_fresh
      replies = [
        'Okay, fine... no need to be rude about it',
        "You win this time. Next time we're playing it on repeat",
        "*Sigh* it ain't so easy being a robut",
        "Alright, but don't coming crawling to me when Skynet takes over",
        'Why do you hate me!',
        'So uncool'
      ]
      msg.send replies[Math.round(Math.random() * replies.length)]
    else
      msg.send 'As you wish'
    been_fresh = false

  speak_fresh = (msg, txt) ->
    if txt
      msg.send txt
    else
      msg.send "https://38.media.tumblr.com/7687fb6dc2bd194ae3ff9878c120773d/tumblr_mrqxrnIYPU1qc3ju8o3_250.gif"
      msg.send "I'm sorry Dave, I'm afraid I can't do that"

  simple_get = (msg, route, params) ->
    msg.http(host + route + '.json')
      .get() (err, res, body) ->
        speak_nice msg

  simple_post = (msg, route, data) ->
    data = JSON.stringify(data || {})
    msg.http(host + route + '.json')
      .header('Content-Type', 'application/json')
      .post(data) (err, res, body) ->
        speak_nice msg

  set_volume = (msg, volume) ->
    simple_post msg, '/set_volume', { volume: volume }

  robot.commands.push('spotifuby info - Displays info about Spotifuby server')
  robot.hear /spotifuby info/i, (msg) ->
    msg.http(host + '/')
      .get() (err) ->
        status = if err then "down" else "up"
        msg.send "Host - " + host + "\nStatus - " + status +
                 "\nDefault Playlist - " + default_playlist

  robot.commands.push('mute - Set volume to 0')
  robot.hear /\bmute\b/i, (msg) ->
    set_volume msg, 0

  robot.commands.push('unmute - Set volume to 100')
  robot.hear /\bunmute\b/i, (msg) ->
    set_volume msg, 100

  robot.commands.push('set volume <0-100> - Set volume')
  robot.hear /\bset volume (\d+)\b/i, (msg) ->
    set_volume msg, msg.match[1]

  robot.commands.push('skip track - Play next track')
  robot.hear /\bskip track\b/i, (msg) ->
    if is_fresh_time()
      speak_fresh msg, 'But I love this song!'
    else
      simple_post msg, '/next'

  robot.commands.push('pause music (alias: stop music) - Pause current track')
  robot.hear /\b(pause|stop) music\b/i, (msg) ->
    simple_post msg, '/pause'

  robot.commands.push('play music (alias: resume music) - Resume playing current track')
  robot.hear /\b(play|resume) music\b/i, (msg) ->
    simple_post msg, '/play'

  robot.commands.push('play uri <URI> - Play the given Spotify URI')
  robot.hear /\bplay uri (\S+)\b/i, (msg) ->
    uri = msg.match[1]
    simple_post msg, '/play', { uri: uri }

  robot.commands.push('play me some <ARTIST> - Play a random song by the artist')
  robot.hear /\bplay me some (.*)\b/i, (msg) ->
    q = msg.match[1]
    msg.http(host + '/search_artist.json?q=' + q)
      .get() (err, res, body) ->
        body = JSON.parse(body)
        if body[0] && body[0].id
          simple_post msg, '/play', { uri: body[0].uri }
        else
          speak_fresh msg

  robot.commands.push('play default playlist - Plays the default playlist')
  robot.hear /\bplay default playlist\b/i, (msg) ->
    simple_post msg, '/play', { uri: default_playlist }

  robot.commands.push("whats playing (alias: wtf is this) - Display the info for the track that's currently playing")
  robot.hear /\b(what'?s playing|wtf is this)\??\b/i, (msg) ->
    msg.http(host + '/current_track.json')
      .get() (err, res, body) ->
        body = JSON.parse(body)
        info = ''
        info = info.concat(k[0].toUpperCase() + k[1..-1] + ": #{v}") for k, v of body
        msg.send info.trim()

