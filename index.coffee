hosts = {}

module.exports = ->
  @hostsfile_entry = (hostnames, [o]...) => @inject_flow =>
    @die("ip is required.")() unless o?.ip # immediate death
    # remember, concatenate, and sort unique hostname assignments between calls
    hosts = {} if o.reset
    hosts[o.ip] = if o.override then [] else hosts[o.ip] or []
    hosts[o.ip] = hosts[o.ip].concat @getNames hostnames
    hosts[o.ip].sort()
    hosts[o.ip].unique()
    # remove any lines referring to the same ip; this prevents duplicates
    @then @execute "sed -i '/^#{o.ip}/d' /etc/hosts", sudo: true
    # append ip and hostnames
    @then @execute "echo #{o.ip} #{hosts[o.ip].join ' '} | sudo tee -a /etc/hosts >/dev/null", expect: 0
