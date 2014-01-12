global.hostsfile_entry = (ip, [o]..., cb) ->
  throw 'hostname is required' unless o?.hostname
  # remove any lines beginning with the same ip
  execute "sudo sed -i '/#{ip}/d' /etc/hosts", ->
    # append ip and hostname
    execute "echo #{ip} #{o.hostname} | sudo tee -a /etc/hosts", cb
