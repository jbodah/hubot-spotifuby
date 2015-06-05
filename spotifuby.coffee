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
#
# Commands:
#   None
#
# Author:
#   jbodah

module.exports = (robot) ->

  host = process.env.SPOTIFUBY_HOST

  commands = [
    {
      regexp: 'mute',
      doc:    'mute - Set volume to 0',
      route:  '/set_volume?to=0'
    },
    {
      regexp: 'unmute',
      doc:    'unmute - Set volume to 100',
      route:  '/set_volume?to=100'
    },
    {
      regexp: 'skip track',
      doc:    'skip track - Play next track',
      route:  '/next'
    },
    {
      regexp: '(play|resume) music',
      doc:    'play music (alias: resume music) - Resume playing current track'
      route:  '/play'
    },
    {
      regexp: '(pause|stop) music',
      doc:    'pause music (alias: stop music) - Pause current track',
      route:  '/pause'
    },
    {
      regexp: "what'?s playing\??",
      doc:    "whats playing - Display the info for the track that's currently playing",
      route:  '/current_track.json',
      filter: (msg, err, res, body) ->
        body = JSON.parse(body)
        info = ''
        info = info.concat(k[0].toUpperCase() + k[1..-1] + ": #{v}") for k, v of body
        msg.send info.trim()
    }
  ]

  for command in commands
    do (command) ->
      robot.commands.push(command.doc)
      robot.hear new RegExp("#{command.regexp}$", 'i'), (msg) ->
        msg.http(host + command.route)
          .get() (err, res, body) ->
            if command.filter
              command.filter(msg, err, res, body)
            else
              msg.send 'As you wish'
