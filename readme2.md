Решение 2.4. Инструменты Git
1. git show aefea
  commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
  комментарий Update CHANGELOG.md
  
2. git show 85024d3
  commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
  
3. git show -s --format=%p b8d720
  56cd7859e0 9ea88f22fc
  
4. git log --oneline v0.12.23..v0.12.24
  33ff1c03bb (tag: v0.12.24) v0.12.24
  b14b74c493 [Website] vmc provider links
  3f235065b9 Update CHANGELOG.md
  6ae64e247b registry: Fix panic when server is unreachable
  5c619ca1ba website: Remove links to the getting started guide's old location
  06275647e2 Update CHANGELOG.md
  d5f9411f51 command: Fix bug when using terraform login on Windows
  4b6d06cc5d Update CHANGELOG.md
  dd01a35078 Update CHANGELOG.md
  225466bc3e Cleanup after v0.12.23 release
  
5. git log -S "func providerSource("
   git show 8c928e83589d90a031f811fae52a81be7153e82f
  +func providerSource(services *disco.Disco) getproviders.Source {
+       // We're not yet using the CLI config here because we've not implemented
+       // yet the new configuration constructs to customize provider search
+       // locations. That'll come later.

6. git grep 'func globalPluginDirs'
  plugins.go:func globalPluginDirs() []string {
   git log -L :'func globalPluginDirs':plugins.go --oneline
  8364383c35 Push plugin discovery down into command package
  66ebff90cd move some more plugin search path logic to command
  41ab0aef7a Add missing OS_ARCH dir to global plugin paths
  52dbf94834 keep .terraform.d/plugins for discovery
  78b1220558 Remove config.go and update things using its aliases
  
7. git log -S'synchronizedWriters' --pretty=format:'%h - %an %ae'
  5ac311e2a9 - Martin Atkins mart@degeneration.co.uk
