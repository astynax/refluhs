# refluhs

Just a simple [react-flux](https://hackage.haskell.org/package/react-flux)
demo project. Live version is available [here](https://astynax.github.io/refluhs).

## How to

To build the project on your machine you'll need

1. Install the [stack](http://docs.haskellstack.org) tool
1. Clone the repo and `cd` into it
1. Install the GHCJS compiler with `stack setup`
1. Build the project with `stack build`

Now you can open `index.dev.html`.

To build the release version of project you will need a
[Google Closure Compiler](https://developers.google.com/closure/) installed.
When you got it, just do `make` and then open `index.html`.
