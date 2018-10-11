# plumber

## The motivation
I am a brazilian [Git](https://git-scm.com) user and when watched a video about Git of [Jonathan Lima](https://github.com/greenboxal) named ["Deep into Git"](https://www.youtube.com/watch?v=H2j7e81J798) I thinked will be very good idea create the basic commands of Git for study a technology that I used in everytime of my programmer life. However I want rewrite the porcelain layer of the Git and by consequence learn more about it.

## Install
**plumber** needs just [Git](https://git-scm.com), [Koala](https://github.com/guiferpa/koala) as bundler and a Unix based OS to run the commands.

### Manual installation
```sh
> git clone git@github.com:guiferpa/plumber.git

Cloning into 'plumber'...
remote: Enumerating objects: 33, done.
remote: Counting objects: 100% (33/33), done.
remote: Compressing objects: 100% (20/20), done.
remote: Total 33 (delta 11), reused 29 (delta 7), pack-reused 0
Receiving objects: 100% (33/33), 4.50 KiB | 4.50 MiB/s, done.
Resolving deltas: 100% (11/11), done.
```
```sh
> cd ./plumber && make

koala plumber /Users/user/src/github.com/guiferpa/plumber/bin/plr
2018/10/09 11:57:17 no custom tag then by default will be use <import> as tag
2018/10/09 11:57:17 spelled successfully 1257 bytes at /Users/user/src/github.com/guiferpa/plumber/bin/plr
ln -s /Users/user/src/github.com/guiferpa/plumber/bin/plr /usr/local/bin/plr
```
> :triangular_flag_on_post: The **plumber** project is installed using a alias name **plr** to short itself.

```sh
> make clean

rm -rf /usr/local/bin/plr
rm -rf /Users/user/src/github.com/guiferpa/plumber/bin/plr
```
> :triangular_flag_on_post: **make clean** will go to clean all builded and installed **plumber**.
