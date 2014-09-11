noflo = require 'noflo'
child = require 'child_process'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in', (event, payload) ->
    return unless event is 'data'
    filename = payload || 'default.jpeg'

    cmd = "fswebcam --jpeg 90 --greyscale --save #{filename}"
    console.log cmd
    child.exec cmd, {}, (err, stdout, stderr) ->
      console.log err, stdout, stderr if err

      c.outPorts.out.send filename      

  c.outPorts.add 'out'
  c
