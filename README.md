# Electric Source Imaging with Binary Region Priors

* [Introduction](https://github.com/EncisoAlva/Region-Priors?tab=readme-ov-file#introduction)
* [Implementation in Brainstorm](https://github.com/EncisoAlva/Region-Priors?tab=readme-ov-file#brainstorm-implementation)
* [Evaluation with synthetic data](https://github.com/EncisoAlva/Region-Priors?tab=readme-ov-file#performance-evaluation-with-synthetic-data)

## Introduction

A central task for Neuroscience is to determine the location of electrical activity of neural origin inside the brain. 
Electrical Source Imaging (ESI) is a particular framework for neural electrical source location.

Although the basic formulation of ESI constitutes an ill-posed problem (in the sense of Hadamard), it may be augmented by modeling any additional information we may have about the electrical sources. For instance, minimal-norm estimators assume that the most plausible estimation is that with a lower norm. 
However, minimal-norm ESI estimators possess a low resolution in space.

In my PhD dissertation, we constructed a novel ESI estimator incorporating binary anatomical data from pathologies observed in the post-mortem to improve its spatial resolution.

Furthermore, the methodology developed in my PhD dissertation can be extended to incorporate similar types of binary data derived from various imaging modalities, such as fMRI, NIRS, and CT, among others.

The interested reader may refer to [my dissertation](https://mavmatrix.uta.edu/math_dissertations/162/). 
The presentation was recorded, and it is available [here](https://drive.google.com/file/d/1jC29LfYxnKniUrf4qTJaTYbJNPSoyBz7/view?usp=sharing); 
the slides can be accessed [here](https://drive.google.com/file/d/1jCc60A6hyuYjBBVgBPFIjxB2DwLOZxNE/view?usp=sharing).

## Algorithm Summary

_A grosso modo_, we construct the spatial priors based on observations from low-resolution imaging modalities. For instance, we use pictures from post-mortem symptoms of a stroke.

<picture>
 <source media="(prefers-color-scheme: dark)" 
srcset="https://github.com/EncisoAlva/Region-Priors/blob/main/doc_img/Pregions01.png?raw=true">
 <source media="(prefers-color-scheme: light)" 
srcset="https://github.com/EncisoAlva/Region-Priors/blob/main/doc_img/Pregions02.png?raw=true">
 <img alt="Binary Anatomical Priors are encoded as P-regions. In this example, P-regions are constructed from stain with Tetrazolium chlorine, which reveals hypoxic tissues." src="https://github.com/EncisoAlva/Region-Priors/blob/main/doc_img/Pregions02.png?raw=true"
width="800" height="214" align="center">
</picture>

# Brainstorm Implementation

[Brainstorm](https://neuroimage.usc.edu/brainstorm/Introduction) is a Matlab toolbox for analyzing brain recordings, including, but not limited to, MEG, EEG, fNIRS, ECoG, etc. In the context of Electrical Source Imaging, Brainstorm offers integrations with state-of-the-art toolboxes such as CAT12 for processing anatomical MRI data and OPENMEEG for solving the forward problems of EEG vs. electrical dipoles.

## Setup

To run these scripts, you need to install Brainstorm. This can be achieved by following the [official tutorial](https://neuroimage.usc.edu/brainstorm/Installation). 

To **install** the proposed algorithm into your local Brainstorm, do as follows:

1. Note the folder `~/.brainstorm/process`, which is designated for user-defined processes. 

2. Go to this repository's `Brainstorm` folder and download `process_RegionPriors.m`.

3. Download the file `process_(...).m` and move it to `~/.brainstorm/process`

Notice that other algorithms are included in the `Brainstorm` folder. They were implemented to compare against the proposed method.

## Execution

Now, to **use** the algorithm, you need data pre-processed to perform a Source Reconstruction. 
This requires that the database contains the subject's anatomy data, sensor data, and electrode positions. 

The appropriate methods are beautifully explained in the [Brainstorm tutorials](https://neuroimage.usc.edu/brainstorm/Tutorials#Get_started). 

Once the data is already in the database, the algorithms provided here can be run as follows:

1. Select the sensor data and drag it to the `Run` section.

2. Select the `Run` button to open the Pipeline editor.

3. Use the cog to open the menu of processes.

4. Navigate to `Sources / Binary Region Priors`.

5. Multiple options are available for selection, such as the heuristic for hyperparameter tuning.

<picture>
 <source media="(prefers-color-scheme: dark)" 
srcset="https://github.com/EncisoAlva/Region-Priors/blob/main/doc_img/Brainstorm_instructions_01.png?raw=true">
 <source media="(prefers-color-scheme: light)" 
srcset="https://github.com/EncisoAlva/Region-Priors/blob/main/doc_img/Brainstorm_instructions_02.png?raw=true">
 <img alt="Steps to access the proposed method in the Brainstorm GUI." src="https://github.com/EncisoAlva/Region-Priors/blob/main/doc_img/Brainstorm_instructions_02.png?raw=true"
width="400" height="456" align="center">
</picture>

The results will be saved to the database as any other Source Reconstruction method mentioned in the tutorials.

Double-click on it on the new file **and** the sensor data to explore visually the sources as they evolve in time.

# Performance Evaluation with synthetic data

Unlike the Brainstorm implementation, the performance metrics were not designed with the final user in mind. Instead, they are designed to make it easier to implement different types of synthetic data, hyperparameter tuning heuristics, ESI solvers, performance metrics, and posterior analysis.

They are available to the public, hoping that future work can be implemented faster.

## Setup

1. Download the contents of the `Pure Matlab` folder. Although this folder can be renamed safely, it will be referred to as such for ease of notation.

2. Inside the `Pure Matlab` folder, create a folder named `data`.

3. Download the folder `anat_ref` from [this link](https://drive.google.com/drive/folders/1bwrJiAwzQgX9c09XAP01Bx7J5I7iN4oC?usp=sharing) and copy it inside the `Pure Matlab` folder. This folder was excluded from the repository because it included large files.

### Custom anatomical data

The folder `anat_ref` contains anatomical data from the ICBM152 template and two head models made from (1) sources at the cortex whose orientation is orthogonal to it and (2) approximately 5,000 dipoles on the brain volume with free orientation.

- If you have anatomical data already loaded into the Brainstorm database, export the head and cortex surfaces to the Matlab workspace as `cortex` and `head`, respectively. Save both variables into a single file in the `anat_ref` folder.

- If you have the head model already loaded into the Brainstorm database, export it to the Matlab workspace as `forward`. Save this variable to a file in the `anat_ref` folder.

Using a forward model with anatomical data from another subject will make the identification of dipoles inside the brain fail.

The original purpose of using two separate files is to consider multiple head models for the same subject, enabling the exploration of model misspecification: what if the true source is at the cortex, but a volume model is used? What if the true source was modeled using one grid, but the inverse solution was computed using a different grid?

## Execution

This set of scripts is designed to be modular and personalizable. 

Interchange of data between functions is done using data structures (_structs_). The main structures are:
* `info`: parameters for the whole simulation.
* `meta`: data constant for each case. For example the SVD-decomposed leadfield matrix, the locations of distributed dipoles, the SNR level, etc.
* `result`: data specific to each individual trial. For example the EEG data, the location of the true source patch, the true magnitudes of the distributed dipoles, etc.
* `solution`: data specific for the estimated magnitudes of distributed dipoles. **This data is not saved to memory.**
* `params`: parameters for each single solver, constant over each case. 
* `checklist`: track of which estimators have been used over each trial.
* `evaluation`: performance metrics, computed for each trial and estimator.

Within this framework, the workflow occurs as follows:
1. Open `~/scripts/run_all.m` and fill the relevant information to `info`. Then run.
2. The function `~/scripts/generator.m` is called. 
   * The excecution loops over source patch shape (`profile`), SNR level, and individual trials.
   * A folder with the name on `info.tagName` is created on `~/data/`; inside of it, one folder level per each loop is created.
   * The function on `info.ProtocolFun` is called to generate the synthetic data.
   * The synthetic data (`result`) is saved to a file, using one file per each trial.
   * The variables `params`, `checklist`, and `solution` are initialized and saved to file, using one file per each inner loop.
3. The function `~/scripts/evaluator.m` is called. 
   * The set of available source estimators is determined from the contents of the folder `~/solvers/`.
     * Subroutines may be included in the folder `~/solvers/sub/`, these are loaded but not recognized as solvers.
     * As a patch, I added the folder `~/solvers/skip/` to store solvers that are fully functional but I don't wan't to load.
   * The set of available performance metrics is determined from the contents of the folder `~/metrics/`.
     * The subfolders `~/metrics/sub/` and `~/metrics/skip/` are analogous as for the solvers.
   * **For parameter tuning,** the excecution loops over estimator method (`solver`), source patch shape (`profile`), SNR level.
     * For each file `ExampleSolver.m` on `~/solvers/`, there should be a file `ExampleSolver_tune.m` on `~/solvers/sub/`.
     * The tuning function will select random trials to use for parameter tuning using generalized cross-validation, L-curve, U-curve, or CRESO criteria.
     * Optimal parameters and other method-specific objects will be saved to `params`, using one file per each inner loop.
     * **_This functionality will be updated on a near future._**
   * The excecution loops over estimator method (`solver`), source patch shape (`profile`), SNR level, and individual trials.
   * For each solver/trial combination, the function `solver.m` is called.
   * The results are saved into `solution`, which is not saved to memory.
   * The excecution now loops over each performance metric.
     * The function `ExampleMetric.m` is called, and the result saved to the variable `evaluation`.
     * As of now, only one number per each perfomance metric is allowed.
   * After all performance metrics are evaluated on a single trial, the updated variable `evaluation` is saved to file. The variable `checklist` is also updated and saved to file.
4. The function `~/scripts/collector.m` is called. 
   * The excecution loops over estimator method (`solver`), source patch shape (`profile`), SNR level.
   * The contents of `evaluation` are converted to a table. This table is saved in `~/stats/tables/` under the name in `info.tag Name`, the file format is cvs.

The purpose of the checklist is to add robustness against interruptions in execution, especially unintentional ones. That is also the reason for a separate `collector` function.

The collection of source estimator algorithms, perfomance metrics, and source patch protocols follow their description in my PhD dissertation, available
[here](https://mavmatrix.uta.edu/math_dissertations/162/).
Repating their description is quite wasteful, so the interested reader may refer to the original material.

It is important to acknowledge that the collection of methods is quite small, yet functional. 
The original scope was bigger, and a larger portion of it may be fullfilled in the future.


**Last updated: Sep 05, 2024.**