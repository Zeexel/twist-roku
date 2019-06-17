twist-roku
====
This is an unofficial Roku app for AnimeTwist (aka [twist.moe](https://twist.moe)). It's built on Roku's SceneGraph framework ([documentation available here](https://developer.roku.com/docs/developer-program/getting-started/roku-dev-prog.md)), and currently has basic functionality such as video playing and anime searching.

Setup
----
This app is not available on the Roku store. To install it, follow Roku's instructions for installing a developer app, [available here](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md).

Once you've enabled developer settings on your Roku, you can use the makefile (rather than the UI) to quickly install or update the app. Execute the following commands in the `twist` directory (modifying the values according to your device):

```
export ROKU_DEV_TARGET=192.168.x.xxx
export DEVPASSWORD=xxxx
make install
```

Please note that the makefile doesn't currently work on Mac OS X.

TODO
----
* Save episode progress
* Add a loading icon while waiting on api calls
* Modify makefile to work on Mac OS X
* Add more error handling
