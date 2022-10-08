# Super Mario Bros 2J And All Night Nippon NES ports

Port of All Night Nippon, and SMB2j to the NES with MMC5.

Why waste time making this? I don't know.

## Download

To get the latest patches go to https://github.com/threecreepio/nes-mmc52j/releases and download them from there.

You can use https://bbbradsmith.github.io/ipstool/, for example, to apply the patches.

The "patch_ann.ips" file applies to an All Night Nippon FDS ROM, SHA1 `f30bdd3c556604d7eaa6d0f4864d5566e519b5d4`. (Compare against the SHA1 in bbbradsmiths patcher to see that you have the right file.)

The "patch_ann.ips" file applies to a Super Mario Bros 2j FDS ROM, SHA1 `20e50128742162ee47561db9e82b2836399c880c`. (Compare against the SHA1 in bbbradsmiths patcher to see that you have the right file.)

The output of both is a ".nes" file. Depending on your patcher you may need to change file extension.

## Building

To compile, make sure you have cc65 and make installed in a bash terminal. Then just write 'make', or 'ANN=1 make' to build the Nippon version.

Enjoy!
/threecreepio
