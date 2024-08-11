## whats this scripts doing

- add dev dockerfile for vite app
- add prettier and eslint base config
- add push and dev scripts in scripts
- if with jest add jest and babel start configure
- default husky init
- default tailwind vite setup
- base fsd folder structure

## Dependency for scripts

- yarn package manager

## if u use unix like system u can run this scripts:

```bash
sh setup.sh  #without jest or tailwind
```

```bash
sh setup.sh jest #with jest
```

```bash
sh setup.sh tailwind #with tailwind
```

---

### Usage

if u have docker on ur host machine, for development ur application u can run:

```bash
sh dev.sh
```

for classic push in repos u can run:

```bash
sh push.sh #<ur commit message>
```

wihtout commit message, commit message will become commit date

![image](./image.png)
