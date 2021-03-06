# Dynamic-graph 101 {#tutorial_dyn_graph_101}

\section  tutorial_first_introduction Introduction

We assume that the stack of tasks has been installed using the installation instruction provided \ref c_installation_detailed.

\section tutorial_dyngrp_101 First steps with dynamic graph

This first tutorial focuses on the dynamic-graph mecanism, which is the backbone of the stack of tasks framework.

As a toy example, let’s realize this operation res=(a+b)*(c+d) using dynamic-graph elements. The corresponding code would be this:

    from dynamic_graph import plug
    from dynamic_graph.sot.core.operator import Add_of_double
    from dynamic_graph.sot.core.operator import Multiply_of_double
    a=1
    b=2
    c=3
    d=4

    # Create  the entities
    ad1  = Add_of_double('ad1')
    ad2  = Add_of_double('ad2')
    mult = Multiply_of_double('mult')

    # Fix the values of the input for the first operation
    ad1.sin1.value = a
    ad1.sin2.value = b

    # Fix the values of the input for the second operation
    ad2.sin1.value = c
    ad2.sin2.value = d

    # plug all the signals
    plug(ad1.sout, mult.sin0)
    plug(ad2.sout, mult.sin1)
    
In order to obtain the result of the multiplication, let’s do:

    mult.sout.value
    #> 0

This is normal. At the creation of an entity, each of the signals has a default value associated to the time 0. In order to have the new value, it is necessary to increment the time, so as to trigger the recomputation.

    mult.sout.time
    #> 0
    mult.sout.recompute(1)
    mult.sout.value
    #> 21

Let’s now change one of the inputs of the entity ad1.

    ad1.sin1.value = 0

The result becomes:

    mult.sout.recompute(2)
    mult.sout.value
    #> 14
    
Note that the intermediary signal ad1.sout, has been updated, while ad2.sout hasn’t:

    ad1.sout.time
    #> 2
    ad2.sout.time
    #> 1
    
\section tutorials_dyngrp_operations Dynamic-graph operations

Here is a list of some basic operations that can be run on the entities/signals. 

\subsection tutorial_first_entity Entity manipulation

entity.help(): Displays the help for an entity, namely the commands with their description

    ad1.help()
    Linear combination of inputs
    - input  double
    -        double
    - output double
    sout = coeff1 * sin0 + coeff2 * sin1
    Coefficients are set by commands, default value is 1.

    List of commands:
    -----------------
    setCoeff1:      Set the coeff1.
    setCoeff2:      Set the coeff2.
    
entity.help('command'): Displays the complete help for the command (number of argument…)

    ad1.help('setCoeff1')
    setCoeff1:

    Set the coeff1.

    Input:
    - a double.
    Void return.
    
entity.commands() Returns the list of commands of an entity, without description

    ad1.commands()
    ('setCoeff1', 'setCoeff2')

entity.displaySignals(): Lists the signals of an entity, indicates whether they are plugged or not.

AUTOPLUGGED: the signal is plugged to a signal of this entity, eventually internal</li>
PLUGGED: the signal is plugged to another one, from an other entity</li>
UNPLUGGED: the signal is not plugged. Requiring its recomputation will cause some issues</li>

    ad1.displaySignals()
    --- <ad1> signal list:
      |-- <Sig:Add_of_double(ad1)::input(double)::sin0> (Type Cst) AUTOPLUGGED
      |-- <Sig:Add_of_double(ad1)::input(double)::sin1> (Type Cst) AUTOPLUGGED
      `-- <Sig:Add_of_double(ad1)::output(double)::sout> (Type Fun)
      
\subsection tutorial_first_signal_manipulation Signal manipulation

entity.signal.value: Returns the current value of a signal

    ad1.sin0.value
    0.0
    
entity.signal.time: Returns the current time of a signal

    ad1.sin1.time
    2
    
entity.signal.recompute(T): Force the recomputation of the signal for time T (only effective it the given time is greater than the current time).


\section tutorial_going_further Going further

More details on the internal graph structure used in the stack of tasks framework are provided in the dynamic-graph-tutorial.

