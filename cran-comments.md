- [x] Please omit the redundant "in R" at the end of your title.

- [x] Please do not start the description with "This package", package name,
title or similar.

- [x] Please use only undirected quotation marks in the description text.
e.g. `skim` --> 'skim', etc...

- [x] Please add () behind all function names in the description texts
(DESCRIPTION file) and omit the quotes. e.g: --> diffdf()

- [ ] Please add small executable examples in your Rd-files to illustrate the
use of the exported function but also enable automatic testing.

- [ ] Please ensure that your functions do not write by default or in your
examples/vignettes/tests in the user's home filespace (including the
package directory and getwd()). This is not allowed by CRAN policies.
Please omit any default path in writing functions. In your
examples/vignettes/tests you can write to tempdir().
-> R/render_data_report.R
For more details:
<https://contributor.r-project.org/cran-cookbook/code_issues.html#writing-files-and-directories-to-the-home-filespace>

- [x] Please always add all authors, contributors and copyright holders in the
Authors@R field with the appropriate roles.
 From CRAN policies you agreed to:
"The ownership of copyright and intellectual property rights of all
components of the package must be clear and unambiguous (including from
the authors specification in the DESCRIPTION file). Where code is copied
(or derived) from the work of others (including from R itself), care
must be taken that any copyright/license statements are preserved and
authorship is not misrepresented.
Preferably, an ‘Authors@R’ would be used with ‘ctb’ roles for the
authors of such code. Alternatively, the ‘Author’ field should list
these authors as contributors. Where copyrights are held by an entity
other than the package authors, this should preferably be indicated via
‘cph’ roles in the ‘Authors@R’ field, or using a ‘Copyright’ field (if
necessary referring to an inst/COPYRIGHTS file)."
e.g.: -> "datareportR core developer team" in your LICENSE file
Please explain in the submission comments what you did about this issue.