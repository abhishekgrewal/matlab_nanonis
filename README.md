# MatLab Library for Nanonis based files

This library allows to open and analyze data saved using the [*Nanonis SPM Control System*](http://www.specs-zurich.com/en/home.html;jsessionid=FCD8A587EE447665C3F4A8CC374671EE).

The first version was developed by Quentin Peter during its master thesis *Spin Polarized Field Emission STM and Image Processing* in the Solid State Laboratory for [*Microstruture Research*](http://www.microstructure.ethz.ch) at the ETH Zurich under the supervision of Dr. U. Ramsperger and L. De Pietro.

## Content

The repository is divided in three sections:
* Manual: pdf of the user manual and source file
* NanoLib: library
* Examples: sample of dummy files and code example for using the library

## Installation and setup

In order to use the library you need to add the path of the library at the beginning of your project with the ```addpath``` standard function of MatLab.

You may use the functions of the library by calling first the ''class'' and than the specific function. Io order to load a SXM image, e.g., you should therefore write ```load.loadSXM```.

A simple example of how to load and to plot an image is given below

```matlab
% load file
fileName = 'SXM_file.sxm';
sxmFile = loadSxM.loadProcessedSxM(fileName);

%% plot data
iCh = 1; % Channel number

%plot image
figure('Name',sprintf('file: %s',fileName));
plotSxM.plotFile(sxmFile,iCh);
```

This and other example can be found in the section *Example*.

## Licence

Distributed under the GNU General Public License, Version 3.0. (See accompanying file [LICENSE](LICENSE) or copy at [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html))
