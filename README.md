# Reuleaux

An HSV-like color model similar to one [Steve Yedlin, ASC](https://yedlin.net/) has demonstrated online.

<img src="https://user-images.githubusercontent.com/66244111/251698400-a1c94c44-0ed4-4e53-9e87-fcbaf0360e5a.jpg" width="49%"/> <img src="https://user-images.githubusercontent.com/66244111/251698422-f358866a-374d-4928-a059-071e620f6032.jpg" width="49%"/>

Massive thanks to [calvinsilly](https://github.com/calvinsilly) for solving the inverse, and whose collaborative efforts this project would not exist without.

Several tools are included. Ideally they'll provide a launch pad for others to create their own. As with any HSV-type model, there are many possibilities.

Note: BlinkScript was made available to Nuke Non-commercial users in version 14.0v3, so the BlinkScripts will work there. Regardless, prefer the `.nk` version of the model itself.

Related, check out this [similar model by Juan Pablo Zambrano](https://github.com/JuanPabloZambrano/DCTL/tree/main/NormSphericalCoords), which has two chroma normalization modes.

## Background and Differences to Other Models

This model differs from the popular [spherical coordinate model by Chen et al.](https://doi.org/10.1117/1.JEI.22.4.043032) in that it replaces the Euclidean norm with the maximum of the input triplet. This adjustment is implemented with a custom opponent color model. *[Constructing cylindrical coordinate colour spaces](https://doi.org/10.1016/j.patrec.2007.11.002)* by Allan Hanbury helped immensely in demonstrating the possibility of this approach.

Increased distance from achromatic changes RGB ratios in relation to the max. This behavior coincidentally improves the perceptual match of film fitting transforms.
