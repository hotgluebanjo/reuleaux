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
