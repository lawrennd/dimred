%{
\begin{octave}
  %}
  % Comment/MATLAB set up code
  importTool('dimred')
  dimredToolboxes
  global printDiagram
  printDiagram = 1
  randn('seed', 1e6)
  rand('seed', 1e6)
  if ~isoctave
    colordef white
  end
%{
\end{octave}
%Start of Comment/MATLAB brackets


\chapter{Thinking in High Dimensions}



To make full use of the computing power available to us today we need
to interface the real world to the computer. To represent a real world
object for processing by a computer, we are typically required to
summarize that object by a series of
\emph{features}\glossary{name={features}, description={in machine
    learning a feature is a characteristic of the data, often
    represented by a number. For a human being some features might be
    height (in centimeters), weight (in kg) and eye color. For eye
    color a one of-$n$ (or nominal) encoding might be used.}}
represented by numbers. As a representation of an object becomes more
complex, the number of features required typically increases. Examples
of objects we might want to process in this way include:

\begin{description}
\item[a customer in a data base,] where the features might include
  their purchase history, where they live, their sex, and age;

\item[a digitized photograph,] where the features include the pixel
  intensities, time, date, and location of the photograph;

\item[human motion capture data for the movie and games industries,]
  where features consist of a time series of angles at each joint;

\item[human speech,] where the features consist of the energy at
  different frequencies (or across the cepstrum) as a time series;

\item[a webpage or other document,] where the features may consist of
  frequencies of given words as they appear in a set of documents and
  linkage information between documents;

\item[gene expression data,] where the features consist of the level
  of expression of thousands of genes, perhaps across a time series,
  or under different disease conditions.
\end{description}

As the complexity of the representation increases, a more accurate
representation of the underlying object is realized. However,
simultaneously we need to deal with more and more features. Data of
this type is known as high dimensional data.

Data is the raw material of machine learning, models are the tools
with which we can process the raw material to make interpretations of
the data: for example categorization of a documents subject,
transcription of spoken language, or classification of disease.
Matching the right model to the data is a crucial first step in
approaching a learning task. In this book we are interested in
\emph{dimensionality reduction}. This is the process of taking data
with a lot of features, or dimensions, and summarizing it with a lower
dimensional representation. It is not the only machine learning
approach available, but it is often used either as a
\emph{preprocessing}\glossary{name={preprocessing}, description={is a
    term used to describe operations applied to data before a further
    algorithm is applied. Dimensionality reduction is often used as a
    preprocessing step for classification or regression.}} step or as
In the first part of the book we will try and motivate why this might
be a sensible approach to dealing with data. Our starting point will
be to develop our understanding of \emph{why} high dimensional data is
special.  It is only by understanding its characteristics that we can
then really think about how to model it. In a successful application
of machine learning the data and the model should work in partnership.

Machine learning is already a very technical subject, and is perhaps
becoming more so. However, in this book we will try and rely more on
intuitions and analogy, with technical material for back up. Reliance
on intuition can be a dangerous thing. We are often fooled by our
particular perspective on a problem: our intuitions can fail. This
doesn't mean we should reject them. Rather, our approach will be to
try and understand when and how they are wrong. However, we should
always proceed with a little caution and bear in mind that ``Proof by
analogy is fraud'' \cite[][page 692]{Stroustrup:tc++pl00}.

A common approach to getting an intuition across is to use a ``toy''
data set to illustrate how an algorithm works. By focusing on toy
data we can get a much better idea of a particular facet of a learning
problem. Such toy data sets can be useful, giving intuitions about
the learning scenario that generalize well to real world problems.
However, such toy examples can also mislead. They can present an overly
simple perspective on a particular learning problem. One of the approaches
to understanding dimensionality reduction we will use in this book
is to explore these toy problems and to use them to think about when,
how and if they fail. Through better understanding of the data we
hope to develop better models and ultimately improved performance
of our learning algorithms.

\begin{boxfloat}
  \caption{Probability notation}\label{box:probability}

  \boxfontsize In this book we will make extensive use of
  probabilistic modeling to represent data. In this box we give a
  short introduction to the probabilistic notation we use.

  A probability distribution is defined over a set of a discrete
  number of possible outcomes for a variable, $S$. For example if we
  were considering a die roll we would have $S={1,2,3,4,5,6}$. The
  distribution is a function that maps from an observed state for $S$
  to a probability. If the observed state is defined to be $s$ then we
  write $P(S=s)$. The probability distribution is defined to be
  positive, and normalized, so that the sum across all possible
  states, $\sum_{S}P(S)=1$.

  A probability density is defined over a continuous space, $X$. For
  example, we might consider a density of the heights of computer
  science students. The value of a density at a given height is given
  by $p(X=x)$, which is defined to be a positive number. It is
  important to note though that this is \emph{not} a probability. A
  probability density is defined to integrate to 1 over the range of
  values in $X$ which are valid,
  \[
  \int_X p(X=x) \mathrm{d}x = 1.
  \]
  We can interrogate the density about any range of values for $X$ for
  which the answer is a discrete outcome. We can express that answer
  in the form of a probability. For example, we define $S={0,1}$ where
  $0$ represents a height being less than $2\mathrm{m}$ and $1$
  indicates it is greater or equal. We can recover a distribution from
  the density as follows
  \[
  P(S=(X\geq 2)) = \int_{2}^\infty p(X=x) \mathrm{d}x.
  \]

  In practice we normally use a shorthand notation for distributions
  and densities, we tend to drop the explicit notation of the event,
  \[
  p(X=x)\equiv p(x).
  \]
  This avoids ``crowding'' of the notation, but it can lead to
  confusion. We use this convention throughout this book. Until you
  are comfortable with it, you may find it useful to rewrite formulae
  with the full notation to remind yourself of their meaning.
\end{boxfloat}

\section{\index{clustering}Clustering}

A recurring plot that is shown in talks on machine learning,
particularly those on clustering, is a configuration of data points in
two dimensions such as those shown in \reffig{fig:clusteredTwoDimensionalData}(a).  At first glance, the data
appears quite realistic. The density of the data points varies
considerably as we move around the plot. The data seems to be
clustered, but not in a uniform manner: some clusters are tighter than
others. The clusters also seem to be somewhat randomly distributed
around the plot. At some point during the talk, a slide containing a
fit to the data, such as that in \reffig{fig:clusteredTwoDimensionalData}(b) is shown. This figure shows
the means and variances of a mixture of multivariate (two dimensional)
Gaussian densitys\index{mixture of Gaussians}
\textbackslash{}cite\{mclachlan\}.  The fit seems to be a good
approximation to the data.

Models of this type can also be justified by appeals to our intuition.
The way I like to think of these mixture models is as a summary of the
data by a series of prototypes (represented by the means of the
Gaussian components of the mixture density). These prototypes are
subject to distortions. The density associated with each component
represents the range of distortions that the data can undergo. In the
case of the mixture of Gaussians, the distortions are of the form of
adding zero mean, Gaussian\index{Gaussian density} distributed, random
noise with a particular covariance matrix. \fixme{How does the presence of prototype Gaussian densities affect
  the distance from the mean---how does it affect the density of
  interpoint squared distances. Need to cover this.}

\begin{boxfloat}
  \caption{The Gaussian Density}\label{box:gaussian}
  \boxfontsize
  The Gaussian density\index{Gaussian density}, or strictly
  speaking, the multi-variate Gaussian density will dominate our
  discussions in this book. The Gaussian density appeared,
  independently, as an approximation to the binomial
  \cite{DeMoivre:approximatio33}\index{De Moivre, Abraham} and as an
  approximation to the posterior density in a Bayesian analysis of
  biased coins \index{Laplace, Pierre Simon}\cite{Laplace:memoire74}.
  % \footnote{Ironically, we would today consider this system tractable
  %   --- it was a beta-binomial system for which the posterior is a beta
  %   density.}. 
  Both derived it by considering series expansions about the mode of a
  distribution of interest. The density is more commonly associated
  with Gauss due to his explicit use of it for modeling the
  ``distribution of error'' to justify least squares approaches
  \cite{Gauss:theoria09}\index{Gauss, Carl Friedrich}.

  The multivariate generalization of the Gaussian
  density\index{multivariate Gaussian density|see{Gaussian density}}
  takes the form
  \[
  \gaussianDist{\mathbf{y}}{\meanVector}{\covarianceMatrix}=\frac{1}{\left(2\pi\right)^{\frac{\dataDim}{2}}\det{\covarianceMatrix}^{\frac{1}{2}}}=\exp\left(-\frac{1}{2}\left(\dataVector-\meanVector\right)^{\top}\covarianceMatrix^{-1}\left(\dataVector-\meanVector\right)\right),
  \]
  where we refer to $\meanVector$ as the mean and
  $\covarianceMatrix$ as the covariance matrix. The notation
  $\det{\cdot}$ represents the determinant of a matrix. In the
  multivariate Gaussian it is part of the normalization term ensuring
  the density integrates to unity. Determinants often arise in
  association with volumes: see \refbox{box:determinant} for the
  intuition behind this. Our density is defined over over $\dataVector$ which
  is a $\dataDim$ dimensional vector,
  $\dataVector\in\mathbb{R}^{\dataDim\times 1}$. The mean is the first
  moment of the density,
  \[
  \meanVector=\expectationDist{\dataVector}{\gaussianDist{\dataVector}{\meanVector}{\covarianceMatrix}}=\int\dataVector\gaussianDist{\dataVector}{\meanVector}{\covarianceMatrix}\mathrm{d}\dataVector,
  \]
  whilst the covariance gives the expected \emph{squared deviation}
  about the mean,
  \[
  \covarianceMatrix=\expectationDist{\left(\dataVector-\meanVector\right)\left(\dataVector-\meanVector\right)^{\top}}{\gaussianDist{\dataVector}{\meanVector}{\covarianceMatrix}}=\int\left(\dataVector-\meanVector\right)\left(\dataVector-\meanVector\right)^{\top}\gaussianDist{\dataVector}{\meanVector}{\covarianceMatrix}\mathrm{d}\dataVector.
  \]
  The \index{covariance matrix}covariance matrix is constrained to
  be positive definite. 

  The Gaussian density has some interesting properties, the sum of two
  Gaussian variables is also Gaussian.  And, under certain conditions,
  the sum of very many non-Gaussian variables tends to be
  Gaussian. This is known as the central limit theorem, an early
  version of which was proposed by Laplace\index{Laplace, Pierre
    Simon} \cite{Laplace:nombres10}, see \refbox{box:central}.

  \noindent\textbf{Properties of the Gaussian Density}

  \begin{itemize}
  \item A multivariate Gaussian is fully specified by its mean vector and
    covariance matrix.
    
  \item All the marginal densities of a Gaussian are also Gaussian. 
    
  \item All the conditional densities of a Gaussian are also Gaussian.
  \end{itemize}
  \fixme{Marginalization property?}
\end{boxfloat}

\begin{boxfloat}
  \caption{The Determinant of a Matrix}\label{box:determinant}

  \boxfontsize The determinant of a matrix will arise various times
  throughout this book. A full course in linear algebra is beyond the
  scope of this text but it is certainly worth attempting to give some
  intuitions about important concepts. The intuition we want to get
  across is the determinant as an assessment of volume.

  The area of a square is its width multiplied by length. The volume of
  a cube is width multiplied by length multiplied by height. In general
  hyper cubes have a volume equal to the product of their
  dimensions. Lets represent each dimension of a hypercube by
  $\eigenvalue_i$. The volume of a $\dataDim$-dimensional hypercube is
  then given by
  \[
  V = \prod_{i=1}^\dataDim \eigenvalue_i.
  \]
  We can think of the vector $\eigenvalueVector$ as an orthogonal basis
  which describes the hypercube, we can define the coordinates of the
  vectors associated with this basis by introducing
  $\eigenvalueMatrix$. The diagonal elements of $\eigenvalueMatrix$ are
  given by $\eigenvalueMatrix_{i, i} =\eigenvalue_i$. The matrix thereby
  defines a set of $\dataDim$ axis aligned vectors, each one with a
  length of $\eigenvalue_i$. We can rotate this basis to rotate the cube
  using multiplication by a rotation matrix, $\eigenvectorMatrix$, where
  $\eigenvectorMatrix^\top \eigenvectorMatrix = \eye$ (i.e. it has
  orthonormal vectors). So we have a new basis for the cube,
  $\mappingMatrix=\eigenvectorMatrix \eigenvalueMatrix$. The determinant
  of this matrix still gives the volume of the hypercube:
  $\mappingMatrix=\prod_{i=1}^\dataDim \eigenvalue_i$.

  The determinant is insensitive to pre-multiplication and
  post-multiplication rotation by an orthonormal basis. A common linear
  algebraic decomposition of a matrix, $\mappingMatrix$, is the singular
  value decomposition (SVD)\index{singular value decomposition} (see
  \refbox{box:svd}) which involves a further rotation of
  $\mappingMatrix$,
  \[
  \weightMatrix = \eigenvectorMatrix \eigenvalueMatrix
  \rotationMatrix^\top
  \]
  where $\rotationMatrix^\top\rotationMatrix=\eye$. The insensitivity to
  rotation means that $\det{\eigenvectorMatrix \eigenvalueMatrix
    \rotationMatrix^\top}=\prod_{i=1}^\dataDim\eigenvalue_i$. 

  A slight problem with the above approach is that if an odd number of
  $\lambda_i$s are less than zero, then the volume will be returned as
  negative. This can be fixed by squaring and square-rooting the
  system. So we have $\sqrt{\left(\prod_{i=1}^\dataDim
      \lambda_i\right)^2=\left(\prod_{i=1}^\dataDim
      \lambda_i^2\right)}$ and we the volume of the hypercube is given
  by $\det{\Lambda^2}^{\frac{1}{2}}$.  Pre-multiplying and
  post-multiplying by $\eigenvectorMatrix$ we can see the volume is
  also given by
  $\det{\eigenvectorMatrix\Lambda^2\eigenvectorMatrix^\top}^{\frac{1}{2}}$. 

  The form $\eigenvectorMatrix\Lambda^2\eigenvectorMatrix$ is positive
  definite, due to the squaring of $\Lambda$. Any valid covariance
  matrix can be written in this form,
  $\covarianceMatrix=\eigenvectorMatrix\Lambda^2\eigenvectorMatrix$,
  so we see that for the multivariate Gaussian (\refbox{box:gaussian})
  $\det{\covarianceMatrix}^{\frac{1}{2}}$ is the volume of the basis
  given by the diagonal of $\Lambda$. The factor of
  $(2\pi)^{{\dataDim}{2}}$ that appears in the normalization constant
  for the multivariate Gaussian deals with the fact that the volume is
  the integral under the exponentiated negative quadratic, not that of
  a hypercube.
\end{boxfloat}

Such a model seems intuitively appealing. When the expectation
maximization approach to optimizing such powerful models was first
described by \cite{Dempster:EM77} the statistics community it must
have seemed to some that the main remaining challenge for density
estimation was principally computational. There are, of course,
applications for which for which a mixture of Gaussians\index{mixture
  of Gaussians} is an appropriate model (\emph{e.g.}  low dimensional
data). Such applications are not the focus of \emph{this} book. We are
more interested in the failings of the Gaussian mixture\index{mixture
  of Gaussians}. There are two foundation assumptions which underpin
this model. We described them both in our early appeal to
intuition. The first assumption is that the data is generated through
prototypes\index{data prototypes}. We will not consider this
assumption further. We will focus on the second assumption: how the
prototypes are corrupted to obtain the data we observe. For the
Gaussian mixture\index{mixture of Gaussians} model the prototypes are
corrupted by Gaussian noise with a particular covariance. It is this
second assumption that we would like to consider first. In particular,
we are going to examine the special case where the covariance is given
by a constant diagonal matrix. We will see that the behavior of a
Gaussian in low dimensional space can be quite misleading when we
develop intuitions as to how these densities behave in higher
dimensions. By higher dimensionality we can think of dimensionality
that is difficult to visualize directly, \emph{i.e.}\ dimensionality
greater than $\dataDim=3$.

\subsection{Dimensionality Greater than Three}

In higher dimensions \emph{models} that seem reasonable in two or
three dimensions can fail dramatically. Note the emphasis on models.
In this section, we are not making any statements about how a
`realistic' data set behaves in higher dimensions, we are making
statements about modeling failures in higher dimensions. In particular
we will focus on what assumptions the model makes about where the data
is distributed in higher dimensions. We will illustrate the ideas
through introducing the Gaussian egg. The Gaussian egg is a hard
boiled egg that consists of three parts: the yolk of the egg, the
white of the egg and a thin boundary shell between the yolk and the
white.  In an over boiled egg the boundary layer is often green from
iron sulfide formed by reactions between the white and the yolk,
giving a bad taste. We therefore refer to this as the ``green'' of the
egg. We will consider spherical Gaussian distributions which have
covariance matrices of the form $\dataStd^2\mathbf{I}$. We define the
volume of the density associated with the yolk as part of the egg that
is within $0.95\dataStd$ of the mean. The green is defined to be the
region from $0.95\dataStd$ to $1.05\dataStd$. Finally, the yolk is all
the density beyond $1.05\dataStd$. We assume the density of the egg
varies according to the Gaussian density, so that the density at the
center of the egg is highest, and density falls off with the
exponentiated negative squared Euclidean distance from the mean. We
take the overall mass of our egg to be one. The question we now ask is
how much of our egg's mass is now taken up by the three component
parts: the green, the white and the yolk. The proportions of the mass
are dependent on the dimensionality of our egg.

For a one dimensional Gaussian density the answer is found through
integrating over the Gaussian. We can find the portion of the Gaussian
that sits inside 0.95 of a standard deviation's distance from the mean
as
\[
\int_{-0.95\dataStd}^{0.95\dataStd} \gaussianDist{\dataScalar}{0}{\dataStd^{2}} \mathrm{d}\dataScalar.
\]
The other portions can be found similarly. For higher dimensional
Gaussians the integral is slightly more difficult. To compute it, we
will switch from considering the Gaussian density that governs the
data directly to the density over squared distances from the mean that
the Gaussian implies. Before we introduce that approach, show three
low dimensional Gaussian eggs in
\reffigrange{fig:oneDGaussianEgg}{fig:threeDGaussianEgg} indicating
their associated masses for the yolk, the green and the white.
% 
\begin{figure}
  \begin{center}
    \includegraphics[width=0.4\textwidth]{../diagrams/oneDgaussian_nobrown}
  \end{center}

  \caption{Volumes associated with the one dimensional Gaussian
    egg. Here the yolk has 65.8\%, the green has 4.8\% and the white
    has 29.4\% of the mass. }\label{fig:oneDGaussianEgg}
\end{figure}

\begin{figure}
  \begin{center}
    \includegraphics[width=0.4\textwidth]{../diagrams/twoDgaussian_nobrown2}
  \end{center}

  \caption{Volumes associated with the regions in the two dimensional
    Gaussian egg. The yolk contains 59.4\%, the green contains 7.4\%
    and the white 33.2\%}\label{fig:twoDGaussianEgg}

\end{figure}
\begin{figure}
  \begin{center}
    \includegraphics[width=0.4\textwidth]{../diagrams/threeDgaussian_nobrown}
  \end{center}

  \caption{Volumes associated with the regions in the three dimensional Gaussian egg. Here the yolk has 56.1\% the green has 9.2\% the white has 34.7\%}\label{fig:threeDGaussianEgg}
\end{figure}


\subsection{Distribution of Mass against Dimensionality }

For the three low dimensional Gaussians, we note that the allocation
of the egg's mass to the three zones changes as the dimensionality
increases. The green and the white increase in mass and the yolk
decreases in mass. Of greater interest to us is the behavior of this
distribution of mass in higher dimensions. It turns out we can compute
this through the cumulative distribution function of the gamma
density. 

We will compute the distribution of the density mass in the three
regions by assuming each data point is sampled independently from our
spherical covariance Gaussian density,
\[
\dataVector_{i, :} \sim \gaussianSamp{\zerosVector}{\dataStd^2\eye}
\]
where $\dataVector_{i, :}$ is the $i$th data point. Independence across features also means we can consider the density associated with the $k$th feature of the $i$th data point, $\dataScalar_{i,k}$,
\[
\dataScalar_{i,k}\sim\gaussianSamp{0}{\dataStd^{2}}.
\]
We are interested in the squared distance of any given sample from the
mean. Our choice of a zero mean Gaussian density means that the
squared distance of each feature from the mean is easily computed as
$\dataScalar_{i,k}^2$. We can exploit a useful characteristic of the
Gaussian to describe the density of these squared distances. The
squares of a Gaussian distributed random variable are known to be
distributed according the \emph{chi-squared density}\index{chi-squared
  density},
\[
\dataScalar_{i,k}^{2}\sim\dataStd^{2}\chi_{1}^{2},
\]
The chi squared density is itself a special case of the gamma
density\index{gamma density} with shape parameter $a=\frac{1}{2}$ and
rate parameter $b=\frac{1}{2\dataStd^{2}}$,
\[
\gammaDist{x}{a}{b}=\frac{b^{a}}{\Gamma\left(a\right)}x^{a-1}e^{-bx}.
\] 


\begin{boxfloat}
  \caption{The Gamma Density}\label{box:gamma}\index{gamma density}

  The Gamma is a density over positive numbers. It has the
  form
  \[ \gammaDist{x}{a}{b}=\frac{b^{a}}{\Gamma\left(a\right)}x^{a-1}e^{-bx}
  \] 
  where $a$ is known as the shape parameter and $b$ is known as a rate
  parameter. The function $\Gamma\left(a\right)$ is known as the gamma
  function and is defined through the following indefinite integral,
  \[
  \Gamma\left(a\right)=\int_{0}^{\infty}x^{a-1}e^{-x}\mathrm{d}x
  \]
  The mean of the gamma density is given by
  \[ 
  \expectationDist{x}{\gammaDist{x}{a}{b}}=\frac{a}{b}
  \] 
  and the variance is given by
  \[
  \varianceDist{x}{\gammaDist{x}{a}{b}}=\frac{a}{b^{2}}.
  \] 
  Sometimes the density is defined in terms of a scale parameter,
  $\beta=b^{-1}$, instead of a rate. Confusingly, this parameter is also
  often denoted by ``$b$''. For example, the statistics toolbox in
  \textsc{Matlab} defines things this way. The gamma density generalizes several
  important special cases including the exponential density with
  rate $b$, $\expDist{x}{b}$, which is the specific case where the shape
  parameter is taken to be $a=1$. The chi-squared density with one
  degree of freedom, denoted $\chiSquaredDist{1}{x}$, is the special case
  where the shape parameter is taken to be $a=\frac{1}{2}$ and the rate
  parameter is $b=\frac{1}{2}$.

  The gamma density is the conjugate density for the inverse variance
  (precision) of a Gaussian density. See \refbox{box:conjugacy} for
  more on conjugacy in Bayesian inference.

  Gamma random variables have the property that, if multiple gamma
  variates are sampled from a density with the same rate, $b$, and
  shape parameters $\left\{a_k\right\}^\dataDim_{k=1}$, then the sum
  of those variates is also Gamma distributed with rate parameter $b$
  and shape parameter $a^\prime = \sum_{k=1}^\dataDim a_k$.
\end{boxfloat}
So we have the squared distance from the mean for a single feature being given
by
\[
\dataScalar_{i,k}^{2}\sim\gammaSamp{\frac{1}{2}}{\frac{1}{2\dataStd^{2}}}.
\]
Of course, we are interested in the distance from the mean of the data
point given by $\dataVector_{i,:}=\left[\dataScalar_{i,1}, \dots,
  \dataScalar_{i,\dataDim}\right]^\top$. The \emph{squared} distance from the
mean of the $i$th data point will be given by $\sum_{k=1}^\dataDim
\dataScalar_{i,k}^2$. Fortunately, the properties of the gamma
density\index{gamma density} (see \refbox{box:gamma}) mean we can also compute the
density of the resulting random variable, in particular we have
\[
\sum_{k=1}^{\dataDim}y_{i,k}^{2}\sim\gammaSamp{\frac{\dataDim}{2}}{\frac{1}{2\dataStd^{2}}}.
\]
Using the properties of the gamma density we can compute the mean and
standard deviation of the squared distance for each point from the
mean,
\[
\expectation{\sum_{k=1}^{\dataDim}y_{i,k}^{2}}=\dataDim\dataStd^{2},
\]
which, we note, scales linearly with the dimensionality of the
data. The average squared distance of each feature will be distributed as
follows,
\[
\frac{1}{\dataDim}\sum_{k=1}^{\dataDim}y_{i,k}^{2}\sim\gammaSamp{\frac{\dataDim}{2}}{\frac{\dataDim}{2\dataStd^{2}}}
\]
the mean for which is simply the variance of the underlying Gaussian
density,
\[
\expectation{\frac{1}{\dataDim}\sum_{k=1}^{\dataDim}y_{i,k}^{2}}=\dataStd^{2}.
\]
We can use this gamma density to work out how much of the mass of the
Gaussian egg is in the different zones. The cumulative distribution
function for the gamma density,
\[
\gammaCdf{z}{a}{b} = \int_0^{x}\gammaDist{z}{a}{b} \mathrm{d} z,
\]
doesn't have a nice analytical form, but implementations of it are provided for many programming languages including R, Matlab and
Python. We can use the cumulative distribution to give the probability
of the squared distance falling under a certain value. For the data
point to be in the yolk, we expect its squared distance from the mean
to be under $(0.95\dataStd)^2$. For the data point to be in the green
we expect its squared distance from the mean to be between
$(0.95/\dataStd)^2$ and $(1.05/\dataStd)^2$. Data in the white will
have a squared distance from the mean greater than
$(1.05/\dataStd)^2$.
% 
\begin{figure}
  \begin{center}
    \includegraphics[width=3cm]{../diagrams/distance2}
    \end{center}

  \caption{Distance from mean of the density (blue circle) to a given
    data point (red square).}

\end{figure}

% 
\begin{figure}
  \begin{octave}
    %}
    close all
    dimredDimensionMass('dimensionMass')
    system(['epstopdf ' pwd filesep '../tex/diagrams/dimensionMass.eps']);
    %{
  \end{octave}
  \begin{center}
    \includegraphics[width=0.8\textwidth]{../diagrams/dimensionMass}
  \end{center}

  \caption{Plot of probability mass versus dimension. Plot shows the
    volume of density inside 0.95 of a standard deviation (yellow),
    between 0.95 and 1.05 standard deviations (green), between 1.05
    and 2 standard deviations (white) and between 2 and 3 standard
    deviations (brown).}

\end{figure}



\subsection{Looking at Gaussian Samples}

The theory has shown us that data sampled from a Gaussian density in
very high dimensions will live in a shell around one standard
deviation from the mean of the Gaussian. This is perhaps surprising
because we are used to thinking of Gaussians being distributions where
most of the data is near the mean of the density. But this is because
we are used to looking at low dimensional Gaussian densities. In this
regime most of the data is near the mean. One useful property of the
Gaussian density is that all the marginal densities are also
Gaussian. This means that when we see a two dimensional Gaussian we
can think of it as a three dimensional Gaussian with one dimension
marginalized. The effect of this marginalization is to project the
third dimension down onto the other two by summing across it. This
means when we see a two dimensional Gaussian on a page such as that in
\reffig{}, we can think of a corresponding three dimensional
Gaussian which has this two dimensional Gaussian as a marginal. That
three dimensional Gaussian would have data going into and coming out
of the page. The projection down to two dimensions makes that data
look like it is close to the mean, but when we expand up to the three
dimensional Gaussian some of that data moves away from the
mean. Following this line of argument, we can ask what if the plot is
the two dimensional marginal of a truly four dimensional Gaussian. Now
some more of the data that appears close to the mean in the two
dimensional Gaussian (and perhaps was close to the mean in the three
dimensional Gaussian) is also projected away. We can continue applying
this argument until we can be certain that there is no data left near
the mean. So the gist of the argument is as follows. When you are
looking at a low dimensional projection of a high dimensional
Gaussian, it does appear that there is a large amount of data close to
the mean. But, when we consider that the data near the mean has been
projected down from potentially many dimensions we understand that in
fact there is very little data near the mean.
% 
\begin{figure}
  \begin{octave}
    %}
    close all
    a = randn(2);
    a = a*a';
    Y = gsamp([0, 0], a, 300);
    a = plot(Y(:, 1), Y(:, 2), 'r.');
    set(a, 'markersize', 10);
    set(gca, 'fontsize', 20)
    zeroAxes(gca);
    printPlot('twoDGaussianSamples', '../tex/diagrams/', '../html/')
    system(['epstopdf ' pwd filesep '../tex/diagrams/twoDGaussianSamples.eps']);
    %{
  \end{octave}
  \begin{center}
    \includegraphics[width=0.8\textwidth]{../diagrams/twoDGaussianSamples}
  \end{center}

  \caption{Looking at a projected Gaussian. This plot shows, in two
    dimensions, samples from a potentially very high dimensional
    Gaussian density. The mean of the Gaussian is at the origin. There
    appears to be a lot of data near the mean, but when we bear in
    mind that the original data was sampled from a much higher
    dimensional Gaussian we realize that the data has been projected
    down to the mean from those other dimensions that we are not
    visualizing.}
\end{figure}

\subsection{High Dimensional Gaussians and Interpoint Distances}

Our analysis above showed that for spherical Gaussians in high
dimensions the density of squared distances from the mean collapses
around the expected value of one standard deviation. Another related
effect is the distribution of \emph{interpoint} squared distances. It turns
out that in very high dimensions, the interpoint squared distances become
equal. This has knock on effects for many learning algorithms: for
example in nearest neighbors classification algorithms a test data
point is assigned a label based on the labels of the $k$ nearest
neighbors from the training data. If all interpoint squared distances were equal then identifying only $k$ neighbors is difficult.  

Can show this for Gaussians with a similar proof to the above,
\[
\dataScalar_{i,k}\sim\gaussianSamp 0{\dataStd_{k}^{2}}\,\,\,\,\,\,\,\dataScalar_{j,k}\sim\gaussianSamp 0{\dataStd_{k}^{2}}
\]
\[
\dataScalar_{i,k}-\dataScalar_{j,k}\sim\gaussianSamp 0{2\dataStd_{k}^{2}}]
\]
\[
\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}\sim\gammaSamp{\frac{1}{2}}{\frac{1}{4\dataStd_{k}^{2}}}
\]
Once again we can consider the specific case where the data is spherical, $\dataStd_{k}^{2}=\dataStd^{2}$, as we can always individually  rescale the data input dimensions to ensure this is the case
\[
\sum_{k=1}^{\dataDim}\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}\sim\gammaSamp{\frac{\dataDim}{2}}{\frac{1}{4\dataStd^{2}}}
\]
\[
\frac{1}{\dataDim}\sum_{k=1}^{\dataDim}\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}\sim\gammaSamp{\frac{\dataDim}{2}}{\frac{D}{4\dataStd^{2}}}
\]
Dimension normalized squared distance between points is Gamma distributed.
Mean is $2\dataStd^{2}$. Variance is $\frac{8\dataStd^{2}}{D}$.

\section{Central Limit Theorem and Non-Gaussian Case}

So far we have entirely focused on data which is generated according to a Gaussian density. For data generated according to spherical Gaussian densities we can compute the corresponding densities of squared distances from the mean and interpoint squared distances  \emph{analytically}. However, our conclusions are not limited to this case. In general, for data where the features (the columns of $\dataMatrix$) are sampled independently  the \emph{central limit theorem}\index{central limit theorem} (see \refbox{box:central}) applies.
\fixme{Need to analyze in detail how the central limit theorem applies.}



\begin{boxfloat}
  \caption{The Central Limit Theorem}\label{box:central}
  \boxfontsize The ``central limit theorem'' underpins much of
  statistics. Indeed it is named ``central'' due to its importance as a
  foundation of much of statistics. It states that the sum of a number
  of independent random variables, $\sum_{i=1}^\numData \dataScalar_i$ ,
  with finite variance, will, as the number of variables increases,
  appear to be drawn from Gaussian density. The mean of the Gaussian is
  given by the sum of the means of the independent variables,
  $\sum_{i=1}^\numData \meanScalar_i$, and the variance is given as the
  sum of the variances, $\sum_{i=1}^\numData \dataStd^2_i$. We can
  analyze what effect this has on the mean of these variables,
  \[
  \lim_{\numData\to\infty}p\left(\frac{\sum_{i=1}^\numData \dataScalar_i}{\numData}\right) = \gaussianDist{\frac{\sum_{i=1}^\numData \dataScalar_i}{\numData}}{\frac{\sum_{i=1}^\numData \meanScalar_i}{\numData}}{\frac{\sum_{i=1}^\numData \dataStd^2_i}{\numData^2}},
  \]
  from which we note that the mean is the average of the means, whereas the variance is $\numData^{-1}$ times the average variance. In other words, as we add more measurements together, the uncertainty in the measurement decreases. 
\end{boxfloat}
% 

% 
\begin{figure}
  \begin{octave]
    %}
      close all
      model = dimredPlotMog(20, 200);
      if exist('printDiagram') & printDiagram
        mogPrintPlot(model, [], 'Artificial', 2);
      end
      system(['epstopdf ' pwd filesep '../tex/diagrams/demArtificialMog2.eps']);
      system(['epstopdf ' pwd filesep '../tex/diagrams/demArtificialMog2NoOvals.eps']);

    %{
    \end{octave}
  \begin{center}
    \includegraphics[width=0.45\textwidth]{../diagrams/demArtificialMog2NoOvals}\hfill{}
    \includegraphics[width=0.45\textwidth]{../diagrams/demArtificialMog2}
    \end{center}

  \caption{A two dimensional data set and the fit of a mixture of
    Gaussians to the data. A mixture of Gaussians appears to be a very
    powerful model as it seems to fit a data set with a fairly complex
    structure.\label{fig:clusteredTwoDimensionalData} }

\end{figure}


\begin{itemize}
\item The mean squared distance in high dimensional space is the mean
  of the variances.
\item The variance about the mean scales as $\dataDim^{-1}$.
\end{itemize}


\subsection{Independent Features: Summary}


We started this chapter by considering data models based on a set of prototypes, each of which was corrupted by  So far, our analysis has focused on data sets which are assumed to have arisen through independently generated features. Our analysis so far has considered the situation where we are given high dimensional data So far we have seen in this chapter that a model which assumes that a high
dimensional data set is made up by independently sampling each feature
behaves rather counter intuitively. All the data falls exactly one
standard deviation away from the mean. If we think of a mixture model
representation of the data, where we justify the mixture representation
by the assumption that our data is made up of prototypes (the mixture
centres) which are corrupted in some way, we find that our prototypes
have vanishingly small probability as dimensions increase. 

\fixme{expand on the central limit theorem approach.}
For the Gaussian case the data are distributed uniformly across the
hypersphere. If we were able to sit at the center of the Gaussian
looking out, the view of the data would be like looking at the night
sky, although all the stars would be one standard deviation away.
For the super Gaussian case the data would be clustered along the
axes. For the sub Gaussian case the data would be clustered at points
rotated $45^{\circ}$ away from the axes.

In the next chapter we will have a look at whether this is an accurate
model of the way real data sets are. We will use real data to inspire
an alternative approach to modeling, one based on dimensionality reduction.





\section{The Curse of Dimensionality?\label{sec:realWorldData}}

\fixme{Add in material about consistency of models which consider
  features to be independent ... in this case dimensionality is a blessing
  ... in the context of maximum likelihood it allows parameters to be
  well determined. This can be a way of introducing GPLVM and spectral
  methods. Question: for GPLVM the number of parameters is known, but
  for spectral methods, how many parameters are we using, if , for example
  we do LLE? k{*}N. This is odd, because as data we only have d{*}N
  data points and sometimes k\textgreater{}d.}

When I first started working in machine learning, the `curse of
dimensionality' was often raised. The theoretical problems of high
dimensional spaces were well understood. When their implications are
considered in the context of a given algorithm, it is often clear that
the algorithm's behavior will deteriorate. For example, many
algorithms are based on measuring the distance between points and
assuming that points which are close together behave in a similar
way. If all data points were approximately equidistant we would be
unable to differentiate between different data points through this
mechanism. \fixme{Use k nearest neighbours as example} In this
chapter, we will explore the question of whether or not this is an
accurate representation for real high dimensional data sets. We will
start, though, by considering an artificial data set, one actually
sampled independently across its features from Gaussian distributions.


\section{Gaussian Samples in High Dimensions}

As a sanity check we will first sample from a Gaussian
distribution. We'll then histogram inter-point squared distances and plot them
against the theoretical distribution we derived in the last
chapter. We will take the squared distance distribution for samples from a
Gaussian distribution with 1000 features, $\dataDim=1000$, and 1000 data points, $\numData=1000$. \Reffig{fig:gaussHighDim} shows the results from plotting the histogram of inter-point squared distances against the theoretical curve.

\begin{figure}
  \begin{octave}
    %}
    close all
    Y = randn(1000, 1000);
    dimredPlotSquaredDistances(Y, 'gaussianDistances1000');
    system(['epstopdf ' pwd filesep '../tex/diagrams/gaussianDistances1000.eps']);

    %{
  \end{octave}
  \begin{center}
    \includegraphics[width=0.6\textwidth]{../diagrams/gaussianDistances1000}
    \end{center}

  \caption{Histogram of inter-point squared distances between points sampled
    from the 1000 point, 1000 dimensional Gaussian. A good match betwen
    theory and the samples for a 1000 dimensional Gaussian
    distribution. \label{fig:gaussHighDim}}
\end{figure}

\begin{comment}
  \section{Sanity Check}

  \textbf{Same data generation, but fewer data points.}
  \begin{itemize}
  \item If dimensions are independent, we expect low variance, Gaussian behaviour
    for the density of squared distances.
  \end{itemize}
  \textbf{Squared distance density for a Gaussian with $\dataDim=1000$}\textbf{\emph{,
      $\numData=100$}}

  % 
  \begin{figure}
  \begin{octave}
    %}
    close all
    Y = randn(100, 1000);
    dimredPlotSquaredDistances(Y, 'gaussianDistances100');
    system(['epstopdf ' pwd filesep '../tex/diagrams/gaussianDistances100.eps']);
    %{
  \end{octave}
    \begin{center}
      \includegraphics[width=0.6\textwidth]{../diagrams/gaussianDistances100}
      \end{center}

    \caption{A good match betwen theory and the samples for a 1000 dimensional
      Gaussian distribution.}

  \end{figure}

\end{comment}

Having performed an empirical validation of the theoretical squared
distance distribution on a known underlying density, we now introduce
a series of real world data sets of differing characteristics. These
data sets have been designed to reflect the diversity of data we might
expect to encounter when using dimensionality reduction in
practice. We will refer to them as the \textbf{oil data}\index{oil
  data}, the \textbf{stick man data}, the \textbf{Spellman data}, the
\textbf{grid speech data} and the \textbf{Netflix data}.

We now turn to a real data set, one that is commonly employed to demonstrate dimensionality reduction algorithms. The data set consists of simulated measurements from an oil pipeline. The model is as follows: oil, water and gas flow together through an oil pipeline. Depending on the relativeproportions they either flow a

\section{Oil Data}
\begin{figure}
  \begin{center}
    \begin{minipage}[b][0.5\textheight][t]{0.5\columnwidth}%
      % 
      \begin{minipage}[t][0.2\textheight]{1\columnwidth}%
        \begin{center}
          Homogeneous
        \end{center}%
      \end{minipage}\\
      % 
      \begin{minipage}[t][0.2\textheight]{1\columnwidth}%
        \begin{center}
          Stratified
        \end{center}%
      \end{minipage}\\
      % 
      \begin{minipage}[t][0.2\textheight]{1\columnwidth}%
        \begin{center}
          Annular
        \end{center}%
      \end{minipage}%
    \end{minipage}\includegraphics[height=0.5\textheight]{../diagrams/oilData}\includegraphics[height=0.5\textheight]{../diagrams/oilDataSensors}
    
  \end{center}
  \caption{The ``oil data''. The data set is artificially generated by modeling
    the manner in which a gamma ray's intensity falls when it passes through
    a different density materials.}\label{fig:oilData}
  
\end{figure}

The ``oil data'' consists of 12 simulated measurements of a
combination of oil, water, and gas flowing in a pipeline
\cite{Bishop:oil93}. The flow has three different regimes: homogeneous,
stratified, or annular. In the homogeneous regime the oil, water, and
gas is distributed relatively uniformly in a cross section of the
pipe. In the other two regimes it either flows in layers: water on the
bottom, oil in the middle, and gas on top. Or it flows as annular
rings of oil, water, and gas.

The flow regimes are simulated and the data consists of simulated
measurements from gamma ray densitometry probes which measure the
density between two points across the pipeline. There are 12 probes
and they are arranged approximately as shown in
\reffig{fig:oilData}. The measurement from each probe is taken to
be a feature. The data consists of 1000 measurements in total for
different proportions of oil, water, and gas.

The density of squared distances between the measurements is shown as
a histogram in \reffig{fig:oilDistances}.
\begin{figure}
  \begin{octave}
    %{
    close all
    Y = lvmLoadData('oil');
    v = dimredPlotSquaredDistances(Y, 'oilDistances');
    system(['epstopdf ' pwd filesep '../tex/diagrams/oilDistances.eps']);
    %}
  \end{octave}

  \begin{center}
    \includegraphics[width=0.6\textwidth]{../diagrams/oilDistances}
  \end{center}
  
  \caption{Interpoint squared distance distribution for oil data with
    $\dataDim=12$.  (variance of squared distances is 1.98 vs
    predicted 0.67)}\label{fig:oilDistances}
\end{figure}



\section{Stick Man Data}

Motion capture rigs are commonly used in the games and movie
industries for capturing realistic motion. The subject wears a special
suit with reflective balls attached at key locations (typically the
subject's joints). Several cameras are used to record the subject's
motion and geometric techniques are used to reconstruct the location
of each joint given the video recordings. High sampling rates are used
(typically 120 frames per second) and missing markers are filled in
through interpolation or and smoothing techniques.

The data set we have selected for analysis is from Ohio State
University's Motion Capture Lab.\footnote{See
  \url{http://accad.osu.edu/research/mocap/mocap_data.htm}, data is
  ``Figure Run 1''.} It consists of a man breaking into a run from a
crouched position. As the run progresses, the subject becomes more
upright: a video provided with the data shows that the runner is
operating in an enclosed space, so it seems that towards the end of
the run the runner's fairly extreme upright position is associated
with the need to stop. We downsampled the data from the original 120
frames to 30 frames per second to reduce the amount of available data.

The raw motion capture data is recovered as a three dimensional point
cloud: each joint is associated with an $x$, $y$ and $z$ position. By
convention in graphics $y$ is taken to be the vertical axis and $x$
and $z$ represent the horizontal plane. Kinematic constraints are
normally imposed on the data by the construction of an underlying
skeleton and the conversion of the $x$, $y$, $z$ positions to a series
of associated joint angles. This is important in animation as it
prevents character configurations associated with physical impossible
maneuvers (such as an extension of the leg). However, for our
purposes, we will consider the raw point cloud data. This will ensure,
when we generate data from the model, that we are not relying on the
constraints imposed by the skeleton to generate realistic data. The
subject in the data set consisted of 34 joints\footnote{We obtained
  the data from
  \url{http://accad.osu.edu/research/mocap/mocap_data.htm}}, leading
to $\dataDim=102$ dimensional data for each frame. The down-sampled
data consisted of $\numData=55$ frames. The data contains
approximately three strides from the run and is therefore pseudo
periodic (it is not truly periodic due to the changing angle of run).

Some frames from the data are visualized in \reffig{fig:stickManData}.
\begin{figure}
  % 
  \begin{minipage}[b][0.8\textheight][t]{0.5\columnwidth}%
    % 
    \begin{minipage}[c][0.3\textheight]{1\columnwidth}%
      \begin{center}
        Changing
        \end{center}%
    \end{minipage}\\
    % 
    \begin{minipage}[c][0.3\textheight]{1\columnwidth}%
      \begin{center}
        Angle
        \end{center}%
    \end{minipage}\\
    % 
    \begin{minipage}[c][0.3\textheight]{1\columnwidth}%
      \begin{center}
        of Run
        \end{center}%
    \end{minipage}%
  \end{minipage}%
  \begin{minipage}[b][0.8\textheight][t]{0.5\columnwidth}%
    % 
    \begin{minipage}[t][0.3\textheight]{1\columnwidth}%
      \begin{center}
        \includegraphics[height=0.2\textheight]{../../../fgplvm/tex/diagrams/demStick3Angle1}
        \end{center}%
    \end{minipage}\\
    % 
    \begin{minipage}[t][0.3\textheight]{1\columnwidth}%
      \begin{center}
        \includegraphics[height=0.2\textheight]{../../../fgplvm/tex/diagrams/demStick3Angle2}
        \end{center}%
    \end{minipage}\\
    % 
    \begin{minipage}[t][0.3\textheight]{1\columnwidth}%
      \begin{center}
        \includegraphics[height=0.2\textheight]{../../../fgplvm/tex/diagrams/demStick3Angle3}
        \end{center}%
    \end{minipage}%
  \end{minipage}
  \caption{The {}``stick man'' data set. We have illustrated frames
    that show the changing angle of run associated with the
    data. } \label{fig:stickManData}

\end{figure}
The histogram of interpoint squared distances for the ``stick man'' data is given in \reffig{fig:stickManDistances}% 
\begin{figure}
  \begin{octave}
    %{
    close all
    Y = lvmLoadData('stick');
    v = dimredPlotSquaredDistances(Y, 'stickDistances');
    system(['epstopdf ' pwd filesep '../tex/diagrams/stickDistances.eps']);
    %}
  \end{octave}

  \begin{center}
    \includegraphics[width=0.6\textwidth]{../diagrams/stickDistances}
    \end{center}

    \caption{Interpoint squared distance distribution for stick man
      data with $\dataDim=102$ (variance of squared distances is 1.09
      vs predicted 0.078).}\label{fig:stickManDistances}

\end{figure}

\section{Robot WiFi Data}

This data consists of a time series of WiFi signal strength recordings
from a robot as it traces a square path in a building. The robot
records the strength of WiFi signals in an attempt to localize its
position \citep[see][for an application]{Ferris:wifi07}. Since the
robot moves only in two dimensions, the inherent dimensionality of the
data should be two: the reduced dimensional space should reflect the
robots moves. The WiFi signals are very noisy relative to (e.g.)
motion capture data. The robot completes a single circuit after
entering from a separate corridor, so it is expected to exhibit ``loop
closure'' in the resulting map. The data consists of 215 frames of
measurement, each frame consists of the WiFi signal strength of up to
30 access points.


\section{Yeast Cell Cycle Data}

Microarray measurements are designed to quantify the amount of
messenger RNA (mRNA) being expressed by the genome at any given
time. This is done by extracting RNA from a population of cells and
reverse transcribing the mRNA to cDNA. This cDNA is fluorescently
tagged and then bound to a set of probes on a slide. The slide is then
scanned to measure the amount of fluorescence associated with each
probe. This acts as a proxy for the amount of mRNA extraced from the
biological sample. Some of these approaches, including many ``spotted
arrays'' bind two samples with different excitation levels for the
fluorescence process two samples at the same time. This allows the
ratio of the fluorescence to be taken as a proxy for the ratio of
expression in the original sample. One of the first publicly available
DNA microarray data sets was published by
\citet{Spellman:yeastcellcy98} and concerns the yeast cell cycle. The
arrays quantify the expression level of 24,4021 different genes
measured at 24 time points in a time series\footnote{Data available
  from
  \url{http://genome-www.stanford.edu/cellcycle/data/rawdata/individual.htm}.}

% 
\begin{figure}
  \begin{center}
    % 
    \begin{minipage}[b][0.8\textheight][t]{0.5\columnwidth}%
      % 
      \begin{minipage}[c][0.3\textheight]{1\columnwidth}%
        \begin{center}
          Yeast
          \end{center}%
      \end{minipage}\\
      % 
      \begin{minipage}[c][0.3\textheight]{1\columnwidth}%
        \begin{center}
          Cell
          \end{center}%
      \end{minipage}\\
      % 
      \begin{minipage}[c][0.3\textheight]{1\columnwidth}%
        \begin{center}
          Cycle
          \end{center}%
      \end{minipage}%
    \end{minipage}\includegraphics[height=0.8\textheight]{../diagrams/spellman}
  \end{center}

  \caption{The ``Spellman'' data. The data consists of gene expression
    measurements from yeast to explore which genes are involved in the
    cell cycle.}



\end{figure}

\begin{figure}
  \begin{center}
    \includegraphics[width=0.6\textwidth]{../diagrams/spellmanDistances_book}
  \end{center}
  
  \caption{Interpoint squared distance distribution for Spellman
    microarray data with $\dataDim=24,401$ (variance of squared
    distances is 0.6173 vs predicted 3.3e-4).}
  
\end{figure}


\section{Grid Speech Data}

The ``grid corpus'' of speech data was collected by the Speech and
Hearing (SpandH) Group at the University of Sheffield. The objective
was to acquire a speech and vision data set with a restricted language
model under controlled conditions for the study of robust speech
recognition. The data set consists of 34 subjects. Jon Barker of the
Sheffield group has created a set of synthesis models for this data
based on hidden Markov models (HMM)\index{hidden Markov model
  (HMM)}. The raw data modeled is the subject's 25 dimensional
spectrogram. The actual value of the spectrogram along with the
``velocities'' and ``accelerations'' are modeled for each
frame. Thirty-six different phones are modeled. To partially deal with
coarticulation affects several phones (for example iy, eh and ih) have
multiple models. For our purposes we can consdier the HMM used to contain seven states: five states for each phone and a start and stop state. Each state has a single component Gaussian density associated with it. This density has a diagonal covariance (so each feature is modeled independently). Need to cite the guy who did this originally \cite{unknown}. \fixme{details of data size and source
  for speech synthesis}.

\begin{figure}
  \begin{center}
    \includegraphics[width=0.6\textwidth]{../diagrams/grid_vowelsDistances_book}
  \end{center}
  
  \caption{Interpoint squared distance distribution for Spellman
    microarray data with $\dataDim=24,401$ (variance of squared
    distances is 0.6173 vs predicted 3.3e-4).}
  
\end{figure}


% Phone list %'iy2', 'iy4', 'iy5', 'iy6', 
% 'ih1', 'ih3', 'ih5', 
% 'eh1', 'eh2', 'eh4', 'eh5', 'eh6', 
% 'ey1', 'ey4', 'ey5', 'ae3', 'aa4', 'aw6', 'ay2', 'ay3', 'ay4', 
% 'ay5', 'ah5', 'ao5', 'ow4', 'ow5', 'uw2', 'uw4', 
% 'uw5', 'uw6', 'ax4', 'ax6', 
% 'p1', 'p4', 'p6', 'b1', 'b2', 'b3', 'b4', 'd2', 
% 'd4', 'g2', 'g6', 't1', 't2', 't3', 't4', 't5', 
% 'k4', 'k5', 
% 'l1', 'l2', 'l4', 'l6', 'r2', 'r5', 'w2', 'w3', 'w4', 'w5', 'y4'
% 'm4', 'n1', 'n2', 'n3', 'n4', 'n5', 'n6', 
% 'f4', 'f5', 's1', 's4', 's5', 's6', 'v4', 'v5', 
% 'z4', 'z5', 'z6', 'dh3', 'th5', 
% 'ch4', 
% 'ia5',
% 'jh4',          
% 'sil', 
% 'sp'

\section{Netflix Data}

The final data set we will consider is the Netflix movie recommender
data. This data was released for the ``Netflix Prize''. The data
consists of about 100 million ratings from over 400 thousand users for
over 17 thousand potential DVD rentals. The ratings are between 1 and
5 stars. The matrix of ratings is highly sparse as a typical user may
rate only a few hundred films. Prediction of the missing ratings using
other users ratings is known as collaborative filtering. This type of
prediction of user preference is a challenging problem for internet
retailers who can raise their turnover by accurate prediction of user
tastes. Whilst this book isn't about collaborative filtering, a
sensible approach to this data is to try and reduce its
dimensionality. The fact that the data set is large and has many
missing elements also presents us with particular challenges that we
might often expect to find in real world data.

\fixme{Maybe include a movielens data for exploration here?}

\section{Another Look at Gaussian Samples}\label{sec:anotherLook}

It is clear that for many data sets the squared distance density does not
conform to the theoretical distribution that we described. Where does
practice depart from our theory? In practice we find that the variance
of the squared distance densities is much larger than we might expect. To
explore how this occurs, let's consider another Gaussian density with
$\dataDim=1000$. Somehow the real data seems to have a smaller
effective dimension. In \reffig{fig:ppcaGaussian} we show inter point squared distances computed from another 1000 dimensional Gaussian density. Here though, the covariance of the Gaussian density has a particular structure.

\begin{figure}
  \begin{center}
    \subfigure[]{\includegraphics[width=0.45\textwidth]{../diagrams/correlatedGaussianDistances_book}}\hfill
    \subfigure[]{\includegraphics[width=0.45\textwidth]{../diagrams/correlatedGaussianDistances2_book}}
  \end{center}

  \caption{Interpoint squared distance density for Gaussian with
    $\dataDim=1000$. The Gaussian density now has a specific low rank
    covariance matrix
    $\mathbf{C}=\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye$.
    Data generated by taking $\dataStd^{2}=1e-2$ and sample
    $\mathbf{W}\in\Re^{1000\times2}$ elements independently from
    $\gaussianSamp{0}{1}$.\label{fig:ppcaGaussian}}

\end{figure}

The theory no longer matches the practice for this histogram. Indeed,
the for a two dimensional Gaussian has a much closer match to the
empirically computed inter-point squared distances. The density we used
exhibits correlations between all data points, and these correlations
are such that the underlying dimensionality of the Gaussian appears
closer to two. Structured covariance Gaussians such as this one appear
to be a more appropriate model for data than the independent Gaussian
on which our analysis was based. In the next chapter we will explore a
latent variable model\index{latent variable model} explanation for
this density. This explanation will reveal why this data is structured
differently. We will see that whilst the apparent dimensionality of
the data is 1000, the underlying dimensionality is only two.

%%% Local Variables:
%%% TeX-master: "book"
%%% End:
%}