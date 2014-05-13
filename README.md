# node chat

## get it work on suse
- install node via [nvm](https://github.com/creationix/nvm)
- npm install
(if it not works manuel install nodewebkit -> use [nodewebkit installer](https://github.com/shama/nodewebkit) and install actual node-webkit version `npm install nodewebkit@0.9.2-4 --save`)
- if you get an error like 
```
error while loading shared libraries: libudev.so.0: can
not open shared object file: No such file or directory
```
check this [site](https://github.com/rogerwang/node-webkit/wiki/The-solution-of-lacking-libudev.so.0) and run the `One line fix`
- npm start