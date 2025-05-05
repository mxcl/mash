#!/usr/bin/env -S pkgx --quiet deno^2 run --ext=ts --allow-read --allow-net --allow-env

import { hooks, Path, semver, SemVer } from "https://deno.land/x/libpkgx@v0.18/mod.ts"
import { walk } from "jsr:@std/fs"
const { useConfig, useInventory } = hooks

for await (const pkg of find()) {
  const [project, version] = (([project, version]) => {
    return [
      project.relative({ to: useConfig().prefix }),
      new SemVer(version)
    ]
  })(pkg.split())

  // breaks libpkgx semver shit sadly
  if (project == 'github.com/ggerganov/llama.cpp') continue

  const inventory = await useInventory().select({ project, constraint: new semver.Range('*') })

  if (!inventory || inventory.lte(version)) continue

  console.error("%coutdated%c: %s", 'color: yellow', 'color: reset', pkg, `(${inventory})`)
}

//////////////////////// utils
async function *find(): AsyncGenerator<Path> {
  const { prefix } = useConfig()
  const dirs = [prefix];
  let dir: Path | undefined;
  while (dir = dirs.shift()) {
    const project = dir.basename();
    const versions = []
    for await (const [path, {name, isDirectory}] of dir.ls()) {
      if (path.string == prefix.join('.local').string) continue;
      if (name.startsWith(".tmp")) continue;
      if (isDirectory && !/^v\d+$/.test(name) && semver.parse(name)) {
        versions.push(new SemVer(name))
      } else if (isDirectory) {
        dirs.push(path);
      }
    }
    const v = versions.sort().pop()
    if (v) yield new Path(dir).join(`v${v}`);
  }
}
