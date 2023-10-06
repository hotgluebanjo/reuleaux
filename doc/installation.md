# Installation

Download the [latest release](https://github.com/hotgluebanjo/reuleaux/releases/latest) for the appropriate program and unzip it.

## Resolve

Place in Resolve's LUT directory. Load via the DCTL OFX plugin.

## Nuke

Place wherever convenient and copy-paste and/or point to the BlinkScripts inside Nuke.

## Usage

All tools expect HSV-like input and must be sandwiched between two instances of Reuleaux. Your node setup should look like this:

- Reuleaux: RGB to Reuleaux.
- Any tools.
- Reuleaux: Reuleaux to RGB.

The only exception is [ReuleauxUserStandalone](../extra/ReuleauxUserStandalone.dctl), which has this setup built in for convenience. It is not included in releases and must be downloaded directly.

## Issues

If a script is entirely non-functional (i.e. it won't compile), report its error message. For DCTL, check Resolve's logs at one of:

```
Windows:
C:\ProgramData\Blackmagic Design\DaVinci Resolve\Support\logs\
C:\Users\<USERNAME>\AppData\Blackmagic Design\DaVinci Resolve\Support\logs\

Mac:
~/Library/Application Support/Blackmagic Design/DaVinci Resolve/logs/
/Library/Application Support/Blackmagic Design/DaVinci Resolve/logs/

Linux:
~/.local/share/DaVinciResolve/logs/
<RESOLVE_INSTALL_DIR>/logs/
/opt/resolve/logs/
```

Should be `davinci_resolve.log`, `ResolveDebug.txt`, `rollinglog.txt` or similar. If none of those are there, generate a log archive from inside Resolve at **Help > Create Diagnostics Log on Desktop**.

Search for the problematic DCTL and copy all lines like:

```
path/to/LUT/reuleaux_resolve/NameOfDctl.dctl(NNNN): error: error description
```
