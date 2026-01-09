import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

def resolvible(v) -> bool:
    # Evita X/Z
    s = v.binstr.lower()
    return ('x' not in s) and ('z' not in s)

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # 50 MHz => 20 ns
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    # Valores iniciales
    dut.ena.value = 1
    dut.ui_in.value = 0      # ui_in[0]=0 (si lo usas como reset-boton)
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Reset algunos ciclos
    await ClockCycles(dut.clk, 20)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 20)

    dut._log.info("Smoke test: uo_out resolvible y cambia")

    v0 = dut.uo_out.value
    assert resolvible(v0), f"uo_out tiene X/Z al salir de reset: {v0.binstr}"

    # Espera un poco: si tu diseño es MUY lento, esto puede no cambiar
    await Timer(200_000, units="ns")  # 200 us

    v1 = dut.uo_out.value
    assert resolvible(v1), f"uo_out tiene X/Z después: {v1.binstr}"
    assert v1 != v0, f"uo_out no cambió (posible divisor enorme o reset/ena). v0={v0.binstr} v1={v1.binstr}"
