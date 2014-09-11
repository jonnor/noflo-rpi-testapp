noflo = require 'noflo'
gpio = require 'rpi-gpio'

# Hack, periodic polling.
# Following changes does not work for me on Arch,
# probably because interrupt support requires kernel patch
listenChange = (c, pin, callback) ->
  readPin = () ->
    gpio.read pin, (err, value) ->
      console.log err if err

      if c.lastValue == null or value != c.lastValue
        c.lastValue = value
        return callback null, value

  setInterval readPin, 100

exports.getComponent = ->
  c = new noflo.Component
  c.lastValue = null
  c.inPorts.add 'pin', (event, payload) ->
    return unless event is 'data'
    pin = payload

    gpio.setup pin, gpio.DIR_IN, (err) ->
      console.log err if err
      listenChange c, pin, (err, value) ->
        c.outPorts.out.send value

  c.outPorts.add 'out'
  c
