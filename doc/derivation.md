# Derivation
**Author:** [calvinsilly](https://github.com/calvinsilly)

On the derivation of Reuleaux, from conception to a final set of transformations.

### Initial start
The starting point conceptually consists of rotating and scaling the RGB cube so that the achromatic diagonal is along a unit-length axis, which when converted to cylindrical coordinates mimics a typical HCI color model.
One of the problems that may arise is *clipping* which in turn induces skewing towards the compliments of the primaries when e.g. tweaking the saturation. Reuleaux avoids this by replacing the existing norm with the maximum of a given RGB triplet, for a detailed analysis on why the max is chosen; see [overview](overview.md).

As a start, we'll modify the part of the transformation that goes from RGB to cylindrical so that it uses $\max(R, G, B)$ for the intensity component.
Where the triplet $R,G,B$ varies through the interval $[0,1]$, the region of which describes a unit cube.

We map to the scaled rotation by

$$
\begin{bmatrix}
  u \\
  v \\
  w
\end{bmatrix} =
\begin{bmatrix}
  \sqrt{2}/3 & -\sqrt{2}/6 & -\sqrt{2}/6 \\
  0 & \sqrt{6}/6 & -\sqrt{6}/6 \\
  1/3 & 1/3 & 1/3
\end{bmatrix}
\begin{bmatrix}
  R \\
  G \\
  B
\end{bmatrix}
$$

which then is transformed into a cylindrical system from

$$
\begin{align*}
  \varphi &= \tan^{-1} \frac{v}{u} \\
  \rho &= \sqrt{u^2+v^2} \\
  z &= w
\end{align*}
$$

followed by $\sqrt{u^2+v^2}$ over $w$, changing the cylindrical description for a conical one; mirroring $S$ from $HSV$.

$$
\begin{align*}
  \varphi &= \tan^{-1} \frac{v}{u} \\
  \rho &= \frac{\sqrt{u^2+v^2}}{w} \\
  z &= w
\end{align*}
$$

The composed map of which we'll define as $\mathcal{C}\colon RGB \mapsto (\varphi, \rho, z)$

Now let $V = \max(R,G,B)$, which we substitute for $z$ such that

$$
\begin{align*}
  \varphi &= \tan^{-1} \frac{v}{u} \\
  \rho &= \frac{\sqrt{u^2+v^2}}{w}\tag{1} \\
  V &= \max(R,G,B)
\end{align*}
$$

Note the use of $\tan^{-1}$ instead of e.g. $\arctan$, which in this context emphasizes the fact that we're pretending (for now) that there's a bijection between sets so as not to dwell on edge cases. (see [Normalization](#normalization))

We have for the sake of clarity that the map $\mathcal{C}^{-1}$ is given by

$$
\begin{align*}
  u &= z \rho \cos \varphi \\
  v &= z \rho \sin \varphi \\
  w &= z
\end{align*}
$$

followed by

$$
\begin{bmatrix}
  R \\
  G \\
  B
\end{bmatrix} =
\begin{bmatrix}
  \sqrt{2}/3 & -\sqrt{2}/6 & -\sqrt{2}/6 \\
  0 & \sqrt{6}/6 & -\sqrt{6}/6 \\
  1/3 & 1/3 & 1/3
\end{bmatrix}^{-1}
\begin{bmatrix}
  u \\
  v \\
  w
\end{bmatrix}
$$

The set of Eqs. in $(1)$ is essentially the corresponding transformation of RGB to Reuleaux. However, our luck runs out when we attempt to find the inverse (the map of which we'll label as $(2)$ for future references) using e.g. *Mathematica* makes the process seem fruitless.

### Stepping back
An alternative method of swapping norms can be done with an additional color model. That is, say we've affected the input $RGB$ such that we have $R'G'B'$, by mapping both to the same model and "copying" a desired component from the other, we're in fact preserving whatever measure that component attempted to describe.

Pictorially, we can communicate the above with some notion of a commutative diagram, which shows the maps (morphisms) as arrows.

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260265-df17bf17-4e3a-466f-9ef2-d2e3ddcb48a5.svg">
<img alt="
\begin{tikzcd}
	RGB & {R'G'B'} \\
	M & {M'} \\
	& {M'_c} \\
	& {R'G'B'\text{-like}}
	\arrow["{f^{-1}}", from=3-2, to=4-2]
	\arrow[""{name=0, anchor=center, inner sep=0}, "{\text{"copy"}}", from=2-2, to=3-2]
	\arrow["f", from=1-2, to=2-2]
	\arrow["f"', from=1-1, to=2-1]
	\arrow[bend right=11, shorten &gt;=7pt, dashed, from=2-1, to=0]
\end{tikzcd}"
width="300" src="https://user-images.githubusercontent.com/63132541/265260273-0caaca27-d27d-4403-ae6c-03c243c81fa9.svg">
</picture></p>

Where $f$ denotes "map to model" and $M'_c$ is a partially preserved model.

Applying the above, we want $M$ to behave like the HSV color model, defined as $\mathcal{H}\colon RGB \mapsto HSV$; while $R'G'B'$ to be some operation within $\mathcal{C}$.

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260267-46fca895-ef3f-45af-8608-dc7c22b9e6f1.svg">
<img alt="
\begin{tikzcd}
	RGB & {(\varphi, \rho, z)} \\
	& {R'G'B'} \\
	\\
	HSV & {H'S'V'} \\
	& {H'S'V} \\
	\\
	& {R'G'B'\text{-like}}
	\arrow["{\mathcal{H}^{-1}}", from=5-2, to=7-2]
	\arrow[""{name=0, anchor=center, inner sep=0}, "{V'\mapsto V}", from=4-2, to=5-2]
	\arrow["{\mathcal{C}}", from=1-1, to=1-2]
	\arrow["{\mathcal{H}}"', from=1-1, to=4-1]
	\arrow["{\mathcal{C}^{-1}}", from=1-2, to=2-2]
	\arrow["{\mathcal{H}}", from=2-2, to=4-2]
	\arrow[bend right=11, shorten &gt;=7pt, dashed, from=4-1, to=0]
\end{tikzcd}"
width="300" src="https://user-images.githubusercontent.com/63132541/265260274-519a85ae-1ceb-432c-9f21-b5f80e27dfd3.svg">
</picture></p>

For reasons that will be clear in a moment, let's draw the process of arriving at $(1)$, that is

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260268-bf4449ae-db68-4be4-8bad-3cc054559f98.svg">
<img alt="
\begin{tikzcd}
	RGB & {(\varphi, \rho, z)} \\
	& {(\varphi, \rho, V)}
	\arrow["{\mathcal{C}}", from=1-1, to=1-2]
	\arrow["{z\mapsto\max(R,G,B)=V}", from=1-2, to=2-2]
	\arrow["{(1)}"', from=1-1, to=2-2]
\end{tikzcd}"
width="450" src="https://user-images.githubusercontent.com/63132541/265260275-e1c0f1ce-7d88-4ed0-94ae-3529e62db454.svg">
</picture></p>

and make the crucial observation that this is in fact the same category as the one before—if we remove a collection of morphisms. More importantly, the collection we have to remove precisely represents the inverse map $(2)$; which is what we wanted to find.

By constructing a diagram from the observation we made above, and making sense of any ambiguity—such as labeling objects appropriately; we get

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260269-b87108e2-912e-47b4-a1fe-998fdbfa87f2.svg">
<img alt="
\begin{tikzcd}
	{(\varphi, \rho, V)} & {(R',G',B')} & {HSV'} \\
	&& HSV \\
	&& RGB
	\arrow["{\mathcal{H}^{-1}}", from=2-3, to=3-3]
	\arrow["{V'\mapsto V}", from=1-3, to=2-3]
	\arrow["{\mathcal{C}^{-1}}", from=1-1, to=1-2]
	\arrow["{\mathcal{H}}", from=1-2, to=1-3]
	\arrow["{(2)}"', from=1-1, to=3-3]
\end{tikzcd}"
width="512" src="https://user-images.githubusercontent.com/63132541/265260276-ca39731f-f89a-4cb7-b36a-0385beed3734.svg">
</picture></p>

Because the diagram commutes, we have that $(2)$ is instead reduced to a mere composition exercise.

### Preparation
Instead of a typical hexagonal definition of $\mathcal{H}$ we'll use a conically-defined alternative $\bar{\mathcal{H}}\colon RGB\mapsto (\varphi,S_c,V)$. The idea of which comes from defining HCI cylindrically with the help of an opponent color space[^1].

We start by altering our scaled rotation $(u,v,w)$ such that we have the map $OCS\colon RGB \mapsto \big(u,v,\max\lbrace R,G,B\rbrace\big)$ which is explicitly written as

[^1]: *[Constructing cylindrical coordinate colour spaces](https://doi.org/10.1016/j.patrec.2007.11.002)* by Allan Hanbury.

$$
\begin{align*}
  u &= \frac{\sqrt{2}}{6} \left(2R-G-B \right) \\
  v &= \frac{\sqrt{6}}{6} \left(G-B \right)  \\
  w' &= \max(R,G,B)
\end{align*}
$$

which we convert to a conical system so that we have

$$
\begin{align*}
  \varphi &= \tan^{-1} \frac{v}{u} \\
  S_c &= \frac{\sqrt{u^2+v^2}}{w'} \\
  V &= w'
\end{align*}
$$

The procedure for $\bar{\mathcal{H}}^{-1}$ starts with undoing the conical map, such that we're back to

$$
\begin{align*}
  u &= V S_c \cos \varphi \\
  v &= V S_c \sin \varphi \\
  w' &= V
\end{align*}
$$

followed by $OCS^{-1}$ (derived using *Mathematica*)

$$
\begin{align*}
  R &= w'-\frac{\sqrt{6}}{2}\max\left\lbrace\left|v\right|-\sqrt{3}u,0\right\rbrace \\
  G &= w'-\frac{\sqrt{6}}{2}\left(\max\left\lbrace\left|v\right|,\sqrt{3}u\right\rbrace-v\right) \\
  B &= w'-\frac{\sqrt{6}}{2}\left(\max\left\lbrace\left|v\right|,\sqrt{3}u\right\rbrace+v\right)
\end{align*}
$$

This lets us replace any instances of $\mathcal{H}$ with $\bar{\mathcal{H}}$, making the process of reducing $(2)$ approachable.

### Reduction
We start by composing $\bar{\mathcal{H}}$ with $\mathcal{C}^{-1}$

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260270-60aee5a8-d5e5-42a6-bd4f-cca520369478.svg">
<img alt="
\begin{tikzcd}
	{(\varphi, \rho, V)} & {R'G'B'} & {(\varphi,S_c,V')}
	\arrow["{\mathcal{C}^{-1}}", from=1-1, to=1-2]
	\arrow["{\bar{\mathcal{H}}}", from=1-2, to=1-3]
	\arrow["{\bar{\mathcal{H}}\circ \mathcal{C}^{-1}}"', bend right=20, from=1-1, to=1-3]
\end{tikzcd}"
width="450" src="https://user-images.githubusercontent.com/63132541/265260277-19a96960-b6fc-4d9d-b96a-2597f84d1e75.svg">
</picture></p>

so that we get

$$
\begin{align*}
  R' &= V \rho \cos \varphi \\
  G' &= V \rho \sin \varphi \\
  B' &= V
\end{align*}
$$

and

$$
\begin{align*}
  \varphi &= \tan^{-1} \frac{G'}{R'} \\
  S_c &= \frac{\sqrt{{R'}^2+{G'}^2}}{M} \\
  V' &= M
\end{align*}
$$

Where $M = \sqrt{2}\max\left(R',\frac{\sqrt{3}}{2}G'-\frac{1}{2}R',-\frac{\sqrt{3}}{2}G'-\frac{1}{2}R'\right)+B'$

Now substitute $V$ for $V'$ such that

$$
\begin{align*}
  \varphi &= \tan^{-1} \frac{G'}{R'} \\
  S_c &= \frac{\sqrt{{R'}^2+{G'}^2}}{M} \\
  V &= V
\end{align*}
$$

acting as the composition $\mathcal{F}=\big(V'\mapsto V\big) \circ \big(\bar{\mathcal{H}}\circ\mathcal{C}^{-1} \big)$.

Finally composing $\bar{\mathcal{H}}^{-1}$ with $\mathcal{F}$

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260272-085a05ed-8e19-41cf-b553-2730ebfe7a94.svg">
<img alt="
\begin{tikzcd}
	{(\varphi, \rho, V)} & {R'G'B'} & {(\varphi,S_c,V')} \\
	&& {(\varphi,S_c,V)} \\
	&& RGB
	\arrow["{\bar{\mathcal{H}}^{-1}}", from=2-3, to=3-3]
	\arrow["{V'\mapsto V}", from=1-3, to=2-3]
	\arrow["{\bar{\mathcal{H}}\circ \mathcal{C}^{-1}}"', from=1-1, to=3-3]
	\arrow["{\mathcal{C}^{-1}}", from=1-1, to=1-2]
	\arrow["{\bar{\mathcal{H}}}", from=1-2, to=1-3]
\end{tikzcd}"
width="512" src="https://user-images.githubusercontent.com/63132541/265260278-648db345-598e-41f4-aa06-3552025ea96d.svg">
</picture></p>

such that

$$
\begin{align*}
  u &= V S_c \cos\varphi \\
  v &= V S_c \sin\varphi \\
  w' &= V
\end{align*}
$$

Notice that $S_c = \frac{V\rho}{M}$, which lets us write $u = \frac{V}{M}\cdot V\rho \cos\varphi$ and $v = \frac{V}{M}\cdot V\rho  \sin\varphi$; which finally gives us

$$
\begin{align*}
  u &= \frac{V}{M} R' \\
  v &= \frac{V}{M} G' \\
  w' &= V
\end{align*}
$$

For the sake of simplicity, we momentarily define the operator $\mathcal{M}(x,y,z)$ to satisfy $\mathcal{M}\left(R',G',B'\right)=M$.  It can then be trivially shown—that the property $\max(ax,ay,az)=a\cdot \max(x,y,z)$ if $a\geq0$ still holds for $\mathcal{M}(x,y,z)$.
$$M=\mathcal{M} \left(R',G',B' \right)\iff \mathcal{M} \left(R',G',B' \right)=\mathcal{M} \left(V \rho \cos \varphi,V \rho \sin \varphi,V \right)$$
Assume $V,\rho$ are non-negative, which in our case makes sense; we then have that
$$\mathcal{M} \left(V \rho \cos \varphi,V \rho \sin \varphi,V\right)=V\rho \cdot \mathcal{M} \left(\cos \varphi,\sin \varphi,\frac{1}{\rho} \right)$$

This then motivates us to rewrite $R'G'B'$ such that $M=\mathcal{M} \left(\cos \varphi,\sin \varphi,\frac{1}{\rho} \right)$. That is

$$
\begin{align*}
  R' &= \cos \varphi \\
  G' &= \sin \varphi \\
  B' &= 1/\rho
\end{align*}
$$

so that we finally have

$$
\begin{align*}
  u &= \frac{V}{M} \cos \varphi\\
  v &= \frac{V}{M} \sin \varphi \\
  w' &= V
\end{align*}
$$

then applying $OCS^{-1}$ we get $(2)$.

Furthermore, we can show that $M$ is non-zero as a consequence of the assumption we made, this reassures us that division by $M$ is not a concern.

Expanding out $M$ we get $$M=\sqrt{2}\max\left(\cos\varphi,\frac{\sqrt{3}}{2}\sin\varphi-\frac{1}{2}\cos\varphi,-\frac{\sqrt{3}}{2}\sin\varphi-\frac{1}{2}\cos\varphi\right)+1/\rho = \sqrt{2}\max\left\lbrace \cos\varphi,\cos\left(\varphi-\frac{2\pi}{3}\right),\cos\left(\varphi+\frac{2\pi}{3}\right) \right\rbrace+1/\rho$$

Let $M=0$ so that solving for $\rho$ we get

$$
\rho(\varphi)=-\frac{\sqrt{2}}{2}\cdot\frac{1}{\max\left\lbrace \cos\varphi,\cos\left(\varphi+\frac{2\pi}{3}\right),\cos\left(\varphi-\frac{2\pi}{3}\right)\right\rbrace}
$$

Because $\rho(\varphi)$ is periodic, showing that $M\neq0$ can be reduced to showing when $\rho(\varphi)=-\frac{\sqrt{2}}{2}\sec \varphi$, reaches its maximum for some $\rho < 0$ in the interval $|\varphi| \leq \pi/3$.

We start by checking the boundary points $\rho \left(\pm \pi/3 \right)=-\sqrt{2} < 0$.

Since $\rho(\varphi)$ is continuous we differentiate and let $\dfrac{\mathrm{d}\rho}{\mathrm{d}\varphi}=0$ to find eventual extrema. That is $$\dfrac{\mathrm{d}\rho}{\mathrm{d}\varphi} = -\frac{\sqrt{2}}{2}\sec \varphi \tan \varphi = 0\iff \sec \varphi \tan \varphi = 0\iff \tan\varphi = 0\iff \varphi=\pi\cdot n$$ where $n$ is some integer. But since $|\varphi| \leq \pi/3$ then $n = 0$ so that $\varphi = 0$, of which $$\rho \left(\pm \pi/3 \right)<\rho(0)=-\frac{\sqrt{2}}{2}<0$$ which is what we wanted to show.

## Normalization
For most use cases we want something intuitive for our domains, such as the interval $[0,1]$. Revisiting $(1)$ we have that $\varphi \in [-\pi,\pi]$, $\rho \subseteq (0, \sqrt{2} ]$ and $V\in [0,1]$.
We require $\varphi$ to instead be defined as e.g. $\varphi = \pi-\text{atan2}(v,-u)\in[0,2\pi]$ and $\rho$ to be altered so that

$$
\rho=
\begin{cases}
  \sqrt{u^2+v^2}/w, & \text{if } w \neq 0 \\
  0, & \text{otherwise}
\end{cases}
$$

Such that $\rho \in[0,\sqrt{2}]$. Leaving $V$ as is we therefore divide by whatever upper bound our two other domains have. As for $(2)$, we multiply the inputs with said constants to return to their respective domain.

## Final set of transformations
### RGB to Reuleaux

$$
\begin{bmatrix}
  u \\
  v \\
  w
\end{bmatrix} =
\begin{bmatrix}
  \sqrt{2}/3 & -\sqrt{2}/6 & -\sqrt{2}/6 \\
  0 & \sqrt{6}/6 & -\sqrt{6}/6 \\
  1/3 & 1/3 & 1/3
\end{bmatrix}
\begin{bmatrix}
  R \\
  G \\
  B
\end{bmatrix}
$$

$$
\begin{align*}
  \varphi &= \pi-\text{atan2}(v,-u)\tag{1} \\
  \rho &=
  \begin{cases}
    \sqrt{u^2+v^2}/w, & \text{if } w \neq 0 \\
    0, & \text{otherwise}
  \end{cases} \\
  V &= \max(R,G,B)
\end{align*}
$$

### Reuleaux to RGB
$M$ is undefined for $\rho = 0$, where e.g. $M \to \infty$ as $\rho \to 0^{+}$ which for practical purposes hasn't been a concern yet; but to avoid this we instead let $$m=\sqrt{2}\rho\max\left\lbrace \cos\varphi,\cos\left(\varphi-\frac{2\pi}{3}\right),\cos\left(\varphi+\frac{2\pi}{3}\right) \right\rbrace+1$$
such that

$$
\begin{align*}
  u &= \frac{V \rho}{m} \cos \varphi \\
  v &= \frac{V \rho}{m} \sin \varphi \\
  w' &= V \tag{2}
\end{align*}
$$

$$
\begin{align*}
  R &= w'-\frac{\sqrt{6}}{2}\max\left\lbrace\left|v\right|-\sqrt{3}u,0\right\rbrace \\
  G &= w'-\frac{\sqrt{6}}{2}\left(\max\left\lbrace\left|v\right|,\sqrt{3}u\right\rbrace-v\right) \\
  B &= w'-\frac{\sqrt{6}}{2}\left(\max\left\lbrace\left|v\right|,\sqrt{3}u\right\rbrace+v\right)
\end{align*}
$$

<br/>

Consider the Eqs. $u,v$ from $(2)$—while letting $V,\rho$ be fixed constants, so that we have the following parametric equation

$$
(x,y)=\frac{V\rho}{m}\left(\cos \varphi,\sin \varphi\right)
$$

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/63132541/265260544-af72ef02-799a-4f2b-979f-897a97e2a34f.svg">
<img alt="
\begin{tikzpicture}
\begin{axis}[
    trig format plots=rad,
    axis equal,
    grid = major,
    xmin=-0.8,
    xmax=0.8,
    ymin=-0.8,
    ymax=0.8,
    legend pos = outer north east,
    ]
\addplot[domain=0:2*pi, samples=300, black, thick] ({0.87/(sqrt(2)*0.87*max(cos(x),cos(x-2*pi/3),cos(x+2*pi/3)) + 1)*cos(x)}, {0.87/(sqrt(2)*0.87*max(cos(x),cos(x-2*pi/3),cos(x+2*pi/3)) + 1)*sin(x)});
\end{axis}
\end{tikzpicture}"
width="512" src="https://user-images.githubusercontent.com/63132541/265260546-54ac7455-d3c3-42e0-b89a-3b40efe8e208.svg">
</picture></p>

The curve of which resembles a Reuleaux triangle. Hence the name Reuleaux.
One possible way of quantifying this resemblance is by comparing the properties of one (e.g. constant width).
In doing so, we have that the average *resemblance* for a curve with $\rho \in [0,\sqrt{2}]$ is $92 \\%$, the maximum of which is $99 \\%$ (when $\rho \approx 0.81$). Larger choices of $\rho$ approach a triangle while smaller ones approach a circle.

<!--
the defining property of constant width for different choices of $\rho$. We therefore define $P(\varphi,\rho):=(x,y)$ with the added parameter $\rho$. Because of symmetry, it's enough to pick the two points $P(\pi,\rho)$ and $P(t,\rho)$ where $t\in [0,\pi/3]$. Evaluating the Euclidean distance between the two points by $\mathcal{D}(t,\rho)=\left\lVert P(\pi,\rho)-P(c,\rho) \right\rVert$. Since we're interested when $\mathcal{D}(t,\rho)$ is near constant, we differentiate with respect to $t$

$$
$$

$$
\min_{\rho\,\in\,I}\frac{3}{\pi}\int_{0}^{\pi/3}\left\lvert\dfrac{\partial}{\partial t}\mathcal{D}(t,\rho)\right\rvert\,\mathrm{d}t
$$
-->

<p align="center"><picture>
<source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/66244111/261149824-c6bded23-95a7-4f7d-a2ff-6ec96315dc85.gif">
<img alt="Parametric plot rho animation"
width="450" src="https://user-images.githubusercontent.com/66244111/261149836-545256a5-4974-44a7-9092-afa23a3e60dd.gif">
</picture></p>
