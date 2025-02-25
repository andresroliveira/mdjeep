
# MD-jeep, version 0.3.2

The Branch & Prune algorithm for Discretizable Distance Geometry
Copyright (C) 2022, A. Mucherino, D.S. Goncalves, C.
Lavor, L. Liberti, J-H. Lin, N. Maculan
GNU General Public License v.3

This program is free software: you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <https://www.gnu.org/licenses/>.

Since version 0.3.0, MDjeep is able to solve instances containing both exact and interval distance values.
Although initially written for problems arising in the context of structural biology, MDjeep is a general
solver capable to solve instances from various applications. General "graph" notions are therefore employed
(vertex, distance edge).

Discretizable Distance Geometry consists of a subclass of problems for which the search space can be discretized
and reduced to a tree. Given a graph $G=(V,E,d)$, with vertex set $V$, edge set $E$ indicating whether the distance
between two vertices is known or not, and a weight function d providing the numerical values for such distances,
an instance of this problem falls in the discretizable subclass where there exist a vertex order on V such that:

1. the first 3 vertices in the order form a clique with exact distances;
2. for all other vertices with rank $i > 3$, there must exist three reference vertices $j_1$, $j_2$ and $j_3$, such that:

$$ j_1 < i, j_2 < i, j_3 < i, (j_1,i) \in E, (j_2,i) \in E, (j_3,i) \in E. $$

In this version, we suppose that only one of the three distances $d(j_1,i)$, $d(j_2,i)$ and $d(j_3,i)$ can be represented
by an interval, while the others are supposed to be exact (ie, its lower and upper bounds are closer than the
predefined error tolerance).

Two methods are currently implemented in MDjeep for the solution of the instances. The Branch-and-Prune (BP)
algorithm is specifically designed to solve instances satisfying the discretization assumptions given above.
The Spectral Projected Gradient (SPG) is an algorithm for local optimization, which may be either run alone,
or as a refinement step in BP. For more information, please refer to our list of publications below.

Since version 0.3.2, MDjeep accepts in input MDfiles (with mdf extension). These are text files containing some
main specifications for loading the problem instances, and for running the solution methods:

Syntax:

```bash
make
./bin/mdjeep [options] mdfile.mdf
```

The MDfile is supposed to contain the specifications for a certain number of predefined "fields". Every field
key-word is followed by its name; key-word and name need to be separated by a colon (:). Every value given
in MDfiles appears on a single line and needs to respect the following syntax (blank characters and tabs cannot
be contained in names or values, as they both act as separators):

 name [colon] value

After the definition of a field's name, every new line starting with the key-word "with" allows to set up one
of the attributes of the field. Some attributes may have default values, so that it is not strictly necessary
to specify them in the MDfile; other attributes are mandatory and their absence in the MDfile will cause the
termination of MDjeep with code 1.

In the MDfile, the first mandatory field is "instance". Any string of characters is a valid name for the instance.
The attributes "file", "format" and "separator" need to be specified in the MDfile in the subsequent lines
starting with the key-word "with":

- file: it's the path and name of the distance file, where distances are arranged line by line
- format: it's the format that MDjeep expects to find for the distance file
- separator: this is the character that serves as a separator in the distance file
The format can include the following elements:
- Id1 (nonnegative integer, mandatory), identifier of vertex 1 (in the line)
- Id2 (nonnegative integer, mandatory), identifier of vertex 2 (in the line)
- groupId1 (integer), group identifier of vertex 1
- groupId2 (integer), group identifier of vertex 2
- Name1 (char string), the name of vertex 1
- Name2 (char string), the name of vertex 2
- groupName1 (char string), the group name of vertex 1
- groupName2 (char string), the group name of vertex 2
- lb (double, mandatory), the lower bound for the distance between vertex 1 and 2
- ub (double, mandatory), the upper bound for the distance between vertex 1 and 2
Notice that:
- if the distance file contains additional information that MDjeep does not need to load, the format element
  "ignore" can be used to skip this information;
- the integer vertex labels need to be consecutive, but the smallest label is not supposed to be equal to 0
  (neither to 1); the only constraint for the smallest label is that it needs to be nonnegative;
- the format compatible with MDjeep versions 0.1 and 0.2 is "Id1 Id2 lb ub Name1 Name2 groupName1 groupName2";
- the format introduced in MDjeep 0.3.0 is "Id1 Id2 groupId1 groupId2 lb ub Name1 Name2 groupName1 groupName2";
- the separator is one single character, and it needs to be specified between single quotes; blank characters
  and tabs are always separators, so if not specified, the default separators are all blank characters and tabs.

Another mandatory field of the MDfile is the "method". Two method names can be specified in the current version
of MDjeep: either "bp", or "spg" (see above). In both cases, a predefined set of attributes can then be specified
on the following lines of the MDfile with the key-word "with". The reader can refer to the examples of MDfile
provided with our instances to discover the several attributes that can be set up. Many of such attributes have
default values: if not specifed in the MDfile, the default value are automatically used. Other attributes are
mandatory: when using SPG as a main method, for example, the path and name of the text file containing the starting
point (attribute "startpoint"), as well as the maximum number of iterations (attribute "maxit"), both need to be
specified. In this version of MDjeep, it is mandatory for the bp method to have a refinement method: this can be
specified via the field "refinement". Since only bp and spg are currently implemented in MDjeep, the only option
for bp for a refinement method is currently spg. The key-word "with" can be invoked multiple times for the
same attribute in the same MDfile: in such a case, the last specified value is the one that will actually be
considered.

Notice that it is possible to include comments in the MDfiles: very line starting with the character '#' is
ignored by MDjeep. Even if not specified as a separator, blank characters and tabs cannot be part of attribute
values, and therefore they work as sort of "general separators".

MDjeep options (you can access to this list by running MDjeep without arguments):
          -1 | the specified method stops at the first solution (always true for SPG)
          -l | specifies after how many solutions the method should stop (applies only to BP)
        -sym | only one symmetric half of the tree is explored (for BP, argument may be 1 or 2)
          -p | prints the best found solution in a text file
          -P | prints all found solutions (in the same text file)
             |  (when using -1, options -p and -P have the same effect)
          -f | specifies the output format (default is "xyz", may be changed to "pdb")
     -consec | verifies whether the consecutivity assumption is satisfied
  -nomonitor | does not show the current layer number during the execution to improve performance
          -r | obsolete, resolution parameter can now be specified in MDfile (method field)
          -e | obsolete, tolerance epsilon can now be specified in MDfile (method field)
          -v | obsolete, file formats can now be specified in MDfile (instance field)

Notice that the use of option -nomonitor can actually improve MDjeep performances; moreover, it is recommended
to use it when redirecting stdout to a file.

Since this version of MDjeep, part of the parameters can be specified through the MDfile, another part through
the input arguments. This separation is supposed to keep on one side the parameters that are related to a
specific method (the method attributes in the MDfile) and on another side the parameters that are generic (the
MDjeep input arguments), such as the printing parameters. As new methods will be added to MDjeep, this separation
may be subject to change: we'll try our best to guarantee the compatibility for future versions of MDjeep, at
least for near versions.

Example of use for solving protein instances with low precision distances (proteinSet2) :

```sh
mdjeep -1 instances/0.3/proteinSet2/proteins.mdf
```

If MDjeep takes too long to solve your instance, you can terminate it with the ^C signal and verify the current
partial solution in the output file (it will be created before termination if one of the two options -p or -P
were used).

If you refer to this sofware in your publications, please cite the appropriate paper(s).
Follows a list of main publications:

 [1] A. Mucherino, J-H. Lin,
     An Efficient Exhaustive Search for the Discretizable Distance Geometry Problem with Interval Data,
     to appear in IEEE Conference Proceedings, Federated Conference on Computer Science and Information Systems (FedCSIS19),
     Workshop on Computational Optimization (WCO19),
     Leipzig, Germany, September 2019. (in "publication-ref.pdf")

 [2] A. Mucherino, J-H. Lin, D.S. Gonçalves,
     A Coarse-Grained Representation for Discretizable Distance Geometry with Interval Data,
     Lecture Notes in Computer Science 11465, Lecture Notes in Bioinformatics series, I. Rojas et al (Eds.),
     Proceedings of the 7th International Work-Conference on Bioinformatics and Biomedical Engineering (IWBBIO19), Part I,
     Granada, Spain, 3-13, 2019.

 [3] D.S. Gonçalves, A. Mucherino, C. Lavor, L. Liberti,
     Recent Advances on the Interval Distance Geometry Problem,
     Journal of Global Optimization 69(3), 525-545, 2017.

 [4] D.S. Gonçalves, A. Mucherino,
     Discretization Orders and Efficient Computation of Cartesian Coordinates for Distance Geometry,
     Optimization Letters 8(7), 2111-2125, 2014.

 [5] V. Costa, A. Mucherino, C. Lavor, A. Cassioli, L.M. Carvalho, N. Maculan,
     Discretization Orders for Protein Side Chains,
     Journal of Global Optimization 60(2), 333-349, 2014.

 [6] L. Liberti, C. Lavor, N. Maculan, A. Mucherino,
     Euclidean Distance Geometry and Applications,
     SIAM Review 56(1), 3-69, 2014.

 [7] D.S. Gonçalves, A. Mucherino, C. Lavor,
     An Adaptive Branching Scheme for the Branch & Prune Algorithm applied to Distance Geometry,
     IEEE Conference Proceedings, Federated Conference on Computer Science and Information Systems (FedCSIS14),
     Workshop on Computational Optimization (WCO14),
     Warsaw, Poland, 463-469, 2014.

 [8] A. Mucherino, C. Lavor, L. Liberti, N. Maculan (Eds.),
     Distance Geometry: Theory, Methods and Applications,
     410 pages, Springer, 2013.

 [9] C. Lavor, L. Liberti, A. Mucherino,
     The interval Branch-and-Prune Algorithm for the Discretizable Molecular Distance Geometry Problem with Inexact Distances,
     Journal of Global Optimization 56(3), 855-871, 2013.

[10] A. Mucherino,
     On the Identification of Discretization Orders for Distance Geometry with Intervals,
     Lecture Notes in Computer Science 8085, F. Nielsen and F. Barbaresco (Eds.),
     Proceedings of Geometric Science of Information (GSI13),
     Paris, France, 231-238, 2013.

[11] A. Mucherino, C. Lavor, L. Liberti,
     The Discretizable Distance Geometry Problem,
     Optimization Letters 6(8), 1671-1686, 2012.

[12] A. Mucherino, C. Lavor, L. Liberti,
     Exploiting Symmetry Properties of the Discretizable Molecular Distance Geometry Problem,
     Journal of Bioinformatics and Computational Biology 10(3), 1242009(1-15), 2012.

[13] C. Lavor, L. Liberti, N. Maculan, A. Mucherino,
     The Discretizable Molecular Distance Geometry Problem,
     Computational Optimization and Applications 52, 115-146, 2012.

[14] C. Lavor, L. Liberti, A. Mucherino,
     On the Solution of Molecular Distance Geometry Problems with Interval Data,
     IEEE Conference Proceedings, International Workshop on Computational Proteomics (IWCP10),
     International Conference on Bioinformatics & Biomedicine (BIBM10),
     Hong Kong, 77-82, 2010.

[15] A. Mucherino, L. Liberti, C. Lavor,
     MD-jeep: an Implementation of a Branch & Prune Algorithm for Distance Geometry Problems,
     Lectures Notes in Computer Science 6327, K. Fukuda et al. (Eds.),
     Proceedings of the 3rd International Congress on Mathematical Software (ICMS10),
     Kobe, Japan, 186-197, 2010.

The complete list of publications can be found at <https://www.antoniomucherino.it/en/publications.php>
