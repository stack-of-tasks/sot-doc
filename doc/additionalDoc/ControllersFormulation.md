# Controllers formulation {#controllers_information}
\section NecessaryConditions Necessary constraints
\subsection SubSecDynamicModeling Dynamic modeling of a free-floating multi-body system
The dynamic model of a free-floating multi-body system can be written this way:

\f[ M(q) \ddot{q} + N(q,\dot{q}) \dot{q}+G(q)=Su \f]

with \f$q\f$ the robot state variable, 
\f$ M(q) \f$ the inertia matrix of the multi-body system, 
\f$ N (q,\dot{q}) \f$ the matrix of the non-linear dynamical effect (Centrifugal and Coriolis forces) of the system motion, 
\f$ G(q) \f$ the gravity, \f$u\f$ the control vector, and \f$ S \f$ the matrix mapping the control vector on the system (also called the selection matrix).

The current software library we are using to computate such quantities and theirs derivatives is Pinocchio 1. 
Pinocchio include dynamical quantities such as angular momentum and its derivatives.
\subsection SubSecContactModels Contact models

When considering a rigid contact model several constraints needs to be considered:
 * No penetration in the ground
 * No sliding
 
Both constraints generate inequalities at the contact points with respect to the state vector:
\f[ \Phi_{n,c} (q) \geq 0 \f]
\f[ \Phi_{t,c} (q) \geq 0 \f]

with \f$ \Phi_{n,c}(q) \f$ the normal force at contact point \f$ c \f$ expressed in the local reference frame of the contact point,
and \f$ \Phi_{t,c}(q) \f$ the tangential force at contact point \f$ c\f$ also expressed in the local reference frame of the contact point.

To avoid penetration velocity and acceleration of the points must be constrained too. Using differentiation we obtain:
\f[ C_n (q) \dot{q}  = 0 \f]
\f[ C_n(q) \ddot{q}+s_n(q,\dot{q})=0 \f]

The same derivation can be realized to avoid sliding:
\f[ C_t(q)\dot{q}=0 \f]
\f[ C_t(q)\ddot{q}+s_n(q,\dot{q})=0 \f]

Self-collisiion is usually avoiding by formulating an inequality constraint on the distance between two robot bodies. To do that the closest two points between two shapes are tracked. The distance between two bodies is obtained through a flavor of the FCL library.
\section SecFunctions Functions used to generate a robot behavior

\subsection SubFuncFormulatingTasks Formulating tasks 
\subsubsection subsubdef Definition 
Task \f$ (e) \f$ are using features \f$(s)\f$. Features might be end-effector posision (hands, feet), the robot center-of-mass, or the center-of-gravity of an object projected in the image. We assume that a function relates the current state of the robot typically the configuration, speed, acceleration to a feature. For instance, we may want to consider the Center-Of-Mass of a robot specified by a model \f$ robot\_model \f$
and a configuration vector \f$ q\f$ \f[ f_{CoM}:(robot\_model,q) \rightarrow c\f]

We further assume that this function is at least differentiable once. A task is then defined by the regulation between the feature depending on the current state 
\f$ s(q) \f$ of the robot and a desired feature \f$s^*\f$:
\f[ e=s(q)−s^*\f]

\subsubsection subsubImposingTaskDyn Imposing the task dynamic
You can impose for instance that the task dynamic is an exponential decay:
\f[ \dot{e}=−λe \f]
But we also have:
\f[ \dot{e}=\dot{s}(q)−\dot{s}^∗\f]

If the desired feature does not move we have 

\f[ \dot{s}^∗=0 \f]
in addition we can remark that 
\f[\dot{s}(q)=\frac{\delta s}{\delta q}\dot{q}=J(q)\dot{q} \f]
Thus
\f[ \dot{e}=J(q)\dot{q}−\dot{s}^∗ \f]

At a given time 
\f$ t=k \Delta T \f$
a measurement of the feature 
\f$ \hat{s}(t) \f$ can give us:
\f[ \hat{e}(t)=\hat{s}(t)−s^∗(t) \f]
By posing 
\f[ \hat{e}(t)=e(t) \f]
we have:
\f[ \dot{e}(t)=−\lambda e(t)=−\lambda \hat{e}(t)= −\lambda ( \hat{s}(t)−s^*(t)) \f]

We will continue by dropping \f$ (t) \f$ for sake of clarity:
\f[ − \lambda ( \hat{s}− s^∗) = J(q)\dot{q} \f]

Therefore if \f$ J(q) \f$ is invertible we can find 
\f$ \dot{q} \f$ using the following relationship:
\f[ \dot{q}=− \lambda J(q)^{−1}(\hat{s}−s^∗) \f]

In general \f$ J(q) \f$ is not square and then we have to use the Moore-Penrose pseudo inverse:
\f[ \dot{q}= −\lambda J(q)^+(\hat{s}−s^∗) \f]

But it can be also understood as the solution of the following optimization problem:
\f[ \begin{matrix}
argmin_{ \dot{q}} || \dot{q} || & \\
s.t. & − \lambda (\hat{s} - s^∗) =J(q)\dot{q} \\
\end{matrix}
\f]
    
 * The library implementing the task formulation in velocity domain is [sot-core](http://github.com/stack-of-tasks/sot-core) (Hierarchy).
 * The library implementing the task formulation in acceleration is [sot-dyninv](http://github.com/stack-of-tasks/sot-dyninv) (Hierarchy with inequalities).
 * The library implementing the task formulation in torque is [sot-torque-control](http://github.com/stack-of-tasks/sot-torque-control) (Weighted sum).
 
\subsection SubsectionFormulatingInstantaneousControl Formulating instantaneous control as optimization problem

The task function is allowing a very versatile formulation including:
 * Hierarchy of tasks: Each task at a level \f$ i\f$ cannot interfer with the control at level \f$i-1\f$.
   This concept has been introduced by Nakamura \cite Nakamura:ijrr:87 extended by Siciliano in \cite Siciliano:icarrue:91 .
 * Weighted problems:  Each task are at the same level i.e. they are all included in the same cost function, and they are weighted against each other.
   

