
# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Smoke test start")

    # Clock (puede ser 10 us o más rápido, da igual para el smoke)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Init inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

    # Opcional: “picar” el botón reset en ui_in[0] si tu wrapper lo usa
    # (si NO lo usas, esto no hace daño)
    dut.ui_in.value = 1  # presiona
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0  # suelta
    await ClockCycles(dut.clk, 20)

    # Si llegamos aquí sin excepciones, el test PASA y cocotb genera results.xml
    dut._log.info("Smoke test done")
