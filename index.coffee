_ = require 'lodash'
hosts = {}

module.exports = -> _.assign @,
  hostsfile_entry: (hostnames, [o]..., cb) =>
    @die "ip is required." unless o?.ip
    # remember, concatenate, and sort unique hostname assignments between calls
    hosts = {} if o.reset
    hosts[o.ip] = if o.override then [] else hosts[o.ip] or []
    hosts[o.ip] = hosts[o.ip].concat @getNames hostnames
    hosts[o.ip].sort()
    hosts[o.ip].unique()
    # remove any lines referring to the same ip; this prevents duplicates
    @execute "sed -i '/^#{o.ip}/d' /etc/hosts", sudo: true, =>
      # append ip and hostnames
      @execute "echo #{o.ip} #{hosts[o.ip].join ' '} | sudo tee -a /etc/hosts >/dev/null", @mustExit 0, cb
