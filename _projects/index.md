---
# Render this collection item directly at /projects/ so the navigation opens the
# project content itself, not an archive page containing another link.
permalink: /projects/
layout: archive
title: "Projects"
excerpt: "ASIC, mixed-signal, and RTL development projects."
author_profile: true
share: false
comments: false
---

<style>
  /*
    Flat project page layout
    ------------------------
    Each project is intentionally shown on this single page, with visible
    section headings so readers do not need to click through archive cards or
    separate project posts.
  */
  .project-entry {
    margin: 2rem 0;
  }

  .project-index {
    margin: 0 0 1rem;
    font-size: 1.15rem;
    font-weight: 700;
  }

  .project-image-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(220px, 1fr));
    gap: 1.5rem;
    align-items: center;
    margin: 1.75rem auto;
    max-width: 920px;
  }

  .project-image-grid figure,
  .project-result-figure {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin: 0;
    text-align: center;
  }

  .project-image-grid img {
    display: block;
    width: 100%;
    height: 260px;
    object-fit: contain;
    margin: 0 auto;
  }

  .project-result-figure {
    margin: 1.75rem auto;
    max-width: 510px;
  }

  .project-result-figure img {
    display: block;
    width: 100%;
    height: auto;
    margin: 0 auto;
  }

  .project-logo-figure {
    margin: 1rem auto 1.5rem;
    text-align: center;
  }

  .project-logo-figure img {
    display: block;
    width: 220px;
    max-width: 70%;
    height: auto;
    margin: 0 auto;
  }

  .project-logo-figure--small {
    max-width: 430px;
  }

  .project-logo-figure--small img {
    width: 82%;
    max-width: 360px;
  }

  .project-image-grid figcaption,
  .project-result-figure figcaption {
    display: block;
    width: 100%;
    margin: 0.45rem auto 0;
    text-align: center !important;
    font-size: 0.85em;
    line-height: 1.2;
    color: #666;
  }

  @media (max-width: 640px) {
    .project-image-grid {
      grid-template-columns: 1fr;
      max-width: 420px;
    }

    .project-image-grid img {
      height: auto;
      max-height: 260px;
    }
  }

</style>

<div class="project-entry" id="ucie-phy">

<div class="project-index">1. UCIe PHY Design</div>

<p>
  <strong>Title</strong>:
  Low-Power 32 GT/s x32 Advanced-Package UCIe PHY for Die-to-Die Interface<br />
  <strong>Role</strong>: Digital Designer<br />
  <strong>Organization</strong>: Samsung Electronics
</p>

<figure class="project-logo-figure">
  <img src="/images/projects/ucie_logo.png" alt="UCIe logo" />
</figure>


<p>
  Designed RTL and digital architecture for a high-speed UCIe PHY, including Link Training State Machine (LTSM) logic, PHY initialization/training flow, APB-based register access and control, and digital frontend implementation such as RTL simulation, lint, CDC analysis, synthesis, and timing-closure.
</p>

</div>

<hr />

<div class="project-entry" id="custom-mcu">

<div class="project-index">2. Custom MCU Design</div>

<p>
  <strong>Title</strong>: Custom MCU for High-Speed PHY Post-Silicon Validation<br />
  <strong>Role</strong>: Digital Designer<br />
  <strong>Application</strong>: 64 GT/s x64 Advanced-Package UCIe PHY<br />
  <strong>Organization</strong>: Samsung Electronics
</p>

<p>
  Designed a custom MCU integrated with the IP to improve flexibility, testability, and debuggability. <strong>Defined the opcode set and instruction behavior, and architected the MCU for small memory usage.</strong> Integrated the MCU into an IP and built a <strong>dedicated compiler</strong> to support post-silicon validation on ATE and enable rapid bug fixes through software code.
</p>

</div>

<hr />

<div class="project-entry" id="lazyverilog">

<div class="project-index">3. LazyVerilog</div>

<p>
  <strong>Title</strong>:
  <a href="https://github.com/kjoonha/LazyVerilog">LazyVerilog</a><br />
  <strong>Languages</strong>: C++<br />
  <strong>Repository</strong>: <a href="https://github.com/kjoonha/LazyVerilog">github.com/kjoonha/LazyVerilog</a>
</p>

<figure class="project-result-figure project-logo-figure--small">
  <img src="/images/projects/lazyverilog_logo.png" alt="LazyVerilog logo" />
  <figcaption>LazyVerilog</figcaption>
</figure>

<p>
  LazyVerilog is a <strong>open-source SystemVerilog LSP</strong> for RTL coding. It provides formatting, lint diagnostics, go-to-definition, references, rename, hover, completion, inlay hints, RTL tree navigation, and RTL code actions such as auto-instantiation, auto-wire, and auto-arg.
</p>

</div>

<hr />

<div class="project-entry" id="adpll">

<div class="project-index">4. Design of Integer-N ADPLL</div>

<p>
  <strong>Title</strong>:
  Integer-N ADPLL with Proportional and Integral Gain Co-Optimization Technique<br />
  <strong>Technology</strong>: Samsung 28nm<br />
  <strong>Clock Frequency</strong>: f<sub>ref</sub> = 100MHz, f<sub>out</sub> = 3.2GHz<br />
  <strong>Designer</strong>: <strong>Kyoungjoon Ha</strong>
</p>

<div class="project-image-grid">
  <figure>
    <img src="/images/projects/adpll.png" alt="ADPLL chip/layout view" />
    <figcaption>Chip/layout view</figcaption>
  </figure>
  <figure>
    <img src="/images/projects/adpll_on_pcb.jpg" alt="ADPLL mounted on PCB" />
    <figcaption>Measurement PCB</figcaption>
  </figure>
</div>

<figure class="project-result-figure">
  <img src="/images/projects/phase_noise.png" alt="ADPLL phase noise measurement" />
  <figcaption>Phase-noise analysis</figcaption>
</figure>

</div>
