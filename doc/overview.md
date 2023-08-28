# Overview

Background on Cone Coordinates and mechanics of the underlying ideas behind Reuleaux.

For the math and detailed implementation information, check out the [derivation](derivation.md).

## Approach

An interpretation of Yedlin's approach to image formation is:

- [Start from interpolated catches, i.e., no colorimetric fit matrix](https://twitter.com/steveyedlin/status/865790998739206144)
- Apply manufacturer log transfer function or shaper
- [Form chromaticity with nonlinear but broad fittings of film data](https://twitter.com/steveyedlin/status/1130261214674673664) in a cylindrical/spherical model to offload complexity, allowing full invertibility to be possible or simpler
- Attenuate
- Apply per-channel lookup, where each channel is a unique interpolation of film data

In trying to imitate this process, a major unknown is the model itself. Comparing Cone Coordinates with similar models, it was clear that it isn't "perceptually uniform" and that it best resembles HSV. Along came the rediscovery of...

## Spherical Coordinates

A [spherical coordinate model by Chen et al.](https://doi.org/10.1117/1.JEI.22.4.043032) scaled to domain $[0, 1]$ (hereafter referred to as "Spherical Coordinates") [appears to perfectly match](https://twitter.com/m_santana/status/1507374932430405643) a [plot Yedlin posted in 2018](https://twitter.com/steveyedlin/status/990033921277489152):

Conical (2018) | Spherical Coordinates
-------------- | ---------------------
<img src="https://user-images.githubusercontent.com/66244111/172126772-6de2bd20-6796-4df9-987b-4e6b4021a9ca.png" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261487786-3f5877f3-bec9-4f24-8d7e-78c6fd8cdac3.jpg" width="200px">

However, it does not match the model demonstrated in the [Display Prep Demo Followup](https://yedlin.net/DisplayPrepDemo/DispPrepDemoFollowup.html) (2019). With $\text{distance}^{1/\text{satch}}$, $\text{satch}=1.6$:

Cone Coordinates (2019) | Spherical Coordinates
----------------------- | ---------------------
<img src="https://user-images.githubusercontent.com/66244111/261484495-8d247c58-7edb-4f8b-ab09-e2c6d06e6d26.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261491009-74fbf5cf-ecbf-441b-b3a5-b1b1e6718c6d.jpg" width="190px">

In [another plot from late 2017](https://twitter.com/steveyedlin/status/934229509338890240), the shell has intricate Spherical Coordinates-like petals that would be smooth edges in Reuleaux and likely Cone Coordinates (2019) because of their intensity measure.

WIP Conical (2017) | Spherical Coordinates | Reuleaux
------------------ | --------------------- | --------
<img src="https://user-images.githubusercontent.com/66244111/261484443-65b59521-c5a8-4f8b-8c43-f3a6a6a70c98.jpg" width="215px"> | <img src="https://user-images.githubusercontent.com/66244111/262826684-3c871e84-1370-4a46-8d6c-39babd165cbb.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/262826690-e9916815-5eb4-4dfc-a91d-cbf8eb7fe53a.jpg" width="185px">

These discrepancies suggest two separate versions.

Both HSV and Cone Coordinates (2019) have flat positive faces with comparable 2D curvature, indicating that they may use the same measure.

Cone Coordinates (2019) | HSV | Spherical Coordinates
----------------------- | --- | ---------------------
<img src="https://user-images.githubusercontent.com/66244111/261484495-8d247c58-7edb-4f8b-ab09-e2c6d06e6d26.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/262190784-8d9b7abb-b89e-498c-b554-065243c87105.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261491009-74fbf5cf-ecbf-441b-b3a5-b1b1e6718c6d.jpg" width="190px">

Modifying Spherical/Cylindrical Coordinates to [use HSV's value component](derivation.md#stepping-back), $\max(R, G, B)$, verifies this and aligns the remaining regions.

Cone Coordinates | Cone Coordinates-like
---------------- | ---------------------
<img src="https://user-images.githubusercontent.com/66244111/261484495-8d247c58-7edb-4f8b-ab09-e2c6d06e6d26.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/262818850-1df2c3b2-d430-4a7d-a9dd-37d508e792e8.jpg" width="200px">

## $\max(R, G, B)$

The mechanics and implications of the max are surprisingly difficult to grasp when the scope is the entire chain. Following is its obvious benefits mixed in with plenty of speculation. A mean is used for comparison, but its advantages apply against most other measures.

### Distance Extrapolation

For an arbitrary pure-ish mixture, e.g., $(0.9, 0.2, 0.1)$, the intensity via mean is $\frac{0.9 + 0.2 + 0.1}{3} = 0.4$. Obviously $0.4 \notin \lbrace0.9, 0.2, 0.1\rbrace$, therefore increasing purity[^1] by extrapolating past RGB from the mean affects all three scalars. Since $0.4 < \max(0.9, 0.2, 0.1)$, this extrapolates intensity which may pass domain bounds, as is noticeable with Spherical Coordinates' top. Directly:

$$ RGB' = \text{lerp}(\text{measure}, RGB, p) $$

Using the previous example triplet, with $p = 1.3$, $RGB' \approx (1.05, 0.14, 0.001)$. Notice $R > 1$, which will clip to the domain bounds, altering the ratios and skewing the result slightly. The max will never do this.

### Purity Implications

An increase in radial distance changes RGB ratios only in relation to the max. Purity increases "downward", theoretically much like rigid emission film. Likewise, purity decreases "upward" toward metaphoric full transmission.

Another facet is that purity holds no weight in the first place; maximum purity equals maximum intensity: $\max(1, 0, 0) = \max(1, 1, 1)$. A mean yields $\frac{1}{3}$, which seems rather polluted.

### Smoothness

The max is not differentiable at intersections.

Input | Max | Result
----- | --- | ------
<img src="https://user-images.githubusercontent.com/66244111/262903328-80fdf3c4-d425-43c0-958a-b827983e33f1.png" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/262903323-55c54755-6180-4197-9a27-3f1db6133183.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/262903330-a3905768-4d47-4b94-b27a-2d5cc3bafba8.png" width="200px">

Large distance adjustments can result in perceived spatial fringing at those near-intersection extremes, as the spikes remain fixed while values below move. It is possible to significantly lessen this effect by [approximating the max](https://en.wikipedia.org/wiki/Smooth_maximum), however there are several disadvantages to doing so. In practice this rarely seems to be an issue.

### Attenuation

As an attenuation factor, most other measures will leave behind high purity because of the aforementioned "pollution", whereas the max unwaveringly hits all purities:

Mean | Mid | Max
---- | --- | ---
<img src="https://user-images.githubusercontent.com/66244111/261757299-8d661ae7-b8be-4635-b1b7-31e9ebd6cb8c.png" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261757304-a3594ffb-90a7-4ebd-9b3a-a85eb992c9e2.png" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261757316-2111c2e3-61d1-4af3-8c35-a4ca6ff713f4.png" width="190px">

In the context of image forming:

Mean | Max
---- | ---
<img src="https://user-images.githubusercontent.com/66244111/261919726-b566c1df-c956-4bda-8a58-2aa433cda974.gif" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261919714-d26a4439-783f-494f-a9d1-ca852ddec7f8.gif" width="200px">

Notice the corners.

## Reuleaux vs. Other Models

### Spherical Coordinates

Reuleaux uses normalized cylindrical coordinates instead of spherical and replaces the Euclidean norm with the max.

### HSV

HSV is very similar, using the same intensity measure. However, Reuleaux has several advantages: simplicity and consistency of implementation, ease of understanding and a direct trigonometric definition.

### CIE LCh, OkLCh, etc.

Reuleaux does not try to be "perceptually uniform". It's merely a different representation of existing stimulus models that *by happenstance* exposes attribute-in-effect components.

### Cone Coordinates

Plots are mostly identical.

Cone Coordinates | Reuleaux
---------------- | --------
<img src="https://user-images.githubusercontent.com/66244111/261484495-8d247c58-7edb-4f8b-ab09-e2c6d06e6d26.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261484514-8f0db23b-a989-4ec3-b7bc-a78574a1546c.jpg" width="200px">
<img src="https://user-images.githubusercontent.com/66244111/261484471-6d97063d-23ea-498f-8f7e-a39c69ee81aa.jpg" width="200px"> | <img src="https://user-images.githubusercontent.com/66244111/261484485-07f503ad-8205-4518-86a6-b46739ce4ba1.jpg" width="200px">

[^1]: Using "purity" very loosely in the sense of a display, less so chromaticity.
