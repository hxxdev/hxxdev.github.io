---
title: Overview of All-Digital PLL
date: 2025-08-11
categories: [circuit, analog]
tags: [analog, mixed, pll]
---

# All-Digital Phase-Locked Loop (ADPLL)

Based on the presentation by Deog-Kyoon Jeong, this document provides an overview of All-Digital Phase-Locked Loops (ADPLLs).

## What is an ADPLL?

An ADPLL is a type of phase-locked loop that is constructed exclusively from digital components.

-   **Broad Sense**: It consists of digital components and their digital equivalents. The input and output levels of its building blocks are defined in the digital domain.
-   **Strict Sense**: It is built entirely from digital function blocks, containing no passive components (like resistors or capacitors in the loop filter). All its components are synthesizable, making it ideal for cell-based design methodologies.

This is in contrast to:
-   **Analog PLL (APLL)**: Uses an analog phase detector (like a multiplier), a loop filter built from passive/active analog components, and a Voltage-Controlled Oscillator (VCO).
-   **Digital PLL (DPLL)**: Typically uses a digital phase detector and a charge-pump, but the core loop remains largely analog.

## ADPLL Architecture and Components

An ADPLL replaces the traditional analog blocks with digital counterparts. The primary components are:

![ADPLL Block Diagram](https://i.imgur.com/9Z8z4gY.png)

*Figure 1: Basic ADPLL Block Diagram, showing the TDC, DLF, and DCO in a feedback loop.*

### 1. Time-to-Digital Converter (TDC)

The TDC converts a time difference (phase error) into a digital value. It is the digital equivalent of a Phase/Frequency Detector (PFD) and Charge Pump (CP) in a traditional PLL.

-   **Types of TDCs:**
    -   **Linear TDC**: Provides fine resolution but can consume significant hardware and power. Examples include delay-line-based and Vernier TDCs.
    -   **Bang-Bang TDC (BBTDC)**: Has a simpler structure and is more reusable. It acts as a 1-bit TDC, indicating if the phase is early or late.

### 2. Digital Loop Filter (DLF)

The DLF is a digital filter (e.g., IIR or FIR) that processes the phase error information from the TDC and generates a control word for the DCO.

-   **Advantages:**
    -   **Small Area & No Leakage**: Being digital, it doesn't suffer from leakage currents and is compact.
    -   **PVT Independent**: Its characteristics are stable across process, voltage, and temperature variations.
    -   **Adaptive**: The filter coefficients can be changed adaptively during operation to optimize for fast locking or low jitter.

### 3. Digitally Controlled Oscillator (DCO)

The DCO is the digital equivalent of a VCO. It generates an output frequency based on a digital control word from the DLF.

-   **Implementation**: 
    -   **Explicit DAC + VCO**: A digital-to-analog converter (DAC) converts the control word to an analog voltage that drives a traditional VCO.
    -   **Embedded DAC**: The control word directly manipulates the oscillator, for example, by turning individual unit cells (like inverters in a ring oscillator or capacitor cells in an LC oscillator) on or off.
-   **Resolution Challenge**: The DCO has a quantized output frequency, which can cause limit cycles (cycling around the target frequency). This is a major challenge in ADPLL design. To overcome this, **ΔΣ (Delta-Sigma) modulation** is often used to dither the DCO control word, effectively increasing its resolution and reducing jitter.

## Key Advantages of ADPLL

ADPLLs offer several benefits over their analog counterparts, especially in modern deep-submicron CMOS technologies:

-   **No Analog Tuning Voltage**: Less sensitive to supply voltage noise.
-   **Easy PVT Compensation**: More stable performance across process, voltage, and temperature variations.
-   **Digital Flexibility**: Information is processed more flexibly, leading to greater portability and testability.
-   **Technology Scaling**: Benefits directly from technology shrinks, leading to smaller area and lower cost.
-   **Synthesizable**: The entire design can be synthesized from a hardware description language.

## Modeling and Analysis

ADPLLs can be analyzed using two main approaches:

1.  **z-domain Analysis**: Models the discrete-time behavior of the loop. It is quick, simple, and allows for an intuitive analogy to traditional Charge-Pump PLLs (CPPLLs). Stability is checked using the unit circle criterion.
2.  **s-domain Analysis**: Uses transformations (like the bilinear transform) to convert the system to the continuous-time s-domain. This allows for the reuse of many familiar analysis techniques from analog control systems, such as analyzing phase margin and bandwidth.

## Noise and Jitter in ADPLLs

-   **TDC Quantization Noise**: The TDC introduces quantization noise, which is low-pass filtered by the loop.
-   **DCO Quantization Noise**: The DCO's finite resolution is a dominant noise source. This noise is high-pass filtered by the loop. ΔΣ dithering is used to shape this noise, pushing it to higher frequencies where it can be more easily filtered.
-   **Jitter**: The timing uncertainty in the output clock. ADPLLs exhibit both **Phase Modulation (PM) jitter** (non-accumulative) and **Frequency Modulation (FM) jitter** (accumulative).

### Jitter Equations

Jitter can be quantified in several ways. A common method is to calculate the RMS jitter from the phase noise spectral density.

**1. Phase Noise to Jitter Conversion:**

The relationship between the phase noise power spectral density \(S_\phi(f)\) and the single-sideband phase noise \(\mathcal{L}(f)\) is:

$$ S_\phi(f) = 2 \mathcal{L}(f) $$

The mean-square phase error \(\langle\phi^2(t)\rangle\) is found by integrating the phase noise density over the frequency range of interest (from \(f_1\) to \(f_2\)):

$$ \langle\phi^2(t)\rangle = \int_{f_1}^{f_2} S_\phi(f) \, df = 2 \int_{f_1}^{f_2} \mathcal{L}(f) \, df $$

**2. RMS Jitter Calculation:**

The RMS jitter (\(J_{RMS}\)) in seconds is then calculated from the mean-square phase error and the carrier frequency (\(f_c\)):

$$ J_{RMS} = \frac{\sqrt{\langle\phi^2(t)\rangle}}{2 \pi f_c} = \frac{\sqrt{2 \int_{f_1}^{f_2} \mathcal{L}(f) \, df}}{2 \pi f_c} $$

Where \(\mathcal{L}(f)\) is often given in dBc/Hz, so it must be converted to a linear scale (\(10^{\mathcal{L}(f)_{dBc}/10}\)) before integration.

**3. Jitter in BBPLL (Bang-Bang PLL):**

For a 1st order Bang-Bang PLL, the peak-to-peak jitter (\(J_{pp}\)) is directly proportional to the loop latency (D) and the quantized step of the DCO (Δ).

$$ J_{pp} \approx 2(1+D)\Delta $$

This highlights the importance of minimizing loop latency in high-performance digital PLLs.

## Summary

ADPLLs are highly integrated, synthesizable, and scalable frequency synthesizers that are well-suited for modern digital systems. They offer significant flexibility and performance advantages. The performance is often dominated by the characteristics of the TDC and DCO, and advanced techniques like ΔΣ modulation and digital calibration are crucial for achieving low noise and high performance.

## References

- Da Dalt, N. "A design-oriented study of the nonlinear dynamics of digital bang-bang PLLs." *IEEE Transactions on Circuits and Systems I: Regular Papers* 52.1 (2005): 21-31.
