#import "sty.typ": *

#show: mycv(
  author: "Nicholas Todoroff", address: "Aurora, CO 80019",
  email: "nd.todoroff@gmail.com", phone: "(616) 808-7495",
  highlight: true,
  size: 11pt, margin: 0.25in,
)

#let work = experience-type("work",
  heading: "company", subheading: "title",
  info1: ("date", x => { x.start; half-em(); x.end }),
  info2: "location"
)
#let project = experience-type("project",
  heading: "title",
  subheading: ("repo", x => text(font: "Fira Code", size: 9pt, x)),
  info1: ("tech", x => [Tech: #x])
)

= Selected Projects
#make-experience("project", column-major: false)

= Skills
#make-skills()

= Education
#make-education()
#sub-heading-info[#set par(justify: false)
  #text(weight: "regular")[Relevant coursework:]
  Multivariable Calculus, Honors Linear Algebra, Classical Mechanics,
  Computational Physics, Intro Computational Modeling, Methods of Parallel
  Computing,
]

= Work Experience
#make-experience("work", column-major: false)

= Personal Interests
#align(center)[
  Math #space Physics #space Video games #space Baking bread
  #space Japanese language
]

#footer[
  This document was created using Typst, a modern open-source typesetting
  language.
]

/******************************************************************************/

//#work(
//  wide: true,
//  title: [Order Entry],
//  company: [Stoneworks],
//  location: [(Remote)],
//  date: (start: "Jun 2023", end: "Present"),
//)[
////  - Completely remote work for the Midwest, East, and South United States.
//  - Entered orders at final stage of preparation into Infor Visual.
//  - Ensured orders are accurate and up-to-date by e.g. updating obsolete part
//    numbers.
//]

#work(
  title: [Order Entry],
  company: [Stoneworks],
  location: [Denver, CO],
//  date: (start: "Aug 2022", end: "Apr 2023"),
  date: (start: "Aug 2022", end: "Present"),
)[
  - Entered orders made by project managers for extra material; also orders
    for warranty work received from customers.
//    Entered using Infor Visual and in-house order management software.

//  - Entered purchase orders received from customers approving said orders via
//    email or online portals.

  - Communicated with team in person and via email to ensure all orders were
    entered correctly.

  - Partook in quarterly physical inventory, and also tasks supporting the order
    entry and sales departments.
]

#work(
  company: [Mathnasium of Kentwood],
  title: [Instructor],
  location: [Kentwood, MI],
  date: (start: "Dec 2019", end: "Apr 2021")
)[
  - Tutored elementary to high school students in math, moving among
    #{sym.tilde}20 students together with other instructors.

  - Managed students' behavior when necessary.

  - Trusted to open/close shop and manage day-to-day when director was not
    present.
]

#work(
  company: [Facility for Rare-Isotope Beams],
  title: [Undergraduate Research Assistant],
  location: [East Lansing, MI],
  date: (start: "Jul 2018", end: "Jul 2019")
)[
  - Worked with a theory group interested in simulating nuclear quantum
    many-body systems.

  - Used machine-learning techniques, programmed simulations, learned advanced
    physics.

//  - Awarded the Lawrence W. Hantel Endowed Fellowship Fund, which "provide[s]
//    talented undergraduate students the opportunity to participate in long-term
//    research programs."
]

#work(
  company: [Michigan State University],
  title: [Undergraduate Learning Assistant],
  location: [East Lansing, MI],
  date: (start: "Jan 2018", end: "May 2018")
)[
  - Led 3-hour lab of 20 physics majors once per week, explaining experiment
    setup, helping students to troubleshoot.

  - Graded lab reports and met with students outside of class for additional
    help when asked.
]

//#work(
//  company: [Michigan State University],
//  title: [Undergraduate Learning Assistant],
//  location: [East Lansing, MI],
//  date: (start: "Sep 2016", end: "Dec 2017")
//)[
//  - Tutored students in physics in a help room for 10 hours/week.
//  - Assisted in proctoring exams.
//]

//#project(
//  title: "Automated Order Entry",
//  tech: "VBA, Python",
//)[
//  - For Stoneworks. Scrapes in-house order management website, external purchase
//    order portal, and purchase order PDFs to compile information necessary for
//    entering orders.
//]
//
#project(
  title: [File Hierarchy Serializer #text(weight: "regular")[(in progress)]],
  tech: "C, TOML",
  repo: "github.com/ndtodoroff/layout",
)[
  - Takes in TOML specifying file contents and hierarchy and produces this, or
    creates such TOML from a given directory tree. Intended as an orthogonal way
    of configuring s6/s6-rc, a process supervision and control suite for Linux.

  - Allows for files to be specified in plain text or encoded in Base64.
    Implements Base64 encoding/decoding.
]

//#project(
//  title: [This Resume],
//  tech: "Typst",
//  repo: "github.com/ndtodoroff/resume",
//)[
//  - Typst is a new open-source typesetting language written in Rust aiming to
//    compete with LaTeX.
//
//  - Resume is written declaratively: data is tagged e.g. `#skill`, `#work`,
//    `#project` and then `sty.typ` renders that information.
//
////  - The `experience-type` function returns new tags rendered as "experience" but
////    with appropriately named fields; e.g. `#project(title: "This Resume")` and
////    `#work(company: "Stoneworks")` render identically.
////    Also allows specifying a lambda to transform a field
//]

#project(
  title: "Ising Model RBM",
  tech: "Julia",
  repo: "github.com/loppy1243/IsingBoltzmann"
)[
  - Implementation of a Restricted Boltzmann Machine, an unsupervised algorithm
    based on statistical physics for learning probability distributions.

  - Defines an API for Metropolis-Hastings samplers, and implements an Ising
    model accordingly to test the RBM.

//  - Defines an array type which acts like a concrete array repeated infinitely
//    along all dimensions.

//  - Defines a utility macro which allows defining functions whose first argument
//    has a default value.

//  - Allows for drop-in use of the CuArrays package, an array type backed by
//    CUDA.
]

//#project(
//  title: "Bare Metal x86",
//  tech: "NASM, Makefile",
//  repo: "github.com/loppy1243/bootloader"
//)[
//  - Assembled image can be written to the first sector of a hard drive and
//    booted on MBR compatible computers.
//
//  - Two stages: (1) BIOS loads MBR code which loads (2) code elsewhere on the
//    disk which prints "Hello World!" to the screen using the BIOS.
//]

//#project(
//  title: "Music Language Compiler",
//  tech: "Racket, x86-64 ASM",
//  repo: "github.com/loppy1243/music"
//)[
//  - Compiles language of music note notations, conditionals, loops, functions
//    into a beeping program. Exposes a command line interface which invokes the
//    compiler, chooses backends and I/O files.
//
//  - Structure of Lexer #sym.arrow Parser #sym.arrow IR #sym.arrow
//    Backend. Backends include: print IR, interpret IR, compile IR to x86
//    ASM. Defines API for backends to implement.
//]

#project(
  title: "MagnusIMSRG",
  tech: "Julia",
  repo: "github.com/loppy1243/MagnusIMSRG"
)[
  - Implements the In-Medium Similarity Renormalization Group method for
    computing ground states of quantum many-body systems. Realized as a
    particular ODE. 

  - Computes commutators of $n$-body operators by converting tensor operations
    to matrix multiplications. Magnus expansion used to preserve unitarity
    during integration.
]
#project(
  title: "Position Refinement Neural Net",
  tech: "Julia, Flux",
  repo: "github.com/loppy1243/BetaML",
)[
  - Uses `Flux.jl` to define and train a 2-layer NN for refining the position of
    electrons on a grid of detectors. Layer 1: convolutional NN which predicts
    most likely cell. Layer 2: Dense NN with one hidden layer centered on most
    likely cell.

  - Demonstrated to perform significantly better than random chance; e.g. 90% of
    predictions were 1.9mm from true position vs. 3.0mm for random chance.
]

#skill[Self-directed, self-motivated, fast learner]
#skill[#{sym.tilde}10 years using Linux personally, primarily Arch and Gentoo]
#skill[Very strong understanding of (multi)linear algebra]
#skill[Passion for mathematics practiced daily, particularly in
Clifford/geometric algebras.]
#skill[Julia, Lisp, Python, C/C++, x86-64 ASM; Machine Learning, Optimization,
Object-Oriented, Functional]
#skill[Vim, SSH, Git, Makefiles]

#education(
  school: [Michigan State University],
  degree: [B.S. in Physics with additional major in Advanced Math],
  location: [East Lansing, MI],
  date: (start: "Sep 2015", end: "May 2019")
)[
  GPA 3.523 #space Dean's list 5/8 semesters
]
