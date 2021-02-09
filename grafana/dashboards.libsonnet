{
  folderID(folder)::
    local lower = std.asciiLower(folder);
    local underscore = std.strReplace(lower, '_', '-');
    local space = std.strReplace(underscore, ' ', '-');
    space,

  local folderID(folder) = self.folderID(folder),

  // It's super common for the dashboards in a single folder to be too
  // large to fit inside a single Kubernetes ConfigMap. We can specify
  // how many ConfigMaps to use for a folder (aka how many shards).

  // add a new empty folder and set config map shard size
  addFolder(name, shards=1):: {
    folders+:: {
      [name]: {
        id: folderID(name),
        name: name,
        shards: shards,
        dashboards: {},
      },
    },
  },

  // add a new dashboard, creating the folder if necessary
  addDashboard(name, dashboard, folder='General'):: {
    local hasShards = std.objectHas(super.folders[name], 'shards'),
    folders+:: {
      [folder]+: {
        id: folderID(name),
        name: name,
        [if !hasShards then 'shards']: 1,
        dashboards+: {
          [name]+: dashboard,
        },
      },
    },
  },
  folders+:: {},
}
