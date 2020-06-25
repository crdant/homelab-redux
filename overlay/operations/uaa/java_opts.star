def update_java_opts(java_opts):
  opts = []
  for param in java_opts.split():
    if param.startswith("-Dspring_profiles"):
      opts.append("{},ldap".format(param))
    else:
      opts.append(param)
    end
  end
  return " ".join(opts)
end
