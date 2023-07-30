#let serif-font = "EB Garamond"
#let sans-font = "HK Grotesk"
#let base-serif-size = 11pt
#let base-sans-size = 10pt
#let sans-serif-factor = base-sans-size/base-serif-size
#let base-leading = 0.65em
#let my-style = state("my-style")

#let _highlight(..args) = block(
  fill: luma(235), radius: 2mm, outset: (x: 1mm, y: 1.2mm),
  ..args
)

#let state-push(st, x) = st.update(y => { y.push(x); return y })

#let _make-header(author, address, email, phone) = {
  let author-content = text(font: serif-font, size: 3.5*base-serif-size, author)
  let line-content = line(length: 100%, stroke: 0.75pt)

  let header-content = {
    author-content
    h(1fr)
    box(move(dy: 1pt, {
      set text(size: 1.1*base-serif-size, font: sans-font)
      set par(leading: base-leading/1.5)
      set align(right)

      email
      linebreak()
      phone
      linebreak()
      address.at(0)
      for line in address.slice(1) {
        linebreak()
        line
      }
    }))
    linebreak()
    {
      set text(size: base-serif-size)
      box(height: 0pt, move(dy: -0.25em, line-content))
    }
  }

  style(sty => {
    let author-height = measure(author-content, sty).height
    let header-height = measure(header-content, sty).height
    let diff = 0
    if header-height > author-height {
      diff = header-height - author-height
    }
    v(0.5in - diff + base-leading)
    block(height: header-height - 0.25em, header-content)
  })
}

#let half-em() = style(sty => {
  let content = scale(x: 50%, sym.dash.em)
  box(width: measure(content, sty).width/2, align(center, content))
})

#let uniform-height(content) = style(sty => {
  let h = measure("ABCDEFGHIJKLMNOPQRSTUVWXYZ", sty).height
  box(height: h, align(bottom, content))
})

#let sub-heading(content) = {
  let factor = 1.25
  set text(size: factor*base-serif-size, font: serif-font, weight: "medium")
  content
}

#let sub-heading-info(content) = {
  let factor = 1.25
  factor = factor*0.76
  set text(font: sans-font, weight: 200, size: factor*base-serif-size)
  content
}

#let body(content) = locate(loc => {
  let s = my-style.at(loc)

  let leading = base-leading/2.5
  set par(leading: leading)
  set text(font: sans-font, size: s.size*sans-serif-factor)
  set list(tight: false, spacing: base-leading, marker: sym.circle.filled.tiny)
  content
})

#let flat-transpose(n, x) = {
  let ret = x
  let m = calc.quo(x.len(), n)
  for i in range(0, m) {
    for j in range(0, n) {
      ret.at(j*m + i) = x.at(i*n + j)
    }
  }

  return ret
}

#let _experiences = state("experiences", (:))

#let experience(
  id, wide: false, heading: none, subheading: none, info1: none, info2: none, desc
) = _experiences.update(x => {
  let data = (
    wide: wide, heading: heading, subheading: subheading, info1: info1,
    info2: info2, desc: desc
  )

  if id in x {
    x.at(id).push(data)
  } else {
    x.insert(id, (data,))
  }

  return x
})

#let experience-type(name, ..args) = {
  let base-keys = ("heading", "subheading", "info1", "info2")

  let well-formed(v) = (
    v.len() == 2
    and type(v.at(0)) == "string"
    and type(v.at(1)) == "function"
  )

  assert(args.pos() == ())
  for (k, v) in args.named().pairs() {
    assert(k in base-keys)
    assert(type(v) in ("string", "array"))
    if type(v) == "array" {
      assert(well-formed(v))
    }
  }

  let args-rev = (:)
  for (k, v) in args.named().pairs() {
    if type(v) == "string" {
      args-rev.insert(v, k)
    } else {
      args-rev.insert(v.at(0), k)
    }
  }

  return (..args2) => {
    let exp-args = (:)

    for (k, v) in args2.named().pairs() {
      if k in args-rev {
        let new-k = args-rev.at(k)
        let maybe-f = args.named().at(new-k)
        if type(maybe-f) == "string" {
          exp-args.insert(new-k, v)
        } else {
          exp-args.insert(new-k, (maybe-f.at(1))(v))
        }
      } else {
        exp-args.insert(k, v)
      }
    }

    experience(name, ..args2.pos(), ..exp-args)
  }
}

#let make-experience(id, column-major: false) = locate(loc => {
  let s = my-style.at(loc)

  let work-exp-content(half-header: false, data) = {
    let header-content = {
      sub-heading(uniform-height(data.heading))
      h(1fr)
      sub-heading-info(uniform-height({
        data.info1
      }))
      linebreak()
      sub-heading-info(uniform-height(data.subheading))
      h(1fr)
      sub-heading-info(uniform-height(data.info2))
    }

    block(below: 0.5em, {
      set par(leading: base-leading)

      (s.highlight)(below: base-leading, {
        if half-header {
          grid(columns: (1fr, 1fr), gutter: 1em, header-content)
        } else {
          header-content
        }
      })

      set text(font: serif-font)
      box(width: 1fr, height: 0pt,
        move(dy: -1em+2pt, repeat({"."; h(0.25em)}))
      )
    })
    body(data.desc)
  }

  let exps = _experiences.final(loc).at(id)

  let exp-groups = ((),)
  for exp in exps {
    if exp.wide {
      exp-groups.push((exp,))
      exp-groups.push(())
    } else {
      exp-groups.last().push(exp)
    }
  }

  let subgrids = ()
  for exp-group in exp-groups {
    if exp-group.len() == 0 {
      continue
    }
    if calc.even(exp-group.len()) {
      if column-major {
        exp-group = flat-transpose(2, exp-group)
      }
      subgrids.push(
        grid(columns: (1fr, 1fr), gutter: 1em,
          ..exp-group.map(work-exp-content)
        )
      )
    } else if exp-group.len() == 1 {
      subgrids.push(block(
        work-exp-content(half-header: true, exp-group.last())
      ))
    } else {
      let exp-group-head = exp-group.slice(0, exp-group.len()-1)
      if column-major {
        exp-group-head = flat-transpose(2, exp-group-head)
      }
      subgrids.push(
        grid(columns: (1fr, 1fr), gutter: 1em,
          ..exp-group-head.map(work-exp-content)
        )
      )
      subgrids.push(block(
        work-exp-content(half-header: true, exp-group.last())
      ))
    }
  }

  block(grid(columns: (1fr,), gutter: 1em, ..subgrids))
})

#let _heading1(h) = {
  locate(loc => {
    if counter(heading).at(loc).at(0) != 0 {
      v(1fr)
    }
  })

  counter(heading).step(level: 1)

  let heading-content = { set text(font: serif-font, size: 26pt, weight: "regular"); h.body }
  block(above: 0pt, below: 1.1*base-leading,
    style(sty => {
      let height = measure(heading-content, sty).height
      grid(rows: (height, 4pt),
        align(right, block(height: height, heading-content)),
        align(bottom, block(height: 0pt,
          repeat(text(font: serif-font, size: base-serif-size, weight: "regular", "."))
        ))
      )
    })
  )
}

#let _skills = state("skills", ())
#let skill(content) = state-push(_skills, content)
#let make-skills() = locate(loc => {
  let s = my-style.at(loc)

  block(grid(
    columns: range(0, 3).map(x => 1fr),
    row-gutter: base-leading, column-gutter: base-leading,
    .._skills.final(loc).map(x => (s.highlight)(outset: (x: 1mm, y: 1mm),
      par(justify: false, body(list(x)))
    ))
  ))
})

#let _educations = state("educations", ())
#let education(
  school: "NONE", degree: "NONE", location: "NOWHERE", date: (),
  extra
) = state-push(_educations, (
  school: school, degree: degree, location: location, date: date, extra: extra
))

#let make-education() = locate(loc => {
  let s = my-style.at(loc)

  let educations = _educations.final(loc).map(data => style(sty => {
    let date-content = sub-heading-info(uniform-height({
      data.date.start; half-em(); data.date.end
    }))
    let location-content = sub-heading-info(uniform-height(data.location))
    let lower-width = calc.max(
      measure(date-content, sty).width, measure(location-content, sty).width
    )
    let lower-height = measure(sub-heading-info(block(data.extra)), sty).height

    sub-heading(uniform-height(data.school))
    h(1fr)
    sub-heading-info(uniform-height(text(weight: "regular", data.degree)))
    h(1fr)
    box(width: lower-width, align(right, date-content))
    linebreak()
    box(align(top, {
      box(width: 1fr, sub-heading-info(block(data.extra)))
      box(width: lower-width, height: lower-height,
        align(right, location-content)
      )
    }))
  }))

  block(for edu in educations {
    (s.highlight)(edu)
  })
})

#let space = h(weak: true, 2em)

#let _footer = state("footer", [])
#let footer(content) = _footer.update({ v(1fr); content })

#let mycv(
  author: "NOBODY", address: "NOWHERE", email: "NO@NO.NO",
  phone: "(555) 5555-5555", size: 11pt, highlight: false,
  margin: 0.5in,
) = doc => {
  set page("us-letter", margin: margin)
  set page(margin: (top: 0pt))
  set par(justify: true)
  set text(font: sans-font, size: size)

  show heading.where(level: 1): _heading1

  let maybe-highlight(..args) = if highlight {
    _highlight(..args)
  } else {
    _highlight(..args, fill: none)
  }

  my-style.update((
    size: size, highlight: maybe-highlight
  ))

  let address = if type(address) == "string" {
    (address,)
  } else {
    address
  }

  _make-header(author, address, email, phone)
  v(2fr)
  doc
  v(2fr)
  block(width: 100%, height: 0pt,
    align(center, move(dy: margin/2, text(size: 0.7em, weight: 200,
      locate(loc => _footer.at(loc))
    )))
  )
}
