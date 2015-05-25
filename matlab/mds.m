%{
\begin{octave}
  %}
  % Comment/MATLAB set up code
  importTool('dimred')
  dimredToolboxes
  randn('seed', 1e6)
  rand('seed', 1e6)
  if ~isoctave
    colordef white
  end
  colorFigs = false;
  % Text width in cm.
  textWidth = 13
%{
%Start of Comment/MATLAB brackets
\end{octave}

\chapter{Dimensionality Reduction through Distance Matching}

In the last chapter we introduced principal component analysis through
a generative interpretation of the model. The approach had much in
common with Hotelling's original model, but through the addition of a
noise term it led to a fully probabilistic interpretation for
PCA. We've related this motivation to factor analysis where the
assumption is that a set of low dimensional factors are responsible
for explaining the data. In this chapter we switch tacks. We consider
a different approach to dimensionality reduction: distance matching.

\section{Inter-point Squared Distance Matching}

The probabilistic interpretation associated with probabilistic
PCA\index{probabilistic PCA (PPCA)} brings many associated
advantages. It allows the model to be extended within the
probabilistic framework, by for example mixture models
\citep{Tipping:iee_mixpca97,Ghahramani:emmixtures97}\index{mixture
  models} and Bayesian approaches
\citep{Bishop:bayesPCA98,Bishop:icann99,Minka:automatic01}\index{Bayesian
  inference}. We also saw above how a probabilistic interpretation
facilitates the problem of missing data. However, the probabilistic
model we described in the previous chapter requires us to consider
explicitly the mapping between the low dimensional data and our
observations, we constrained this mapping to be linear. In this
chapter we will first highlight the need for approaches which allow
for nonlinear relationships between the latent and data space. We will
consider a class of approaches known as multidimensional
scaling\index{multidimensional scaling} for performing this
dimensionality reduction.


In \refchap{chap:linear} we described how the dimensionality of data
could be reduced through explicitly modeling a linear relationship
between a low dimensional latent space and the observed data space. We
referred to this as the generative approach to dimensionality
reduction. A range of related approaches to dimensionality reduction
such as independent component analysis\index{independent component
  analysis (ICA)} and factor analysis\index{factor analysis (FA)} can
be seen as generative models, but our main focus was on the
probabilistic interpretation of principal components
analysis\index{probabilistic PCA (PPCA)}. In this chapter we will
consider the alternative approach of inter-point squared distance
matching. The basic idea is to compute the inter-point squared
distances of the data set, $\distanceMatrix$. By computing the squared
distances of the latent configurations, $\latentDistanceMatrix$, and
moving the latent points, $\latentMatrix$, to ensure these distances
match the data distances we can find a reduced dimensional
representation of the data. To motivate this approach we will consider
an artificial example based around a handwritten six.

\section{Rotated Sixes}

In \refchap{chap:thinking} we discussed the use of mixtures of
Gaussian densities for modelling data. The motivation was that the
center of each Gaussian density represented a ``prototype'' data point
that was then corrupted through various transformations. The
corruption of the points was modeled by Gaussian densities.  Here we
would like to consider a more realistic corruption of a prototype.

Let's consider an image of the handwritten digit 6 (image
br1561\_6.3.pgm), taken from the \fixme{USPS ??} data. The image has
$64$ rows by $57$ columns, giving a data point which is living in a
$\dataDim=3,648$ dimensional space. Let's consider a simple model for
handwritten 6s. We model each pixel independently with a binomial
distribution (\refbox{box:multinomial}). Each pixel is the result of a
single binomial trial.
\[
p(\dataVector) = \prod_{j=1}^\dataDim \binomProb^{\dataScalar_j}
(1-\binomProb)^{(1-\dataScalar_j)},
\]
where the probability across pixels are taken to be independent and
are governed by the same probability of being on, $\binomProb$. The
maximum likelihood solution for this parameter is given by the number
of pixels that are on in the data point divided by the total number of
pixels (see \refbox{box:binomial}:
\[
\binomProb = \frac{849}{3,648}.
\]
The probability of recovering the original six in any given sample is
then given by\footnote{Note this is not the binomial distribution
  which gives probabilities for total number of successes in a series
  of binary trials, here we don't only need a precise number of
  successes, we also need the successes to occur at the right pixels.}
\fixme{Add number of ones}
\[
p(\dataVector=\text{given\,image}) = \binomProb^{849}(1-\binomProb)^{3,648 - 849
}=2.67\times10^{-860}.
\]
\begin{boxfloat}
  \caption{The Binomial Distribution}\label{box:binomial}

  \boxfontsize
  The binomial distribution is the special case of the multinomial where
  the outcome of the trials is binary (success or failure). It
  represents the distribution for a given number of successes in a set
  number of trials when the probability of success is constant. For a
  probability of success given by $\binomProb$ the binomial distribution
  has the form
  \[
  p(n|N, \binomProb)=\frac{N!}{n!(N-n)!}  \binomProb^n (1-\binomProb)^{N-n}
  \]
  where $n$ is the number of successes and $N$ is the total number of
  trials. The term $\frac{N!}{n!(N-n)!}$ is known as the binomial
  coefficient and represents the number of ways in which $n$ successes
  can occur in $N$ trials (for example 1 success in 2 trials can occur
  either by success then failure or by failure then success. That's two
  ways: $\frac{2!}{(1!\times (2-1)!)} = 2$).

  A special case of the binomial is the when $N=1$. Then it is sometimes
  known as the Bernoulli distribution,
  \[
  p(s|\binomProb) = \binomProb^s (1-\binomProb)^{1-s}.
  \]
  For a model of binary pixels in an image that assumes each pixel is
  independent we have
  \[
  p(\dataVector|\binomProb) = \prod_{j=1}^{\dataDim}
  \binomProb^{\dataScalar_j} (1-\binomProb)^{1-\dataScalar_j}
  \]
  where $\dataVector$ is a vector of binary pixel values from the image
  and the image has $\dataDim$ pixels. The negative log likelihood is
  \[
  \errorFunction(\binomProb) = -\sum_{j=1}^\dataDim\dataScalar_j \log \binomProb -
  \sum_{j=1}^{\dataDim}(1-\dataScalar_j) \log(1-\binomProb)
  \]
  and gradients with respect to $\binomProb$ can be computed as
  \[
  \diff{\errorFunction(\binomProb)}{\binomProb} =
  \frac{1}{\binomProb}\sum_{j=1}^\dataDim \dataScalar_j -
  \frac{1}{1-\binomProb}\sum_{j=1}^\dataDim (1-\dataScalar_j)
  \]
  which can be re-expressed using the fact that the number of pixels
  that are on is $\dataDim_1=\sum_{j=1}^\dataDim\dataScalar_j$ and the
  number of off pixels is $\dataDim -\dataDim_1 = \sum_{j=1}^\dataDim
  (1-\dataScalar_j)$,
  \[
  \diff{\errorFunction(\binomProb)}{\binomProb} = \frac{\dataDim_1}{\binomProb} -
  \frac{\dataDim-\dataDim_1}{1-\binomProb}
  \]
  setting to zero and rearranging we recover
  \[
  \binomProb = \frac{\dataDim_1}{\dataDim-\dataDim_1}{1-\binomProb}
  \]
  at a stationary point. Further rearrangement leads to
  \[
  \binomProb =\frac{\frac{\dataDim_1}{\dataDim-\dataDim_1}}{\left(1 +
      \frac{\dataDim_1}{\dataDim-\dataDim_1}\right)} =
  \frac{\dataDim_1}{\dataDim}
  \]
  which turns out to be a global minimum of the negative log
  likelihood. To see this we simply compute the second derivative of the
  negative log likelihood with respect to $\binomProb$,
  \[
  \diffTwo{\errorFunction(\binomProb)}{\binomProb} = -
  \frac{\dataDim_1}{\binomProb^2} -
  \frac{\dataDim-\dataDim_1}{(1-\binomProb)^2},
  \]
  which will always be negative if $0 \leq \binomProb \leq 1$ as it must
  be. This implies the negative log likelihood is convex and the
  stationary point is a global minimum.
\end{boxfloat}
This implies that even if we sampled from this model every nanosecond
between now and the end of the universe\footnote{We follow
  \cite{MacKay:information03} in assuming that will be in
  approximately \fixme{$number$} years.} we would still be highly
unlikely to see the original six. Our expected waiting time would be
$10^{217}$ years and there is only a \fixme{$fill$} probability of seeing it
before the universe ends\footnote{This can be computed with the geometric distribution.}. This is clearly a very poor generative
model of the six. The independence assumption across features (just as
in \refchap{chap:thinking}) is a very poor one. Let's consider an
alternative model for handwritten sixes. We generate a data set in the
following way: we take the prototype 6 and rotate the image 360 times,
by one degree for reach rotation. This corruption of the prototype 6
is designed to reflect the sort of corruptions that real prototypes
might undergo. A rotated 6 is still a 6, and although it is not
realistic to consider such drastic rotations as we have applied, it
will be helpful in visualizing the corruption of the data. In
\reffig{fig:prototypeSix} we show the original digit and rotations of
10 degrees clockwise and anticlockwise.

\begin{figure}
  \begin{octave}
    %end of Comment/MATLAB brackets.
    %} 

    close all

    % Load in the six.
    sixImage = double(imread('br1561_6.3.pgm'));
    rows = size(sixImage, 1);
    col = size(sixImage, 2);


    figure(1)
    imagesc(sixImage);
    axis off
    axis equal
    if ~colorFigs, colormap gray; end
    printLatexPlot('demSix0', '../../../dimred/tex/diagrams/', 0.33*textWidth);
    for i = 1:3
      randImage = rand(rows, col)>length(find(sixImage))/(rows*col);
      clf
      imagesc(-randImage);
      axis off
      axis equal
      if ~colorFigs, colormap gray; end
      printLatexPlot(['demSixSpace' num2str(i)], '../../../dimred/tex/diagrams/', 0.33*textWidth);
    end

    options.noiseAmplitude = 0;
    options.subtractMean = false;

    Y = generateManifoldData('six', options);

    ind = [31 11 350 330 310 290];
    for i = 1:length(ind)
      clf
      imagesc(-reshape(Y(ind(i), :), 64, 64))
      if ~colorFigs, colormap gray; end
      axis off
      axis equal
      printLatexPlot(['demSix' num2str(i)], '../../../dimred/tex/diagrams', 0.33*textWidth);
    end

    %{
  \end{octave}
  \begin{center}
    \subfigure[Original 6]{\input{../../../dimred/tex/diagrams/demSix0}}\hfill
    \subfigure[Rotation through 10 degrees clockwise]{\input{../../../dimred/tex/diagrams/demSix3}}\hfill
    \subfigure[Rotation through 10 degrees anticlockwise]{\input{../../../dimred/tex/diagrams/demSix2}}
  \end{center}
  \caption{The prototype 6 taken from the \fixme{USPS} data along with
    two example rotations of the digit. The original image has been
    converted to 64$\times$64 to match dimensionality of the rotated
    images.}\label{fig:prototypeSix}
\end{figure}

In \reffig{fig:rotatedSixes} we take all 360 examples of the rotated
digits and visualize these data using principal component analysis.
and linearly project them down to a two dimensional space (using the
posterior given in \refsec{sec:ppcaPosterior}). Selected examples from
the data are also placed on the plot near their corresponding
projected position. What we see makes intuitive sense. The data,
projected into the two dimensional space, proscribes a circle. The
data set is inherently one dimensional. The dimension of the data is
associated with the rotation transformation. A pure rotation would
lead to a pure circle. In practice rotation of images requires some
interpolation and this leads to small corruptions of the latent
projections away from the circle.
\begin{figure}
  \begin{octave}
    %end of Comment/MATLAB brackets.
    %} 
    % close all
    disp('Here two')
    demSixDistances(4096)
    printLatexPlot('demSixDistances4096', '../../../dimred/tex/diagrams', 0.9*textWidth);
    %{
  \end{octave}
  \begin{center}
    \input{../../../dimred/tex/diagrams/demSixDistances4096}
  \end{center}
  % \fixme{Another plot that is a zoom in on some portion of the plot??}
  \caption{Inter-point squared distances for the rotated digits data. Much of the
    data structure can be seen in the matrix. All points are ordered by
    angle of rotation. We can see that the distance between two points
    with similar angle of rotation is small (note in the upper right and
    lower left corners the low distances associated with 6s rotated by
    roughly 360 degrees and unrotated 6s.}\label{fig:sixDistances4096}
\end{figure}

This inspires an alternative approach to dimensionality reduction: can
we find a configuration of points, $\latentMatrix$, such that the
normalized squared distance between each latent point,
\[
\frac{\latentDistanceScalar_{i,j}}{\latentDim}=\frac{1}{\latentDim}\ltwoNorm{\latentVector_{i,:}-\latentVector_{j,:}}^2
\]
closely matches the corresponding normalized squared distance
$\frac{\distanceScalar_{i,j}}{\dataDim}$ in the data space? We can do
this by defining an objective function that depends on the matrix of
squared distances in the latent space,
$\latentDistanceMatrix=\left(\latentDistanceScalar_{i,j}\right)_{i,j}$,
and the matrix of squared distances in the data space,
$\distanceMatrix=\left(\distanceScalar_{i,j}\right)_{i,j}$\index{distance
  matrix|see{squared distance matrix}}.

\section{Feature Selection\index{feature selection}}

A very simple approach to dimensionality reduction is to select
some features from the data to retain, and discard the other
features. If we retain $\latentDim$ of the original $\dataDim$
features, we have a $\latentDim$ dimensional representation of our
data.

To decide which $\latentDim$ features to retain we define an objective
function that measures the absolute error between the squared
distances in the latent space and those in the data space. We
represent this through an entrywise $L_{1}$ norm on average difference
between squared distances
\[
\errorFunction\left(\latentMatrix\right)=\frac{1}{\numData(\numData-1)}\sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\loneNorm{\frac{\distanceScalar_{i,j}}{\dataDim}-\frac{\latentDistanceScalar_{i,j}}{\latentDim}}.
\]
The pre-factor $\frac{1}{\numData(\numData-1)}$ accounts for the
number of non-zero entries in the squared distance matrices that are
being compared: there are $\numData^2$ entries, but the $\numData$
diagonal entries will always be zero.  For a given number of retained
features, $\latentDim$, we will look to minimize this error. We can do
this by selecting for $\latentMatrix$, in turn, the column from
$\dataMatrix$. We can repeat this process until we have the desired
number of features for our latent representation.

It will turn out that to minimize $\errorFunction\left(\dataMatrix\right)$
we need to compose $\latentMatrix$ by extracting the columns of
$\dataMatrix$ which have the largest variance.

The squared distance in the data space can be expressed as
\[
\distanceScalar_{i,j}=\sum_{k=1}^{\dataDim}\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}.
\]
Since we can re-order the columns of $\dataMatrix$ without affecting
the distances we choose an ordering which is such that the first
$\latentDim$ columns of $\dataMatrix$ are the those that will best
represent the distance matrix. Each selected feature will also be
scaled by a factor given by $\singularvalue_k$. This allows us to
replace $\latentMatrix$ with columns from $\dataMatrix$. We perform
the substitution
$\latentVector_{:,k}=\singularvalue_k\dataVector_{:,k}$ for all
$k=1\dots\latentDim$. This means we can express the squared distances
in latent space using
\[
\latentDistanceScalar_{i,j}=\sum_{k=1}^{\latentDim}\left(\latentScalar_{i,k}-\latentScalar_{j,k}\right)^{2}=\sum_{k=1}^{\latentDim}\singularvalue^2_k\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}
\]
Using this form for the squared latent distances we can rewrite the
objective function as
% ,
% \[
% E\left(\latentMatrix\right)=\sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\left|\distanceScalar_{ij}^{2}-\latentDistanceScalar_{ij}^{2}\right|.
% \]
\begin{align}
\errorFunction\left(\latentMatrix\right) = & \frac{1}{\numData(\numData-1)}\sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\sum_{k=1}^\latentDim\loneNorm{\left(\frac{1}{\dataDim}-\frac{\singularvalue_k^2}{\latentDim}\right)\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}} \nonumber \\&+  \sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\sum_{k=\latentDim+1}^{\dataDim}\frac{1}{\dataDim}\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}.\label{eq:distObjectiveExpanded}
\end{align}
First of all we optimize with respect to the scale parameter,
$\singularvalue_k$. This scale parameter only appears in the first
term of \refeq{eq:distObjectiveExpanded}. Because of the L1 norm
around this term, its minimum must be non-negative. We can see by
inspection that this term can be set to zero by setting the scale
parameter to
$\singularvalue_k=\sqrt{\frac{\latentDim}{\dataDim}}$ minimizing the first term. This leaves us with
\[
\errorFunction\left(\latentMatrix\right)  = \frac{1}{\dataDim\numData(\numData-1)}\sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\sum_{k=\latentDim+1}^{\dataDim}\left(\dataScalar_{i,k}-\dataScalar_{j,k}\right)^{2}.
\]
In other words, the minimum of the objective is dependent on the
squared distance between points that is associated with the columns
that we will choose to discard. We need to minimize this quantity. To
do this we first introduce the mean of each dimension,
$\meanScalar_k=\frac{1}{\numData}\sum_{i=1}^{\numData}\dataScalar_{i,k}$,
and center each data point. This can be done without effecting the
overall objective function,
\[
\errorFunction\left(\latentMatrix\right)
=\frac{1}{\dataDim\numData(\numData-1)}\sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\sum_{k=\latentDim+1}^{\dataDim}\left(\left(\dataScalar_{i,k}-\meanScalar_{k}\right)-\left(\dataScalar_{j,k}-\meanScalar_{k}\right)\right)^{2}.
\]
Expanding the brackets gives
\begin{align*}
\errorFunction\left(\latentMatrix\right)
=\frac{1}{\dataDim\numData(\numData-1)}\sum_{i=1}^{\numData}\sum_{j=1}^{\numData}\sum_{k=\latentDim+1}^{\dataDim}\Bigl(&\left(\dataScalar_{i,k}-\meanScalar_{k}\right)^{2}+\left(\dataScalar_{j,k}-\meanScalar_{k}\right)^{2}\\&-2\left(\dataScalar_{j,k}-\meanScalar_{k}\right)\left(\dataScalar_{i,k}-\meanScalar_{k}\right)\Bigr).
\end{align*}
Bringing the sums over the data points inside the sum over the
discarded dimensions we have
\begin{align*}
\errorFunction\left(\latentMatrix\right)
=\frac{1}{\dataDim(\numData-1)}\sum_{k=\latentDim+1}^{\dataDim}\Bigl(&\sum_{i=1}^{\numData}\left(\dataScalar_{i,k}-\meanScalar_{k}\right)^{2}+\sum_{j=1}^{\numData}\left(\dataScalar_{j,k}-\meanScalar_{k}\right)^{2}\\&-\frac{2}{\numData}\sum_{j=1}^{\numData}\left(\dataScalar_{j,k}-\meanScalar_{k}\right)\sum_{i=1}^{\numData}\left(\dataScalar_{i,k}-\meanScalar_{k}\right)\Bigr).
\end{align*}
Using the fact that $\sum_{j=1}^\numData \dataScalar_{j,k} =
\sum_{j=1}^\numData \meanScalar_k$ we can remove the last term inside
the brackets
\[
\errorFunction\left(\latentMatrix\right)
=\frac{1}{\dataDim(\numData-1)}\sum_{k=\latentDim+1}^{\dataDim}\left(\sum_{i=1}^{\numData}\left(\dataScalar_{i,k}-\meanScalar_{k}\right)^{2}+\sum_{j=1}^{\numData}\left(\dataScalar_{j,k}-\meanScalar_{k}\right)^{2}\right).
\]
If we estimate the variance\footnote{Here, for convenience we are using the ``unbiased'' estimator of the variance which uses $\numData-1$ in the denominator. Generally we will use the maximum likelihood estimator, which uses $\numData$ alone.} of the $k$th column of $\dataMatrix$
to be $\featureStd^2_k=\frac{1}{\numData-1}\sum_{i=1}^\numData
(\dataScalar_{i, k} - \meanScalar_{k})^2$ we can re-express the error
as a function of the sum of the sample variance for each discarded
column of $\dataMatrix$,
\[
\errorFunction\left(\latentMatrix\right)=\frac{2}{\dataDim}\sum_{k=\latentDim+1}^{\dataDim}\featureStd_{k}^{2}.
\]
This error can be minimized by discarding the $\dataDim-\latentDim$
columns with the smallest sample variance: in other words we need to
retain the $\latentDim$ columns with the largest sample
variance. These columns need to be retained and scaled by
$\sqrt{\frac{\latentDim}{\dataDim}}$ to compose the matrix
$\latentMatrix$.

\subsection{Feature Selection for Rotated Sixes}

Our feature selection algorithm is quite simple: compute the variance
of each feature (column) of $\dataMatrix$. Retain the $\latentDim$
features with the largest variance. Applying this to the rotated six
example, let's see how good a job the features we select do when
representing the data space distances.
\begin{figure}
  \begin{octave}
    % end of Comment/MATLAB brackets.
    %} 
    close all
    e=demSixDistances(2)    
    if ~colorFigs, colormap gray; end
    axis equal
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesError2.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistances2', '../../../dimred/tex/diagrams', 0.45*textWidth);
    close
    e=demSixDistances(10)
    if ~colorFigs, colormap gray; end
    axis equal
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesError10.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistances10', '../../../dimred/tex/diagrams', 0.45*textWidth);
    close
    e=demSixDistances(100)
    if ~colorFigs, colormap gray; end
    axis equal
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesError100.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistances100', '../../../dimred/tex/diagrams', 0.45*textWidth);
    close
    e=demSixDistances(1000)
    if ~colorFigs, colormap gray; end
    axis equal
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesError1000.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistances1000', '../../../dimred/tex/diagrams', 0.45*textWidth);
    %{
  \end{octave}
%\input{../../../dimred/tex/diagrams/sixDistancesError10}
%\input{../../../dimred/tex/diagrams/sixDistancesError100}
%\input{../../../dimred/tex/diagrams/sixDistancesError1000}
  \begin{center}
    \input{../../../dimred/tex/diagrams/sixDistancesError2}
    \subfigure[Distances reconstructed with two dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistances2}}\hfill
    \input{../../../dimred/tex/diagrams/sixDistancesError10}
    \subfigure[Distances reconstructed with 10 dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistances10}}\\
    \input{../../../dimred/tex/diagrams/sixDistancesError100}
    \subfigure[Distances reconstructed with 100 dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistances100}}\hfill
    \input{../../../dimred/tex/diagrams/sixDistancesError1000}
    \subfigure[Distances reconstructed with 1000 dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistances1000}}
  \end{center}
  
  \caption{Reconstruction of inter-point squared distances for the rotated six data where feature selection is used to reduce the dimensionality.}\caption{fig:featureSelectionReconstruction}
\end{figure}
In
\reffig{fig:featureSelectionReconstruction} we've imaged
$\latentDistanceMatrix$ for different values of $\latentDim$. We can
see that it isn't until we select a considerable number of features
(around $\latentDim=1000$) that the finer features of the distance
matrix are recreated. In particular the grid lines at $90$, $180$, and
$270$ degrees are not visible until $1000$ features are selected. We
also show the mean absolute error between the true distances and the
latent distances in the caption of each plot. It drops relatively
slowly from \input{../../../dimred/tex/diagrams/sixDistancesError2}\errorVal to \input{../../../dimred/tex/diagrams/sixDistancesError1000}\errorVal.

As an approach to dimensionality reduction, feature selection doesn't
seem very encouraging. To reflect the finer structure of the original
data we seem to need to retain around 1000 dimensions: for this many
dimensions our latent dimensional space is itself very high
dimensional. In the next section we will further develop the approach
to distance matching by rotating the features before we select
them. This implies a linear transformation of the features to the
latent space: rotation followed by scaling and selection. The added
flexibility of the rotation may allow us to make a much better
approximation to the squared distances with far fewer features.

\section{Feature Extraction\index{feature extraction}}

To motivate rotations of the data set, we first note that rotating the
data has no effect on the inter-point squared distance matrix. Consider a new
data set $\dataMatrix^\prime = \dataMatrix\rotationMatrix^\top$ where
$\rotationMatrix$ is a $\dataDim \times \dataDim$ orthogonal matrix
such that $\rotationMatrix^\top\rotationMatrix=\eye$. The inter-point
squared distances for the original data can be written in matrix form
as,
\[
\distanceMatrix = \diag{\dataMatrix\dataMatrix^\top}\onesVector^\top - 2\dataMatrix\dataMatrix^\top + \onesVector \diag{\dataMatrix\dataMatrix^\top}
\]
where $\diag{\mathbf{A}}$ is an operator that extracts the diagonal of
matrix $\mathbf{A}$ as a column vector. Computation of the distances
for the rotated data set gives
\[
\distanceMatrix^\prime = \diag{\dataMatrix\rotationMatrix^\top\rotationMatrix\dataMatrix^\top}\onesVector^\top - 2\dataMatrix\rotationMatrix^\top\rotationMatrix\dataMatrix^\top + \onesVector \diag{\dataMatrix\rotationMatrix^\top\rotationMatrix\dataMatrix^\top}^\top.
\]
Using the fact that $\rotationMatrix^\top\rotationMatrix = \eye$ we
can see that $\distanceMatrix^\prime = \distanceMatrix$. So rotations
of the features have no effect on the inter-point squared
distances.\footnote{Clearly this is also be true for latent squared
  distances when the latent variables are
  rotated. $\latentMatrix^\prime=\latentMatrix\rotationMatrix^\top
  \rightarrow \latentDistanceMatrix^\prime=\latentDistanceMatrix$. So
  any solution we find for $\latentMatrix$ will be rotation
  invariant.} We take this as a license to perform any rotation we
want before selecting features. Our plan is simple: rotate the data in
such a way that the retained features for $\latentMatrix$ best
approximate the data's inter-point squared distance matrix,
$\distanceMatrix$, through the latent matrix $\latentDistanceMatrix$,
\[
\latentDistanceMatrix = \diag{\latentMatrix\latentMatrix^\top}\onesVector^\top - 2\latentMatrix\latentMatrix^\top + \onesVector\diag{\latentMatrix\latentMatrix^\top}^\top.
\]
In the last section we consider dimensionality reduction by simply
extracting features directly from the data for our latent
variables. Ignoring the scale factor of
$\sqrt{\frac{\latentDim}{\dataDim}}$ this is equivalent to projecting
the data directly onto the features we retain. This is shown for a
simple two dimensional data set projected onto one feature in
\reffig{fig:demNoRotationDistFeatureSelection}.
\begin{figure}
  \begin{octave}
    %}
    randn('seed', 1e6);
    rand('seed', 1e6);

    numData = 100;

    covMat = [4.1 2; 2 1.1];


    Y = gsamp(zeros(1, 2), covMat, numData);

    % Feature selection.
    h = plot(Y(:, 1), Y(:, 2), 'bo');
    set(h, 'linewidth', 3)
    %set(h, 'markersize', 20)
    axis equal
    set(gca, 'xlim', [-8 8]);
    set(gca, 'ylim', [-4 4]);
    set(gca, 'xtick', [-8 -4 0 4 8]);
    set(gca, 'ytick', [-4 0 4]);
    zeroAxes(gca, 0.02);
    printLatexPlot('demRotationDist1', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    projLines = [];
    for i = 1:numData
      projLines = [projLines line([Y(i, 1) Y(i, 1)], [0 Y(i, 2)])];
    end
    set(projLines, 'color', [1 0 0]);
    set(projLines, 'visible', 'off');
    set(projLines, 'visible', 'on')
    printLatexPlot('demRotationDist2', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    delete(projLines)
    set(h, 'ydata', zeros(numData, 1));
    printLatexPlot('demRotationDist3', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    % Rotate the Selection
    [R, Lambda] = eig(cov(Y));

    [void, vecInd] = max(diag(Lambda));
    if R(1, vecInd)<0
      R(:, vecInd) = -R(:, vecInd);
    end
    maxTheta = acos(R(1, vecInd));
    counter = 0;
    for theta = linspace(0, maxTheta, 5)
      counter = counter + 1;
      R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
      Yrot = Y*R;
      clf
      h = plot(Yrot(:, 1), Yrot(:, 2), 'bo');
      set(h, 'linewidth', 3)
      %set(h, 'markersize', 20)
      axis equal
      set(gca, 'xlim', [-8 8]);
      set(gca, 'ylim', [-4 4]);
      set(gca, 'xtick', [-8 -4 0 4 8]);
      set(gca, 'ytick', [-4 0 4]);
      zeroAxes(gca, 0.02);
      printLatexPlot(['demRotationDist4_' num2str(counter)], '../../../dimred/tex/diagrams/', 0.45*textWidth)
    end

    projLines = [];
    for i = 1:numData
      projLines = [projLines line([Yrot(i, 1) Yrot(i, 1)], [0 Yrot(i, 2)])];
    end
    set(projLines, 'color', [1 0 0]);
    set(projLines, 'visible', 'off');
    set(projLines, 'visible', 'on')
    printLatexPlot('demRotationDist5', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    delete(projLines)
    set(h, 'ydata', zeros(size(Yrot, 1), 1));
    printLatexPlot('demRotationDist6', '../../../dimred/tex/diagrams/', 0.45*textWidth)
    %{
  \end{octave}

  \subfigure[Data with two features ($\dataDim=2$) shown as a scatter plot.]{
    \input{../../../dimred/tex/diagrams/demRotationDist1}}\hfill
  \subfigure[Selecting the feature with the largest variance  is equivalent to projecting the data onto the
  $x$-axis.]{
    \input{../../../dimred/tex/diagrams/demRotationDist2}}\\
  \centerline{\subfigure[The new representation of the data has only
    one feature.]{
      \input{../../../dimred/tex/diagrams/demRotationDist3}}}

  \caption{Feature selection via distance preservation. Data is having
    its dimensionality reduced through selecting the feature with the
    largest variance. Here data containing two features is projected
    down to data containing one feature by selecting the feature with
    the largest variance to represent the
    data.}\label{fig:demNoRotationDistFeatureSelection}
\end{figure}


The fact that we can rotate the data without changing the inter-point
squared distances suggests the following alternative strategy: rotate
the data to increase the variance associated with the retained
dimensions, so that the discarded variance is smaller. This works
because the total variance\index{total variance}\newglossaryentry{total_variance}{name={total
    variance}, description={The total variance associated with a
    covariance matrix is the sum of the diagonal variance elements. It
    is given by the trace of the covariance matrix and it is invariant
    to rotation of the data set.}}: the sum of the variances of the
features remains constant under rotation. If more variance can be
associated with retained features, less variance will be associated
with discarded features. The general idea is shown in
\reffig{fig:demRotationDistFeatureSelection}.
% 
\begin{figure}
  \subfigure[Original data in two dimensions.]{\input{../../../dimred/tex/diagrams/demRotationDist4_1}}\hfill
  \subfigure[Data rotated so that direction of maximum variance is now axis aligned.]{
    \input{../../../dimred/tex/diagrams/demRotationDist4_5}}\\
  \subfigure[Lines show projections of data onto the principal axis.]{
    \input{../../../dimred/tex/diagrams/demRotationDist5}}\hfill
  \subfigure[Data is projected down to a single dimension.]{
    \input{../../../dimred/tex/diagrams/demRotationDist6}}

  \caption{Rotation of the data features better preserves the
    inter-point squared distances. Here data is rotated onto its
    direction of maximum variations and then the data dimension is
    reduced to one.}\label{fig:demRotationDistFeatureSelection}

\end{figure}



\subsection{Which Rotation?}

More formally we are interested in rotating the data set so we can
minimize the residual error associated with retaining features of the
data. We can use our algorithm for discarding features, we showed in
the last section that we should retain features with the maximum
variance, the error is then given by the sum of residual variances,
\[
\errorFunction\left(\latentMatrix\right)=\frac{2}{\dataDim}
\sum_{k=\latentDim+1}^{\dataDim}\featureStd_{k}^{2}.
\]
The total variance of a data set is defined as the sum of the variances of each feature,
\[
\featureStd_\text{total}^2 = \sum_{k=1}^\dataDim \featureStd_k^2 = (\numData-1)^{-1}\tr{\cdataMatrix^\top \cdataMatrix}
\]
where $\cdataMatrix$ is the centered data matrix so that the maximum likelihood estimate of the sample
covariance is given by
$\sampleCovMatrix=\numData^{-1}\cdataMatrix^\top\cdataMatrix$. From the
properties of the trace (see \refbox{box:trace}) we know that
rotations of the data have no effect on the total variance
\[
\tr{\rotationMatrix\cdataMatrix^\top\cdataMatrix\rotationMatrix} = \tr{\cdataMatrix^\top \cdataMatrix}.
\]
If we are looking to discard the directions associated with the
smallest variance then we need to retain the directions associated
with the maximum variance as the total variance will be conserved
under rotation. We will now develop the algorithm that rotates the data
to find the directions of maximum variance. We will operate directly
on the sample covariance matrix
$\sampleCovMatrix=\numData^{-1}\cdataMatrix^{\top}\cdataMatrix$ of the
data and will extract each direction in turn.

\subsection{Maximum Variance Rotations}

We want to rotate the data such that our first extracted dimension
$\latentVector_{:,1}=\sqrt{\frac{\latentDim}{\dataDim}}\cdataMatrix\rotationVector_{:,1}$,
has the maximum variance. Where $\rotationVector_{:,1}$ is the first column of the rotation matrix, $\rotationMatrix$. We can find the maximum variance direction by looking for 
\[
\rotationVector_{:, 1}  =  \text{argmax}_{\rotationVector_{:, 1}}\variance{\cdataMatrix\mathbf{\rotationVector_{:, 1}}}.
\]
Since $\rotationVector_{:, 1}$ is a vector from the rotation matrix we must also impose the constraint that it has unit length, in other words
\[  
\rotationVector_{:, 1}^{\top}\rotationVector_{:, 1}=1.
\]
We can write the variance of the latent variable in terms of the
sample covariance. Since $\cdataMatrix$ is centered, then the latent
direction $\latentVector_{:,1}$ will also be centered. Its variance is
given therefore given by $\variance{\latentVector_{:, 1}} =
\numData^{-1}\latentVector_{:, 1}^\top \latentVector_{:, 1}$. This can
be rewritten in terms of the centered data matrix by substituting with
$\latentVector_{:, 1}=\sqrt{\frac{\latentDim}{\dataDim}}\cdataMatrix\rotationVector_{:, 1}$

\[
\variance{\latentVector_{:,1}}=\numData^{-1}\frac{\latentDim}{\dataDim}\left(\cdataMatrix\rotationVector_{:, 1}\right)^{\top}\cdataMatrix\rotationVector_{:, 1}=\frac{\latentDim}{\dataDim}\rotationVector_{:, 1}^{\top}\underbrace{\left(\numData^{-1}\cdataMatrix^{\top}\cdataMatrix\right)}_{\text{sample}\,\text{covariance}}\rotationVector_{:, 1}=\frac{\latentDim}{\dataDim}\rotationVector_{:, 1}^{\top}\sampleCovMatrix\rotationVector_{:, 1}.
\]
Finding the direction of maximum variance in the data therefore
consists of maximizing $\rotationVector_{:,
  1}^\top\sampleCovMatrix\rotationVector_{:, 1}$ with respect to
$\rotationVector_{:, 1}$ under the constraint that the length of
$\rotationVector_{:, 1}$ is one. This requires that we introduce a
Lagrange multiplier, $\eigenvalue_1$, to enforce the constraint (see
\refbox{box:lagrangeMultipliers}).
\begin{boxfloat}
  \caption{Lagrange Multipliers}\label{box:lagrangeMultipliers}
  \boxfontsize

  Lagrange multipliers allow us to perform the optimization of a
  function under constraints. They do this through a clever
  trick. Let's say we are optimizing an error function,
  $\errorFunction(\parameterVector)$ under some constraint on the
  parameters. For example we might constrain the parameters such that
  $g(\parameterVector)=b$. We can force the solution to respect the
  constraint by introducing a new `parameter'
  $\lagrangeMultiplier$. We then write the objective function as
  \[
  \lagrangian(\parameterVector) = \errorFunction(\parameterVector) +
  \lagrangeMultiplier(g(\parameterVector)-b).
  \]
  This function is known as a Lagrangian and the new parameter,
  $\lagrangeMultiplier$< is known as a Lagrange multiplier.The effect
  of this modified objective can be seen if we take the gradient with
  respect to $\lagrangeMultiplier$,
  \[
  \diff{\lagrangian(\parameterVector)}{\lagrangeMultiplier} =
  g(\parameterVector) - b
  \]
  looking for a fixed point where the gradient of the Lagrangian is
  zero gives us the following equation:
  \[
  g(\parameterVector) = b
  \]
  so the fixed points of the augmented system will impose the
  constraint we required. If multiple constraints are required further
  terms can be added,
  \[
  \lagrangian(\parameterVector) = \errorFunction(\parameterVector) + \sum_{i}\lagrangeMultiplier_i(g_i(\parameterVector)-b_i).
  \]

  \fixme{Sometimes constraints are also imposed in the form of inequalities,
  $g_{i}(\parameterVector)\geq b$. In this case the Karush Kahn Tucker conditions must be used.}
\end{boxfloat}
giving a \emph{Lagrangian}\index{Lagrangian}\newglossaryentry{lagrangian}{name={Lagrangian},
  description={The Lagrangian is the name given to an objective
    function composed of an original objective function with
    additional terms that include Lagrange multipliers (see
    \refbox{box:lagrangeMultipliers}) associated with any constraints
    imposed on the system. See \refbox{box:lagrangeMultipliers}.}} of the form
\[
\lagrangian\left(\rotationVector_{:, 1},\eigenvalue_{1}\right)=\rotationVector_{:, 1}^{\top}\sampleCovMatrix\rotationVector_{:, 1}+\eigenvalue_{1}\left(1-\rotationVector_{:, 1}^{\top}\rotationVector_{:, 1}\right).
\]
The gradient of the Lagrangian with respect to $\rotationVector_{:, 1}$
is given by
\[
\diff{\lagrangian\left(\rotationVector_{:, 1},\eigenvalue_{1}\right)}{\rotationVector_{:, 1}}=2\sampleCovMatrix\rotationVector_{:, 1}-2\eigenvalue_{1}\rotationVector_{:, 1}
\]
and a stationary point of this objective may be found by rearranging the equation to give
\begin{equation}
  \sampleCovMatrix\rotationVector_{:, 1}=\eigenvalue_{1}\rotationVector_{:, 1}.\label{eq:principalEigenvector}
\end{equation}
This equation has the form of an eigenvalue problem (see
\refbox{box:eigenvalueProblem}.
\begin{boxfloat}
  \caption{Eigenvalue Problems}\label{box:eigenvalueProblem}

  \boxfontsize An eigenvalue problem is a matrix equation of the form
  \[
  \Amatrix \eigenvector = \eigenvalue \eigenvector. 
  \]
  where $\Amatrix\in\Re^{k\times k}$, $\eigenvalue$ is a scalar and $\eigenvector\in\Re^{k\times 1}$ and is constrained to have unit length, $\eigenvector^\top\eigenvector=1$. The word comes from the German mathematician: ``eigen'' in this sense may be thought to mean ``characteristic''. In other words these are characteristic vectors and values of the matrix $\Amatrix$. . The aim in an eigenvalue problem is to find that vector. If the matrix $\Amatrix\in\Re^{k\times k}$ then there will be up to $k$ different solutions for this eigenvalue problem. re are typically  be several vectors in other words the idea is to find a vector, $\eigenvector$, which when multiplied by a matrix  
  If the matrix is real and symmetric then the eigenvalues of the system will also be real.
\end{boxfloat}
By pre-multiplying the eigenvalue problem by
$\rotationVector_{:, 1}^{\top}$ and using the constraint that
$\rotationVector_{:, 1}^\top\rotationVector_{:, 1}=1$ we can see that
\[
\eigenvalue_{1}=\rotationVector_{:, 1}^{\top}\sampleCovMatrix\rotationVector_{:, 1}.
\]

So the variance of our rotated data is given by a scaled eigenvalue of
$\sampleCovMatrix$: $\variance{\latentVector_{:,
    1}}=\frac{\latentDim}{\dataDim}\eigenvalue_1$. The maximum
variance must be given by the largest eigenvalue of
$\sampleCovMatrix$. The associated eigenvector is then given by
$\rotationVector_{:, 1}$. This is the single direction that will best
preserve the inter-point squared distances under the absolute error
criterion. %The maximum eigenvalue of the sample covariance is also the
%first principal component of the system (see \fixme{where to see}).

Having extracted a new feature, $\latentVector_{:, 1}$ from the data
that best preserves the inter-point squared distance in the absolute
sense, we now need to find the next feature, given by
$\latentVector_{:, 2}= \sqrt{\frac{\latentDim}{\dataDim}}\cdataMatrix\rotationVector_2$. Since we are rotating the data space, the vector
$\rotationVector_{:,2}$ must be of unit length \emph{and} orthogonal to
$\rotationVector_{:, 1}$ such that
$\rotationVector_{:, 1}^\top\rotationVector_2 = 0$. In fact, for all
future features we extract, we must ensure that their associated
directions, $\rotationVector_k$, are orthogonal to all the
directions we have extracted before. In other words we need to
ensure that for $j<k$ we have
\[
\rotationVector_{:, j}^{\top}\rotationVector_{:, k}=\zerosVector\quad\quad\rotationVector_{:, k}^{\top}\rotationVector_{:, k}=1.
\]
This ensures that the full rotation matrix is orthonormal so $\rotationMatrix^\top\rotationMatrix = \eye$. To find these directions, we use a Lagrangian of the form
\[
\lagrangian\left(\rotationVector_{:, k},\eigenvalue_{k},\boldsymbol{\gamma}\right)=\rotationVector_{:, k}^{\top}\sampleCovMatrix\rotationVector_{:, k}+\eigenvalue_{k}\left(1-\rotationVector_{:, k}^{\top}\rotationVector_{:, k}\right)+\sum_{j=1}^{k-1}\gamma_{j}\rotationVector_{:, j}^{\top}\rotationVector_{:, k}
\]
where $\gamma_j$s are Lagrange multipliers that enforce the constraint that the $k$th direction is orthogonal to all the preceding directions. Gradients with respect to the $k$th direction can then be found as,
\[
\diff{\lagrangian\left(\rotationVector_{:, k},\eigenvalue_{k}\right)}{\rotationVector_{:, k}}=2\sampleCovMatrix\rotationVector_{:, k} - 2\eigenvalue_{k}\rotationVector_{:, k}+\sum_{j=1}^{k-1}\gamma_{j}\rotationVector_{:, j}
\]
and a stationary point is recovered when  this equation is set to zero,

\[
\zerosVector=2\sampleCovMatrix\rotationVector_{:, k} - 2\eigenvalue_{k}\rotationVector_{:, k}+\sum_{j=1}^{k-1}\gamma_{j}\rotationVector_{:, j}.
\]
Premultiplying this equation by $\rotationVector_{:,i}^\top$, where $i<k$, gives
\begin{equation}
  \gamma_{i} = - 2\rotationVector_{:, i}^\top\sampleCovMatrix\rotationVector_{:, k}.\label{eq:gammaSolution}
\end{equation}
If $i=1$, then from the transpose of \refeq{eq:principalEigenvector} we already know that $\rotationVector_{:, 1}^\top\sampleCovMatrix = \eigenvalue_1\rotationVector_{:, 1}^\top$ which we can substitute into \refeq{eq:gammaSolution} giving
\[
\gamma_{1} = - 2\rotationVector_{:, 1}^\top\rotationVector_{:, k}=0
\]
because $\rotationVector_{:, 1}^\top\rotationVector_{:,k}$ is constrained to be
zero. Given the fact that  $\gamma_1$ is zero we can consider the stationary point when $k=2$,
\[
\sampleCovMatrix\rotationVector_{:, 2} = \eigenvalue_{2}\rotationVector_{:, 2},
\]
which also has the form of an eigenvalue problem. Since the variance
associated with the discarded directions must be minimized, and
maximum variance direction has already been extracted, the
eigenvector associated with the second direction must be that
associated with the second highest eigenvalue. 

This result can also substitute this result into
\refeq{eq:gammaSolution} to recover that $\gamma_2=0$. We can then
proceed to extract the direction associated with the third feature,
$\rotationVector_{:,3}$. Accordingly we find that the third direction
is associated with the 3rd highest eigenvalue. This process can be
repeated until all $\latentDim$ directions are recovered with the
result that the directions associated with $\latentDim$ highest
eigenvalues should be used as features. We refer to these as the first
$\latentDim$ \emph{principal eigenvectors}\newglossaryentry{principal_eigenvectors}{name={principal eigenvectors}, description={The principal eigenvectors of a matrix are those associated with the highest eigenvalues of the matrix.}}. Premultiplying
\refeq{eq:gradObjectiveLaterPcs} by $\rotationVector_{k}^\top$ shows
that the eigenvalues give the associated variances
\[
\eigenvalue_{k}=\rotationVector_{:, k}^{\top}\sampleCovMatrix\rotationVector_{:, k}.
\]

The full matrix of latent variables is given by $\latentMatrix =
\sqrt{\frac{\latentDim}{\dataDim}}\cdataMatrix\rotationMatrix_{\latentDim}$ where
$\rotationMatrix_\latentDim$ is the first $\latentDim$ principal
eigenvectors of $\sampleCovMatrix$ in a $\dataDim\times\latentDim$
matrix. The resulting variances of the latent representation can then be given as a diagonal matrix in the form $\frac{\latentDim}{\dataDim(\numData-1)}\rotationMatrix^\top_\latentDim\cdataMatrix^\top \cdataMatrix\rotationMatrix_\latentDim=\frac{\latentDim}{\dataDim}\eigenvalueMatrix_\latentDim$ where $\eigenvalueMatrix_\latentDim$ is a diagonal matrix containing the first $\latentDim$ principal eigenvalues of $\sampleCovMatrix$. The mean absolute error between the latent squared distances and the data squared distances is then given by
\[
\errorFunction\left(\latentMatrix\right)=\frac{2\numData}{\dataDim(\numData-1)}\sum_{k=\latentDim+1}^{\dataDim}\eigenvalue_{k},
\]
where we have converted between the maximum likelihood estimate of the variance and the unbiased estimate of the variance with the factor $\frac{\numData}{\numData -1}$ which approaches unity as the number of data becomes large.
Since the sum of all eigenvalues is given by the total variance and the total variance is given by the trace of the sample covariance matrix: $\featureStd_{\text{total}}^2 = \frac{\numData}{\numData-1}\tr{\sampleCovMatrix} = \frac{1}{\numData-1}\tr{\cdataMatrix^\top\cdataMatrix}$, then we can write the error in terms of the retained eigenvalues,
\[
\errorFunction\left(\latentMatrix\right)=\frac{2\numData}{\dataDim(\numData-1)}\left(\tr{\sampleCovMatrix}-\sum_{k=1}^{\latentDim}\eigenvalue_{k}\right).
\]

\subsection{Principal Component Analysis}\index{principal component analysis (PCA)}

We saw in the last chapter that the process of performing an
eigendecomposition on the sample covariance matrix of the data is
known as principal component analysis\index{principal component
  analysis (PCA)}: in the last chapter we had a probabilistic
interpretation of the approach as a generative model. In this chapter
the same solution arose from an exercise in matching the mean absolute
error between squared distances in the latent space and the data
space. Principal component analysis is the backbone of this book. Our
aim is to relate approaches to dimensionality reduction to each other
through how they relate to principal component analysis. As we've seen
in this chapter and the last: two seemingly very different approaches
to dimensionality reduction actually both lead to principal component
analysis\index{principal component analysis (PCA)}. In the next
chapter we will start to consider nonlinear extensions of PCA, but
before we do that we'll revisit the rotated sixes example and show how
PCA can be applied in classical multidimensional
scaling\index{classical multidimensional scaling (CMDS)}.

\subsection{Rotation Reconstruction from Latent Space}

We now look at the rotated sixes data using the feature extraction
techniques we've developed. Basically here we are finding the
principal components of the data and computing the latent square
distance matrices for different latent dimensions. These squared
distance matrices are shown in \reffig{fig:demRotationDistRotate}. The
reconstructions are much better than those achieved using feature
selection. Even for two latent dimensions (which are in fact those
plotted in \reffig{fig:rotatedSixes} when introducing the example) we
have a much more powerful representation of the data than 1000
dimensions of feature selection (note the grayscale is covering a much
smaller range in these plots). The approach has already extracted
salient features like the grid pattern at 90, 180 and 270 degrees and
the cyclic nature of the data set. Note that we are unable to extract
more than $\latentDim=360$ dimensions because while the sample
covariance matrix $\sampleCovMatrix$ is $\dataDim \times \dataDim$ its
rank is upper bounded by the number of data, $\numData$, which is 360
for this example. This means that extracting 360 dimensions
\fixme{More detail on this}

 
% 
\begin{figure}
  % 
  \begin{octave}
    % end of Comment/MATLAB brackets.
    %} 
    close all
    e = demSixDistances(2, true);  
    if ~colorFigs, colormap gray; end
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesRotateError2.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistancesRotate2', '../../../dimred/tex/diagrams', 0.45*textWidth);
    close
    e = demSixDistances(10, true);
    if ~colorFigs, colormap gray; end
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesRotateError10.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistancesRotate10', '../../../dimred/tex/diagrams', 0.45*textWidth);
    close
    e = demSixDistances(100, true);
    if ~colorFigs, colormap gray; end
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesRotateError100.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistancesRotate100', '../../../dimred/tex/diagrams', 0.45*textWidth);
    close
    e = demSixDistances(360, true);
    if ~colorFigs, colormap gray; end
    printLatexText(['\global\long\def\errorVal{$' numsf2str(e, 3) '$}'], 'sixDistancesRotateError360.tex', '../../../dimred/tex/diagrams');
    printLatexPlot('demSixDistancesRotate360', '../../../dimred/tex/diagrams', 0.45*textWidth);
    %{
  \end{octave}
  \begin{center}
    \input{../../../dimred/tex/diagrams/sixDistancesRotateError2}
    \subfigure[Distances reconstructed with two dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistancesRotate2}}\hfill{}
    \input{../../../dimred/tex/diagrams/sixDistancesRotateError10}
    \subfigure[Distances reconstructed with 10 dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistancesRotate10}}
    \input{../../../dimred/tex/diagrams/sixDistancesRotateError100}
    \subfigure[Distances reconstructed with 100 dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistancesRotate100}}\hfill{}
    \input{../../../dimred/tex/diagrams/sixDistancesRotateError360}
    \subfigure[Distances reconstructed with 360 dimensions. MAE: \errorVal.]{\input{../../../dimred/tex/diagrams/demSixDistancesRotate360}}
  \end{center}

  \caption{Reconstructed distance matrix for the artificial data set
    generated from latent variables by rotating the features before
    extracting them.}\label{fig:demRotationDistRotate}
\end{figure}



\subsection{Principal Coordinates Analysis}

We motivated distance matching as an approach to dimensionality
reduction, and we introduced rotations of the data set to extract
features of the largest variance to construct our latent
representation. So far though, we have relied on direct access to the
data matrix, $\dataMatrix$, to construct our latent representations
through rotations, $\latentMatrix =
\sqrt{\frac{\latentDim}{\dataDim}}\dataMatrix\rotationMatrix_\latentDim$. However,
there are situations where such access is not possible. In
multidimensional scaling\index{multidimensional scaling (MDS)} the
assumption is that we only have access to the proximity information
(such as a squared distance matrix) and not the actual data. A
classical example is trying to determine the configuration of a given
set of cities given road distances between the cities. We will look
closely at such an example in \refsec{sec:roadDistances}, but first we
need to find an approach to computing the eigenvectors of the sample
covariance when the sample covariance is not available.

\subsubsection{An Alternative Formalism}\label{sec:eigenvalueEquivalence}

The matrix form of the eigenvalue problem for the first $\latentDim$
eigenvectors of the sample covariance is written in the form
\begin{equation}
  \sampleCovMatrix\rotationMatrix_{\latentDim}=\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim},\label{eq:standardEigenvalue}
\end{equation}
where $\rotationMatrix_{q}$ is a matrix in $\Re^{\dataDim\times\latentDim}$ for which $\rotationMatrix_{q}^\top\rotationMatrix_{q}=\eye$.
We can express the sample based covariance matrix in terms of the centered data matrices, $\cdataMatrix$, using the fact that $\sampleCovMatrix = \frac{1}{\dataDim}\cdataMatrix^\top\cdataMatrix$ as 
\[
\frac{1}{\dataDim}\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}=\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}.
\]
We now we premultiply both sides of this equation by the centered data
matrix, giving
\[
\frac{1}{\dataDim}\cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}.
\]
Postmultiplying both sides by the inverted square root of the
eigenvalue matrix, $\eigenvalueMatrix_{\latentDim}^{-\half}$, gives
\[
\frac{1}{\dataDim}\cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\eigenvalueMatrix_{\latentDim}.
\]
We now introduce the matrix $\eigenvectorMatrix_{\latentDim}$ which we
define to be equal to
$\eigenvectorMatrix_{\latentDim}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}$. This
allows us to write
\begin{equation}
\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvectorMatrix_{\latentDim}\dataDim\eigenvalueMatrix_{\latentDim}
\end{equation}
which again has the form of a matrix eigenvalue problem. If we can
show that the matrix $\eigenvectorMatrix_\latentDim$
\emph{diagonalizes}\newglossaryentry{diagonalize}{name={diagonalize}, description={In
    matrix algebra, diagonalization is the process of converting a
    square matrix into a diagonal matrix, typically through
    rotation.}} the centered inner product matrix,
$\cdataMatrix\cdataMatrix^\top$, then we know that
$\eigenvectorMatrix_\latentDim$ are the eigenvectors of
$\cdataMatrix\cdataMatrix^\top$. To show this diagonalization, we pre-
and postmultiply $\cdataMatrix\cdataMatrix^\top$ by
$\eigenvectorMatrix_\latentDim^\top$ and
$\eigenvectorMatrix_\latentDim$ and substitute our definition for $\eigenvectorMatrix_\latentDim$ giving


\[
\eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\cdataMatrix^\top\cdataMatrix\cdataMatrix^{\top}\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}.
\]
The central term can be rewritten using its eigenvalue decomposition. Because the full eigendecomposition is $\cdataMatrix^\top \cdataMatrix = \rotationMatrix \eigenvalueMatrix\rotationMatrix^\top$ and $\rotationMatrix^\top\rotationMatrix = \eye$ we can write $\cdataMatrix^\top\cdataMatrix\cdataMatrix^\top\cdataMatrix = \dataDim^2\rotationMatrix\eigenvectorMatrix^2\rotationMatrix^\top$ we can write
\[
\eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\dataDim^2\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}.
\]
which can be reexpressed as
%
%
% Full eigendecomposition of sample covariance \[
% \mathbf{\cdataMatrix^{\top}\cdataMatrix}=\rotationMatrix\eigenvalueMatrix\rotationMatrix^{\top}\]
%
% Implies that \[
% \left(\cdataMatrix^{\top}\cdataMatrix\right)^{2}=\rotationMatrix\eigenvalueMatrix\rotationMatrix^{\top}\rotationMatrix\eigenvalueMatrix\rotationMatrix^{\top}=\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}.\]

% $\eigenvectorMatrix_{\latentDim}$ Diagonalizes the Inner Product
% Matrix
%
% Need to prove that $\eigenvectorMatrix_{q}$ are eigenvectors of inner
% product matrix.
%
%
% \[
% \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}\]
% \[
% \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\left[\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\right]\eigenvalueMatrix_{\latentDim}^{-\half}\]
% \[
% \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}{\color{red}\left[\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}\right]}\eigenvalueMatrix_{\latentDim}^{-\half}\]
% \[
% \eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\eigenvalueMatrix_{\latentDim}^{-\half}\eigenvalueMatrix_{q}^{2}\eigenvalueMatrix_{\latentDim}^{-\half}\]


\[
\eigenvectorMatrix_{\latentDim}^{\top}\cdataMatrix\cdataMatrix^{\top}\eigenvectorMatrix_{\latentDim}=\dataDim^2\eigenvalueMatrix_{q}^2
\]

because the product of the first $\latentDim$ eigenvectors with the rest is given by
\[
\rotationMatrix^{\top}\rotationMatrix_{q}=
\left[\begin{array}{c}
    \eye_{\latentDim}\\
    \zerosVector
  \end{array}\right]\in\Re^{\dataDim\times\latentDim}
\]
where we have used $\eye_{\latentDim}$ to denote a
$\latentDim\times\latentDim$ identity matrix. When multiplied by the eigenvalues, $\eigenvalueMatrix$, this matrix extracts the first $\latentDim$ eigenvalues,
\[
\eigenvalueMatrix\rotationMatrix^{\top}\rotationMatrix_{\latentDim}=\left[\begin{array}{c}
    \eigenvalueMatrix_{\latentDim}\\
    \zerosVector\end{array}\right].\]
This is expression is then multiplied by itself transposed giving 
\[
\rotationMatrix_{\latentDim}^{\top}\rotationMatrix\eigenvalueMatrix^{2}\rotationMatrix^{\top}\rotationMatrix_{\latentDim}=\eigenvalueMatrix_{q}^{2}.
\]
Because  $\eigenvectorMatrix_\latentDim$ diagonalizes $\cdataMatrix\cdataMatrix^\top$ giving a $\latentDim \times \latentDim$ diagonal matrix $\dataDim^2\eigenvalueMatrix_q^2$ then we know that the first $\latentDim$ eigenvalues of $\cdataMatrix\cdataMatrix^\top$ are $\dataDim\eigenvalueMatrix_\latentDim$ and the corresponding principal eigenvectors are given by 
\[
\eigenvectorMatrix_{\latentDim}=\cdataMatrix\rotationMatrix_{\latentDim}\eigenvalueMatrix_{\latentDim}^{-\half}.
\]
By taking $\latentDim=\dataDim$ we can see that the two eigenvalue problems for $\cdataMatrix^\top\cdataMatrix$ and $\cdataMatrix\cdataMatrix^\top$ are fully equivalent.\footnote{In this situation we have $\eigenvectorMatrix = \cdataMatrix\rotationMatrix\eigenvalueMatrix^{-\frac{1}{2}}$.} One solves for the rotation that needs to be applied to the data space to find the latent space, $\rotationMatrix_\latentDim$ the other gives a solution related to the location of these data points once they are in latent space. Using the fact that  $\latentMatrix =
\sqrt{\frac{\latentDim}{\dataDim}}\cdataMatrix\rotationMatrix_\latentDim$ we have 
\[
\eigenvectorMatrix_\latentDim = \sqrt{\frac{\dataDim}{\latentDim}}\latentMatrix \eigenvalueMatrix_\latentDim^{-\frac{1}{2}}
\]
showing that $\eigenvectorMatrix_\latentDim$ is equal to
$\latentMatrix$ with the columns scaled (since
$\eigenvalueMatrix_\latentDim^{-\half}$ is diagonal it only serves to
scale the columns of $\latentMatrix$). In general when performing
these eigenvalue problems, if $\dataDim<\numData$ it is more
computationally efficient to solve for the rotation,
$\rotationMatrix_{q}$. But when $\dataDim>\numData$ we solve for the
latent variables. This is known as principal coordinate analysis: it can be
seen as a dual form of principal component analysis. Note that the
eigenvalues we obtain in each case are simply scaled versions of one
another. This explains whey we could not extract more than 360
dimensions from the rotated six data we considered earlier in the
chapter: the maximum number of non zero eigenvalues is given by the
smaller of $\numData$ or $\dataDim$.


\section{The Standard Transformation}

In multidimensional scaling we may not know
$\dataMatrix$ and so cannot compute $\cdataMatrix^{\top}\cdataMatrix$,
as we are given only a interpoint squared distance matrix. Can we
compute $\cdataMatrix\cdataMatrix^{\top}$ instead? It turns out we
can, and this is known as the \emph{standard transformation}\newglossaryentry{standard_transformation}{name={standard transformation}, description={in classical multidimensional scaling is a way of transforming a distance matrix into a similarity matrix. If the similarity is a positive definite matrix it is equivalent to the distance in the ``feature space'' that the similarity matrix implies. Alternatively it can be thought of as the square root of the expected squared distance under a Gaussian random field governed by the similarity as a covariance.}}  between a
similarity and a distance matrix. Given a similarity matrix, $\kernelMatrix$, the standard transformation relates the similarity matrix to a squared distance matrix in the following way,
\[
\distanceScalar_{i,j}=\kernelScalar_{i,i}+\kernelScalar_{j,j}-2\kernelScalar_{i,j}.
\]
This is the squared distance between the two points according to the
similarity matrix. This transformation is known as the standard
  transformation between a similarity and a distance \cite[pg
402]{Mardia:multivariate79}. As we will see later in the book it also
has an interpretation as squared distance in a feature space or an
expected distance between two points sampled from a correlated
Gaussian.

If the similarity matrix is taken to be of the form $\kernelMatrix=\dataMatrix\dataMatrix^{\top}$
then $\kernelScalar_{i,j}=\dataVector_{i,:}^{\top}\dataVector_{j,:}$
and 
\[
\distanceScalar_{i,j}=\dataVector_{i,:}^{\top}\dataVector_{i,:}+\dataVector_{j,:}^{\top}\dataVector_{j,:}-2\dataVector_{i,:}^{\top}\dataVector_{j,:}=\left\Vert\dataVector_{i,:}-\dataVector_{j,:}\right\Vert_{2}^{2}.
\]
and we see that we recover standard squared Euclidean distance. To perform classical multidimensional scaling we take the squared distance matrix, 
\[
\distanceMatrix = \onesVector\diag{\dataMatrix\dataMatrix^\top} -2\dataMatrix\dataMatrix^\top + \diag{\dataMatrix\dataMatrix^\top}\onesVector^\top
\]
and center it giving 
\[
\centeringMatrix \distanceMatrix \centeringMatrix = -2\centeringMatrix\dataMatrix\dataMatrix\centeringMatrix = -2\cdataMatrix\cdataMatrix^\top.
\]
Multiplying by $-\half$ then gives 
\[
-\half \centeringMatrix \distanceMatrix \centeringMatrix = \cdataMatrix\cdataMatrix^\top
\]
which is the inner product matrix formed from the centered data matrix. Since we know the relationship between the eigenvectors of this matrix and those of $\cdataMatrix^\top\cdataMatrix$  we can now perform principal component analysis multidimensional scaling by working directly with the squared Euclidean distance matrix, $\distanceMatrix$. The procedure is:
\begin{enumerate}
  \item Compute the centered matrix $\bMatrix = -\half\centeringMatrix\distanceMatrix\centeringMatrix$.
  \item Compute the first $\latentDim$ principal eigenvalues, $\eigenvalueMatrix_\latentDim$, of $\bMatrix$ and associated eigenvectors, $\eigenvectorMatrix_\latentDim$. 
  \item Set the latent representation to be $
    \latentMatrix = \sqrt{\frac{\latentDim}{\dataDim}}\eigenvectorMatrix_\latentDim\eigenvalueMatrix_\latentDim^{\frac{1}{2}} 
$
  \item This is the configuration of points $\latentMatrix$ that minimizes \refeq{eq:distObjectiveExpanded} under the optimal linear transformation from the original space.
\end{enumerate}

For any other squared distance matrix we can follow the same procedure to recover a configuration of points that minimizes the same function. As long as the eigenvalues of the resulting $\bMatrix$ are all non-negative, the distances can be seen to have been computed in a Euclidean space.
 
\subsection{Example: Road Distances with Classical MDS}
\label{sec:roadDistances}
To illustrate the operation of classical multidimensional scaling we
turn to a standard example given in many statistical texts \citet[see
e.g.][]{Mardia:multivariate79}. We recreate this example by
considering road distances between $53$ cities in Europe. The data
consists of the a distance matrix containing the distances between
each of the cities. Our approach to the data is to first convert it to
a similarity matrix using the standard transformation and
perform an eigendecomposition on the resulting similarity matrix.  

\fixme{Detailed description of the example.}
\begin{figure}
  \begin{octave}
    % end of Comment/MATLAB brackets.
    %} 
    close all

    % Plot axes longitudes and latitudes
    minLong = -15;
    maxLong = 50;
    minLat = 30;
    maxLat = 65;

    % Load in data.
    nums = csvread('../../../dimred/matlab/europeDistance.csv');
    names = textread('../../../dimred/matlab/europeCities.csv', '%s');
    data = nums(:, 3:end);
    data = tril(data);
    data = data + data';
    [i, j] = find(isnan(data));
    toRemove = [];
    for k = i';
      if any(k==j)
        toRemove = [toRemove k];
      end
    end
    data(toRemove, :) = [];
    data(:, toRemove) = [];
    names(toRemove, :) = [];
    for i = 1:length(names)
      names{i} = strrep(names{i}, '_', ' ');
    end


    %[data, names] = xlsLoadData('europeDistance.xls', 'europeDistance');
    longLat = nums(:, 1:2); %[longLat, namesLong] = xlsLoadData('europeDistance.xls', 'europeLongLat');
    longLat(toRemove, :) = [];

    longitude = longLat(:, 2);
    latitude = longLat(:, 1);

    index = find (longitude >= minLong & longitude <= maxLong ...
                  & latitude >= minLat & latitude <= maxLat);
    longitude = longitude(index);
    latitude = latitude(index);
    data = data(index, index);

    names = names(index, :);

    % Draw map using m_map toolbox.
    m_proj('mercator', 'lon', [minLong maxLong], 'lat', [minLat maxLat]);
    m_coast;
    axis off
    axis equal
    set(gca, 'xlim', [-0.6, 0.6], 'ylim', [0.55, 1.55])
    %m_grid;
    hold on
    [xProj, yProj] = m_ll2xy(longitude, latitude);

    proj = [xProj yProj];

    % Do scaling.
    numData = size(data, 1);

    % Get squared distances
    D = data.*data;

    % Convert to 'similarities'
    B = -0.5*centeringMatrix(size(D, 1))*D*centeringMatrix(size(D, 1));

    % Eigenvalue problem on similarities.
    [U, V] = eig(B);
    [void, order] = sort(diag(V));
    U = U(:, order);
    V = V(order, order);
    
    v = diag(V);
    N = length(v);

    % Retain the largest two eigenvectors.
    [void, order] = sort(v, 'descend');
    retained = order(1:2);

    X = U(:, retained)*diag(sqrt(v(retained)));
    meanProj = mean(proj);

    %for i = 1:2
    %  proj(:, i) = proj(:, i) - meanProj(i);
    %  X(:, i) = X(:, i) - mean(X(:, i));
    %end
    %X = X/sqrt(var(X(:)))*sqrt(var(proj(:)));

    % Do Procrustes rotation to match to ground truth
    Z = proj'*X;
    [U, D, V] = svd(Z);
    proc = U*V';
    RX = X*proc';
    factor = sqrt(var(RX(:)));
    RX = RX/factor;
    factor = sqrt(var(proj(:)));
    RX = RX*factor;

    for i = 1:2
      RX(:, i) = RX(:, i) + meanProj(i);
      proj(:, i) = proj(:, i) + meanProj(i);
    end

    % Draw the map to display results.
    figure(1)
    clf
    m_proj('mercator', 'lon', [minLong maxLong], 'lat', [minLat maxLat]);
    m_coast;
    set(gca, 'xlim', [-0.57, 0.43], 'ylim', [0.545, 1.51])
    set(gca, 'xtick', [], 'ytick', [])
    %m_grid;
    axis equal
    set(gca, 'position', [0 0 1 1]);
    hold on
    RXlongLat = zeros(size(RX));
    [RXlongLat(:, 1) RXlongLat(:, 2)] = m_xy2ll(RX(:, 1), RX(:, 2));
    m_plot(RXlongLat(:, 1), RXlongLat(:, 2), 'rx')
    hold on;
    m_plot(longitude, latitude, 'ro')
    citiesToDisplay = [1:53] %[1 3 5 6 7 8 10 11 12 13 15 16 20 21 23 24 27 ...
    %28 29 30 31 34 35 38 39 41 42 43 45 46];
    for i = citiesToDisplay
      m_text(longitude(i)+0.5, latitude(i), names(i, 1), 'fontsize', 10)
    end
    for i = 1:N
      a = m_line([RXlongLat(i, 1) longitude(i)], [RXlongLat(i, 2) ...
                  latitude(i)]);
      set(a, 'color', [1 0 0]);
    end
    if ~colorFigs, colormap gray; end
    printLatexPlot('demCmdsRoadData1', '../../../dimred/tex/diagrams/', 1.2*textWidth)


    figure(2)
    clf
    bar(v(order));
    printLatexPlot('demCmdsRoadData2', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    figure(3)
    clf
    imagesc(data)
    axis equal
    set(gca, 'xlim', [0 48]);
    set(gca, 'ylim', [0 48]);
    set(gca, 'xtick', [0 12 24 36 48])
    set(gca, 'ytick', [0 12 24 36 48])
    set(gca, 'Xaxislocation', 'top')
    if ~colorFigs, colormap gray; end
    pause(0.01)
    colorbar
    printLatexPlot('demCmdsRoadData3', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    figure(4)
    clf
    distReconstruct = sqrt(dist2(X, X));
    imagesc(distReconstruct)
    axis equal
    set(gca, 'xlim', [0 48]);
    set(gca, 'ylim', [0 48]);
    set(gca, 'xtick', [0 12 24 36 48])
    set(gca, 'ytick', [0 12 24 36 48])
    set(gca, 'Xaxislocation', 'top')
    if ~colorFigs, colormap gray; end
    pause(0.01)
    colorbar
    printLatexPlot('demCmdsRoadData4', '../../../dimred/tex/diagrams/', 0.45*textWidth)

    figure(5)
    clf
    imagesc(B)
    axis equal
    set(gca, 'xlim', [0 48]);
    set(gca, 'ylim', [0 48]);
    set(gca, 'xtick', [0 12 24 36 48])
    set(gca, 'ytick', [0 12 24 36 48])
    set(gca, 'Xaxislocation', 'top')
    if ~colorFigs, colormap gray; end
    pause(0.01)
    colorbar
    printLatexPlot('demCmdsRoadData5', '../../../dimred/tex/diagrams/', 0.45*textWidth)
    %{
  \end{octave}
  \subfigure[Road distances between European cities.]{\input{../../../dimred/tex/diagrams/demCmdsRoadData3}}\hfill
    \subfigure[Centered similarity matrix derived from the distance matrix.]{\input{../../../dimred/tex/diagrams/demCmdsRoadData5}}
  %\subfigure[Road distances between European
%  cities.]{\includegraphics[width=0.45\textwidth,height=5cm]{../../../dimred/tex/diagrams/demCmdsRoadData3NoColour}}\hfill{}
%  \subfigure[Similarity matrix derived from the distance matrix.]{\input{../../../dimred/tex/diagrams/demCmdsRoadData5NoColour}}

  \caption{Road distances can be converted to a similarity matrix using
    the ``standard transformation''. Our interpretation is that the
    similarity matrix is a covariance matrix from which the locations of
    the cities were sampled.}

\end{figure}



% 
\begin{figure}
  \begin{centering}
    \input{../../../dimred/tex/diagrams/demCmdsRoadData1}
  \end{centering}

  \caption{Reconstructed locations projected
    onto true map using Procrustes rotations.}

\end{figure}
\fixme{Need to describe procrustes rotations}

In \reffig{fig:roadEigenvalues} we plot the eigenvalues of the
similarity matrix. We note that in this case some of the eigenvalues
are negative. This indicates that the distances in \reffig{fig:}
cannot be embedded in an Euclidean space. There are two effects at
play here. If we were to use shortest distances between the cities the
curvature of the earth dictates that we wouldn't be able to flatten
all distances onto a two dimensional plane. Secondly, the use of road
distances prevents ...
% 
\begin{figure}
  \begin{center}
    \input{../../../dimred/tex/diagrams/demCmdsRoadData2}
  \end{center}

  \caption{Eigenvalues of the similarity matrix are negative in this
    case.}\label{fig:roadEigenvalues}

\end{figure}


% 
\begin{figure}
  \subfigure[Original distance
  matrix.]{\input{../../../dimred/tex/diagrams/demCmdsRoadData3}}\hfill
  \subfigure[Reconstructed distance
  matrix.]{\input{../../../dimred/tex/diagrams/demCmdsRoadData4}}

  \caption{Comparison between the two distance matrices, the original
    inter city distance matrix and the reconstructed distance matrix
    provided by the latent configuration of the data.}

\end{figure}

\section{Summary}

In summary multidimensional scaling\index{multidimensional scaling
  (MDS)} is a statistical approach to creating a low dimensional
representation of a data set through matching distances in the low
dimensional space to distances in a high dimensional space. If our
objective function is to minimize the absolute error between the
squared distances in the two spaces, we can produce a low dimensional
representation through an eigenvalue problem. This is known as
classical multidimensional scaling\index{classical MDS}. If the
distances as computed in the data space are simply the Euclidean
distance between each data point, $\dataVector_{i,:}$, then classical
MDS is equivalent to principle component analysis\index{principal
  component analysis (PCA)}. This algorithm is generally referred to
as principal coordinate analysis\index{principal coordinate analysis
  (PCO)}.

We also considered the classical from the statistical scaling
literature: that of embedding a set of cities in a two dimensional
space using the distances by road between the cities. This highlighted
an issue with \emph{ad hoc} specification of inter point distances:
there is no guarantee that they can be embedded in a Euclidean
space. Sets of distances that cannot be embedded in Euclidean spaces
are associated with negative eigenvalues in their associated
similarity matrices \fixme{Need to check what Mardia says on this}.

We have given very little attention to how we derive the distance
matrix, in the examples we gave we either considered Euclidean
distances or road distances. The main focus of the developments in
spectral approaches to dimensionality reduction have been in clever
ways of specifying the distance/similarity matrix. We shall cover
these in Chapter \ref{chap:spectral}. We have also paid scant regard
to the choice of objective function for distance matching. We will
return to the objective function in Chapter \ref{chap:iterative.tex}.

\fixme{relate to pca in previous chapter}

\section{Notes}

Multidimensional scaling: preserve a distance matrix.


\subsubsection{Classical MDS}

A particular objective function

For Classical MDS distance matching is equivalent to maximum variance

Spectral decomposition of the similarity matrix

For Euclidean distances in $\dataMatrix$ space classical MDS is equivalent
to PCA. 

known as principal coordinate analysis (PCO)

Haven't discussed choice of distance matrix.

%}

%%% Local Variables: 
%%% mode: latex
%%% TeX-master: "book"
%%% End: 
