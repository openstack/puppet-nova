type Nova::SshKey = Struct[
  {
    key  => String[1],
    type => Enum['ssh-rsa', 'ssh-dsa', 'ssh-ecdsa', 'ssh-ed25519']
  }
]
