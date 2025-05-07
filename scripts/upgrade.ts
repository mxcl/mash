#!/usr/bin/env -S pkgx --quiet deno~1.39 run --ext=ts --allow-read --unstable --allow-net --allow-ffi --allow-write --allow-env --allow-run

import { hooks, Path, plumbing, semver, SemVer } from "https://deno.land/x/libpkgx@v0.18/mod.ts"
import usePantry from "https://deno.land/x/libpkgx@v0.18/src/hooks/usePantry.ts";
const { useConfig, useInventory } = hooks
const { install, link } = plumbing

for await (const pkg of pkgs()) {
  const [project, version] = (([project, version]) => {
    return [
      project.relative({ to: useConfig().prefix }),
      new SemVer(version)
    ]
  })(pkg.split())

  // breaks libpkgx semver shit sadly
  if (project == 'github.com/ggerganov/llama.cpp') continue

  console.error("checking:", project)
  const inventory = await useInventory().select({ project, constraint: new semver.Range('*') })

  if (!inventory || inventory.lte(version)) continue

  console.error("%cupdating%c: %s", 'color: yellow', 'color: reset', pkg)
  const installation = await install({ project, version: inventory })
  await link(installation)

  console.error("%cupgraded:%c %s", 'color: green', 'color: reset', installation.path)
}

//////////////////////// utils
async function *pkgs(): AsyncGenerator<Path> {
  const { prefix } = useConfig()

  if (Deno.args.length) {
    for (const arg of Deno.args) {
      for (const {project} of await usePantry().find(arg)) {
        const versions = []
        for await (const [path, {name, isDirectory}] of prefix.join(project).ls()) {
          if (path.string == prefix.join('.local').string) continue;
          if (name.startsWith(".tmp")) continue;
          if (isDirectory && !/^v\d+$/.test(name) && semver.parse(name)) {
            versions.push(new SemVer(name))
          }
        }
        const v = versions.sort().pop()
        if (v) {
          yield prefix.join(project, `v${v}`);
        } else {
          console.error("not installed:", arg);
        }
      }
    }
  } else {
    const dirs = [prefix];
    let dir: Path | undefined;
    while (dir = dirs.shift()) {
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
}
