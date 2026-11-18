# OptiLibre

OptiLibre is a free IDE (Integrated Development Environment) for building and
solving linear and mixed integer linear programming models with
[lp_solve](https://lpsolve.sourceforge.net/). It is written in Free Pascal /
Lazarus and uses the lp_solve 5.5 shared library.

[lp_solve](https://lpsolve.sourceforge.net/5.5/) is a free, open-source solver
for linear and mixed integer linear programming. It can handle continuous,
integer and binary variables, and is distributed as a shared library that
OptiLibre uses to solve models.

## Installation

### Windows

Download and run the [OptiLibre 6.0 Windows installer](https://github.com/MMunozMarquez/OptiLibre/raw/refs/heads/main/windows-installer/OptiLibre-Setup-6.0.exe),
then follow the setup wizard. The installer is for 64-bit Windows.

### Linux

Download the Debian package for 64-bit (amd64) systems:
[optilibre_6.0_amd64.deb](https://github.com/MMunozMarquez/OptiLibre/raw/refs/heads/main/linux-package/optilibre_6.0_amd64.deb).
To install it with APT, open a terminal in your Downloads folder and run:

```sh
sudo apt install ./optilibre_6.0_amd64.deb
```

APT installs the package's required dependencies. Alternatively, open the
downloaded package with any package installer available on your system. After
installation, launch OptiLibre from your applications menu or by running
`optilibre`.

## Main window

The main window has a menu, a toolbar and these tabs:

| Tab | Purpose |
|-----|---------|
| **Editor** | Model editor with syntax highlighting |
| **Data** | MathProg `.dat` file editor (shown when needed) |
| **Matrix** | Matrix view of the model |
| **Options** | All solver options |
| **Results** | Solution, constraints, sensitivity and duals |
| **Log / Messages** | Messages from the solver and the IDE |

The status bar shows the solver status, time and, for models with integer
variables, the **GAP**. Hover over a status bar panel for a description.

## Model formats

* **LP format**, **fixed MPS**, **free MPS** and **MathProg** (`.mod` + `.dat`).
* **File > New** (or the toolbar) creates a new script in any of the four
  formats; **View** switches the current format.
* Open, Save and Save as. Unsaved changes are shown independently in the
  **Editor** and **Data** tab captions.
* **Conversion between formats:** when the format is changed, OptiLibre
  converts the model. Every format can be exported to MathProg (including LP
  and MPS models). If a conversion is not possible, a warning is shown.

## Editor

* Syntax highlighting for LP models.
* Cut, Copy, Paste, Undo and Redo.
* Find, Find next, Find previous, Replace and Goto line number.
* **Export Source** to HTML, RTF or LaTeX.

## MathProg and data files

Open a MathProg `.dat` file to load it into the **Data** tab.

* Opening a MathProg model without a `data` section asks whether to load a
  matching `.dat` file. The loaded data, including unsaved edits, is used when
  solving.
* With an inline `data` section the model's data is used; the Data tab is
  closed (asking to save unsaved edits first). If a `.dat` is opened anyway,
  the Data tab caption turns red to show that it will not be used.
* Before solving a model without inline data, OptiLibre asks whether to use a
  loaded `.dat` with a different name, or to choose a data file. A `.dat` with
  the same name as the script is used automatically.

## Solving

* **Solve** runs the model. **Stop** aborts the solve.
* **Solve relaxed** (red icon after Solve) ignores integer and semi-continuous
  restrictions and solves the relaxed model. It warns and does not solve if
  the model has SOS constraints, as `lp_solve -noint` does.
* **Solve basis** solves starting from a `.bas` basis file; **Save basis**
  saves the basis after a successful solve (unavailable after the model or its
  format changes).
* **Syntax Check** validates the script without solving.
* **Statistics** shows model statistics.
* For MILP models the GAP panel shows the gap between the best integer
  solution found and the best bound, with two decimals. At an optimal stop it
  shows the real gap when it can be computed, otherwise the relative gap
  allowed in Options. It is hidden for models without integer restrictions
  and with Solve relaxed.

## Results

Result tables are cleared when a solve starts. For models with integer
variables each improved solution is shown in its own column (**MILP
Feasible** for the first, **MILP Better** for the following) and a final
**result** column shows the optimal one. Columns resize to show full values.

Tabs:

* **Objective** – objective function and variable values.
* **Constraints** – constraint values.
* **Sensitivity > Objective** – objective function sensitivity ranges.
* **Sensitivity > Duals** – dual values and ranges. If sensitivity is not
  available, only the header with "Sensitivity unavailable" is shown.

Features common to all result tables:

* **Sort** by clicking a column header.
* **Filter row:** the first row under the header is empty and editable. Click
  a cell and type text to show only the rows whose value in that column
  contains the text (case-insensitive). Filters on several columns are
  combined (all must match). The *Objective* row is always shown. Filters are
  cleared when a new solve starts.
* **Context menu** options:
  * **Show all integer solutions** – show every solution found, or only the
    latest. It does not affect the solver.
  * **Show only non-null values** (Objective and Duals tabs) – hide rows whose
    values are all null; a value is null if its absolute value is below the
    *Epsel* option.
* Search (Find) also works on the visible rows of the active result table.

## Export

* **Export Matrice** – matrix as CSV, HTML or RTF.
* **Export Result** – Objective and Constraints tables as CSV, HTML or RTF.
* **Export Sensitivity** – Objective and Dual tables as CSV, HTML or RTF.
* Exports contain only the visible (non-filtered) rows.

## Options

The **Options** tab contains the lp_solve options grouped by topic, including
the **Output** tab: *Messages* (Verbose first, then message flags),
*Debugging* and *Solutions* (Show all integer solutions, Show only non-null
values, Print Sol).

* An option changed since the program started or since the defaults were last
  saved is shown in **blue**; one that differs from the lp_solve default is
  shown in **bold**.
* Press **F1** on an option to open its help page; hover for a hint.
* **Options > Solver** menu: Save solver options, Load solver options, Save
  solver options as default and Restore default solver options. The default file is
  `~/.config/OptiLibre/default.ini`.
* **Options > Display** menu: *Increase text size* (Ctrl++), *Decrease text
  size* (Ctrl+-) and *Default text size* (Ctrl+0), or Ctrl+mouse wheel, change
  the text size of the editors, Log and Messages. The *Clear Log and Messages
  when solving* option is enabled by default and clears both tabs whenever a
  solve, relaxed solve or basis solve starts. On exit OptiLibre asks whether to
  save changed display settings as default in `~/.config/OptiLibre/ui.ini`.
  *Save display settings* and *Load display settings* store them in, or read
  them from, a file; they are independent of the Solver options.

## About

OptiLibre 6.0.0 is developed with [Lazarus](https://www.lazarus-ide.org/) by
[M. Munoz-Marquez](https://github.com/MMunozMarquez/OptiLibre). It is licensed
under the [GNU GPL](https://www.gnu.org/licenses/licenses.html#GPL).

### Based on LPSolve IDE v5.5

Authors:

* Henri Gourvest ([hgourvest@progdigy.com](mailto:hgourvest@progdigy.com))
* William Patton
* Peter Notebaert

### lp_solve

Authors:

* Michel Berkelaar ([michel@ics.ele.tue.nl](mailto:michel@ics.ele.tue.nl))
* Jeroen Dirks ([jeroend@tor.numetrix.com](mailto:jeroend@tor.numetrix.com))
* Kjell Eikland ([kjell.eikland@broadpark.no](mailto:kjell.eikland@broadpark.no))
* Peter Notebaert ([peno@mailme.org](mailto:peno@mailme.org))

* [lp_solve documentation and downloads](https://lpsolve.sourceforge.net/5.5/)
* [lp_solve discussion group](https://groups.google.com/g/lp_solve)

### Third-party components

* **xli_MathProg**, by Kjell Eikland
  ([kjell.eikland@broadpark.no](mailto:kjell.eikland@broadpark.no);
  [XLI documentation](https://lpsolve.sourceforge.net/5.1/XLI.htm)).

