# ikori
Peer to peer chat based on [nodewebkit](https://github.com/rogerwang/node-webkit) and webrtc. Ikori means 'chat' in [igbo language](http://en.wikipedia.org/wiki/Igbo_language)

## How to install
- install node via [nvm](https://github.com/creationix/nvm)
- make sure you use node version `> 0.11`
- npm install
- npm start

## troubleshooting suse
- if you get an error like 
```
error while loading shared libraries: libudev.so.0: can
not open shared object file: No such file or directory
```
check this [site](https://github.com/rogerwang/node-webkit/wiki/The-solution-of-lacking-libudev.so.0) and run the *One line fix*
- `cd node_modules/nodewebkit/nodewebkit/`
- `sed -i 's/\x75\x64\x65\x76\x2E\x73\x6F\x2E\x30/\x75\x64\x65\x76\x2E\x73\x6F\x2E\x31/g' nw`

## troubleshooting mac
- if you get an error like
```
Invalid package.json 
Field 'main' is required.
```
rename `packag.json` in `nodewebkit`
- `mv node_modules/nodewebkit/package.json node_modules/nodewebkit/_package.json`
