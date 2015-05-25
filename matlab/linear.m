%{
\begin{verbatim}
  %}
  % Comment/MATLAB set up code
  importTool('dimred')
  dimredToolboxes
  global printDiagram
  printDiagram = 1
%{
\end{verbatim}
%Start of Comment/MATLAB brackets

\chapter{A Linear Model for Dimensionality Reduction}

We've used the first chapter of the book to introduce some intuitions
about what might happen in high dimensions, backing up some basic
assumptions with theoretical analysis. For independently sampled
features, we saw how data has the characteristic that all points end
up at a fixed distance from the center of the density. For Gaussian
densities we saw that all sampled points become uniformly distributed
across a sphere, rather like a stars scattered uniformly across the
sky: but with the distances to all those stars fixed and equal to the
standard deviation of the Gaussian. For non-Gaussian densities data
becomes clustered at points which are either axis aligned (for super
Gaussian sources) or rotated 45 degrees from the axes. The
distance between those clusters and the origin is the standard
deviation of the generating density.

To explore this effect in a range of real data sets we measured the
squared distances for a small cross section of different data. We saw
that there was a serious mismatch between the theory we'd developed
and the reality and the reality. As a sanity check, we considered
features sampled independently from a spherical Gaussian density in
high dimensions and saw that the theory worked well. We finished the
by showing that for covariance matrices of a particular
form,
\[
\covarianceMatrix=\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye
\]
we could recover the mismatch.

In this chapter we will develop the probabilistic model behind this
covariance matrix. This will allow us to introduce several concepts
that will also prove useful in future derivations. Because the
covariance matrix is non-diagonal, it describes correlations between
the features. This is where the mismatch between the theory and
practice occurs. When $\mappingMatrix \in \Re^{\dataDim\times
  \latentDim}$, with $\latentDim<\dataDim$ we can think of this
covariance matrix as a combination of a reduced rank portion
($\mappingMatrix\mappingMatrix^\top$, which has a rank of
$\latentDim$) with a diagonal term, $\dataStd^2\eye$ that ensures
positive definitiveness of the covariance.  If $\dataStd$ is small
relative to the magnitude of the columns of $\mappingMatrix$,
$\mappingVector_{:, i}$, then we can think of the structure of the
covariance as being inherently low dimensional. In this chapter we
will introduce another interpretation of that low rank structure: we
will show it can arise through a dimensionality reduction. This comes
about through a probabilistic interpretation of principal component
analysis (PCA)\index{principal component analysis
  (PCA)}\index{probabilistic PCA}.


\section{Probabilistic Linear Dimensionality Reduction}

The term ``principal components'' was introduced by Harold
Hotelling\index{Hotelling, Harald}, he was interested in summarizing
multivariate data with a reduced number of variables. \citealp[Quoting
from][page 417:]{Hotelling:analysis33}

\begin{quote}
  Consider $\dataDim$ variables attaching to each individual of a
  population.  These statistical variables $\dataScalar_1$,
  $\dataScalar_2$, ... , $\dataScalar_\dataDim$ might for example be
  scores made by school children in tests of speed and skill in
  solving arithmetical problems or in reading; or they might be
  various physical properties of telephone poles, or the rates of
  exchange among various currencies. The $\dataScalar$'s will
  ordinarily be correlated. It is natural to ask whether some more
  fundamental set of independent variables exists, perhaps fewer in
  number than the $\dataScalar$'s, which determine the values the
  $\dataScalar$'s will take. If $\latentScalar_1$, $\latentScalar_2$,
  ... are such variables, we shall then have a set of relations of the
  form
  \[
  \dataScalar_i = f(\latentScalar_1, \latentScalar_2, ...)\quad (i = 1, 2,
  ..., \dataDim)\quad (1)
  \]
  Quantities such as the $\latentScalar$'s have been called mental
  factors in recent psychological literature. However in view of the
  prospect of application of these ideas outside of psychology, and
  the conflicting usage attaching to the word ``factor'' in mathematics,
  it will be better simply to call the $\latentScalar$'s components of
  the complex depicted by the tests.

\end{quote}

Where in the quote we have substituted Hotelling's notation with ours
for ease of integration with the book.

Hotelling went on to assume that the components, $\latentVector$,
(which we refer to as latent variables) were drawn from a Gaussian
density, and he restricted the relationship between them and the data
to be linear. It turns out that there is a rotational identifiability
issue in such models. To resolve this he suggested selecting, in turn,
orthogonal components that describe the largest portion of the data
variance. His approach of seeking components to explain the largest
variance was motivated mainly by analogy. He called these the
principal components\index{principal components}.

Principal component analysis\index{principal components analysis
  (PCA)} is one of the earliest approaches to dimensionality
reduction. It also underlies many other approaches to dimensionality
reduction.  As we shall see, it can be viewed from different
perspectives, but it seems appropriate to introduce it first from a
perspective that is close to Hotelling's own motivation.

Hotelling's definition of principal components would be described in
the machine learning literature as a \emph{generative
  model}\glossary{name={generative model}, description={Generative
    models in machine learning are models which explicitly attempt to
    model a generation process for the data. Often, it will not be a
    close approximation to the actual generating process, but would
    typically be composed of tractable probability densities, perhaps
    formed in a hierarchical manner, from which data are sampled. For
    example in speech processing, the cepstral coefficients are often
    modeled as being generated from a discrete Markov chain which
    selects Gaussian components from which the coefficients are
    sampled. Generative models are often contrasted with
    \emph{discriminative models} (such as the support vector machine)
    which do not seek to model the generating process directly, but
    may provide a mapping from features directly to a categorization
    for a data point.}}. He describes a generating process for the
data: that it arises from a set of uncorrelated factors and is then
mapped to a higher dimensional data space.

A modern probabilistic perspective on PCA\index{probabilistic PCA (PPCA)}
also addresses it from a generative modeling perspective. By
introducing \emph{noise}\glossary{name={noise}, description={Noise is
    a catch all term with origins in signal processing. It was
    originally used to describe unwanted perturbation to the
    signal. In a generative model, it is typically used to represent
    aspects of the data that we are not explicitly modeling with our
    generating process.}} in the generative model, PCA has been
reformulated giving a model which does not need to recourse to
analogies to formulate the associated optimization algorithm. By
introducing a model of the noise in the system and optimizing the
model through \emph{maximum likelihood}\index{maximum
  likelihood}\glossary{name={maximum likelihood}, description={Maximum
    likelihood is a technique for fitting a probabilistic model to a
    data set. To perform maximum likelihood, the probability of the
    data given the parameters is first written down. This is known as
    the likelihood. This likelihood is then maximized with respect to
    the parameters. Typically. Normally, rather than maximizing the
    likelihood directly, we maximize the logarithm of the likelihood
    (the log likelihood). Maximizing the log likelihood is equivalent
    to maximizing the likelihood because logarithm is a
    \emph{monotonic} transformation. Typically the log likelihood has
    a slightly simpler form than the likelihood (e.g. in the case of a
    Gaussian likelihood it is quadratic in the data, instead of an
    exponentiated quadratic)}} we recover a fully probabilistic
interpretation for PCA. In this guise the model is known as either
``sensible PCA''\index{sensible PCA|see{probabilistic PCA (PPCA)}} or
``probabilistic PCA''\index{probabilistic PCA (PPCA)}.

Probabilistic PCA
\cite{Tipping:probpca99,Roweis:SPCA97}\index{probabilistic PCA (PPCA)}
is a \emph{latent variable}\index{latent variable
  models}\glossary{name={latent variable}, description={A latent
    variable is a variable in a model that is not observed. Such a
    latent variable can either be real, or simply explanatory. For
    example, body mass index is a latent variable which explains the
    relationship between height and weight of an individual. This is
    an explanatory latent variable. Early work on principal component
    analysis and factor analysis\index{factor analysis (FA)} sought to summarize intelligence
    through a reduced number of explanatory latent variables. Real
    latent variables occur in, for example, state space models. In a
    state space model the latent variables are often physical
    properties of the system: such as the speed, velocity, and
    acceleration of an aircraft.}} representation of data. The basic
idea is the same as Hotelling's model: the ``true'' manifestation of
the data lies in a low, $\latentDim$-dimensional latent
space. However, we observe a data point which is mapped from the low
dimensional space to a, $\dataDim$-dimensional space. The main
difference in the probabilistic PCA model is that we include
corrupting noise that corrupts the observed location of the data
point.

\section{The Probabilistic PCA Model}

For our notation, we express the $i$th data point's position in the
underlying latent space by the vector $\latentVector_{i, :}$. The
relationship between the latent space and the data space in the form
of a linear mapping,
\[
\dataVector_{i, :} = \mappingMatrix \latentVector_{i, :} + \meanVector
+ \noiseVector_{i, :}
\]
where $\mappingMatrix \in \Re^{\dataDim,\latentDim}$ is a mapping
matrix which encodes the relationship between the latent space and the
data space. The vector $\noiseVector$ represents the corrupting
noise. We will assume the noise is independently sampled from a
Gaussian density,
\[
\noiseVector_{i,:} \sim \gaussianSamp{0}{\dataStd^2\eye},
\]
where $\dataStd$ is the standard deviation of the corrupting noise. 

Linear dimensionality reduction can be thought of as finding a lower
dimensional plane embedded in a higher dimensional space. The plane is
described by the matrix $\mappingMatrix$. The direction of the vectors
in this matrix define the orientation of the
plane. \Reffig{fig:mapping2to3linear} shows how this works when
the latent space is two dimensional and the data space is three
dimensional.
\begin{figure}
  \begin{centering}
    \includegraphics[width=0.8\textwidth]{../diagrams/mapping2to3linear}
  \end{centering}
  
  \caption{Mapping a two dimensional plane to a higher dimensional
    space in a linear way. Data are generated by corrupting points on
    the plane with noise.}\label{fig:mapping2to3linear}
  
\end{figure}

We represent the entire data set in the form of a \emph{design
  matrix}\glossary{name={design matrix}, description={The design matrix
    is the standard way of representing a data set in statistics. It
    involves placing the data in a matrix, where each row of the
    matrix is a separate data point. Different features are then given
    in each column of the design matrix.}}, $\dataMatrix \in
\Re^{\numData\times\dataDim}$. 


The next step is to incorporate these assumptions into a probability
density. This is done by using a Gaussian density with a \emph{mean
  function}. The basic idea is to specify the mean of a Gaussian
density by a function that is dependent on the latent variables. If
the variance of this density is taken to be the variance of the
corrupting Gaussian noise then we have a simple Gaussian model for a
data point, $\dataVector_{i,:}$ given the mapping matrix,
$\mappingMatrix$, the latent point, $\latentVector_{i, :}$, and the
noise variance, $\dataStd^2$. If the noise is independently added to
each feature, and has the same variance for each feature, then the
mean for the $j$th feature of the $i$th data point will be given by
$\mappingVector_{j, :}^\top \latentVector_{i, :} + \meanScalar_j$ and
the corresponding variance will be $\dataStd^2$. The Gaussian density
governing the data point will then be
\[
\dataScalar_{i,j} \sim \gaussianSamp{\mappingVector_{j,
    :}^\top\latentVector_{i,:}+\meanScalar_j}{\dataStd^2}. \label{eqn:marginalDatum}
\]
% 
\begin{boxfloat}
  \caption{Joint Probabilities}\label{box:joint}

  \boxfontsize
  A joint probability expresses the distribution for two simultaneously
  occurring events. We can think of it as being the probability of both
  $S=s$ and $Z=z$. It is expressed with commas, so we have the
  probability $P(S=s, Z=z)$. 

  Conditional probabilities represent the influence of one event upon
  another, so if we know that the value of $Z$ is dependent on $S$ we
  can write the distribution as $P(S=s|Z=z)$. If the outcome of $S$ is
  unaffected by the value of $Z$ then the two events are said to be
  independent and we can write $P(S=s|Z=z)=P(S=s)$.

  The product rule of probability states that the joint distribution is
  related to the conditional distribution in the following way,
  \[
  P(S=s,Z=z)=P(S=s|Z=z)P(Z=z).
  \]
\end{boxfloat}

\begin{boxfloat}
  \caption{Marginalization}\label{box:marginalization}

  \boxfontsize
  The sum rule of probability relates the distribution over one variable, $P(S=s)$ to the joint distribution:
  \[
  P(S=s) = \sum_Z P(S=s, Z=z),
  \]
  this process is known as marginalization (presumably because the variable $Z$ disappears into the ``margin''). The distribution $P(S=s)$ is known as the marginal distribution. For continuous variables and probability densities marginalization is achieved through integration,
  \[
  p(X=x) = \int_Y p(X=x, Y=y) \mathrm{d}y
  \]
  We will be using the shorthand described in \refbox{box:probability}
  which allows us to write
  \[
  p(x, y) \equiv p(X=x, Y=y).
  \]
  Note here that probability notation differs fundamentally from
  standard function notation. For function notation, $f(\latentScalar,
  \dataScalar)$ does not typically equal $f(\dataScalar,
  \latentScalar)$. It will do so only if the function is symmetric. This
  is because in function notation position is significant (as it is in
  many programming languages like C, Java and Matlab). However,
  probability notation is not the same as functional notation. When
  using probability notation, position isn't significant: there is an
  implicity ``name'' associated with each argument that we have dropped
  in our shorthand (this is like ``named parameter'' functions in
  programming languages such as Python, Ada and R). When names are
  provided ordering isn't important. In the shorthand for probability
  notation the names are implicit so $p(x,y) = p(y,x)$ even if the
  density function is not symmetric because we are really writing
  $p(X=x, Y=y) = p(Y=y, X=x)$.
\end{boxfloat}
% 
If we assume that the noise is independent across both features and
data, then can we write down the joint probability density for the
entire data set as a product of the marginal densities for each data
point and each feature given in \refeq{eqn:marginalDatam}. Note that
we are not saying that each data point and feature is completely
independent, we are saying that given the parameters of the model and
the latent variables each feature of each data point is
independent. In other words, the noise that corrupts the features of
each data point is independent. Actual data points may be strongly
correlated, both across observations and features (through the mapping
matrix and the latent variables respectively).  

Given this independence assumption the joint distribution over the
observed data, given the parameters and latent variables, is then
\[
\dataMatrix \sim \prod_{i=1}^\numData\prod_{j=1}^\dataDim
\gaussianSamp{\mappingVector_{j, :}^\top \latentVector_{i,
    :}+\meanScalar_{j}}{\dataStd^2}.
\]
We can rewrite this density, incorporating the feature independence in
a multivariate Gaussian density with a \emph{spherical covariance
  matrix},\glossary{name = {spherical covariance matrix},
  description={A spherical covariance matrix is a covariance matrix
    (typically for a Gaussian density) where all data points sampled
    from the density are independent (i.e. off diagonal terms are
    zero) and share the same variance (i.e. on diagonal terms are
    constant). It is termed spherical because contours of equal
    likelihood from the associated Gaussian density are in the form of
    circles (for 2D Gaussians), spheres (for 3D Gaussians), and
    hyper-spheres (for higher dimensionality). Gaussians with other
    forms of covariance matrix have elliptical contours of equal
    likelihood.}} $\dataStd^2 \eye$, as a product over observations:
\[
p\left(\dataMatrix|\latentMatrix,\mappingMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\dataVector_{i,:}}{\mappingMatrix\latentVector_{i,:}+\meanVector}{\dataStd^{2}\eye}.
\]
There are several unknowns in this likelihood: the parameters
($\mappingMatrix$, $\meanVector$, and $\dataStd^2$) and the latent
variables, $\latentMatrix$.

The latent variables, $\latentMatrix$, are sometimes known as
``nuisance parameters''. This reflects the idea that if we were only
interested in the values of the mapping matrix (which defines the
embedded plane) we may not be interested in the positions of the
latent variables. For PCA it will turn out that we are often
interested in both. However, the nuisance parameters need to be dealt
with. Hotelling took the approach of assuming that these parameters
are sampled from another Gaussian density, with zero mean and unit
variance,
\[
\latentScalar_{i,j}\sim \gaussianSamp{0}{1}.
\]
So the joint density for the components can be written
\[
p(\latentMatrix) = \prod_{i=1}^\numData
\gaussianDist{\latentVector_{i, :}}{\zerosVector}{\eye}.
\]


\begin{boxfloat}
  \caption{Independence over observations in likelihood and prior.}\label{box:independence}

  \boxfontsize The fact that both are independent over data points
  (given the parameters) means that the joint density over latent
  variables and data is also independent over observations,
  \[
  p(\dataMatrix, \latentMatrix | \mappingMatrix, \meanVector,
  \dataStd^2) = \prod_{i=1}^\numData p(\dataVector_{i, :},
  \latentVector_{i, :}| \mappingMatrix, \meanVector, \dataStd^2)
  \]
  This means that the marginal likelihood for $\dataMatrix$ will also
  be independent over observations.
  \begin{align*}
    p(\dataMatrix | \mappingMatrix, \meanVector, \dataStd^2) & = \int
    \prod_{i=1}^\numData p(\dataVector_{i, :}, \latentVector_{i, :}|
    \mappingMatrix, \meanVector, \dataStd^2)
    \mathrm{d}\latentVector_{i, :} & = \prod_{i=1}^\numData
    p(\dataVector_{i, :}| \mappingMatrix, \meanVector, \dataStd^2).
  \end{align*}
  This is a very typical set up for latent variable models. It should
  be contrasted with a Bayesian treatment of the parameters, which
  typically don't use prior densities which are independent over
  observations. Such priors induce dependencies between observations
  in the data set.
\end{boxfloat}

This density is often known as a \emph{prior}\glossary{name={prior
    distribution}, description={The prior distribution (or density)
    encapsulates our believes about the values of a parameter, or
    variable, before we have seen the data. For statisticians the use
    of the prior density is one of the more controversial aspects of
    Bayesian inference as it can introduce subjectivity into
    statistical analysis. However, the use of prior distributions can
    be very powerful as it can allow us to include assumptions (such
    as smoothness) in the model.}}. Once we have defined the prior
density we can compute the \emph{marginal
  likelihood}\glossary{name={marginal likelihood}, description={The
    marginal likelihood is a term used to refer to a likelihood from
    which one or more of the parameters have been marginalized. It is
    also called the evidence \cite{Jaynes:probability03}. The marginal
    likelihood is often used in model selection, in this context
    ratios between marginal likelihoods are sometimes known as Bayes
    factors\cite{Raftery:hypothesis96}. Maximization of the marginal
    likelihood with respect to its parameters is sometimes called
    empirical Bayes, but it can also just be seen as another variant
    of maximum likelihood.}} of the data given the parameters,
$p(\dataMatrix|\mappingMatrix, \meanVector, \dataStd^2)$ by
integration over the latent variables,
\[
p(\dataMatrix|\mappingMatrix, \meanVector, \dataStd^2) = \int
p(\dataMatrix | \mappingMatrix, \meanVector,
\dataStd^2)p(\latentMatrix) \mathrm{d}\latentMatrix.
\]
This integration can be done analytically for the case where both the
likelihood, $p(\dataMatrix| \mappingMatrix, \meanVector, \dataStd^2)$,
and the prior, $p(\latentMatrix)$ are Gaussian. We will go through it
in detail now. The first step is to exploit the independence across
data points in both the prior and the likelihood (see
\refbox{box:independence} for details),
\[
p(\dataMatrix|\mappingMatrix, \meanVector, \dataStd^2) =
\prod_{i=1}^\numData \prod_{i=1}^\numData p(\dataVector_{i, :} |
\mappingMatrix, \meanVector, \dataStd^2) \mathrm{d}\latentVector_{i,
  :}.
\]
so we can analyze the density for each observation independently,
\[
p(\dataVector_{i, :} | \mappingMatrix, \meanVector, \dataStd^2) = \int
p(\dataVector_{i, :}| \latentVector_{i, :}, \mappingMatrix,
\meanVector, \dataStd^2)p(\latentVector_{i, :})
\mathrm{d}\latentVector_{i, :}.
\]
\begin{tipfloat}
  \caption{Integration Tricks for
    Probabilities} \label{tip:integrationTricks} 
  
  \boxfontsize Integration is a non trivial operation: when dealing
  with integration over probability densities there are a couple of
  tricks that can help. The primary trick is that we know that any
  probability density must be normalized. By being familiar with the
  form of densities you effectively have knowledge of indefinite
  integrals. For example if we wish to know the indefinite integral of
  an exponentiated quadratic, $\int \exp
  \left(-\half(\mathbf{x}-\mathbf{b})^\top \mathbf{A} (\mathbf{x}
    -\mathbf{b})\right)\mathrm{d}\mathbf{x}$, we can use the fact that
  \[
  \gaussianDist{\mathbf{x}}{\mathbf{b}}{\mathbf{A}} =
  \frac{1}{\det{2\pi \mathbf{A}}^{-\half}}\exp
  \left(-\half(\mathbf{x}-\mathbf{b})^\top \mathbf{A}^{-1}
    (\mathbf{x} -\mathbf{b})\right)
  \]
  and the normalization property of a density, $\int
  \gaussianDist{\mathbf{x}}{\mathbf{b}}{\mathbf{A}}
  \mathrm{d}\mathbf{x} = 1$, to derive
  \[
  \int \exp \left(-\half(\mathbf{x}-\mathbf{b})^\top
    \mathbf{A}^{-1} (\mathbf{x}
    -\mathbf{b})\right)\mathrm{d}\mathbf{x} = \det{2\pi
    \mathbf{A}}^{-\half}.
  \]
  This trick is very useful in speeding up calculations. We can also
  apply it for the gamma density (\refbox{box:gamma}) to recover,
  $\int_{0}^{\infty} \exp(-bx)x^{a-1}\mathrm{d}x =
  \frac{\Gamma(a)}{b^a}$.
  
  The normalization property leads to an often used shorthand for
  probabilities,
  \[
  p(x|a, b) \propto \exp(-bx)x^{a-1},
  \]
  where the implication here is that $x|a, b$ has a gamma
  density. This shorthand is often used when exploiting
  \emph{conjugacy} to extract the posterior (see
  \refbox{box:conjugacy}).
\end{tipfloat}



\begin{boxfloat}
  \caption{Bayes' Rule}\label{box:bayes}
  \boxfontsize

  For two random variables, $x$ and $y$, Bayes'
  rule relates the two possible conditional probabilities through the
  marginal distributions. It arises first through the product rule for
  probability,
  \[
  p(x, y) = p(x|y)p(y)
  \]
  Recall from \refbox{box:probability} that for probabilities $p(x, y) = p(y, x)$. The joint density can also be expressed by  
  \[
  p(x, y) = p(y|x)p(x).
  \]
  So we can write $p(x|y)p(y)=p(y|x)p(x)$. This can be re-expressed as
  \[
  p(x|y) = \frac{p(y|x)p(x)}{p(y)}.
  \]
  This is known as Bayes' rule\index{Bayes' rule}. If $x$ is a
  parameter or latent variable and $y$ is an observation then the
  formula has the following interpretation: The density $p(x)$
  represents our knowledge about the latent variable before we saw the
  observation. This is known as the
  \emph{prior}\index{prior}\glossary{name={prior}, description={The
      prior is a density or distribution which encapsulates our
      assumptions about a variable or parameter before we have seen
      the data.}} density. The density $p(y|x)$ represents the
  relationship between the latent variable (or parameter) and our
  observation. This is known as the
  \emph{likelihood}\index{likelihood}\glossary{name={likelihood},
    description={The likelihood of a data set is the probability
      density that relates the data to the parameters and potentially
      the latent variables. In Bayesian inference the likelihood is
      combined with the prior to find the posterior density and the
      marginal likelihood of the data.}}. The density $p(x|y)$ is
  known as the \emph{posterior}\glossary{name={posterior},
    description={The posterior is a density or distribution which
      reflects our knowledge about a parameter or variable having
      observed some data. It is computed through Bayes'
      rule\index{Bayes' rule} and depends on the form of the
      likelihood and the prior.}}. It represents our updated
  understanding of $x$ arising from the observation of the data, $y$,
  and the relationship we specify between the data and $x$ through the
  likelihood. Finally $p(y)$ is known as the marginal likelihood. It
  represents the probability of the data under the marginalized
  model. The marginal likelihood is also a consequence of our
  definition of prior and likelihood because it is recovered via
  marginalization,
  \[
  p(y) = \int p(y|x)p(x) \mathrm{d}x.
  \]
  This marginalization is often the stumbling block for Bayesian
  methods as for complicated combinations of prior and likelihood the
  integral is generally not analytically tractable.
\end{boxfloat}


\begin{boxfloat}
  \caption{Conjugate Priors}\label{box:conjugacy}
  \boxfontsize

  As we saw in \refbox{box:bayes} Bayes' rule\index{Bayes' rule}
  allows us to combine an observation (through a likelihood) with a
  prior density to recover a posterior density. However, the operation
  is often intractable due to the integral required to compute the
  marginal likelihood. Cojugacy is used to describe a particular class
  of likelihood and prior pairings that leads to tractable
  models. Conjugacy is used in the sense of conjoined. A prior applies
  to a particular parameter of the likelihood. Let's refer to it as
  $x$. If the prior is conjugate to the likelihood, then the
  functional form of the posterior density after multiplying by the
  prior will be identical to the prior.

  For example, if we place a gamma prior, $p(x) \propto
  x^{a-1}\exp(-bx)$ over the precision (which is the inverse variance)
  of a zero mean Gaussian density, $p(y) \propto
  x^{\half}\exp\left(-\frac{x}{2}y^2\right)$, we recover a
  conjugate relationship when we compute the posterior density,
  \[
  p(x|y) \propto p(y|x)p(x) \propto
  x^{a-1}\exp(-bx)x^{\half}\exp\left(-\frac{x}{2}y^2\right)
  \]
  \[
  p(x|y) \propto x^{a+\half-1}\exp(-(b+{y^2}{2})x),
  \]
  which using the marginalization trick from
  \reftip{tip:integrationTricks} we can write down as a gamma,
  \[
  p(x|y) = \gammaDist{x}{a+{\scriptstyle \half}}{b+{\scriptstyle
      \frac{y^2}{2}}}.
  \]
  Other useful conjugate relationships include a Gaussian prior over
  the mean of a Gaussian density, a gamma prior over the rate
  parameter of a Poisson distribution, a beta prior over the
  probabilities of a binomial and a Dirichlet prior over the
  parameters of a multinomial. For more on Bayesian modeling and
  conjugacy see \citealp{Gelman:bayesian95}.
\end{boxfloat}

We can perform this integral analytically: the Gaussian prior is
conjugate to the latent variables in the likelihood (see
\refbox{box:conjugacy}). The first step is to write down the joint
density,
\[
p(\dataVector_{i, :}, \latentVector_{i, :}) \propto \exp\left( -
  \frac{1}{2\dataStd^2}\left(\dataVector_{i,:} -
    \mappingMatrix\latentVector_{i, :}-\meanVector\right)^\top
  \left(\dataVector_{i,:} - \mappingMatrix\latentVector_{i,
      :}-\meanVector\right) - \half\latentVector_{i, :}^\top
  \latentVector_{i, :}\right).
\]
To marginalize the latent variables we collect terms involving
$\latentVector_{i, :}$,
\[
p(\dataVector_{i, :}, \latentVector_{i, :}) \propto \exp\left( -
  \frac{1}{2\dataStd^{2}}(\dataVector_{i,:}
  -\meanVector)^\top(\dataVector_{i,:} -\meanVector) -
  \half\latentVector_{i,:}^\top\boldsymbol{\Sigma}_\latentScalar^{-1}\latentVector_{i,
    :} + \dataStd^{-2}(\dataVector_{i,:} -
  \meanVector)^\top\mappingMatrix\latentVector_{i, :}\right).
\]
where we have introduced
$\boldsymbol{\Sigma}_\latentScalar=(\dataStd^{-2}\mappingMatrix^\top\mappingMatrix+\eye)^{-1}$. We
now complete the square\footnote{Completing the square for a matrix
  quadratic form is similar to the univariate case. We first look to
  express the quadratic form as a matrix inner product and we then
  compensate for the constant term that arises by adding it back in.}
for $\latentVector_{i, :}$,
\begin{align*}
  p(\dataVector_{i, :}, \latentVector_{i, :}) \propto &\exp\Bigg( - \half(\dataVector_{i,:} -\meanVector)^\top (\dataStd^{-2}\eye - \dataStd^{-4}\mappingMatrix\boldsymbol{\Sigma}_\latentScalar\mappingMatrix^\top)(\dataVector_{i,:} -\meanVector)  \\
  &-\half\left(\latentVector_{i, :} -
    \boldsymbol{\Sigma}_\latentScalar\dataStd^{-2}(\dataVector_{i,:} -
    \meanVector)\right)^\top\boldsymbol{\Sigma}_\latentScalar^{-1}\left(\latentVector_{i,
      :} -
    \boldsymbol{\Sigma}_\latentScalar\dataStd^{-2}(\dataVector_{i,:} -
    \meanVector)\right)\Bigg).\label{eq:refactorizedJoint}
\end{align*}
This process of completing the matrix square is a very common
operation when manipulating Gaussians. Here it has had the effect of
refactorizing the joint density into the form $p(\dataVector_{i,:},
\latentVector_{i,
  :})=p(\dataVector_{i,:})p(\latentVector_{i,:}|\dataVector_{i,:})$,
i.e. the product of the posterior and the marginal likelihood. We
recognize the first term in the exponent of
\refeq{eq:refactorizedJoint} as belonging to the marginal likelihood,
\[
p\left(\dataVector_{i, :}\right) \propto \exp\left(-\half
  (\dataVector_{i,:} -\meanVector)^\top (\dataStd^{-2}\eye -
  \dataStd^{-4}\mappingMatrix\boldsymbol{\Sigma}_\latentScalar\mappingMatrix^\top)(\dataVector_{i,:}
  -\meanVector)\right)
\]
and the second as being from the posterior of the latent variables
given the data,
\[
p\left(\latentVector_{i, :}|\dataVector_{i, :}\right) \propto
\exp\left(- \half\left(\latentVector_{i, :} -
    \boldsymbol{\Sigma}_\latentScalar\dataStd^{-2}(\dataVector_{i,:} -
    \meanVector)\right)^\top\boldsymbol{\Sigma}_\latentScalar^{-1}\left(\latentVector_{i,
      :} -
    \boldsymbol{\Sigma}_\latentScalar\dataStd^{-2}(\dataVector_{i,:} -
    \meanVector)\right)\right).
\]
Both these densities are also in the form of Gaussians.

We will return to the posterior density later, for the moment though
we will focus on the marginal likelihood. As we mentioned the marginal
likelihood is in the form of a multivariate Gaussian. By inspection we
can identify that the mean of that Gaussian is given by $\meanVector$
and the covariance is given by $(\dataStd^{-2}\eye -
\dataStd^{-4}\mappingMatrix\boldsymbol{\Sigma}_\latentScalar\mappingMatrix^\top)^{-1}$. We
can use the matrix inversion lemma (see \refbox{box:inversion}) to
rewrite this as
\[
(\dataStd^{-2}\eye -
\dataStd^{-4}\mappingMatrix\boldsymbol{\Sigma}_\latentScalar\mappingMatrix^\top)^{-1} = \dataStd^2\eye  + \mappingMatrix\mappingMatrix^\top.
\]
So the final marginal likelihood has the form
\[
\dataVector_{i, :} \sim \gaussianSamp{\meanVector}{\covarianceMatrix}.
\]
where the covariance matrix is given by $\covarianceMatrix = \mappingMatrix\mappingMatrix^\top + \dataStd^2\eye$.

This marginal likelihood can also be derived using properties of
multivariate Gaussians. Our model was as follows: generate each
observation by sampling a $\latentDim$-dimensional vector from a zero
mean Gaussian with covariance $\eye$,
\[
\latentVector_{i, :}\sim \gaussianSamp{0}{\eye}.
\]
This vector is then multiplied by a matrix $\mappingMatrix$ and
corrupted by Gaussian noise,
\[
\dataVector_{i, :} = \mappingMatrix \latentVector_{i, :} + \meanVector + \noiseVector.
\]
This is enough information to specify the covariance of the data
density. Multiplying a variable sampled from a zero mean multivariate
Gaussian (with unit covariance) by $\mappingMatrix$ leads to a sample
from a zero mean Gaussian with covariance $\mappingMatrix
\mappingMatrix^\top$. We then add a vector $\meanVector$ and corrupt
the result through additive Gaussian noise. Adding $\meanVector$
merely shifts the mean of the Gaussian fro $\zerosVector$ to
$\meanVector$. Adding the corrupting noise is equivalent to summing two
Gaussian random variables: the resulting variable's covariance is the
sum of the two covariances. So if the noise has covariance
$\dataStd^2$ then we have
\[
\dataVector_{i, :} \sim \gaussianSamp{\meanVector}{\mappingMatrix\mappingMatrix^\top + \dataStd^2\eye}.
\]

\begin{boxfloat}
  \caption{The Matrix Inversion Lemma}\label{box:inversion}
  
  \boxfontsize The matrix inversion gives an approach to rewriting
  matrix inverses of the form $(\mathbf{A} +
  \mathbf{B}\mathbf{C}\mathbf{D})^{-1}$, where
  $\mathbf{A}\in\Re^{n\times n}$ and $\mathbf{C}\in \Re^{m\times m}$
  are both invertible matrices. The matrix $\mathbf{B}\in \Re{n
    \times m}$ and $\mathbf{D}\in \Re{m\times n}$. The lemma states
  in general terms that this inverse can be rewritten as
  \[
  (\mathbf{A} + \mathbf{B}\mathbf{C}\mathbf{D})^{-1} = \mathbf{A}^{-1}
  - \mathbf{A}^{-1}\mathbf{B}\left(\mathbf{C}^{-1} +
    \mathbf{D}^\top\mathbf{A}^{-1}\mathbf{B}^\top\right)^{-1}\mathbf{D}\mathbf{A}^{-1}.
  \]
  It can be particularly useful when the inverse of $\mathbf{A}$ is
  quick to compute, for example if it is diagonal. In these cases it
  allows us to move between computing an inverse of an $m\times m$
  matrix and an $n \times n$ matrix which can lead to computational
  savings. For example we might be interested in an inverse of the form
  \[
  (a\eye + \mathbf{B}\mathbf{B}^\top)^{-1} = a^{-1}\eye - a^{-2}\mathbf{B}\left(\eye + a^{-1}\mathbf{B}^\top\mathbf{B}\right)\mathbf{B}^\top.
  \]
  The formula is very useful for algebraic manipulation, but in
  implementation some care must be taken in its application: computing
  the left hand side is more numerically stable than computing the
  right hand side.
\end{boxfloat}

The covariance of the Gaussian model we have derived is recognized as
the same covariance we used to produce the samples in
\refsec{sec:anotherLook}. There we used a probabilistic PCA model with
a latent dimensionality of $\latentDim=2$ (for data of dimensionality
$\dataDim=1000$). The squared distance histogram we obtained was far
closer to the theory for two dimensional data than that for 1000
dimensional data.

% This is because the Gaussian prior we chose is the conjugate prior for the 

% The latent variable model approach is to define a prior distribution
% over the latent variables and integrate them out. A convenient choice
% of prior, due to its analytic properties\footnote{We might also
%   motivate the Gaussian choice of prior through maximum entropy
%   arguments or appeals to the central limit theorem. However,
%   pragmatism may be the dominant motivation for its widespread use as
%   both a prior and a likelihood. Models derived from it are typically
%   more tractable.}, is Gaussian. 


\begin{figure}
  \begin{center}
    \includegraphics[width=0.5\textwidth]{../../../gplvm/tex/diagrams/ppcaGraph}
  \end{center}
  \caption{What goes here.}
\end{figure}

% \[
% p\left(\latentMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\latentVector_{i,:}}{\zerosVector}{\eye}
% \]
% \[
% p\left(\dataMatrix|\mappingMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\dataVector_{i,:}}{\zerosVector}{\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye}\]



\section{Optimization of Probabilistic PCA}

Our objective is to find the parameters of the model. We do this
through maximum likelihood. The idea is to find the parameters which
make the data more likely than any other. Maximum likelihood\index{maximum likelihood} is often
justified through consistency arguments. These arguments run as
follows: if the data was really generated by a variant of the model
you are considering, then as the size of the data set you have
approaches infinity then you will recover the original model. We can
show this consistency by introducing the Kullback-Leibler (KL)
divergence\index{Kullback-Leibler (KL) divergence}
(\refbox{Kullback:info51}). Let's assume that the true data generating
density is given by $p(\dataMatrix)$. The inclusive KL-divergence
between the true data generating density and our approximation is
given by
\[
\KL{p(\dataMatrix)}{p(\dataMatrix| \mappingMatrix, \dataStd^2,
  \meanVector)} = \int p(\dataMatrix) \log
\frac{p(\dataMatrix)}{p(\dataMatrix| \mappingMatrix, \dataStd^2,
  \meanVector)} \mathrm{d}\dataMatrix.
\]
we rewrite this in the form of two expectations
\[
\KL{p(\dataMatrix)}{p(\dataMatrix| \mappingMatrix, \dataStd^2,
  \meanVector)} = \expDist{\log p(\dataMatrix)}{p(\dataMatrix)} -
\expDist{\log p(\dataMatrix| \mappingMatrix, \dataStd^2,
  \meanVector)}{p(\dataMatrix)}.
\]
The first expectation is simply the negative entropy of the true data
generating density. It is not affected by the parameters of the
model. The second term is the expectation of the log likelihood of the
data under the true generating density, $p(\dataMatrix)$. If the log
likelihood of the data factorizes across the data points,
\[
p(\dataMatrix|\mappingMatrix, \dataStd^2, \meanVector) =
\prod_{i=1}^\numData p(\dataVector_{:, i}| \mappingMatrix, \dataStd^2,
\meanVector),
\]
then we can write that expectation as 
\[
\expDist{\log p(\dataMatrix|\mappingMatrix, \dataStd^2,
  \meanVector)}{p(\dataMatrix)} = \sum_{i=1}^\numData \expDist{\log
  p(\dataVector_{:, i}| \mappingMatrix, \dataStd^2,
  \meanVector)}{p(\dataVector_{:, i})},
\]
If the samples are
\emph{exchangeable}\index{exchangeability}\glossary{name={exchangeability},
  description={\fixme{Description of exchangeability!! }}} \fixme{Not
  sure if we need exchangeability here, if we do we need a box on it! Need to explain why the marginal is then the same ...}
then the marginal likelihood for each data point will be the same and
we can write this as
\[
\expDist{\log p(\dataMatrix|\mappingMatrix, \dataStd^2,
  \meanVector)}{p(\dataMatrix)} = \numData\expDist{\log
  p(\dataVector| \mappingMatrix, \dataStd^2,
  \meanVector)}{p(\dataVector)},
\]
where we are using $p(\dataVector)$ to marginal probability for any single data point.

\begin{boxfloat}
  \caption{The Kullback-Leibler Divergence}
  
  \boxfontsize The Kullback-Leibler divergence\index{Kullback-Leibler (KL) divergence} \cite{Kullback:info51},
  also known as the relative entropy \fixme{AND WHAT ELSE} is an
  information theoretic assessment of the dissimilarity between two
  distributions or densities. It is the expected value of the log
  ratio of the two densities. The asymmetry arises as you must choose
  one of the densities for the expectation. Here, for example, we
  compare two densities $p(x)$ and $q(x)$ and take the expectation
  under $p(x)$
  \[
  \KL{p(x)}{q(x)} = \int p(x) \log \frac{p(x)}{q(x)} \mathrm{d}x.
  \]
  The log ratio is always taken such that whichever density is used
  for the expectation is always the numerator in the ratio. \emph{Jensen's
    inequality}\index{Jensen's inequality}\glossary{
    name={Jensen's inequality}, 
    description={\fixme{More detail} is an inequality between the sum of a convex function and the convex function of a sum. In probability it is perhaps most used to relate the sum of logarithms with the logarithm of a sum,
      \[
      \sum_i \log f_i(x) \leq \log \sum_i f_i(x).
      \]
    }
  }
  can be used to show that the KL-divergence\index{Kullback-Leibler (KL) divergence} is always
  positive unless $q(x)=p(x)$ when it is zero. This allows the
  KL-divergence\index{Kullback-Leibler (KL) divergence} to be used when approximating one density with
  another. We can minimize the KL-divergence with respect to $q(x)$ to
  find an approximation for $p(x)$. When performing these
  optimizations we must typically make a choice of which KL-divergence
  to use. If the expectation is taken under $p(x)$ we call this as the
  \emph{inclusive} KL-divergence\index{Kullback-Leibler (KL) divergence}. If it is taken under $q(x)$ we call
  this the \emph{exclusive} KL-divergence\index{Kullback-Leibler (KL) divergence}. The term inclusive reflects
  the fact that when we wish to approximate $p(x)$ and we take the
  expectation under that density we \emph{include} in that expectation
  all the actual areas of high density. The exclusive form only
  considers areas of high density under the approximating density. 
\end{boxfloat}

We don't have the true marginal, $p(\dataVector)$, but we do have
samples from it: these are our data points. We therefore make use of a
sample based approximation (see \refbox{box:sample}) to the integral,
\[
\expDist{\log
  p(\dataVector| \mappingMatrix, \dataStd^2,
  \meanVector)}{p(\dataVector)} = \frac{1}{\numData}\sum_{i=1}^\numData\log
p(\dataVector_i| \mappingMatrix, \dataStd^2,
\meanVector).
\]

\begin{boxfloat}
  \caption{Sample Approximations to Integrals}\label{box:sample}

  \boxfontsize A sample based approximation to an integral is a discrete sum approximation. The approximation has the form
  \[
  \int f(x) p(x) \mathrm{d}x \approx \frac{1}{S} \sum_{i=1}^Sf(x_i)
  \]
  if $\{x_i\}_{i=1}^S$ are a set of samples from $p(x)$. As the number of samples approaches infinity, this approximation becomes exact.  
\end{boxfloat}

\section{Maximizing the Log Likelihood\index{maximum likelihood}}


For probabilistic PCA we now look for the values of $\mappingMatrix$, $\meanVector$ and $\dataStd^2$ that maximize the likelihood of the model. The log likelihood of the model is given by 
\[
\log p(\dataMatrix|\mappingMatrix, \meanVector, \dataStd^2) = -\frac{\numData\dataDim}{2}\log 2\pi -\frac{\numData}{2}\log \det{\covarianceMatrix} - \half \sum_{i=1}^\numData (\dataVector_{i, :}-\meanVector)^\top \covarianceMatrix^{-1}(\dataVector_{i, :}-\meanVector).
\]
This is our objective function. We want to find the global maximum of
this function with respect to the parameters. This is achieved by
differentiating the function with respect to the parameters and
finding where the gradient is zero. Maximization problems always have
an equivalent minimization problem: simply place a minus sign in front
of the objective. By convention, the optimization community prefers to
discuss minimization rather than maximization. Optimization forms a
very important component of the machine learning. There is a strong
case for the argument that machine learning is nothing more than model
formulation (writing down an objective function) and optimization. The
approach to model formulation we are taking in this chapter is a
probabilistic one. In an acknowledgement of the importance of
optimization for machine learning, we follow their convention and
consider minimizing the negative log likelihood:
\begin{equation}
  E(\mappingMatrix, \meanVector, \dataStd^2) = \frac{\numData}{2}\log
  \det{\covarianceMatrix} + \half \sum_{i=1}^\numData
  (\dataVector_{i, :}-\meanVector)^\top
  \covarianceMatrix^{-1}(\dataVector_{i, :}-\meanVector), \label{eq:ppcaError}
\end{equation}
where we have dropped the term which is constant in the
parameters. This objective function is sometimes known as an
\emph{error function}.\glossary{name={error function}, description={In
    machine learning error function is often used to refer to the
    objective function that is being minimized.}} But we can think of
it as a proxy for the KL-divergence\index{Kullback-Leibler (KL)
  divergence} we are trying to minimize.

\section{Optimizing the Mean Vector}

We will first look for the minimum of \refeq{eq:ppcaError} with
respect to the vector $\meanVector$. This involves looking for the
gradient of the error function with respect to each element of the
vector $\meanVector$. We can think of this as multivariate calculus:
the usual rules of calculus apply, but here they are being applied to
matrix operations. However, matrix operations are merely a short-hand
for a series of operations being placed on a collection of
parameters. Matrix differentiation\index{matrix calculus} has a
generalized set of rules. The term of the error function involving the
mean is the last term,
\[
E(\meanVector) = -\half\sum_{i=1}^\numData
(\dataVector_{i, :}-\meanVector)^\top
\covarianceMatrix^{-1}(\dataVector_{i, :}-\meanVector)
\]
which is recognized as the matrix equivalent of a quadratic: a
quadratic form\index{quadratic form}. The gradient of this form with
respect to the mean vector is
\[
\diff{E(\meanVector)}{\meanVector} = \sum_{i=1}^\numData
\covarianceMatrix^{-1}(\dataVector_{i, :}-\meanVector)
\]
which can be rewritten
\[
\diff{E(\meanVector)}{\meanVector} =
\covarianceMatrix^{-1}\left(\sum_{i=1}^\numData\dataVector_{i,
    :}-\numData\meanVector\right).
\]
To find the minimum, we look for a point where the gradients of the
function are all zero,
\[
\zerosVector =
\covarianceMatrix^{-1}\left(\sum_{i=1}^\numData\dataVector_{i,
    :}-\numData\meanVector\right)
\]
which implies that
\begin{align*}
  \covarianceMatrix^{-1}\meanVector & = \covarianceMatrix^{-1}\frac{1}{\numData} \sum_{i=1}^\numData \dataVector_{i,:}\\
  \meanVector & = \frac{1}{\numData}
  \sum_{i=1}^\numData \dataVector_{i,:}.
\end{align*}
So the gradients are zero when $\meanVector$ is given by the sample
mean of the data. We can double check that this is a minimum by
looking at the curvature of the error function. The curvature is found
by the second derivative of the error function. In multivariate
systems, the curvature consists of a matrix (it includes all possible
second derivatives between the parameters), it is also known as the
Hessian. The Hessian for this system is easily derived,
\[
\frac{\mathrm{d}^2E(\meanVector)}{\mathrm{d}\meanVector\meanVector^\top}
= \covarianceMatrix^{-1},
\]
it is given by the inverse covariance matrix: also known as the
\emph{precision} or \emph{information
  matrix}.\index{precision matrix}\index{information matrix|see{precision matrix}}\glossary{name={precision matrix}, description={The
    precision matrix is the inverse of the covariance matrix. It is
    also known as the information matrix and is important when
    defining conditional independencies in Gaussian
    systems.}}\glossary{name={information matrix}, description={In the
    context of Gaussian densities the information matrix is an
    alternative name for the precision matrix.}} This matrix is known
to be positive definite if the Gaussian is to be normalizable. This
implies that the solution for $\meanVector$ is a minimum. We also note
that the curvature is not dependent on the solution for
$\meanVector$. This implies that the problem is convex, which means
that the minimum is unique. 

In other words, a maximum likelihood solution for the mean vector is
given by the sample mean, the fact that the optimization surface is
convex, and that the solution is not dependent on the covariance
matrix, means that this solution is a global minimum of the objective
function. It can be computed before either $\mappingMatrix$ and
$\dataStd^2$ are known. For this reason, we often consider the data to
be \emph{centered} and we ignore the mean. In \reftip{tip:centered} we
show how this operation can be applied. We follow this approach when
finding the rest of the maximum likelihood solution.
\begin{tipfloat}
  \caption{Centered Data Sets}\label{tip:centered}

  \boxfontsize It is very often convenient (for notational reasons) to
  deal with a centered data set. As we have seen in the main text, the
  maximum likelihood solution for the mean vector of a Gaussian is
  that it should equal the sample mean. A centered data set is one
  where the sample mean of the data has been subtracted, when working
  with a centered data and Gaussian densities, we can assume that we
  have already found the maximum likelihood solution for the mean. 

  We can center a data set stored in a design matrix with the
  following operation,
  \[
  \cdataMatrix = \dataMatrix - \onesVector \meanVector^\top,
  \]
  where $\meanVector$ is the \emph{sample mean}.\glossary{name={sample
      mean}, description={A sample mean is the value obtained when the
      data points are summed together and divided by the total number
      of data points. It is a sample based approximation of the true
      mean, which is the expected value of a data point.}} This
  operation can also be carried out through multiplication by a
  \emph{centering matrix},\index{centering
    matrix}\glossary{name={centering matrix}, description={the
      centering matrix, denoted in this book by $\centeringMatrix$, is
      a matrix which, when premultiplying a design matrix returns a
      centered version of the data, where the center is defined by the
      sample mean of the data set.}}
  \[
  \centeringMatrix=\eye-\numData^{-1}\onesVector\onesVector^{\top}\in\Re^{\numData\times\numData},
  \]
  so we have $\cdataMatrix = \centeringMatrix \dataMatrix$. When
  modeling a centered data set with a Gaussian density we can set the
  mean of the Gaussian to be zero and we know we have the maximum
  likelihood solution.
\end{tipfloat}

\section{Optimizing the Covariance}

A common trick to reduce the notational complexity of equations is to work with the centered data set. This is useful for making equations shorter, but it is worth bearing in mind that it only works because the maximum likelihood solution for the mean is the sample mean. Given this solution, we can center the
data set and work with $\cdataMatrix = \dataMatrix -
\onesVector\meanVector^\top$. Substituting this form into the likelihood results in a new ``likelihood'' over the centered data,
% \[
% p\left(\cdataMatrix|\mappingMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\cdataVector_{i,:}}{\zerosVector}{\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye}
% \]
% which can be rewritten
\[
p\left(\cdataMatrix|\mappingMatrix\right)=\prod_{j=1}^{\dataDim}\gaussianDist{\cdataVector_{i,:}}{\zerosVector}{\covarianceMatrix},
\]
where we are using the particular form for the covariance matrix, $
\covarianceMatrix=\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye
$. \citet{Tipping:probpca99} showed that the global maximum likelihood
solution for the parameters $\mappingMatrix$ and $\dataStd^2$ can be
found through an eigenvalue problem. Before we review how that is
done, we will first show what the maximum likelihood solution for an
unconstrained covariance matrix would be, i.e. for the moment we will
ignore the fact that $
\covarianceMatrix=\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye
$ and allow $\covarianceMatrix$ to be any positive definite matrix.


The negative log likelihood\footnote{The equivalence between this
  expression and the negative log likelihood we used in the previous
  section can easily be seen if you set $\cdataVector_{i,
    :}=\dataVector_{i, :} - \meanVector$ and recall that at the
  minimum $\meanVector=\frac{1}{\numData}\sum_{i=1}^\numData
  \dataVector_{i, :}$.} of the data is
\[
E(\mappingMatrix, \dataStd^2) = \frac{\numData\dataDim}{2}\log 2\pi + \frac{\numData}{2}\log \det{\covarianceMatrix} + \half\sum_{i=1}^\numData\cdataVector_{i, :}^\top \covarianceMatrix^{-1} \cdataVector_{i, :}.
\]
We are going to look for the minimum through matrix calculus. This
means that it is much more convenient to use matrix notation for all
terms in our objective instead of the sum sign. To do this we can
introduce the matrix trace (see \refbox{box:trace}). The matrix trace
(which is the sum of the diagonal terms of a matrix) allows us to
write
\[
E(\mappingMatrix, \dataStd^2) = \frac{\numData\dataDim}{2}\log 2\pi + \frac{\numData}{2}\log \det{\covarianceMatrix} + \half\tr{\covarianceMatrix^{-1} \cdataMatrix^\top \cdataMatrix}.
\]
\begin{boxfloat}
  \caption{The Trace of a Matrix\index{trace (of a matrix)}}\label{box:trace}

  \boxfontsize The trace of a matrix is merely the sum of its
  diagonals.
  \[
  \tr{\mathbf{A}} = \sum_{i} a_{i,i}
  \]
  However, it has some important characteristics. Whilst in normal
  matrix multiplication, the ordering is important, within a trace the
  ordering becomes less important, so for example
  \[
  \tr{\mathbf{A}\mathbf{B}} = \tr{\mathbf{B}\mathbf{A}}
  \]
  if $\mathbf{A}$ and $\mathbf{B}$ are both square matrices. This is
  very useful when computing expectations of matrix quadratic
  forms. We can write a sum as matrix inner products as $
  \sum_{i=1}^\numData \dataVector_{i,
    :}^\top\covarianceMatrix^{-1}\dataVector_{i, :} $ Consider the
  following matrix, $ \mathbf{A} =
  \dataMatrix\covarianceMatrix^{-1}\dataMatrix^\top, $ it has
  dimensionality $\numData \times \numData$ (see
  \reftip{tip:matrixMultiplications}). The element from the $i$th row
  and $j$th of $\mathbf{A}$ is given by
  \[
  a_{i, j} = \dataVector_{i, :}^\top\covarianceMatrix^{-1}\dataVector_{j, :}.
  \]
  The trace of $\mathbf{A}$  will be the sum of the diagonal elements, 
  \[
  \tr{\dataMatrix\covarianceMatrix^{-1}\dataMatrix^\top } = \sum_{i=1}^\numData \dataVector_{i, :}^\top\covarianceMatrix^{-1}\dataVector_{i, :},
  \]
  recovering the sum of matrix inner products. The ordering property
  of the trace means that
  \[
  \tr{\dataMatrix\covarianceMatrix^{-1}\dataMatrix^\top } =
  \tr{\covarianceMatrix^{-1}\dataMatrix^\top\dataMatrix}.
  \]
  This reformulation can be very useful when computing expectations of
  quadratic forms,
  \[
  \sum_{i=1}^\numData \expDist{\dataVector_{i,
      :}^\top\covarianceMatrix^{-1}\dataVector_{i, :}}{p(\dataMatrix)}
  = \tr{\covarianceMatrix^{-1} \expDist{\dataMatrix^\top
      \dataMatrix}{p(\dataMatrix)}}.
  \]
  
  \emph{Important note}: although we make use of the notation
  $\tr{\dataMatrix\covarianceMatrix^{-1}\dataMatrix^\top}$ you
  shouldn't normally compute it that way. For example in Octave/Matlab
  you might be tempted to write \lstset{language=Matlab}
  \begin{lstlisting}
    trace(Y*Cinv*Y')
  \end{lstlisting}
  but this will use matrix multiplications to create an $\numData
  \times \numData$ matrix, and then only the diagonal elements are
  needed in the resulting sum.  More efficient would be
  \begin{lstlisting}
    sum(sum(Y.*(Y*Cinv)))
  \end{lstlisting}
  where \lstinline!.*! is Matlab/Octave notation for the element by
  element product ($\odot$). 
\end{boxfloat}

\begin{tipfloat}
  \caption{Matrix Dimensions}\label{tip:matrixMultiplication}

  \boxfontsize This is perhaps an obvious trick, but a very useful one
  so worth reinforcing. We will be making a lot of use of matrix
  notation in this book. When using matrix multiplication it is easy to
  get confused about where transposes should be and what the ordering
  should be. One important sanity check is a dimensionality check on the
  matrices. We have defined the data matrix to be $\dataMatrix \in
  \Re^{\numData \times \dataDim}$ and the inverse covariance matrix is
  $\covarianceMatrix^{-1} \in \Re^{\dataDim\times \dataDim}$. When
  writing down a multiplication of these matrices try writing the
  dimensionalities below,
  \begin{align*}
    \begin{array}{cccc}
      \dataMatrix &  \covarianceMatrix^{-1} &\dataMatrix^\top & \mathrm{matrix\ multiplication}\\
      \numData \times \dataDim & \dataDim \times \dataDim & \dataDim \times \numData & = \numData \times \numData\ \mathrm{dimensionalities}.
    \end{array}
  \end{align*}
  At the interface between the multiplications, the dimensionalities
  should match. The final dimensionality is found by ``canceling'' these
  interface dimensionalities. You should get in the habit of performing this sanity check when writing down equations.

  If $\kernelMatrix \in \Re^{\numData\times\numData}$ and recalling
  that $\latentMatrix \in \Re^{\numData\times\latentDim}$ and
  $\mappingMatrix \in \Re^{\dataDim\times \latentDim}$ confirm for
  yourself the dimensionality of the results from the following
  operations:
  \begin{align*}
    \dataMatrix^\top \kernelMatrix \dataMatrix \\
    \latentMatrix\latentMatrix^\top \kernelMatrix \\
    \latentMatrix\mappingMatrix^\top - \dataMatrix\\
    \latentMatrix\latentMatrix^\top\kernelMatrix^{-1}\dataMatrix
  \end{align*}
\end{tipfloat}
Now we have our objective function in the form of matrix operations,
we can compute the gradient of the objective with respect to the
coovariance matrix using results from matrix calculus (see also
\refapp{app:matrixCalculus}). Many of these results will also prove
useful in future chapters, so we will go through them in a little more
detail here. First of all we can compute the gradient with respect to
the covariance matrix, $\covarianceMatrix$. This involves a couple of
matrix derivatives. Firstly, we need the gradient of the log
determinant,
\[
\diff{\log \det{\covarianceMatrix}}{\covarianceMatrix} = \covarianceMatrix^{-1}.\label{eq:lndetGrad}
\]
The gradient of the log determinant has a nice simple form:
determinants are associated with volumes and therefore dependent on
products across dimensions. The logarithms of products lead to sums,
typically leading to simpler derivatives than the gradient of the
product directly. 
\begin{intfloat}
  \caption{Gradient of the Log Determinant}\label{int:gradientLogDeterminant}

  \boxfontsize Determinants represent volumes (see
  \refbox{box:determinant}). When we take the gradient of the
  determinants logarithm we are seeing how the log volume changes with
  respect to elements of the matrix. This is perhaps easier to see if we
  first consider a diagonal matrix,
  $\covarianceMatrix=\eigenvalueMatrix^2$ where $\eigenvalueMatrix$ is a
  diagonal matrix. Now the log determinant is simply given by
  \[
  \log\det{\eigenvalueMatrix^2} = \sum_i^\dataDim \log \eigenvalue_i^2.
  \]
  The gradient of this sum with respect to an off diagonal element of $\eigenvalueMatrix$ is zero. The gradient with respect to the $i$th diagonal element is,
  \[
  \diff{\sum_{j=1}^\dataDim\log \eigenvalue_j^2}{\eigenvalue_i^2}=\eigenvalue_i^{-2}
  \]
  so we have 
  \[
  \diff{\log\det{\eigenvalueMatrix^2}}{\eigenvalueMatrix^2} = \eigenvalueMatrix^{-2}.
  \]
  What this is basically saying is that the largest changes are made
  to the log volume by changes in the smallest values of
  $\eigenvalue_i$. When applied to positive definite matrices, similar
  intuitions apply but the basis $\eigenvalueMatrix^2$ is rotated,
  \[
  \diff{\log\det{\eigenvectorMatrix\eigenvalueMatrix^2\eigenvectorMatrix^\top}}{\eigenvectorMatrix\eigenvalueMatrix^2\eigenvectorMatrix^\top} = \eigenvectorMatrix\eigenvalueMatrix^{-2}\eigenvectorMatrix^\top,
  \]
  since any symmetric positive definite matrix can be represented by
  $\covarianceMatrix=\eigenvectorMatrix\eigenvalueMatrix^2\eigenvectorMatrix^\top$
  and $\covarianceMatrix^{-1}=
  \eigenvectorMatrix\eigenvalueMatrix^{-2}\eigenvectorMatrix^\top$
  because $\eigenvectorMatrix^\top \eigenvectorMatrix =\eye$ we
  recover
  \[
  \diff{\log\det{\covarianceMatrix}}{\covarianceMatrix} = \covarianceMatrix^{-1}
  \]
  this result is a multivariate generalization of the univariate derivative,
  \[
  \diff{\log \eigenvalue}{\eigenvalue} =\frac{1}{\lambda}.
  \]
\end{intfloat}

Secondly we need to be able to compute the gradient of the trace
term. This is slightly more involved as the $\covarianceMatrix$ appears in inverse form. We will therefore need to make use of the following relationship,
\[
\diff{f}{\covarianceMatrix} =
-\covarianceMatrix^{-1}\diff{f}{\covarianceMatrix^{-1}}
\covarianceMatrix^{-1},\label{eq:invGrad}
\]
which is a multivariate generalization of
\[
\diff{f}{\eigenvalue} = -\eigenvalue^{-2}\diff{f}{\eigenvalue^{-1}}
\]
which can be derived through the chain rule. 

\begin{intfloat}
  \caption{Derivative of a Trace\index{trace (of a matrix)}}\label{int:traceDerivative}


  \boxfontsize The trace of the matrix is the sum of the diagonal values. So for any matrix we have,
  \[
  \tr{\mathbf{A}} = \sum_{i=1}^\dataDim a_{i,i},
  \]
  where $a_{i,i}$ is the $i$th diagonal element of the matrix. We can easily differentiate this expression with respect to all elements of the matrix giving the identity,
  \[
  \diff{\tr{\mathbf{A}}}{\mathbf{A}} = \eye,
  \]
  as a result. This is because the gradient of the diagonal sum with
  respect to each off diagonal element is zero whilst the gradient with
  respect to each diagonal element is unity.

  For a trace of a product of matrices,
  \[
  \tr{\mathbf{A}\mathbf{B}} = \sum_{i=1}^\dataDim \mathbf{a}_{i,
    :}^\top\mathbf{b}_{:,i} = \sum_{i=1}\sum_{j=1} a_{i, j} b_{j,i}
  \]
  so the gradients are given by
  \[
  \diff{\tr{\mathbf{A}\mathbf{B}}}{\mathbf{A}} =\mathbf{B}^\top.
  \]
\end{intfloat}

That leaves us with computation of the matrix derivative of a trace
(see \refint{int:traceDerivative}). The direct derivative of a trace is given by
the identity matrix,
\[
\diff{\tr{\mathbf{A}}}{\mathbf{A}}=\eye. 
\]
If the matrix is part of a product within the trace then the result is
\[
\diff{\tr{\mathbf{A}\mathbf{B}}}{\mathbf{A}}=\mathbf{B}^\top. 
\]
so for the trace term that appears in the log likelihood we can make use of the following result,
\[
\diff{\tr{\covarianceMatrix^{-1}\cdataMatrix^\top\cdataMatrix}}{\covarianceMatrix^{-1}}=\cdataMatrix^\top\cdataMatrix.
\]
Combining it with with \refeqs{eq:lndetGrad}{eq:invGrad} we can write down the gradient of the negative log likelihood with respect to the covariance matrix,
\begin{equation}
  \diff{E(\mappingMatrix, \dataStd^2)}{\covarianceMatrix} = \frac{\numData}{2}\covarianceMatrix^{-1} - \half\covarianceMatrix^{-1} \cdataMatrix^\top\cdataMatrix \covarianceMatrix^{-1}.\label{eq:gaussianGrad}
\end{equation}
The covariance matrix, $\covarianceMatrix$, has a particular structure
for this probabilistic PCA model, so it is not legitimate to optimize
directly with respect to the covariance matrix. We need to find the
gradients with respect to the mapping matrix, $\mappingMatrix$ and the
noise variance $\dataStd^2$. However, while we are here it seems
legitimate to take a slight detour and remind ourselves what the
maximum likelihood solution for the covariance matrix is. It will
prove useful when we contrast with the solution for probabilistic PCA.

Setting the gradient of \refeq{eq:gaussianGrad} to zero and
rearranging we find that at a stationary point we have
\[
\covarianceMatrix = \numData^{-1}\cdataMatrix^\top\cdataMatrix.
\]
This can also be written as
\[
\covarianceMatrix = \numData^{-1} \sum_{i=1}^\numData \cdataVector_{i,
  :}\cdataVector_{i, :}^\top = \numData^{-1}\sum_{i=1}^\numData
\left(\dataVector_{i, :}-\meanVector\right)\left(\dataVector_{i,
    :}-\meanVector\right)^\top.
\]
In statistics this is known as the sample covariance (it is the sample
based approximation to the covariance). So if the covariance matrix of
the Gaussian model is unconstrained then a stationary point in the
likelihood solution is given by setting the covariance to the sample
covariance of the data, $\covarianceMatrix =
\numData^{-1}\cdataMatrix^\top\cdataMatrix$. Further analysis can be
used to show that this stationary point is a maximum of the
likelihood. In other words, for the multivariate
Gaussian\index{Gaussian|maximum likelihood solution}\index{maximum
  likelihood} density the maximum likelihood solution corresponds to
setting the mean to the sample mean and the covariance to the sample
covariance. This actually corresponds to a technique known as moment
matching\index{moment matching}---match the first moment of the
density (the mean) to the sample based approximation of the first
moment. Then match the second moment (given by
$\expSamp{\dataMatrix^\top\dataMatrix}$) of the density to the
empirical value. This is an approach to fitting densities that Karl
Pearson\index{Pearson, Karl} suggested. However, it is not always the
case that the maximum likelihood solution corresponds to moment
matching: for a special class of models known as the exponential
family it does (see \refbox{box:exponentialFamily}), but the moments
to be matched must be chosen carefully: they are known as the
sufficient statistics of the density.

\begin{boxfloat}
  \caption{The Exponential Family\index{exponential family}}\label{box:exponentialFamily}

  \boxfontsize The exponential family is a class of distributions and
  densities that can be written in the form
  \[
  p(\dataVector | \parameterVector) = h(\dataVector) \exp \left(\eta(\parameterVector)^\top T(\dataVector) - A(\parameterVector)\right)
  \]
  where $\parameterVector$ is a vector of parameters and $\dataVector$
  is the space over which the density is defined. The function
  $T(\dataVector)$ is known as the sufficient statistic of the
  distribution. The form is dependent on four functions:
  $h(\dataVector)$ and $A(\parameterVector)$ which are scalar
  functions of the data and parameters respectively; $T(\dataVector)$
  and $\eta(\parameterVector)$ which are vector output functions

  \fixme{sufficient statistics}

  \fixme{natural parameters}
  
  \fixme{normalization factor}

\end{boxfloat}

Of course, our multivariate Gaussian density has the special form
$\covarianceMatrix = \mappingMatrix \mappingMatrix^\top + \dataStd^2
\eye$. We do not have the freedom to set the covariance matrix equal
to the sample covariance.

\subsection{Optimizing $\mappingMatrix$ and $\dataStd^2$}

To find the optimal mapping matrix and noise variance we need to make
use of the chain rule for matrix derivatives. Let's consider the noise
variance first. This is a scalar quantity. We are interested in
$\inlineDiff{E(\mappingMatrix, \dataStd^2)}{\dataStd^2}$ and we have
$\inlineDiff{E(\mappingMatrix, \dataStd^2)}{\covarianceMatrix}$: the
gradient with respect to each element of the covariance matrix. We can
use the multivariate chain rule to compute
$\inlineDiff{E(\mappingMatrix, \dataStd^2)}{\dataStd^2}$: we need to
find how each element of the covariance matrix varies with
$\dataStd^2$, $\inlineDiff{\covarianceMatrix}{\dataStd^2}$. We then
multiply this matrix elementwise by $\inlineDiff{E(\mappingMatrix,
  \dataStd^2)}{\covarianceMatrix}$ and sum all the elements to get the
result. Computation of the gradient of the covariance matrix with
respect to the noise variance is relatively trivial,
\[
\diff{\covarianceMatrix}{\dataStd^2} = \eye.
\]
Multiplying these gradients elementwise and summing across the
elements simply leads to the trace,
\[
\diff{E(\mappingMatrix, \dataStd^2)}{\dataStd^2} = \tr{\diff{E(\mappingMatrix, \dataStd^2)}{\covarianceMatrix}}.
\]
\begin{boxfloat}
  \caption{The Multivariate Chain Rule}\label{box:mvchainRule}

  \boxfontsize The chain rule is perhaps the mainstay of differential calculus,
  \[
  \diff{x}{z} = \diff{x}{y} \times \diff{y}{z}.
  \]
  where $x$ is assumed to a function of $y$ and $y$ is a function of
  $z$. The multivariate chain rule is applied when a function has
  several parameters, each of which is dependent on some shared
  parameter. Imagine $x$ is a function of a set of $y$s,
  $\left\{y_i\right\}$, and each $y_i$ depends on $z$, then we have
  \[
  \diff{x}{z} = \sum_{i}\partDiff{x}{y_i} \times \diff{y_i}{z},
  \]
  where $\partDiff{\cdot}{\cdot}$ represents the partial derivative.
  In matrix calculus the derivative
  $\inlineDiff{E}{\covarianceMatrix}$ represents the partial
  derivatives of $E$ with respect to each element of
  $\covarianceMatrix$. The matrix
  $\inlineDiff{\covarianceMatrix}{\dataStd^2}$ is the matrix formed by
  the derivative of each element of $\covarianceMatrix$ with respect
  to $\dataStd^2$. Applying the multivariate chain rule to this system
  gives
  \[
  \diff{E}{\dataStd^2} = \tr{\diff{E}{\covarianceMatrix} \diff{\covarianceMatrix}{\dataStd^2}}
  \]
  where the two matrices of derivatives are being multiplied together
  inside the trace.
\end{boxfloat}

Computing the gradients with respect to the mapping matrix is slightly
more involved. To develop them through the chain rule we need to
introduce an approach for computing the derivative of one matrix,
$\covarianceMatrix$ with respect to another, $\mappingMatrix$. Details
of how this is achieved are given in \refapp{app:matrixCalculus}. Here
we will simply consider the result,
\[
\diff{E(\mappingMatrix, \dataStd^2)}{\mappingMatrix} =
\frac{\numData}{2}\covarianceMatrix^{-1}\mappingMatrix -
\half\covarianceMatrix^{-1} \cdataMatrix^\top\cdataMatrix
\covarianceMatrix^{-1}\mappingMatrix.
\]
We again need to look for stationary points of the system which
implies that
\[
\mappingMatrix = \numData^{-1}\cdataMatrix^\top\cdataMatrix
\covarianceMatrix^{-1}\mappingMatrix.
\]
Note that we can identify the sample based covariance matrix in this
equation, for convenience we represent it by
$\sampleCovMatrix=\numData^{-1}\cdataMatrix^\top\cdataMatrix$. Applying
the matrix inversion lemma to $\covarianceMatrix$ then gives,
\begin{equation}
  \mappingMatrix = \sampleCovMatrix \left[\dataStd^{-2}\mappingMatrix -
    \dataStd^{-4}\mappingMatrix\left(\eye +
      \dataStd^{-2}\mappingMatrix^\top
      \mappingMatrix\right)^{-1}\mappingMatrix^\top\mappingMatrix\right]. \label{eq:statPointMapping}
\end{equation}
\citealp{Tipping:probpca99} showed how we can solve this system for
the mapping matrix. The first step of the solution is to consider the
singular value decomposition of the mapping matrix (see
\refbox{box:svd}),
\[
\mappingMatrix=\eigenvectorMatrix_\latentDim \singularvalueMatrix_\latentDim \rotationMatrix^\top,
\]
substituting into \refeq{eq:statPointMapping} we have 
\begin{align*}
  \eigenvectorMatrix_\latentDim \singularvalueMatrix_\latentDim
  \rotationMatrix^\top & = \sampleCovMatrix
  \left[\dataStd^{-2}\eigenvectorMatrix_q -
    \dataStd^{-4}\eigenvectorMatrix_q\singularvalueMatrix_\latentDim\rotationMatrix^\top\left(\eye
      + \dataStd^{-2}\rotationMatrix
      \singularvalueMatrix_\latentDim^2\rotationMatrix\right)^{-1}\rotationMatrix
    \singularvalueMatrix_\latentDim\right]\singularvalueMatrix_\latentDim\rotationMatrix^\top\\
  & = \sampleCovMatrix 
  \left[\dataStd^{-2}\eigenvectorMatrix_q -
    \dataStd^{-4}\eigenvectorMatrix_q\left(\singularvalueMatrix_\latentDim^{-2}
      + \dataStd^{-2}\eye\right)^{-1}\right]\singularvalueMatrix_\latentDim\rotationMatrix^\top\\
  & = \sampleCovMatrix \eigenvectorMatrix_q
  \left[\dataStd^{-2}\eye -
    \dataStd^{-4}\left(\singularvalueMatrix^{-2}
      + \dataStd^{-2}\eye\right)^{-1}\right]\singularvalueMatrix_\latentDim\rotationMatrix^\top\\
  & = \sampleCovMatrix \eigenvectorMatrix_q
  \left[\dataStd^2\eye + \singularvalueMatrix^2\right]^{-1}\singularvalueMatrix_\latentDim\rotationMatrix^\top.
\end{align*}
post-multiplying both sides by $\rotationMatrix \singularvalueMatrix_\latentDim^{-1} \left[\dataStd^2\eye + \singularvalueMatrix_\latentDim^2\right]$ we recover
\[
\eigenvectorMatrix_\latentDim\left[\dataStd^2\eye + \singularvalueMatrix_\latentDim^2\right] = \sampleCovMatrix \eigenvectorMatrix_\latentDim 
\]
this is recognized as the matrix form of an eigenvalue problem (see
\refbox{box:eigenvalues}). It implies that stationary points are found
when $\eigenvectorMatrix_q$ are eigenvectors of the sample based
covariance matrix, $\sampleCovMatrix$. The associated eigenvalues are
then given by $\dataStd^2\eye + \singularvalueMatrix_\latentDim^2$. We cannot
recover the rotation matrix as all its appearances have canceled. This
makes sense as $\mappingMatrix$ only appears in the likelihood in the
form $\mappingMatrix\mappingMatrix^\top = \eigenvectorMatrix_\latentDim
\singularvalueMatrix_\latentDim^2 \eigenvectorMatrix_\latentDim^\top$. So the likelihood
is insensitive to our choice of $\rotationMatrix$. It is common
practice to set $\rotationMatrix=\eye$, but it should be borne in mind that the solution is valid for any rotation matrix.

The eigenvalue decomposition of the sample covariance matrix has the form
\[
\eigenvectorMatrix_q \eigenvalueMatrix = \sampleCovMatrix \eigenvectorMatrix_q,
\]
which implies that $\singularvalue_{i,i}^2 + \dataStd^2 =
\eigenvalue_{i,i}$, implying that $\singularvalue_{i,i} =
\sqrt{\eigenvalue_{i,i} - \dataStd^2}$ can be derived from the
eigenvalues of the sample covariance and the noise variance,
$\dataStd^2$. Let's now return to the estimation of the noise
variance.

\section{Fixed Point Equation for $\dataStd^2$}

The stationary points of $\mappingMatrix$ are derived through the
eigenvectors and eigenvalues of the sample covariance matrix. Any set
of $\latentDim$ eigenvector/value pairings will be a stationary point
but which $\latentDim$ eigenvectors should we choose to retain? We can order the eigenvector/value pairs so that those that we retain are the first $\latentDim$. Then we can index the retained pairings by $i=1\dots
\latentDim$. To determine which pairings these are we first
need to return to estimation of the noise variance, $\dataStd^2$. 

The gradient with respect to $\dataStd^2$ was expressed in terms of
the sample covariance, $\sampleCovMatrix$, and the mapping matrix,
$\mappingMatrix$. Specifically it was given by the trace of the
gradient with respect to the covariance matrix, as given by
\refeq{eq:gaussianGrad}. First let's derive an alternative
representation of the covariance matrix. Substituting the solution for
$\mappingMatrix$, we can write the covariance as
\[
\covarianceMatrix = \eigenvectorMatrix_q\singularvalueMatrix_q^2\eigenvectorMatrix_q + \dataStd^2\eye.
\]
We now define a new matrix $\singularvalueMatrix \in \Re^{\dataDim
  \times \dataDim}$. We set the first $\latentDim$ diagonal elements
of $\singularvalueMatrix$ to be given by, $\left\{\singularvalue_{i,
    i}\right\}_{i=1}^{\latentDim}$. The remaining diagonal elements
are set to zero. This allows us to introduce the $\dataDim\times
\dataDim$ matrix of eigenvectors of $\sampleCovMatrix$,
$\eigenvectorMatrix$. This allows us to write $\eigenvectorMatrix_q
\singularvalueMatrix_q^2\eigenvectorMatrix_q^\top = \eigenvectorMatrix
\singularvalueMatrix^2 \eigenvectorMatrix^\top$. Now, since
$\eigenvectorMatrix\eigenvectorMatrix^\top = \eye$ then we can write,
\begin{equation}
  \covarianceMatrix = \eigenvectorMatrix\left(\singularvalueMatrix^2 + \dataStd^2 \eye\right) \eigenvectorMatrix^\top, \label{eq:covMatrix}
\end{equation}
and the corresponding inverse is given by
\[
\covarianceMatrix^{-1} = \eigenvectorMatrix\left(\singularvalueMatrix^2 + \dataStd^2\eye\right)^{-1} \eigenvectorMatrix^\top.
\]
This representation allows us to write
\[
\covarianceMatrix^{-1} \cdataMatrix^\top \cdataMatrix
\covarianceMatrix^{-1} = \numData \eigenvectorMatrix
\left(\singularvalueMatrix^2 +
  \dataStd^2\eye\right)^{-2}\eigenvalueMatrix\eigenvectorMatrix^\top
\]
by substituting the sample covariance matrix,
$\numData^{-1}\cdataMatrix^\top\cdataMatrix$ with its eigenvalue
decomposition, $\eigenvectorMatrix \eigenvalueMatrix
\eigenvectorMatrix^\top$ we can write the trace of this matrix as
\[
\tr{\covarianceMatrix^{-1} \cdataMatrix^\top \cdataMatrix
  \covarianceMatrix^{-1}} = \frac{\numData}{2}\sum_{i=1}^\latentDim
\frac{\eigenvalue_{i,i}}{(\singularvalue_{i,i}^2 + \dataStd^2)^2} +
\frac{\numData}{2}\sum_{i=\latentDim+1}^\dataDim \frac{\eigenvalue_{i,
    i}}{\dataStd^4}.
\]
This needs to be combined with the trace of $\covarianceMatrix^{-1}$
to get the gradient with respect to $\dataStd^2$. So we need
\[
\frac{n}{2}\tr{\covarianceMatrix^{-1}} =
\frac{\numData}{2}\sum_{i=1}^\latentDim
\frac{1}{\singularvalue_{i,i}^2 +\dataStd^2} +
\frac{\numData}{2}\frac{\dataDim - \latentDim}{\dataStd^2}.
\]
Within these trace terms we first substitute the solution for
$\singularvalue_{i, i} = \sqrt{\eigenvalue_{i, i} -\dataStd^2}. $ Then
we can write down the resulting gradient with respect to $\dataStd^2$,
\[
\diff{E(\mappingMatrix, \dataStd^2)}{\dataStd^2} = \frac{\numData}{2}\frac{\dataDim - \latentDim}{\dataStd^2}-\frac{\numData}{2}\sum_{i=\latentDim+1}^\dataDim \frac{\eigenvalue_{i, i}}{\dataStd^4}. 
\]
A stationary point is given when 
\[
\dataStd^2 =\frac{1}{\dataDim - \latentDim} \sum_{i=\latentDim+1}^\dataDim \eigenvalue_{i, i}.
\]
In other words the stationary point is when $\dataStd^2$ is the
average of the discarded eigenvectors.

\section{The Global Optimum}

We now have stationary points for all the constituent parts of the
covariance matrix. However, we still haven't determined what type of
stationary points they are. \citealp{Tipping:probpca99} substituted
the stationary points into the log likelihood. Using the same
representation of $\covarianceMatrix$ as we described in \refeq{eq:covMatrix} we
can write the negative log likelihood at these stationary points. First though, we add an additional term: the log determinant of the sample covariance matrix. This has no effect on the optimum with respect to our parameters, but it will lead to a nice interpretation of the objective,
\[
E = -\frac{\numData}{2}\log \det{\covarianceMatrix} +
\frac{\numData}{2}\log \det{\sampleCovMatrix} + \frac{\numData}{2}
\tr{\covarianceMatrix^{-1}\sampleCovMatrix}
\]
This can be rewritten as
\[
E = -\frac{\numData}{2}\log
\det{\covarianceMatrix^{-1}\sampleCovMatrix} + \frac{\numData}{2}
\tr{\covarianceMatrix^{-1}\sampleCovMatrix} .
\]
Using our decomposition of the covariance matrix at the stationary
points we have
\[
\covarianceMatrix^{-1}\sampleCovMatrix = \eigenvectorMatrix
(\singularvalueMatrix^2
+\dataStd^2\eye)^{-1}\eigenvalueMatrix\eigenvectorMatrix^\top.
\]
The first $\latentDim$ eigenvalues of this matrix are therefore given
by $\frac{\eigenvalue_{i,i}}{\singularvalue_{i, i}^2 + \dataStd^2}$
which at the stationary points we have derived is equal to 1. The
remaining eigenvalues are given by
$\frac{\eigenvalue_{i,i}}{\dataStd^2}$ which at the stationary point
we derived for $\dataStd^2$ are equal to
$(\dataDim-\latentDim)\frac{\eigenvalue_{i,
    i}}{\sum_{j=\latentDim+1}^\dataDim \eigenvalue_{i, i}}$. In other
words this matrix has eigenvalues given by 1 for the first
$\latentDim$ dimensions, and by $\frac{(\dataDim -
  \latentDim)\eigenvalue_i}{\sum_{i=\latentDim+1}^{\dataDim}
  \eigenvalue_i}$ for the remaining eigenvalues. The error function
can be written entirely in terms of these eigenvalues because both the
trace and the log determinant can be expressed as a sum of eigenvalues
and log eigenvalues respectively.
\[
E = \frac{\numData(\dataDim -\latentDim)}{2} \log
\left(\prod_{i=\latentDim+1}^\dataDim\frac{\eigenvalue_i}{\sum_{j=\latentDim+1}^\dataDim
    \eigenvalue_j}\right)^\frac{1}{\dataDim - \latentDim} +
\frac{\numData(\dataDim -
  \latentDim)}{2}\sum_{i=\latentDim+1}^\dataDim
\frac{\eigenvalue_i}{\sum_{j=\latentDim+1}^\dataDim \eigenvalue_j}
+\frac{\numData(\dataDim-\latentDim)}{2}\log(\dataDim - \latentDim)
\]

\[
E() = -\half\sum_{i=1}^\latentDim \log \eigenvalue_i -
\frac{\dataDim-\latentDim}{2}\log \frac{\sum_{i=\latentDim+1}^\dataDim
  \eigenvalue_i}{\dataDim-\latentDim} + \frac{\latentDim}{2}
+\frac{(\dataDim-\latentDim)}{2}\sum_{i=\latentDim+1}^\dataDim
\frac{\eigenvalue_i}{\sum_{j=\latentDim+1}^\dataDim \eigenvalue_j}
\]
where we have used the fact that the log determinant of a matrix is
the sum of the log-eigenvalues and the trace of a matrix is the sum of
its eigenvalues.
\[
\]
\fixme{Describe why it is a global maximum.}

\begin{boxfloat}
  \caption{The Singular Value Decomposition} \label{box:svd}

  \boxfontsize The singular value decomposition of a matrix decomposes it in the following form,
  \[
  \mappingMatrix = \eigenvectorMatrix_\latentDim \singularvalueMatrix_\latentDim \rotationMatrix^\top
  \]
  where the matrix we are decomposing is assumed to be
  $\mappingMatrix\in \Re^{\dataDim \times \latentDim}$ with
  $\dataDim\geq \latentDim$. The matrix
  $\eigenvectorMatrix_\latentDim\in \Re^{\dataDim \times \latentDim}$
  is constrained so that $\eigenvectorMatrix^\top
  \eigenvectorMatrix=\eye$ and $\singularvalueMatrix \in
  \Re^{\latentDim\times \latentDim}$ is a diagonal matrix of the
  ``singular values''. Finally $\rotationMatrix \in
  \Re^{\latentDim\times \latentDim}$ is an orthonormal matrix which
  we can think of as a rotation,
  $\rotationMatrix^\top\rotationMatrix = \eye$.
  
  We can think of the singular values, $\singularvalueMatrix$, as an
  axis aligned $\latentDim$-dimensional basis which is rotated into
  higher dimensions, $\dataDim$, by the matrix
  $\eigenvectorMatrix_\latentDim$. Within the $\latentDim$-dimensional
  space, we can also rotate the basis by $\rotationMatrix$.
  
  The singular value decomposition can represent arbitrary matrices,
  but there is an important relationship between it and the
  eigendecomposition of a positive semi-definite matrices in the
  following way. A positive semi-definite matrix may be formed by the
  product of two unconstrained matrices,
  \[
  \covarianceMatrix = \mappingMatrix \mappingMatrix^\top
  \]
  substituting the singular value decomposition of $\mappingMatrix$ we have
  \[
  \covarianceMatrix = \eigenvectorMatrix_\latentDim \singularvalueMatrix^2 \eigenvectorMatrix_\latentDim^\top.
  \]
  The rotation matrix, $\rotationMatrix$, disappears from this
  operation. This can be seen as an eigenvalue decomposition of the
  positive definite matrix (see \refbox{box:evd}). We could also
  construct a positive definite matrix the other way around,
  \[
  \boldsymbol{\Sigma} = \mappingMatrix^\top\mappingMatrix = \rotationMatrix^\top \singularvalueMatrix^2\rotationMatrix
  \]
  which is full rank and has eliminated $\eigenvectorMatrix_\latentDim$ instead of $\rotationMatrix$.
\end{boxfloat}


\begin{boxfloat}
  \caption{The Eigenvalue Decomposition of a Positive Definite Matrix}\label{box:evd}
  
  \boxfontsize
  
  
\end{boxfloat}

\section{Posterior Density for the Latent Positions}\label{sec:ppcaPosterior}


% \[
% \log p\left(\cdataMatrix|\mappingMatrix\right) =
% -\frac{\numData}{2}\log\left|\covarianceMatrix\right| -
% \half\tr{\covarianceMatrix^{-1}\cdataMatrix^{\top}\cdataMatrix}
% +\mbox{const.}
% \]
% If $\eigenvectorMatrix_{\latentDim}$ are first $\latentDim$ principal
% eigenvectors of $\numData^{-1}\cdataMatrix^{\top}\cdataMatrix$ and the
% corresponding eigenvalues are $\Lambda_{\latentDim}$,
% \[
% \mappingMatrix=\mathbf{U}_{\latentDim}\mathbf{L}\rotationMatrix^{\top},
% \,\,\,\,\,\,\,\mathbf{L}=\left(\Lambda_{\latentDim}-\dataStd^{2}\eye\right)^{\half}
% \]
% where $\rotationMatrix$ is an arbitrary rotation matrix.

\begin{figure}
  \begin{center}
    \includegraphics[width=0.5\textwidth]{../../../gplvm/tex/diagrams/ppcaGraph}
  \end{center}
  \caption{Simple graphical model showing the relationship between the
    latent variables, $\latentMatrix$, the mapping matrix,
    $\mappingMatrix$, and the data, $\dataMatrix$. The arrows
    (directional edges) represent the fact that we are modeling
    $\dataMatrix$ conditional on both the latent matrix,
    $\latentMatrix$, and the mapping matrix, $\mappingMatrix$. The
    shading of the nodes (vertices) represent the fact that the matrix
    $\dataMatrix$ is observed (gray shading), the latent variables are
    marginalized through a prior distribution (white shading), and the
    mapping matrix is optimized by maximum likelihood (black shading).}\label{fig:ppcaGraph}
\end{figure}

\section{Why is a Probabilistic Interpretation Important?}

We have presented a probabilistic interpretation of principal
component analysis. The motivation for the model is very close to
Hotelling's own description of principal component analysis, but why
should we place such stock on the probabilistic interpretation of the
model? Probabilistic models clarify the assumptions we are making for
the generating process for the data. For probabilistic PCA we are
assuming that low dimensional latent variables, $\latentMatrix$, are
sampled from a Gaussian density and linearly mapped into a higher
dimensional space through a matrix, $\mappingMatrix$, before being
corrupted by isotropic Gaussian noise. Any of these assumptions can be
changed. For example, suggesting that non-Gaussian densities are used
for the latent variables, but maintaining independence across the
latent dimensions, leads to independent component
analysis\index{independent component analysis (ICA)} (ICA)
\citep{MacKay:ica96,Hyvarinen:icabook01}. If the Gaussian noise has a
different variance for each output dimension then factor
analysis\index{factor analysis (FA)} is recovered
\citep{Roweis:unifying}. In later chapters we will consider nonlinear
mappings between the latent variables and the data (see
\refchaprange{chap:nonlinear}{chap:gp}. Probabilistic models provide a
principled approach to dealing with missing data
\citep{Tipping:probpca99}. They can also be easily be expanded in a
number of formulaic ways: for example Bayesian treatments of
parameters \citep{Bishop:bayesPCA98,Bishop:icann99,Minka:automatic01}
and mixture models
\citep{Tipping:pca97,Ghahramani:emmixtures97,Ghahramani:bfa00}. With
the exception of ICA we will exploit all these characteristics of the
model. First though we will apply standard probabilistic
PCA\index{probabilistic PCA (PPCA)} to some of the data sets we
introduced in the last chapter.

\section{Example Applications of Probabilistic PCA}

\subsection{Robot Wireless Data}

\subsection{Stick Man Data}

\subsection{Spellman Data}

\fixme{Use to describe the dual version of the eigenvalue problem}.

\subsection{Oil Data}

\subsubsection{Missing Values}

% 
\begin{figure}
  \subfigure[Full data
  set.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilFullProject}}\hfill{}
  \subfigure[10\% missing
  values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing90Project}}

  \subfigure[20\% missing
  values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing80Project}}\hfill{}
  \subfigure[30\% missing
  values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing70Project}}
  \subfigure[50\% missing
  values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing50Project}}

  \caption{Projection of the oil data set on to $\latentDim=2$ latent
    dimensions using the probabilistic PCA model. Different plots show
    various proportions of missing values. All values are missing at
    random from the design matrix $\dataMatrix$.}

\end{figure}


\section{Factor Analysis}\index{factor analysis (FA)}
\fixme{Mention that factor Analysis leads to $\mathbf{C}=\mappingMatrix\mappingMatrix^{\top}+\mathbf{D}$,
  $\mathbf{D}=\mathrm{diag}\left(\mathbf{d}\right)$ --- not discussed
  further.}

\section{Mixtures of Linear Models}

Local minima issues

introduce through prototypes with linear pertubations.

Derive EM algorithm.

Mention global coordination issues.

\section{Bayesian Principal Components}


\subsection{Probabilistic Matrix Factorization}\index{probabilistic matrix factorization}

\section{Conclusions}

So far we have shown that data can behave very non-intuitively in high
dimensions. Fortunately, most data is not intrinsically high
dimensional. We showed that for particular low rank structures of
covariance matrix, data sampled from a Gaussian is not inherently high
dimensional. The probabilistic PCA model underlies this low rank
structure, when fitted to data it can exploit the linear low
dimensional structure in the data. However, the linear constraint is a
strong one. In the next section we will consider an alternative
approach to dimensionality reduction. It involves distance matching
between inter-point distances in the latent space and those in the data
space. In statistics this approach is known as multidimensional
scaling\index{multidimensional scaling}. As a first step we will show
how the model can be related to principal component analysis. Then, in
the next chapter, we shall use the resulting framework: known as
principal coordinate analysis, to motivate non-linear extensions to
linear dimensionality reduction models.



% \chapter{Linear Models and Classical Scaling}

% In the last chapter we discussed how for independently sampled
% features, data has the characteristic that all points end up at a
% fixed point from the center of the distribution. For Gaussian
% densities we saw that points become uniformly distributed across a
% sphere with radius equal to the standard deviation. For non-Gaussian
% densities data becomes clustered at points which are either axis
% aligned (for super Gaussian sources) or rotated 45 degrees from the
% axes.

% However, when we measured squared distances for a group of real world
% data sets we saw that there was a mismatch between the theory and the
% reality. Whilst we had shown that the theory did match for a spherical
% covariance Gaussian in high dimensions, we finished the last chapter
% by showing that for covariance matrices of a particular form, namely
% \[
% \mathbf{C}=\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye
% \]
% there was also a mismatch between the theory and the practice. We can
% think of this covariance matrix as a reduced rank matrix. If we have
% $\mappingMatrix \in \Re^{\dataDim \times \latentDim}$ then
% $\mappingMatrix\mappingMatrix^{\top}\in \Re^{\dataDim \times
%   \dataDim}$ is a matrix of rank $\latentDim$. Adding the scaled
% identity, $\dataStd^2 \eye$, ensures that final covariance matrix is
% full rank, but if $\dataStd$ is small relative to the length of the
% columns of $\mappingMatrix$, $\mappingVector_{:, i}$, then we can
% think of the structure of the covariance as being inherently low
% dimensional. In fact, we can construct this covariance matrix through
% a probabilistic model known as probabilistic principal component
% analysis\index{PCA}\index{probabilistic PCA}.

% \section{Probabilistic Linear Dimensionality Reduction}


% Probabilistic PCA \cite{Tipping:probpca99,Roweis:SPCA97} is a
% probabilistic latent variable\index{latent variable models}
% representation of data. The basic idea is to construct a probabilistic
% generative model, where data is mapped from a low dimensional latent
% space to a high dimensional data space. If we denote each data point's
% position in the latent space by the vector $\latentVector_{i, :}$, we
% can think of the relationship between the latent and data spaces being
% in the form of a mapping,
% \[
% \cdataVector_{i, :} = \mappingMatrix \latentVector_{i, :} + \meanVector + \noiseVector_{i, :}
% \]
% where $\mappingMatrix \in \Re^{\dataDim,\latentDim}$ is a mapping
% matrix which encodes the linear relationship between the latent space
% and the data space. The vector $\noiseVector$ represents a corrupting
% noise term which we will take to be independently sampled from a
% Gaussian density,
% \[
% \noiseVector_{i,:} \sim \gaussianSamp{0}{\dataStd^2\eye},
% \]
% where $\dataStd$ is the standard deviation of the noise. We represent
% the entire data set in the form of a design matrix, $\dataMatrix \in
% \Re^{\numData\times\dataDim}$. For convenience we define the centered
% data as, $\cdataMatrix = \dataMatrix - \onesVector
% \meanVector^\top$. If $\meanVector$ is the sample mean of the data,
% this operation can be carried out using a \emph{centering
%   matrix}\index{centering matrix} defined as,
% \[
% \centeringMatrix=\eye-\numData^{-1}\onesVector\onesVector^{\top}\in\Re^{\numData\times\numData},
% \]
% so we have $\cdataMatrix = \centeringMatrix \dataMatrix$. 

% The linear relationship given above may be encoded in a Gaussian
% density. Since the noise is independent we can think of the $j$th
% feature from the $i$th data point as being sampled from a Gaussian
% density with mean given by $\mappingVector_{j, :}^\top
% \latentVector_{i, :}$ and a variance given by $\dataStd^2$,
% \[
% \cdataScalar_{i,j} \sim \gaussianSamp{\mappingVector_{j, :}^\top\latentVector_{i,:}}{\dataStd^2}.
% \]
% If the noise is independent across both features and data then we can write the likelihood as a function of all data and parameters through products over the rows and columns of $\cdataMatrix$,
% \[
% \cdataMatrix \sim \prod_{i=1}^\numData\prod_{j=1}^\dataDim \gaussianSamp{\mappingVector_{j, :}^\top \latentMatrix_{i, :}}{\dataStd^2}.
% \]


% this likelihood  each data
% point, $\dataScalar_{i, j}$, as being sampled from a Gaussian density.
% \[
% p\left(\dataMatrix|\latentMatrix,\mappingMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\cdataVector_{i,:}}{\mappingMatrix\latentVector_{i,:}}{\dataStd^{2}\eye}\]

% \begin{figure}
%   \begin{center}
%     \includegraphics[width=0.5\textwidth]{../../../gplvm/tex/diagrams/ppcaGraph}
%   \end{center}
%   \caption{Simple graphical model showing the relationship between the
%     latent variables, $\latentMatrix$, the mapping matrix,
%     $\mappingMatrix$, and the data, $\dataMatrix$. The arrows
%     (directional edges) represent the fact that we are modeling
%     $\dataMatrix$ conditional on both the latent matrix,
%     $\latentMatrix$, and the mapping matrix, $\mappingMatrix$. The
%     shading of the nodes (vertices) represent the fact that the matrix
%     $\dataMatrix$ is observed (gray shading), the latent variables are
%     marginalized through a prior distribution (white shading), and the
%     mapping matrix is optimized by maximum likelihood (black shading).}
% \end{figure}

% Linear dimensionality reduction can be thought of as finding a lower
% dimensional plane embedded in a higher dimensional space. The plane is
% described by the matrix $\mappingMatrix$. The direction of the vectors
% in this matrix define the orientation of the
% plane. Figure~\ref{fig:mapping2to3linear} shows how this works when
% the latent space is two dimensional and the data space is three
% dimensional.
% \begin{figure}
%   \begin{centering}
%     \includegraphics[width=0.8\textwidth]{../diagrams/mapping2to3linear}
%   \end{centering}

%   \caption{Mapping a two dimensional plane to a higher dimensional space in a
%     linear way.}\label{fig:mapping2to3linear}

% \end{figure}

% For probabilistic PCA we now look for the values of $\mappingMatrix$
% that maximize the likelihood of the model.

% The latent variables, $\latentMatrix$, are sometimes known as
% ``nuisance parameters'' in statistics. If we are interested in the
% values of the mapping matrix (which defines the embedded plane) we may
% not be interested in the positions of the latent variables. The latent
% variable model approach is to define a prior distribution over the
% latent variables and integrate them out. A convenient choice of prior,
% due to its analytic properties\footnote{We might also motivate the
%   Gaussian choice of prior through maximum entropy arguments or
%   appeals to the central limit theorem. However, pragmatism may be the
%   dominant motivation for its widespread use as both a prior and a
%   likelihood. Models derived from it are typically more tractable.},
% is Gaussian. Analysis is further simplified if we choose the Gaussian
% to be a product of unit variance Gaussians across the latent
% dimensions.
% \begin{figure}
%   \begin{center}
%     \includegraphics[width=0.5\textwidth]{../../../gplvm/tex/diagrams/ppcaGraph}
%   \end{center}
%   \caption{What goes here.}
% \end{figure}
% \[
% p\left(\latentMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\latentVector_{i,:}}{\zerosVector}{\eye}
% \]
% \[
% p\left(\dataMatrix|\mappingMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\dataVector_{i,:}}{\zerosVector}{\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye}\]



% \subsection{Linear Model Optimization}
% \citet{Tipping:probpca99} showed that the likelihood of the model we defined above can be analytically found through an eigenvalue problem. To derive the likelihood we must first marginalize the latent variables. Doing so gives
% \[
% p\left(\dataMatrix|\mappingMatrix\right)=\prod_{i=1}^{\numData}\gaussianDist{\dataVector_{i,:}}{\zerosVector}{\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye}\]
% which can be rewritten
% \[
% p\left(\dataMatrix|\mappingMatrix\right)=\prod_{j=1}^{\dataDim}\gaussianDist{\dataVector_{i,:}}{\zerosVector}{\covarianceMatrix},
% \]
% where
% \[
% \covarianceMatrix=\mappingMatrix\mappingMatrix^{\top}+\dataStd^{2}\eye\]
% \[
% \log p\left(\dataMatrix|\mappingMatrix\right)=-\frac{\numData}{2}\log\left|\covarianceMatrix\right|-\half\tr{\covarianceMatrix^{-1}\dataMatrix^{\top}\dataMatrix}+\mbox{const.}\]
% If $\eigenvectorMatrix_{\latentDim}$ are first $\latentDim$ principal
% eigenvectors of $\numData^{-1}\dataMatrix^{\top}\dataMatrix$
% and the corresponding eigenvalues are $\Lambda_{\latentDim}$,\[
% \mappingMatrix=\mathbf{U}_{\latentDim}\mathbf{L}\rotationMatrix^{\top},\,\,\,\,\,\,\,\mathbf{L}=\left(\Lambda_{\latentDim}-\dataStd^{2}\eye\right)^{\half}\]
% where $\rotationMatrix$ is an arbitrary rotation matrix.


% Why Probabilistic PCA?
% \begin{itemize}
% \item What is the point in probabilistic methods?
% \item Could we not just project with regular PCA?

%   \begin{itemize}
%   \item Integration within other models (\emph{e.g.}\ mixtures of PCA \cite{Tipping:pca97},
%     temporal models).
%   \item Model selection through Bayesian treatment of parameters \cite{Bishop:bayesPCA98}.
%   \item Marginalisation of missing data \cite{Tipping:probpca99}.
%   \end{itemize}
% \end{itemize}
% \begin{center}
%   \textbf{Note: These same advantages hold for Factor Analysis}
%   \par\end{center}

% \fixme{Mention that factor Analysis leads to $\mathbf{C}=\mappingMatrix\mappingMatrix^{\top}+\mathbf{D}$,
%   $\mathbf{D}=\mathrm{diag}\left(\mathbf{d}\right)$ --- not discussed
%   further.}


% \subsection{Oil Data with Missing Values}

% % 
% \begin{figure}
%   \subfigure[Full data
%   set.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilFullProject}}\hfill{}
%   \subfigure[10\% missing
%   values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing90Project}}

%   \subfigure[20\% missing
%   values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing80Project}}\hfill{}
%   \subfigure[30\% missing
%   values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing70Project}}
%   \subfigure[50\% missing
%   values.]{\includegraphics[width=0.4\textwidth]{../diagrams/oilMissing50Project}}

%   \caption{Projection of the oil data set on to $\latentDim=2$ latent
%     dimensions using the probabilistic PCA model. Different plots show
%     various proportions of missing values. All values are missing at
%     random from the design matrix $\dataMatrix$.}

% \end{figure}

% So far we have shown that data can behave very non-intuitively in high
% dimensions. Fortunately, most data is not intrinsically high
% dimensional. We showed that for particular low rank structures of
% covariance matrix, data sampled from a Gaussian is not inherently high
% dimensional. The probabilistic PCA model underlies this low rank
% structure, when fitted to data it can exploit the linear low
% dimensional structure in the data. However, the linear constraint is a
% strong one. In the next section we will consider an alternative
% approach to dimensionality reduction. It involves distance matching
% between inter-point distances in the latent space and those in the data
% space. In statistics this approach is known as multidimensional
% scaling\index{multidimensional scaling}. As a first step we will show
% how the model can be related to principal component analysis. Then, in
% the next chapter, we shall use the resulting framework: known as
% principal coordinate analysis, to motivate non-linear extensions to
% linear dimensionality reduction models.

% \fixme{factor analysis}
% \fixme{independent component analysis}

% \section{Inter-point Distance Matching}

% The probabilistic interpretation associated with probabilistic
% PCA\index{probabilistic PCA} brings many associated advantages. It
% allows the model to be extended within the probabilistic framework, by
% for example mixture
% models\cite{Tipping:iee_mixpca97,Ghahramani:emmixtures97} and Bayesian
% approaches\cite{Bishop:bayesPCA98,Bishop:icann99,Minka:automatic01}. We
% also saw above how a probabilistic interpretation facilitates the
% problem of missing data. However, the probabilistic model described
% above is limited by the use of a linear mapping. We now motivate the
% need for more general \emph{non linear} approaches to dimensionality
% reduction.

% \subsubsection{Feature Extraction}

% % 
% \begin{figure}
%   \subfigure[Two dimensional data shown as a scatter plot.]{
%     \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist1}}\hfill
%   \subfigure[Selecting the feature with the largest variance is equivalent to projecting onto the $x$-axis.]{
%     \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist2}}\\
%   \centerline{\subfigure[The new representation of the data with only one feature.]{
%       \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist3}}}

%   \caption{Feature selection via distance preservation. Data is having its dimensionality reduced through selecting the feature with the largest variance. Here data containing two features is projected down to data containing one feature by selecting the feature with the largest variance to represent the data. }

% \end{figure}


% Feature Extraction

% % 
% \begin{figure}
%   \subfigure[Unrotated data in two dimensions.]{

%     \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist4_1}}\hfill
%   \subfigure[Data rotated so that direction of maximum variance is axis aligned.]{

%     \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist4_5}}\\
%   \subfigure[Red lines show projections of data onto the principal axis.]{

%     \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist5}}\hfill
%   \subfigure[Data is projected down to a single dimension.]{

%     \includegraphics[width=0.45\textwidth]{../diagrams/demRotationDist6}}

%   \caption{Rotation of the data preserves the interpoint distances. Here data is rotated onto its direction of maximum variations and then the data dimension is reduced to one.}\label{fig:demRotationDistFeatureSelection}

% \end{figure}



% \subsubsection{Which Rotation?}
% \begin{itemize}
% \item We need the rotation that will minimise residual error.
% \item We already an algorithm for discarding directions.
% \item Discard direction with \emph{maximum variance}. 
% \item Error is then given by the sum of residual variances.\[
%   E\left(\latentMatrix\right)=2\numData^{2}\sum_{k=\latentDim+1}^{\dataDim}\sigma_{k}^{2}.\]

% \item Rotations of data matrix \emph{do not }effect this analysis.
% \end{itemize}

% \subsubsection{Rotation Reconstruction from Latent Space}

% % 
% \begin{figure}
%   %   
%   \begin{centering}
%     \subfigure[Distances reconstructed with two dimensions.]{\includegraphics[width=0.45\textwidth]{../diagrams/demSixDistancesRotate2}}\hfill{}\subfigure[Distances reconstructed with 10 dimensions.]{\includegraphics[width=0.45\textwidth]{../diagrams/demSixDistancesRotate10}
%     }
%     \subfigure[Distances reconstructed with 100 dimensions.]{\includegraphics[width=0.45\textwidth]{../diagrams/demSixDistancesRotate100}}\hfill{}\subfigure[Distances reconstructed with 360 dimensions.]{\includegraphics[width=0.45\textwidth]{../diagrams/demSixDistancesRotate360}}
%   \end{centering}

%   \caption{Reconstructed distance matrix for the artificial data set generated by roating the handwritten digit 6.}\label{fig:demRotationDistRotate}
% \end{figure}



% \section{PCA and MDS}

% Reminder: Principal Component Analysis
% \begin{itemize}
% \item How do we find these directions?
% \item Find directions in data with maximal variance.

%   \begin{itemize}
%   \item That's what PCA does!
%   \end{itemize}
% \item \textbf{PCA}: rotate data to extract these directions.
% \item \textbf{PCA}: work on the sample covariance matrix $\sampleCovMatrix=\numData^{-1}\cdataMatrix^{\top}\cdataMatrix$.
% \end{itemize}
% Principal Component Analysis
% \begin{itemize}
% \item Find a direction in the data, $\latentVector_{:,1}=\cdataMatrix\rotationVector_{1}$,
%   for which variance is maximised. \begin{eqnarray*}
%     \rotationVector_{1} & = & \mathrm{argmax}_{\rotationVector_{1}}\variance{\cdataMatrix\mathbf{\rotationVector_{1}}}\\
%     \mathrm{subject\, to:} &  & \rotationVector_{1}^{\top}\rotationVector_{1}=1\end{eqnarray*}

% \item Can rewrite in terms of sample covariance
% \item \[
%   \variance{\latentVector_{:,1}}=\numData^{-1}\left(\cdataMatrix\rotationVector_{1}\right)^{\top}\cdataMatrix\rotationVector_{1}=\rotationVector_{1}^{\top}\underbrace{\left(\numData^{-1}\cdataMatrix^{\top}\cdataMatrix\right)}_{\mathrm{sample}\,\mathrm{covariance}}\rotationVector_{1}=\rotationVector_{1}^{\top}\sampleCovMatrix\rotationVector_{1}\]

% \end{itemize}
% Lagrangian
% \begin{itemize}
% \item Solution via constrained optimisation:\[
%   L\left(\rotationVector_{1},\eigenvalue_{1}\right)=\rotationVector_{1}^{\top}\sampleCovMatrix\rotationVector_{1}+\eigenvalue_{1}\left(1-\rotationVector_{1}^{\top}\rotationVector_{1}\right)\]

% \item Gradient with respect to $\rotationVector_{1}$\[
%   \frac{\mathrm{d}L\left(\rotationVector_{1},\eigenvalue_{1}\right)}{\mathrm{d}\rotationVector_{1}}=2\sampleCovMatrix\rotationVector_{1}-2\eigenvalue_{1}\rotationVector_{1}\]
%   rearrange to form\[
%   \sampleCovMatrix\rotationVector_{1}=\eigenvalue_{1}\rotationVector_{1}.\]
%   Which is recognised as an eigenvalue problem.
% \end{itemize}
% Lagrange Multiplier
% \begin{itemize}
% \item Recall the gradient,\begin{equation}
%     \frac{\mathrm{d}L\left(\rotationVector_{1},\eigenvalue_{1}\right)}{\mathrm{d}\rotationVector_{1}}=2\sampleCovMatrix\rotationVector_{1}-2\eigenvalue_{1}\rotationVector_{1}\label{eq:gradObjective}\end{equation}
%   to find $\eigenvalue_{1}$ premultiply (\ref{eq:gradObjective}) by
%   $\rotationVector_{1}^{\top}$ and rearrange giving \[
%   \eigenvalue_{1}=\rotationVector_{1}^{\top}\sampleCovMatrix\rotationVector_{1}.\]

% \item Maximum variance is therefore \emph{necessarily }the maximum eigenvalue
%   of $\sampleCovMatrix$. 
% \item This is the \emph{first principal component.}
% \end{itemize}
% Further Directions
% \begin{itemize}
% \item Find orthogonal directions to earlier extracted directions with maximal
%   variance. 
% \item Orthogonality constraints, for $j<k$ we have \[
%   \rotationVector_{j}^{\top}\rotationVector_{k}=\zerosVector\,\,\,\,\rotationVector_{k}^{\top}\rotationVector_{k}=1\]

% \item Lagrangian\[
%   L\left(\rotationVector_{k},\eigenvalue_{k},\boldsymbol{\gamma}\right)=\rotationVector_{k}^{\top}\sampleCovMatrix\rotationVector_{k}+\eigenvalue_{k}\left(1-\rotationVector_{k}^{\top}\rotationVector_{k}\right)+\sum_{j=1}^{k-1}\gamma_{j}\rotationVector_{j}^{\top}\rotationVector_{k}\]
%   \[
%   \frac{\mathrm{d}L\left(\rotationVector_{k},\eigenvalue_{k}\right)}{\mathrm{d}\rotationVector_{k}}=2\sampleCovMatrix\rotationVector_{k}-2\eigenvalue_{k}\rotationVector_{k}+\sum_{j=1}^{k-1}\gamma_{j}\rotationVector_{j}\]

% \end{itemize}
% Further Eigenvectors
% \begin{itemize}
% \item Gradient of Lagrangian:\begin{equation}
%     \frac{\mathrm{d}L\left(\rotationVector_{k},\eigenvalue_{k}\right)}{\mathrm{d}\rotationVector_{k}}=2\sampleCovMatrix\rotationVector_{k}-2\eigenvalue_{k}\rotationVector_{k}+\sum_{j=1}^{k-1}\gamma_{j}\rotationVector_{j}\label{eq:gradObjectiveLaterPcs}\end{equation}

% \item Premultipling (\ref{eq:gradObjectiveLaterPcs}) by $\rotationVector_{i}$
%   with $i<k$ implies\[
%   \gamma_{i}=0\]
%   which allows us to write \[
%   \sampleCovMatrix\rotationVector_{k}=\eigenvalue_{k}\rotationVector_{k}.\]

% \item Premultiplying (\ref{eq:gradObjectiveLaterPcs}) by $\rotationVector_{k}$
%   implies\[
%   \eigenvalue_{k}=\rotationVector_{k}^{\top}\sampleCovMatrix\rotationVector_{k}.\]

% \item This is the \emph{$k$th principal component}.
% \end{itemize}

% \subsection{Principal Coordinates Analysis}
% \begin{itemize}
% \item The rotation which finds directions of maximum variance is the eigenvectors
%   of the covariance matrix. 
% \item The variance in each direction is given by the eigenvalues. 
% \item \textbf{Problem:} working directly with the sample covariance, $\sampleCovMatrix$,
%   may be impossible. 
% \item For example: perhaps we are given distances between data points, but
%   not absolute locations.

%   \begin{itemize}
%   \item No access to absolute positions: cannot compute original sample covariance.
%   \end{itemize}
% \end{itemize}
% An Alternative Formalism
% \begin{itemize}
% \item Matrix representation of eigenvalue problem for first $\latentDim$
%   eigenvectors.\begin{equation}
%     \cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}=\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}\,\,\,\,\,\rotationMatrix_{q}\in\Re^{\dataDim\times\latentDim}\label{eq:standardEigenvalue}\end{equation}

% \item Premultiply by $\cdataMatrix$:\[
%   \cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}\]

% \item Postmultiply by $\eigenvalueMatrix_{\latentDim}^{-\half}$


%   \[
%   \cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]
%   \[
%   \cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\eigenvalueMatrix_{\latentDim}\]
%   \[
%   \cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvectorMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}\,\,\,\,\,\eigenvectorMatrix_{\latentDim}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]


% \end{itemize}
% $\eigenvectorMatrix_{\latentDim}$ Diagonalizes the Inner Product
% Matrix
% \begin{itemize}
% \item Need to prove that $\eigenvectorMatrix_{q}$ are eigenvectors of inner
%   product matrix.


%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\cdataMatrix^{\top}\cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]
%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\left(\cdataMatrix^{\top}\cdataMatrix\right)^{2}\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]
%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]


% \item Full eigendecomposition of sample covariance \[
%   \mathbf{\cdataMatrix^{\top}\cdataMatrix}=\rotationMatrix\eigenvalueMatrix\rotationMatrix^{\top}\]

% \item Implies that \[
%   \left(\cdataMatrix^{\top}\cdataMatrix\right)^{2}=\rotationMatrix\eigenvalueMatrix\rotationMatrix^{\top}\rotationMatrix\eigenvalueMatrix\rotationMatrix^{\top}=\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}.\]

% \end{itemize}
% $\eigenvectorMatrix_{\latentDim}$ Diagonalizes the Inner Product
% Matrix
% \begin{itemize}
% \item Need to prove that $\eigenvectorMatrix_{q}$ are eigenvectors of inner
%   product matrix.


%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]
%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\left[\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\right]\eigenvalueMatrix_{\latentDim}^{-\half}\]
%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}{\color{red}\left[\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\right]}\eigenvalueMatrix_{\latentDim}^{-\half}\]
%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\eigenvalueMatrix_{q}^{2}\eigenvalueMatrix_{\latentDim}^{-\half}\]


%   \[
%   \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{q}\]
%   \[
%   \cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvectorMatrix_{\latentDim}\eigenvalueMatrix_{q}\]


% \item Product of the first $\latentDim$ eigenvectors with the rest, 
%   \[
%   \rotationMatrix^{\top}\rotationMatrix_{q}=
%   \left[\begin{array}{c}
%       \eye_{\latentDim}\\
%       \zerosVector
%     \end{array}\right]\in\Re^{\dataDim\times\latentDim}
%   \]
%   where we have used $\eye_{\latentDim}$ to denote a
%   $\latentDim\times\latentDim$ identity matrix.

% \item Premultiplying by eigenvalues gives,\[
%   \eigenvalueMatrix\rotationMatrix^{\top}\rotationMatrix_{\latentDim}=\left[\begin{array}{c}
%       \eigenvalueMatrix_{\latentDim}\\
%       \zerosVector\end{array}\right]\]

% \item Multiplying by self transpose gives
%   \[
%   \rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}=\eigenvalueMatrix_{q}^{2}\]
%   \[
%   {\color{red}\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}}=\eigenvalueMatrix_{q}^{2}\]
%   \[
%   \rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}=\eigenvalueMatrix_{q}^{2}\]


% \end{itemize}
% Equivalent Eigenvalue Problems
% \begin{itemize}
% \item Two eigenvalue problems are equivalent. One solves for the rotation,
%   the other solves for the location of the rotated points. 
% \item When $\dataDim<\numData$ it is easier to solve for the rotation,
%   $\rotationMatrix_{q}$. But when $\dataDim>\numData$ we solve for the embedding
%   (principal coordinate analysis).
% \item In MDS we may not know $\dataMatrix$, cannot compute $\cdataMatrix^{\top}\cdataMatrix$
%   from distance matrix. 
% \item Can we compute $\cdataMatrix\cdataMatrix^{\top}$
%   instead?
% \item THe standard transformation
% \end{itemize}
% The Covariance Interpretation
% \begin{itemize}
% \item $\numData^{-1}\cdataMatrix^{\top}\cdataMatrix$ is
%   the data covariance.
% \item $\cdataMatrix\cdataMatrix^{\top}$ is a centered inner
%   product matrix.

%   \begin{itemize}
%   \item Also has an interpretation as a covariance matrix (Gaussian processes).
%   \item It expresses correlation and anti correlation between \emph{data points}.
%   \item Standard covariance expresses correlation and anti correlation between
%     \emph{data dimensions}.
%   \end{itemize}
% \end{itemize}
% Distance to Similarity: A Gaussian Covariance Interpretation
% \begin{itemize}
% \item Translate between covariance and distance.

%   \begin{itemize}
%   \item Consider a vector sampled from a zero mean Gaussian distribution,\[
%     \fantasyVector\sim\gaussianSamp{\zerosVector}{\kernelMatrix}.\]

%   \item Expected square distance between two elements of this vector is\[
%     \distanceScalar_{i,j}^{2}=\left\langle \left(\fantasyScalar_{i}-\fantasyScalar_{j}\right)^{2}\right\rangle \]
%     \[
%     \distanceScalar_{i,j}^{2}=\left\langle z_{i}^{2}\right\rangle +\left\langle z_{j}^{2}\right\rangle -2\left\langle z_{i}z_{j}\right\rangle \]
%     under a zero mean Gaussian with covariance given by $\mathbf{K}$
%     this is\[
%     \distanceScalar_{i,j}^{2}=\kernelScalar_{i,i}+\kernelScalar_{j,j}-2\kernelScalar_{i,j}.\]
%     Take the distance to be square root of this,\[
%     d_{i,j}=\left(\kernelScalar_{i,i}+\kernelScalar_{j,j}-2\kernelScalar_{i,j}\right)^{\half}.\]

%   \end{itemize}
% \end{itemize}

% \section{Standard Transformation}
% \begin{itemize}
% \item This transformation is known as the \emph{standard transformation}
%   between a similarity and a distance \cite[pg 402]{Mardia:multivariate79}. 
% \item If the covariance is of the form $\kernelMatrix=\cdataMatrix\cdataMatrix^{\top}$
%   then $\kernelScalar_{i,j}=\dataVector_{i,:}^{\top}\dataVector_{j,:}$
%   and \[
%   d_{i,j}=\left(\dataVector_{i,:}^{\top}\dataVector_{i,:}+\dataVector_{j,:}^{\top}\dataVector_{j,:}-2\dataVector_{i,:}^{\top}\dataVector_{j,:}\right)^{\half}=\left\Vert \dataVector_{i,:}-\dataVector_{j,:}\right\Vert _{2}.\]

% \item For other distance matrices this gives us an approach to covert to
%   a similarity matrix or kernel matrix so we can perform classical MDS.
% \end{itemize}

% \subsection{Example: Road Distances with Classical MDS}

% % To illustrate the operation of classical multidimensional scaling we
% % turn to a classic example given in many statistical texts \citet[see
% % \emph{e.g}][]{Mardia:multivariate79}. We recreate this example by
% % considering road distances between $mising cities$ cities in Europe. The data
% % consists of the a distance matrix containing the distances between
% % each of the cities. Our approach to the data is to first convert it to
% % a similarity matrix using the ``covariance interpretation'' and
% % perform an eigendecomposition on the resulting similarity matrix.  See
% % \fixme{url}{http://www.cs.man.ac.uk/~neill/dimred} for the data we used.

% \fixme{Covariance interpretation and conditionally positive definite
%   kernels ... see Schoelkopf and Smola.}

% \begin{figure}
%   \subfigure[Road distances between European
%   cities.]{\includegraphics[width=0.45\textwidth,height=5cm]{../diagrams/demCmdsRoadData3}}\hfill{}
%   \subfigure[Similarity matrix derived from the distance matrix.]{\includegraphics[width=0.45\textwidth]{../diagrams/demCmdsRoadData5}}

%   \caption{Road distances can be converted to a similarity matrix using
%     the ``standard transformation''. Our interpretation is that the
%     similarity matrix is a covariance matrix from which the locations of
%     the cities were sampled.}

% \end{figure}



% % 
% \begin{figure}
%   \begin{centering}
%     \includegraphics[width=0.8\textwidth]{../diagrams/demCmdsRoadData1}
%     \par\end{centering}

%   \caption{\texttt{demCmdsRoadData}. Reconstructed locations projected
%     onto true map using Procrustes rotations.}

% \end{figure}
% \fixme{Need to describe procrustes rotations}

% In \reffig{fig:roadEigenvalues} we plot the eigenvalues of the
% similarity matrix. We note that in this case some of the eigenvalues
% are negative. This indicates that the distances in Figure \ref{fig:}
% cannot be embedded in an Euclidean space. There are two effects at
% play here. If we were to use shortest distances between the cities the
% curvature of the earth dictates that we wouldn't be able to flatten
% all distances onto a two dimensional plane. Secondly, the use of road
% distances prevents ...
% % 
% \begin{figure}
%   \begin{centering}
%     \includegraphics[width=0.45\textwidth]{../diagrams/demCmdsRoadData2}
%   \end{centering}

%   \caption{Eigenvalues of the similarity matrix are negative in this
%     case.\label{fig:roadEigenvalues}}

% \end{figure}


% % 
% \begin{figure}
%   \subfigure[Original distance
%   matrix.]{\includegraphics[width=0.45\textwidth]{../diagrams/demCmdsRoadData}}\hfill
%   \subfigure[Reconstructed distance
%   matrix.]{\includegraphics[width=0.45\textwidth]{../diagrams/demCmdsRoadData3}}

%   \caption{Comparison between the two distance matrices, the original
%     inter city distance matrix and the reconstructed distance matrix
%     provided by the latent configuration of the data.}

% \end{figure}

% In summary multidimensional scaling\index{multidimensional scaling
%   (MDS)} is a statistical approach to creating a low dimensional
% representation of a data set through matching distances in the low
% dimensional space to distances in a high dimensional space. If our
% objective function is to minimize the absolute error between the
% squared distances in the two spaces, we can produce a low dimensional
% representation through an eigenvalue problem. This is known as
% classical multidimensional scaling\index{classical MDS}. If the
% distances as computed in the data space are simply the Euclidean
% distance between each data point, $\dataVector_{i,:}$, then classical
% MDS is equivalent to principle component analysis\index{principal
%   component analysis (PCA)}. This algorithm is generally referred to
% as principal coordinate analysis\index{principal coordinate analysis
%   (PCO)}.

% We also considered the classical from the statistical scaling
% literature: that of embedding a set of cities in a two dimensional
% space using the distances by road between the cities. This highlighted
% an issue with \emph{ad hoc} specification of inter point distances:
% there is no guarantee that they can be embedded in a Euclidean
% space. Sets of distances that cannot be embedded in Euclidean spaces
% are associated with negative eigenvalues in their associated
% similarity matrices \fixme{Need to check what Mardia says on this}.

% We have given very little attention to how we derive the distance
% matrix, in the examples we gave we either considered Euclidean
% distances or road distances. The main focus of the developments in
% spectral approaches to dimensionality reduction have been in clever
% ways of specifying the distance/similarity matrix. We shall cover
% these in \refchap{chap:spectral}. We have also paid scant regard
% to the choice of objective function for distance matching. We will
% return to the objective function in \refchap{chap:iterative.tex}.
% \section{Summary}



% \subsection{MDS Conclusions}
% \begin{itemize}
% \item Multidimensional scaling: preserve a distance matrix.
% \item Classical MDS

%   \begin{itemize}
%   \item a particular objective function
%   \item for Classical MDS distance matching is equivalent to maximum variance
%   \item spectral decomposition of the similarity matrix
%   \end{itemize}
% \item For Euclidean distances in $\dataMatrix$ space classical MDS is equivalent
%   to PCA. 

%   \begin{itemize}
%   \item known as principal coordinate analysis (PCO)
%   \end{itemize}
% \item Haven't discussed choice of distance matrix.
% \end{itemize}


% \section{Matrix PCA}

% The dual approach to PCA leads us to consider a natural extension to PCA that relies on the matrix Gaussian density\index{matrix Gaussian density}. The matrix Gaussian is defined as
% \[
% \frac{1}{(2\pi)^{\frac{M\numData}{2}} \det{\covarianceMatrix}^{\frac{\numData}{2}} \det{\kernelMatrix}^{\frac{M}{2}}} \exp\left( -\half\tr{\kernelMatrix^{-1} \left(\dataMatrix -\meanMatrix\right)\covarianceMatrix^{-1} \left(\dataMatrix - \meanMatrix\right)^\top}\right)
% \]
% Note that the trace term in the exponential can be rewritten,
% \[
% -\half\tr{\kernelMatrix^{-1} \left(\dataMatrix -\meanMatrix\right)\covarianceMatrix^{-1} \left(\dataMatrix - \meanMatrix\right)^\top} =  -\half\tr{\covarianceMatrix^{-1} \left(\dataMatrix -\meanMatrix\right)^\top\kernelMatrix^{-1} \left(\dataMatrix - \meanMatrix\right)}
% \] 
% so the distribution is insensitive to swapping $\covarianceMatrix$ and $\kernelMatrix$ and transposing $\dataMatrix$ and $\meanMatrix$.

% Consideration of probabilistic PCO allows us to consider a dimensionality reduction version of this model. If we take $\covarianceMatrix = \fantasyMatrix\fantasyMatrix^\top + \dataStd_\fantasyScalar^2 \eye$ and  $\kernelMatrix = \latentMatrix\latentMatrix^\top + \dataStd_\latentScalar^2 \eye$ and have $\meanMatrix = \mu \onesVector$ we can produce a variant of PCO for probabilistic data. The situation is that each feature, $j$, of our data is associated with a $\numData\times M$ matrix, $\dataMatrix_j$. Following probabilistic PCO we treat each of these features independently given the latent variables and write down a likelihood as
% \[
% p\left(\left\{\dataMatrix_j\right\}_{j=1}^\dataDim | \latentMatrix,
%   \fantasyMatrix, \dataStd^2_\latentScalar,
%   \dataStd^2_\fantasyScalar\right) =
% \prod_{j=1}^\dataDim\frac{1}{(2\pi)^\frac{M \numData}{2}
%   \det{\covarianceMatrix}^\frac{\numData}{2}
%   \det{\kernelMatrix}^\frac{M}{2}} \exp\left(
%   -\half\tr{\kernelMatrix^{-1} \left(\dataMatrix_j
%       -\meanScalar_j \onesVector\right)\covarianceMatrix^{-1}
%     \left(\dataMatrix - \meanScalar_j\onesVector\right)^\top}\right)
% \]
% We can compute the gradient of the log likelihood with respect to
% $\latentMatrix$,
% \[
% \frac{\mathrm{d}\log
%   p\left(\left\{\dataMatrix_j\right\}_{j=1}^\dataDim | \latentMatrix,
%     \fantasyMatrix, \dataStd^2_\latentScalar,
%     \dataStd^2_\fantasyScalar\right)}{\mathrm{d}\latentMatrix} =
% -\left(\frac{M}{2}\kernelMatrix^{-1} +
%   \half\kernelMatrix^{-1}\cdataMatrix_j\covarianceMatrix^{-1}\cdataMatrix_j^\top\kernelMatrix^{-1}\right)\latentMatrix
% \]
% we have seen how we can solve for a fixed point in this equation by setting
% \[
% \latentMatrix = \eigenvectorMatrix_\latentScalar
% \eigenvalueMatrix_\latentScalar\rotationMatrix_\latentScalar^\top
% \]
% where $\eigenvectorMatrix_\latentScalar$ are the eigenvectors of
% $\cdataMatrix_j\covarianceMatrix^{-1}\cdataMatrix_j^\top$ associated
% with the largest $\latentDim_\latentScalar$ eigenvalues,
% $\left\{\ell_i\right\}_{i=1}^{\latentDim_\latentScalar}$. The matrix
% $\eigenvectorMatrix_\latentScalar$ is diagonal with elements given by
% $\eigenvalue_i=\sqrt{\ell_i-\dataStd^2_\latentScalar}$ and
% $\rotationMatrix_\latentScalar$ is an arbitrary rotation matrix.

% We can solve a similar fixed point equation for $\fantasyMatrix$ giving
% \[
% \fantasyMatrix = \eigenvectorMatrix_\fantasyScalar
% \eigenvalueMatrix_\fantasyScalar\rotationMatrix_\fantasyScalar^\top
% \]
% where $\eigenvectorMatrix_\fantasyScalar$ are the eigenvectors of
% $\cdataMatrix_j^\top\kernelMatrix^{-1}\cdataMatrix_j$ associated
% with the largest $\fantasyDim_\fantasyScalar$ eigenvalues,
% $\left\{\ell_i\right\}_{i=1}^{\latentDim_\fantasyScalar}$. The matrix
% $\eigenvectorMatrix_\fantasyScalar$ is diagonal with elements given by
% $\eigenvalue_i=\sqrt{\ell_i-\dataStd^2_\fantasyScalar}$ and
% $\rotationMatrix_\fantasyScalar$ is an arbitrary rotation matrix.

%%% Local Variables:
%%% TeX-master: "book"
%%% End:
%}