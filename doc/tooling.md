# Tooling

Most tools require the input to Reuleaux to be log encoded or in domain zero to one.

For colorists and general usage, the suggested tool is ReuleauxUser. It's intuitive and good for grading.

The tool labels were chosen for friendliness. Familiarity of HSV percept labels outweighs verbose accuracy, so all operation names are condensed into those three groups, each describing the coincidental sensation correlated to each component. Many tools implicitly behave a specific way: "saturation" is adjusted nonlinearly[^1] and "value" is normalized by saturation.

[^1]: Exception being SaturationAtValue, which for the purpose of attenuation is an inclusive multiply.

## Categories

Chromaticity fitting:

- HueAtHue
- SaturationAtHue(Auto)

Depleting or "shaping":

- SaturationAtValue
- ValueAtSaturation
- CompressSaturation

Other or grading:

- ReuleauxUser
- ValueAtHue
